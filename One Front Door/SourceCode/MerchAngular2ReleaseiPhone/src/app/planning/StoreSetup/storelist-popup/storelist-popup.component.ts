import { Component, OnInit, Output, EventEmitter, Input, ElementRef } from '@angular/core';
//import {CORE_DIRECTIVES} from '@angular/common';
import { StorelookupService } from '../../../services/storelookup.service';
import { MerchConstant } from '../../../../app/MerchAppConstant';
import { StoreInfo, MerchGroup } from '../../../services/planning';
import { FilterPipe } from '../../../pipes/filter.pipe';
import { } from '../../../services/planning';

@Component({
  // moduleId: module.id,
  selector: 'storelist-popup',
  templateUrl: 'storelist-popup.component.html',
  styleUrls: ['storelist-popup.component.css'],
  // directives:[CORE_DIRECTIVES],
  // pipes: [FilterPipe],
  providers: [StorelookupService]
})
export class StorelistPopupComponent implements OnInit {

  @Output() storeSelected = new EventEmitter();
  @Input() storeLookupList: Array<any> = [];
  @Input() MerchGroupItem: MerchGroup;

  private inputURL: string;
  private _webapi: string = MerchConstant.WebAPI_ENDPOINT;//'http://localhost:8888/';
  public keyword: string;
  public isLoading: boolean = false;

  public el: HTMLElement;
  public inputEl: HTMLInputElement;

  constructor(elementRef: ElementRef, private lookupService: StorelookupService) {
    this.el = elementRef.nativeElement;
  }

  ngOnInit() {
    var SAPBranchID = '1115';
    this.inputEl = <HTMLInputElement>(this.el.querySelector('#txtStoreSearch'));
    this.lookupService.sourceUrl = this.inputURL;
    this.lookupService.pathToData = "Stores";
  }

  initializeStoreSearch() {
    this.storeLookupList = [];
    this.inputEl.value = '';
  }

  showDropdownList(): void {
    // this.keyword = '';
    this.inputEl.focus();
    this.reloadList();
  }

  reloadListInDelay(): void {
    let delayMs = 500;
    //executing after user stopped typing
    this.delay(() => this.reloadList(), delayMs);
  }

  reloadList(): void {
    let keyword = this.inputEl.value;
    if (keyword.length >= 3) {
      this.isLoading = true;

      let query = { keyword: keyword };
      this.inputURL = this._webapi + 'api/Merc/GetStoresLookUpBySAPBranchID/' + this.MerchGroupItem.SAPBranchID + '/' + this.MerchGroupItem.MerchGroupID + '/' + ':keyword';
      this.lookupService.sourceUrl = this.inputURL;
      this.lookupService.getRemoteData(query)
        .subscribe(
        resp => {
          this.storeLookupList = [];
          this.storeLookupList = (<any>resp);
        },
        error => null,
        () => this.isLoading = false //complete
        );
    }
    else {
      this.storeLookupList = [];
    }
  }

  private delay = (function () {
    var timer = 0;
    return function (callback: any, ms: number) {
      clearTimeout(timer);
      timer = setTimeout(callback, ms);
    };
  })();

  addStore(account: StoreInfo) {
    var result: any = { close: 'true', Account: account };
    this.storeLookupList = [];
    this.inputEl.value = '';
    this.storeSelected.emit(result);
  }

}
