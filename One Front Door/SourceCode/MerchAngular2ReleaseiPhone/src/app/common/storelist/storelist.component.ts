
import { Component, OnInit, Input, Output,EventEmitter } from '@angular/core';
//import {CORE_DIRECTIVES} from '@angular/common';
import {Account, AccountInput, Dispatches, StorePreDispatch, DispatchOutput,Store} from '../../services/dispatch';
import {MerchConstant} from '../../../app/MerchAppConstant';
import { DispserviceService } from '../../services/dispservice.service';

@Component({
 // moduleId: module.id,
  selector: 'app-storelist',
  templateUrl: 'storelist.component.html',
  styleUrls: ['storelist.component.css'],
  providers:[DispserviceService]
  
  //directives: [CORE_DIRECTIVES]

})
export class StorelistComponent implements OnInit {
    
    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    public localTabAccts: Array<Account> = [];
    @Input() currentTabAccts: Array<Account>;

    @Input() routeDataInput: Dispatches;
    @Input() lastModifiedByInput: string;
    @Input() unassignedDelete:string;
    @Output() accountSelected = new EventEmitter();




  public constructor(public dispService: DispserviceService) {
    
  }

  pullInfoUpdate() {


        let tempStores: Array<Store> = this.routeDataInput.Stores.slice();

        for (var j = 0; j < tempStores.length; j++) {
            let pullcount = 0;
            for (var k = 0; k < this.routeDataInput.Stores.length; k++) {
                if (tempStores[j].AccountID == this.routeDataInput.Stores[k].AccountID) {
                    pullcount++;
                    if (pullcount == 1) {
                        this.routeDataInput.Stores[k].PullNumber = "";
                    }
                    else if (pullcount == 2) {
                        this.routeDataInput.Stores[k].PullNumber = pullcount + "nd Pull";
                    }
                    else if (pullcount == 3) {
                        this.routeDataInput.Stores[k].PullNumber = pullcount + "rd Pull";
                    }
                    else {
                        this.routeDataInput.Stores[k].PullNumber = pullcount + "th Pull";
                    }
                    
                }
            }
        }

    }
  

   

    addStore(accountID: number, accountName: string, address: string,displayCnt:number, checkinGSN: string, actualArrival: string) {
        this.dispService.set(this._webapi + 'api/Merc/InsertStorePredisp/');
        let storepredispatch: StorePreDispatch = new StorePreDispatch(this.routeDataInput.DispatchDate,
            this.routeDataInput.MerchGroupID,
            this.routeDataInput.RouteID,
            this.routeDataInput.GSN, accountID, this.lastModifiedByInput);

        this.dispService.post(JSON.stringify(storepredispatch))
            .subscribe(res => {
                var data: any = res;
                let resultInsert: DispatchOutput;
                resultInsert = data;
                if (resultInsert.Message == null) {
                    this.routeDataInput.Stores.push(new Store(accountID, accountName, this.routeDataInput.Stores.length + 1, null,displayCnt, checkinGSN, actualArrival));//added by lakshmi
                    this.pullInfoUpdate();
                    this.accountSelected.emit(
                       { close: 'true'}
                     )
                }
            },
            error => {

                if (error.status == 401 || error.status == 404) {
                    //this.notificationService.printErrorMessage('Authentication required');
                    //this.utilityService.navigateToSignIn();
                }
            });
  }

    ngOnInit() {

        // this.localTabAccts.push(new Account(0, '', ''));
        // if (this.currentTabAccts && this.currentTabAccts.length > 0) {
        //     this.localTabAccts = this.currentTabAccts;
        // }

    }


}
