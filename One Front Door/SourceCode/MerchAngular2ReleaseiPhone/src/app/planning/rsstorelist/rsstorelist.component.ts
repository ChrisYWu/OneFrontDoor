import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import {FilterPipe} from '../../pipes/filter.pipe';
import {StoreWeekDayInput, StoreWeekDayOutput, Account, Dispatches, DispatchOutput, Store} from '../RouteStoreAssignment';
import {DispserviceService } from '../../services/dispservice.service';
import {MerchConstant} from '../../../app/MerchAppConstant';

@Component({
    selector: 'app-rsstorelist',
    templateUrl: 'rsstorelist.component.html',
    styleUrls: ['rsstorelist.component.css'],
})
export class RsstorelistComponent implements OnInit {

    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    public localTabAccts: Array<Account> = [];
    @Input() currentTabAccts: Array<Account>;
    @Input() routeDataInput: Dispatches;
    @Input() lastModifiedByInput: string;
    @Input() selectedWeekDayInput: number;
    @Output() accountSelected = new EventEmitter();

    public constructor(public dispService: DispserviceService) { }

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
    addStore(accountID: number, accountName: string, address: string) {
        this.dispService.set(this._webapi + 'api/Merc/InsertStoreWeekday/');

        let storeWeekDayInput: StoreWeekDayInput = new StoreWeekDayInput(this.routeDataInput.MerchGroupID,
            this.selectedWeekDayInput,
            this.routeDataInput.RouteID,
            accountID,
            this.lastModifiedByInput);
        this.dispService.post(JSON.stringify(storeWeekDayInput))
            .subscribe(res => {
                var data: any = res;
                let resultInsert: StoreWeekDayOutput;
                resultInsert = data;
                if (resultInsert.ReturnStatus == 1) {
                    this.routeDataInput.Stores.push(new Store(accountID, accountName, this.routeDataInput.Stores.length + 1, null));
                    this.pullInfoUpdate();
                    this.accountSelected.emit(
                        { close: 'true' }
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

            // if (this.currentTabAccts && this.currentTabAccts.length > 0) {
            //     this.localTabAccts = this.currentTabAccts;
            // }
    }

}
