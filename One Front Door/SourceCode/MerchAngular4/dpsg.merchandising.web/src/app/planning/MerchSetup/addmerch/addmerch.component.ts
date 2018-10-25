import { Component, OnInit, Output, EventEmitter, ViewChild, Input } from '@angular/core';
//import {CORE_DIRECTIVES} from '@angular/common';
import {ModalDirective} from 'ng2-bootstrap/ng2-bootstrap';
import { AddmerchpopupComponent } from '../addmerchpopup';
import {MerchGroup} from '../MerchSetupClass';

@Component({
 // moduleId: module.id,
  selector: 'app-addmerch',
  templateUrl: 'addmerch.component.html',
  styleUrls: ['addmerch.component.css'],
//  directives: [CORE_DIRECTIVES, AddmerchpopupComponent, MODAL_DIRECTIVES],
//  viewProviders: [BS_VIEW_PROVIDERS],
})
export class AddmerchComponent implements OnInit {

  @ViewChild('lgModal') lgModal: ModalDirective;
  @Input() MerchGroupItem: MerchGroup;
  @Input() merchLookupList: Array<any> = [];
  @Output() merchSelected = new EventEmitter();

  closedialog() {
    this.lgModal.hide();
  }

  constructor() { }

  ngOnInit() {
  }

  setselectedMerch($event) {
    if ($event.close == 'true') {
      this.closedialog();
    }

    this.merchSelected.emit(
      { $event }
    )

  }

}
