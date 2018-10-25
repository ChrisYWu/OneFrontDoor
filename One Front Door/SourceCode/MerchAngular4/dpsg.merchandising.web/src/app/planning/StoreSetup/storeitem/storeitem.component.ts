import { Component, OnInit,Output,EventEmitter,ViewChild,Input } from '@angular/core';
//import {CORE_DIRECTIVES} from '@angular/common';
import { ModalDirective} from 'ng2-bootstrap/ng2-bootstrap';
import { StorelistPopupComponent } from '../storelist-popup';
import {MerchGroup} from '../../../services/planning';


@Component({
  //moduleId: module.id,
  selector: 'storeitem',
  templateUrl: 'storeitem.component.html',
  styleUrls: ['storeitem.component.css'],
 // directives:[CORE_DIRECTIVES,StorelistPopupComponent,MODAL_DIRECTIVES], 
 // viewProviders: [BS_VIEW_PROVIDERS],
})
export class StoreitemComponent implements OnInit {

     
      @ViewChild('lgModal') lgModal: ModalDirective;
      @ViewChild(StorelistPopupComponent) private storelistPopupComponent:StorelistPopupComponent;
    
      @Input() storeLookupList: Array<any>=[];
      @Input() MerchGroupItem:MerchGroup;

      @Output() storeSelected = new EventEmitter();

  

  constructor() {}

  ngOnInit() {
  }

  closeAddStorePopup()
  {
    this.storelistPopupComponent.initializeStoreSearch();
    this.lgModal.hide();
  }

  closedialog(){    
      this.lgModal.hide();
  }
  initializeStoreListPopUp() : void
  {
    this.storelistPopupComponent.initializeStoreSearch();
    this.lgModal.show();
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
