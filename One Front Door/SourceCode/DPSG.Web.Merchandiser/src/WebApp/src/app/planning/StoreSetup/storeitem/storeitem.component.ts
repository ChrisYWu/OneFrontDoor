import { Component, OnInit,Output,EventEmitter,ViewChild,Input } from '@angular/core';
import {CORE_DIRECTIVES} from '@angular/common';
import {MODAL_DIRECTIVES, BS_VIEW_PROVIDERS,ModalDirective} from 'ng2-bootstrap/ng2-bootstrap';
import { StorelistPopupComponent } from '../storelist-popup';
import {MerchGroup} from '../../../services/planning';


@Component({
  moduleId: module.id,
  selector: 'storeitem',
  templateUrl: 'storeitem.component.html',
  styleUrls: ['storeitem.component.css'],
  directives:[CORE_DIRECTIVES,StorelistPopupComponent,MODAL_DIRECTIVES], 
  viewProviders: [BS_VIEW_PROVIDERS],
})
export class StoreitemComponent implements OnInit {

     @Output() storeSelected = new EventEmitter();
      @ViewChild('lgModal') lgModal: ModalDirective;
        @Input() storeLookupList: Array<any>=[];
        @Input() MerchGroupItem:MerchGroup;

   closedialog(){
      this.lgModal.hide();
    }

  constructor() {}

  ngOnInit() {
  }

  setselectedStore($event) {
    if($event.close=='true')
       {
          this.closedialog();
       }     
     
    this.storeSelected.emit(
            { $event }
       )
       
    }

}
