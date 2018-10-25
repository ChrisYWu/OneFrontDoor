import { Component, OnInit, Input, Output, EventEmitter, ViewChild } from '@angular/core';
import {CORE_DIRECTIVES} from '@angular/common';
import {FilterPipe} from '../../../pipes/filter.pipe';
import {MerchConstant} from '../../../../app/MerchAppConstant';
import { MerchInfo, RouteData} from '../MerchSetupClass';

@Component({
  moduleId: module.id,
  selector: 'app-merchlist',
  templateUrl: 'merchlist.component.html',
  styleUrls: ['merchlist.component.css'],
  directives: [CORE_DIRECTIVES],
  pipes: [FilterPipe]
})
export class MerchlistComponent implements OnInit {
  @Input() selectedIdx: number = 0;
  @Input() MerchListData: Array<any> = [];
  @Output() merchListSelected = new EventEmitter();

  constructor() { }

  ngOnInit() {
  }

  onMerchSelect(merch: any, idx: number) {

    this.selectedIdx = idx;
    var result: any = { merchInfo: merch, ListIndex: this.selectedIdx };
    this.merchListSelected.emit(result);
  }
}
