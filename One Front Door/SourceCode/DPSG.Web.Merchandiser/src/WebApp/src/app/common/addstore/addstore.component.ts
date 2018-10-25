import { Component, OnInit, Input, Output, EventEmitter,ViewChild,ElementRef } from '@angular/core';
import {CORE_DIRECTIVES} from '@angular/common';
import {MODAL_DIRECTIVES, BS_VIEW_PROVIDERS, ModalDirective} from 'ng2-bootstrap/ng2-bootstrap';
import {TabsComponent} from '../tabs/';
import { DispserviceService } from '../../services/dispservice.service';
import {Account, StorePreDispatch, DispatchOutput, Store,Dispatches} from '../../services/dispatch';
import {MerchConstant} from '../../../app/MerchAppConstant';



@Component({
  moduleId: module.id,
  selector: 'app-addstore',
  templateUrl: 'addstore.component.html',
  styleUrls: ['addstore.component.css'],
  directives: [MODAL_DIRECTIVES, CORE_DIRECTIVES, TabsComponent],
  viewProviders: [BS_VIEW_PROVIDERS],
  providers: [DispserviceService]
  
})
export class AddstoreComponent implements OnInit {
    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    
    //public selectedacct: number;
    @ViewChild('lgModal') lgModal: ModalDirective;
    public resultInsert: DispatchOutput;
    public storePredispatchInsertData: StorePreDispatch;
    
    @Input() unassignedInputAccts: Array<Account>;
    
    @Input() allInputAccts: Array<Account>;
    @Input() otherInputAccts: Array<Account>;
    @Input() lastModifiedByInput: string;
    @Input() routeDataInput: Dispatches;
   

    @Output() accountSelected = new EventEmitter();

    public emptyStore: Store = new Store(null, null, null,null);

    closedialog(){
      this.lgModal.hide();
    }

    constructor(public dispService: DispserviceService) { }

    setselectedAcct($event) {
       if($event.$event.close=='true')
       {
          this.closedialog();
       }
 
       this.accountSelected.emit(
            {  $event }
       )
    }
   

  ngOnInit() {
  }
    

}
