import { Component, OnInit, Input, Output, EventEmitter,ViewChild,ElementRef } from '@angular/core';
import {ModalDirective} from 'ng2-bootstrap/ng2-bootstrap';
import {Account, StorePreDispatch, DispatchOutput, Store,Dispatches,AccountInput} from '../../services/dispatch';
import {MerchConstant} from '../../../app/MerchAppConstant';
import {DispserviceService} from '../../services/dispservice.service';


@Component({
  //moduleId: module.id,
  selector: 'app-addstore',
  templateUrl: 'addstore.component.html',
  styleUrls: ['addstore.component.css'],
  
  //viewProviders: [BS_VIEW_PROVIDERS],

  
})
export class AddstoreComponent implements OnInit {
    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    public isRequesting: boolean ;
    //public selectedacct: number;
    @ViewChild('lgModal') lgModal: ModalDirective;
    public resultInsert: DispatchOutput;
    public storePredispatchInsertData: StorePreDispatch;
    
    // @Input() unassignedInputAccts: Array<Account>;
    
    // @Input() allInputAccts: Array<Account>;
    // @Input() otherInputAccts: Array<Account>;

     public unassignedAccts: Array<Account>;
     public allAccts: Array<Account>;
     public otherAccts: Array<Account>;

    @Input() lastModifiedByInput: string;
    @Input() routeDataInput: Dispatches;
   

    @Output() accountSelected = new EventEmitter();

    public emptyStore: Store = new Store(null, null, null,null,null,'','');//added by lakshmi

    closedialog(){
      this.lgModal.hide();
    }

    opendialog()
    {
      if(this.routeDataInput.GSN !='')
      {
        this.dispService.set(this._webapi + 'api/Merc/GetStores/');
        var acctInput = new AccountInput(this.routeDataInput.MerchGroupID, this.routeDataInput.DispatchDate);
        this.getAccounts(acctInput);
        this.lgModal.show();
      }
      else
      {
        alert('Please add merchandiser to the route before adding stores');
      }
    }
   constructor(public dispService: DispserviceService) {
     
    }

    setselectedAcct($event) {
       if($event.$event.close=='true')
       {
          this.closedialog();
       }
     
       this.accountSelected.emit(
            {  $event }
       )
    }
    private stopRefreshing() {
        this.isRequesting = false;
    }

    getAccounts(data: AccountInput) {
           this.isRequesting = true;
        this.dispService.post(JSON.stringify(data), true)
            .subscribe(res => {
                var data: any = res;
                this.allAccts = data.AllStores;
                this.unassignedAccts = data.UnassignedStores;
                this.otherAccts = data.OtherStores;
            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            // error => {

            //     if (error.status == 401 || error.status == 404) {
            //         //this.notificationService.printErrorMessage('Authentication required');
            //         //this.utilityService.navigateToSignIn();
            //     }
            // }
            );
    }


  ngOnInit() {
  }
    

}
