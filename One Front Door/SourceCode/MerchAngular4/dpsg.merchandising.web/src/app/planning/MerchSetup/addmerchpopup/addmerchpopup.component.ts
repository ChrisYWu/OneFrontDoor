import { Component, OnInit, Output, EventEmitter, Input, ElementRef } from '@angular/core';
//import {CORE_DIRECTIVES} from '@angular/common';
import { StorelookupService } from '../../../services/storelookup.service';
import {MerchConstant} from '../../../../app/MerchAppConstant';
import {FilterPipe} from '../../../pipes/filter.pipe';
import { MerchInfo, RouteData, MerchGroup} from '../MerchSetupClass';

@Component({
 // moduleId: module.id,
  selector: 'app-addmerchpopup',
  templateUrl: 'addmerchpopup.component.html',
  styleUrls: ['addmerchpopup.component.css'],
  //directives:[CORE_DIRECTIVES],
 // pipes: [FilterPipe],
  providers: [StorelookupService]
})
export class AddmerchpopupComponent implements OnInit {

  // @Output() storeSelected = new EventEmitter();
  @Input() MerchLookupList: Array<any>=[];
  @Input() MerchGroupItem:MerchGroup;

 @Output() merchSelected = new EventEmitter();

  private inputURL : string;
  private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
  public keyword: string;
  public isLoading: boolean = false;
  public newMerchUser: MerchInfo = new MerchInfo();
  public filterText:string = '';
  public el: HTMLElement;
  public inputEl: HTMLInputElement;

  constructor(elementRef: ElementRef, private lookupService: StorelookupService) {
    this.el = elementRef.nativeElement;
  }

  ngOnInit() {    
    this.inputEl = <HTMLInputElement>(this.el.querySelector('#txtMerchSearch'));     
    this.inputURL = this._webapi + 'api/Merc/GetMerchUserDetails/:keyword';
    this.lookupService.sourceUrl = this.inputURL;
    this.lookupService.pathToData = "Users";
  }

   showDropdownList(): void {
    this.keyword = '';
    this.inputEl.focus();
    this.reloadList();
  }

    reloadListInDelay(): void {
    let delayMs =  500;
    //executing after user stopped typing
    this.delay(() => this.reloadList(), delayMs);
  }

  reloadList(): void {
    let keyword = this.inputEl.value;
      if (keyword.length >= 3) {       
        this.isLoading = true;

        let query = {keyword: keyword};
        this.lookupService.getRemoteData(query)
          .subscribe(
            resp => {
              this.MerchLookupList = (<any>resp);
            },
            error => null,
            () => this.isLoading = false //complete
          );
      }
      else
      {
         this.MerchLookupList = [];
      }
    }
  

  private delay = (function(){
    var timer = 0;
    return function(callback: any, ms: number){
      clearTimeout(timer);
      timer = setTimeout(callback, ms);
    };
  })();

   addMerch(merch: any)
   { 
     this.newMerchUser.GSN = merch.sAMAccountName;
     this.newMerchUser.MerchName = merch.givenName + ' ' + merch.sn; // merch.DisplayName;
     this.newMerchUser.FirstName = merch.givenName;
     this.newMerchUser.LastName = merch.sn;     

     var result : any = { close: 'true', newMerch:this.newMerchUser};
     this.merchSelected.emit(result);      
   }

}

