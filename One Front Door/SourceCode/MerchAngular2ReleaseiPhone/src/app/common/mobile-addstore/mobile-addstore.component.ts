import {
  Component,
  OnInit,
  Input,
  Output,
  EventEmitter,
  ViewChild,
  Inject,
  ElementRef
} from '@angular/core';
import { DOCUMENT } from '@angular/platform-browser';
import {
  ModalDirective
} from 'ng2-bootstrap/ng2-bootstrap';
import {
  Account,
  StorePreDispatch,
  DispatchOutput,
  Store,
  Dispatches,
  AccountInput
} from '../../services/dispatch';
import {
  MerchConstant
} from '../../../app/MerchAppConstant';
import {
  DispserviceService
} from '../../services/dispservice.service';


@Component({
  selector: 'app-mobile-addstore',
  templateUrl: './mobile-addstore.component.html',
  styleUrls: ['./mobile-addstore.component.scss']
})
export class MobileAddstoreComponent implements OnInit {
// IPhone related start
  public isShowAddStore: boolean = false;
  @Output() storePopupToggle: EventEmitter < any > = new EventEmitter();


  public isOpenPopup(isToOpen: boolean) {
    //debugger;
    this.isShowAddStore = isToOpen;
    if (isToOpen) {
      if (this.routeDataInput.GSN != '') {
        this.dispService.set(this._webapi + 'api/Merc/GetStores/');
        var acctInput = new AccountInput(this.routeDataInput.MerchGroupID, this.routeDataInput.DispatchDate);
        this.getAccounts(acctInput);

         this.document.body.scrollTop = 0;

      } else {
        alert('Please add merchandiser to the route before adding stores');
      }

    }


    this.storePopupToggle.emit({});
  }
  //IPhone ends 
  private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
  public isRequesting: boolean;
  //public selectedacct: number;
  
  public resultInsert: DispatchOutput;
  public storePredispatchInsertData: StorePreDispatch;

  // @Input() unassignedInputAccts: Array<Account>;

  // @Input() allInputAccts: Array<Account>;
  // @Input() otherInputAccts: Array<Account>;

  public unassignedAccts: Array < Account > ;
  public allAccts: Array < Account > ;
  public otherAccts: Array < Account > ;

  @Input() lastModifiedByInput: string;
  @Input() routeDataInput: Dispatches;


  @Output() accountSelected = new EventEmitter();

  public emptyStore: Store = new Store(null, null, null, null, null,'',''); //added by lakshmi

 
  opendialog() {
    if (this.routeDataInput.GSN != '') {
      this.dispService.set(this._webapi + 'api/Merc/GetStores/');
      var acctInput = new AccountInput(this.routeDataInput.MerchGroupID, this.routeDataInput.DispatchDate);
      this.getAccounts(acctInput);
    
    } else {
      alert('Please add merchandiser to the route before adding stores');
    }
  }


  constructor(@Inject(DOCUMENT) private document: Document, public dispService: DispserviceService) {

  }

  setselectedAcct($event) {
    if ($event.$event.close == 'true') {
      this.isShowAddStore = false;
      this.storePopupToggle.emit({});
    }

    this.accountSelected.emit({
      $event
    })
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


  ngOnInit() {}


}
