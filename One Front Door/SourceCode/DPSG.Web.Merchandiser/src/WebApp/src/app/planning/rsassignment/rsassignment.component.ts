import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { CORE_DIRECTIVES, FORM_DIRECTIVES } from '@angular/common';
import {MODAL_DIRECTIVES, BS_VIEW_PROVIDERS} from 'ng2-bootstrap/ng2-bootstrap';
import { DispserviceService } from '../../services/dispservice.service';
import { RsrouteComponent} from '../rsroute/';
import {} from '../services/dispatch';
import {RSInput, Dispatches, AccountInput, Account, Accounts, RouteListInput, Route, Store} from '../RouteStoreAssignment';
import {MerchConstant} from '../../../app/MerchAppConstant';
import {Subscription} from 'rxjs/Subscription';
import { HeadernavService } from '../../services/headernav.service';
import {MerchGroup} from '../../services/planning';
import { SpinnerComponent } from '../../common/spinner';

@Component({
    moduleId: module.id,
    selector: 'app-rsassignment',
    templateUrl: 'rsassignment.component.html',
    styleUrls: ['rsassignment.component.css'],
    directives: [MODAL_DIRECTIVES, CORE_DIRECTIVES, FORM_DIRECTIVES, RsrouteComponent, SpinnerComponent],
    providers: [DispserviceService, HeadernavService],
    viewProviders: [BS_VIEW_PROVIDERS]
})
export class RsassignmentComponent implements OnInit {
    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    item: MerchGroup = new MerchGroup();
    subscription: Subscription;

    public dispatch: Array<Dispatches>;
    public rsInput: RSInput;
    public lastModifiedBy: string = 'satrk001';
    public merchGroupId: number = 102;
    public selectedWeekDay: number = 2;
    public accts: Accounts;
    public acctInput: AccountInput;
    public allAccts: Array<Account>;
    public unassignedAccts: Array<Account>;
    public unassignedAcctsLength: number = 0;
    public otherAccts: Array<Account>;
    public selectedacct: string;
    public routesInput: Array<Route>;
    public unassignedToggle: boolean = false;
    public isRequesting: boolean;


    @Input() itemsObservables;


    constructor(public dispService: DispserviceService, public navService: HeadernavService) { }

    private stopRefreshing() {
        this.isRequesting = false;
    }

    ngOnInit() {
        this.subscription = this.navService.navItem$
            .subscribe(item => {
                this.item = item;
                if (this.item.MerchGroupID) {
                    this.merchGroupId = this.item.MerchGroupID;
                    this.lastModifiedBy = this.item.LoggedInUser;
                    this.loadData();
                }
            }
            );
    }

    setselectedAcct($event) {
        this.dispService.set(this._webapi + 'api/Merc/GetStoreList/');
        this.acctInput = new AccountInput(this.merchGroupId, this.selectedWeekDay);
        this.getUnassignedAccounts(this.acctInput);
    }

    setSelectedWeekDay(tabIndex) {
        this.selectedWeekDay = tabIndex;
        this.loadData();
    }

    loadData(): void {
        this.dispService.set(this._webapi + 'api/Merc/GetRSDetailByWeekDay/');
        this.rsInput = new RSInput(this.merchGroupId, this.selectedWeekDay);
        this.getDipatchInfoPost(this.rsInput);
    }

    toggleUnassigned() {
        if (this.unassignedAcctsLength > 0) {
            if (this.unassignedToggle)
                this.unassignedToggle = false;
            else
                this.unassignedToggle = true;
        }
    }

    setupdatedroute($event) {
        let targetRouteId = $event.value.routeid;
        let reassignStore: Store = $event.value.store;

        for (var i = 0; i < this.dispatch.length; i++) {

            if (targetRouteId == this.dispatch[i].RouteID) {
                reassignStore.Sequence = this.dispatch[i].Stores.length + 1;
                this.dispatch[i].Stores.push(reassignStore);
            }

        }
        this.pullInfoUpdate();

    }

    pullInfoUpdate() {
        for (var i = 0; i < this.dispatch.length; i++) {

            let tempStores: Array<Store> = this.dispatch[i].Stores.slice();

            for (var j = 0; j < tempStores.length; j++) {
                let pullcount = 0;
                for (var k = 0; k < this.dispatch[i].Stores.length; k++) {
                    if (tempStores[j].AccountID == this.dispatch[i].Stores[k].AccountID) {
                        pullcount++;
                        if (pullcount == 1) {
                            this.dispatch[i].Stores[k].PullNumber = "";
                        }
                        else if (pullcount == 2) {
                            this.dispatch[i].Stores[k].PullNumber = pullcount + "nd Pull";
                        }
                        else if (pullcount == 3) {
                            this.dispatch[i].Stores[k].PullNumber = pullcount + "rd Pull";
                        }
                        else {
                            this.dispatch[i].Stores[k].PullNumber = pullcount + "th Pull";
                        }

                    }
                }
            }
        }
    }


    getDipatchInfo(): void {
        this.dispService.get()
            .subscribe(res => {
                var data: any = res.json();
                this.dispatch = data.Routes;
            },
            error => {

                if (error.status == 401 || error.status == 404) {
                    //this.notificationService.printErrorMessage('Authentication required');
                    //this.utilityService.navigateToSignIn();
                }
            });

    }

    removeNullAccount() {
        for (var i = 0; i < this.dispatch.length; i++) {
            for (var j = 0; j < this.dispatch[i].Stores.length; j++) {
                if (this.dispatch[i].Stores[j].AccountID == null) {
                    this.dispatch[i].Stores.pop();
                }
            }
        }
    }

    getDipatchInfoPost(data: RSInput) {
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(data))
            .subscribe(res => {
                var data: any = res;
                this.dispatch = data.RoutesTile;
                this.routesInput = data.Routes;
                this.allAccts = data.AllStores;
                this.unassignedAccts = data.UnassignedStores;
                this.unassignedAcctsLength = this.unassignedAccts.length;

                this.removeNullAccount();
                this.pullInfoUpdate();
            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            );
    }

    getUnassignedAccounts(data: AccountInput) {
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(data), true)
            .subscribe(res => {
                var data: any = res;
                this.unassignedAccts = data.UnassignedStores;
                this.unassignedAcctsLength = this.unassignedAccts.length;
            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            );
    }
}
