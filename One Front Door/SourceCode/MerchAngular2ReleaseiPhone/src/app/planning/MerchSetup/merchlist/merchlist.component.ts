import { Component, OnInit, Input, Output, EventEmitter, ViewChild } from '@angular/core';
//import {CORE_DIRECTIVES} from '@angular/common';
import {FilterPipe} from '../../../pipes/filter.pipe';
import {MerchConstant} from '../../../../app/MerchAppConstant';
import { MerchInfo, RouteData, MerchDeleteInput} from '../MerchSetupClass';
import { DispserviceService } from '../../../services/dispservice.service';

@Component({
  //moduleId: module.id,
  selector: 'app-merchlist',
  templateUrl: 'merchlist.component.html',
  styleUrls: ['merchlist.component.css'],
  //directives: [CORE_DIRECTIVES],
  //pipes: [FilterPipe]
})
export class MerchlistComponent implements OnInit {
  @Input() selectedIdx: number = 0;
  @Input() MerchListData: Array<any> = [];
  @Output() merchListSelected = new EventEmitter();
  @Output() refreshDeleteList = new EventEmitter();

  private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
   public merchDelInput: MerchDeleteInput;
  
  constructor(public dispService: DispserviceService) { }

  ngOnInit() {
  }

  onMerchSelect(merch: any, idx: number) {

    this.selectedIdx = idx;
    var result: any = { merchInfo: merch, ListIndex: this.selectedIdx };
    this.merchListSelected.emit(result);
  }

   deleteMerch(merchGSN: string)
  {        
    var r = confirm("Are you sure, you want to delete this Merchandiser?");
    if (r == true) {
       this.dispService.set(this._webapi + 'api/Merc/DeleteMerch/');
       this.merchDelInput = new MerchDeleteInput(merchGSN);
        this.dispService.post(JSON.stringify(this.merchDelInput), true)
            .subscribe(res => {
                var d: any = res;                
                this.refreshDeleteList.emit();
            },
            error => {
                if (error.status == 401 || error.status == 404) {
                }
            });
    }       
  }

}
