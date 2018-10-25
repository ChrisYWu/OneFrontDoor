
import { Component, OnInit, Input, Output, EventEmitter, ViewChild } from '@angular/core';
import { Subscription } from 'rxjs/Subscription';
import { ModalDirective } from 'ng2-bootstrap/ng2-bootstrap';
import { DatePickerModule, DatePickerOptions, DateModel } from 'ng2-datepicker/ng2-datepicker';
import * as moment from 'moment';
import { MerchConstant } from '../MerchAppConstant';
import {
    Dispatches, DispatchInput, AccountInput, Account, Accounts, RouteListInput, Route,
    Store, Merchandiser, DispatchReady, DispatchFinalResult, DispatchFinalInput, DispatchHistory,
    StorePreDispatch, DispatchOutput, ScheduleStatusOutput, ScheduleStatusInput
} from '../services/dispatch';

import { DispserviceService } from '../services/dispservice.service';

import { HeadernavService } from '../services/headernav.service';

@Component({
    //moduleId: module.id,
    selector: 'app-merc-main',
    templateUrl: 'merc-main.component.html',
    styleUrls: ['merc-main.component.css'],
    providers: [DispserviceService, HeadernavService]

    //viewProviders: [BS_VIEW_PROVIDERS]


})

export class MercMainComponent implements OnInit {
    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    public isRequesting: boolean;

    @ViewChild('lgDispatchHistoryModal') lgDispatchHistoryModal: ModalDirective;
    @ViewChild('dispatchFinalModal') dispatchFinalModal: ModalDirective;
    @ViewChild('unassignedStoresModal') unassignedStoresModal: ModalDirective;
    @ViewChild('unassignedStoreRouteModal') unassignedStoreRouteModal: ModalDirective;

    public dispHistory: Array<DispatchHistory>;
    public dispHistoryLength: number = 0;

    public dispatch: Array<Dispatches>;
    public dispatchNoEmptyMerch: Array<Dispatches> = new Array<Dispatches>();
    public dispatchLength: number = 0;
    public dispInput: DispatchInput;
    public dispathchDate: string;
    //public DispathchDate: string = new Date().toISOString().split('T')[0];
    public DispathchDate: DateModel;
    public lastModifiedBy: string;

    public merchGroupId: number;

    public accts: Accounts;
    public acctInput: AccountInput;
    public allAccts: Array<Account>;
    public unassignedAccts: Array<Account>;
    public unassignedAcctsLength: number = 0;
    public otherAccts: Array<Account>;
    public selectedacct: string;
    // public routesInput: Array<Route>;
    public unassignedMerch: Array<Merchandiser> = [];
    public unassignedOtherMerch: Array<Merchandiser> = [];
    public dispatchReadyInfo: Array<DispatchReady>;
    public dispatchFinalResult: Array<DispatchFinalResult>;
    public dispatchReadyInfoLength: number = 0;
    public dispatchNotes: string = '';
    public unassignedToggle: boolean = false;
    public changeeventtimeout: boolean = true; // this is a global variable.
    customScheduleDate: DatePickerOptions;
    private subscription: Subscription;

    public msgText: string = "";
    public scheduleDateCount: number = 0;
    public unassignedSelectAcctID: number;
    public unassignedSelectAcctName: string;
    public unassignedSelectAcctAddess: string;
    public scheduleStatus: ScheduleStatusOutput;
    public enableDispatch: boolean;
    public scheduleStatusText: string;
    public statusCSS: string;
    public enableReset: boolean;
    public gmtDate: any;
    public gmtTime: string;

    @Input() itemsObservables;

    constructor(public dispService: DispserviceService, public navService: HeadernavService) {
    }

    formatToLocalTime(releaseTime: Date) {
        var localDate = (new Date(releaseTime.toLocaleString()));
        return localDate;
    }

    getTimeZoneName(releaseTime: Date) {
        // var tzName= (new Date(releaseTime.toLocaleString())).toLocaleDateString('en',{timeZoneName:'short'}).split(' ').pop();
        var tzName = (new Date(releaseTime.toLocaleString())).toTimeString().split('(')[1].replace(')', '').split(" ");
        var abbr = "";

        for (var i = 0; i < tzName.length; i++) {
            // for each word - get the first letter
            abbr += tzName[i].charAt(0);
        }

        return abbr;
    }




    private stopRefreshing() {
        this.isRequesting = false;
    }

    setDispatchDate() {
        this.dispathchDate = (this.DispathchDate.year + "-" + this.DispathchDate.month + "-" + this.DispathchDate.day);
    }

    ngOnInit() {


        var curr = new Date;
        var currMin = new Date;
        var currMax = new Date;
        var mindate = new Date(currMin.setDate(currMin.getDate() - 60));
        var maxdate = new Date(currMax.setDate(currMax.getDate() + 60));

        this.customScheduleDate = new DatePickerOptions(
            {
                autoApply: true,
                format: "dddd, MMM DD",
                firstWeekdaySunday: true,
                minDate: mindate,
                maxDate: maxdate,
                initialDate: curr,

            }
        )
        this.subscription = this.navService.navItem$.subscribe(item => { this.merchGroupId = item.MerchGroupID; this.lastModifiedBy = item.LoggedInUser; this.loadData() });


    }

    ngOnDestroy() {
        // prevent memory leak when component is destroyed
        this.subscription.unsubscribe();
    }

    onChange($event) {

        this.loadData();

    }

    openDispatchpopup() {
        this.previewDispatch();
    }

    setselectedAcct($event) {
        this.dispService.set(this._webapi + 'api/Merc/GetStores/');
        this.acctInput = new AccountInput(this.merchGroupId, new Date(this.DispathchDate.year + "-" + this.DispathchDate.month + "-" + this.DispathchDate.day));
        this.getUnassignedAccounts(this.acctInput);
        //
        this.getScheduleStatusInfo();
        //
    }

    setResequence($event) {
        this.getScheduleStatusInfo();
    }

    setUnassignedAcctSelection(acctid: number, acctname: string, acctaddress: string, acctcity: string, acctstate: string, acctzip: string) {
        this.unassignedSelectAcctID = acctid;
        this.unassignedSelectAcctName = acctname + " (" + acctid + ")";
        this.unassignedSelectAcctAddess = acctaddress + ", " + acctcity + ", " + acctstate + "-" + acctzip;

        this.unassignedStoresModal.hide();
        this.populateNoEmptyMerch();
        this.unassignedStoreRouteModal.show();

    }

    dispatchHistory() {
        this.dispService.set(this._webapi + 'api/Merc/GetDispatchHistory/');
        let routelistinput: RouteListInput;
        routelistinput = new RouteListInput(new Date(this.DispathchDate.year + "-" + this.DispathchDate.month + "-" + this.DispathchDate.day), this.merchGroupId);

        this.dispService.post(JSON.stringify(routelistinput), true)
            .subscribe(res => {
                var data: any = res;
                this.dispHistory = data.DispatchHistory;
                this.dispHistoryLength = this.dispHistory.length;
                this.lgDispatchHistoryModal.show();
            },
            error => {

                if (error.status == 401 || error.status == 404) {
                    //this.notificationService.printErrorMessage('Authentication required');
                    //this.utilityService.navigateToSignIn();
                }
            });
    }

    public getScheduleStatusInfo() {

        this.dispService.set(this._webapi + 'api/Merc/GetScheduleStatus/');

        if (this.DispathchDate) {
            this.setDispatchDate();
            let scheduleStatusInput = new ScheduleStatusInput(this.merchGroupId,
                new Date(this.DispathchDate.year + "-" + this.DispathchDate.month + "-" + this.DispathchDate.day));


            this.dispService.post(JSON.stringify(scheduleStatusInput))
                .subscribe(res => {
                    var data: any = res;
                    this.scheduleStatus = data;
                    this.scheduleStatusText = this.scheduleStatus.StatusText;
                    this.enableDispatch = !this.scheduleStatus.EnableDispatch;
                    this.enableReset = !this.scheduleStatus.EnableReset;

                    if (this.scheduleStatus.GMTTime) {
                        this.gmtDate = new Date(this.scheduleStatus.GMTTime);
                        // this.gmtDate =  new Date( this.scheduleStatus.GMTTime.toString().split("T")[0] 
                        // + " " + this.scheduleStatus.GMTTime.toString().split("T")[1] + " GMT");
                        // this.gmtTime = this.getTimeZoneName(this.scheduleStatus.GMTTime);
                    }
                    else {
                        this.gmtDate = null;
                        this.gmtTime = "";
                    }

                    if (this.scheduleStatus.StatusBackGround == "Yellow") {
                        this.statusCSS = "row status-main-preview navbar-fixed-top";
                    }
                    else if (this.scheduleStatus.StatusBackGround == "Red") {
                        this.statusCSS = "row status-main-not-schedule navbar-fixed-top";
                    }
                    else if (this.scheduleStatus.StatusBackGround == "Green") {
                        this.statusCSS = "row status-main-schedule navbar-fixed-top";
                    }
                    else {
                        this.statusCSS = "status-main-noshow";
                    }



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

    }

    resetFromPlanning(): void {
        this.msgText = "";

        this.dispService.set(this._webapi + 'api/Merc/GetAllDispatchSliced/');
        if (this.lastModifiedBy) {
            if (this.DispathchDate) {
                this.setDispatchDate();
                this.dispInput = new DispatchInput(
                    this.lastModifiedBy,
                    this.merchGroupId,
                    new Date(this.DispathchDate.year + "-" + this.DispathchDate.month + "-" + this.DispathchDate.day),
                    true,
                    new Date().getTimezoneOffset() / 60);
                this.getAllDipatchInfo(this.dispInput);
            }
        }    }

    loadData(): void {
        this.msgText = "";

        this.dispService.set(this._webapi + 'api/Merc/GetAllDispatchSliced/');
        if (this.lastModifiedBy) {
            if (this.DispathchDate) {
                this.setDispatchDate();
                this.dispInput = new DispatchInput(
                    this.lastModifiedBy,
                    this.merchGroupId,
                    new Date(this.DispathchDate.year + "-" + this.DispathchDate.month + "-" + this.DispathchDate.day),
                    false,
                    new Date().getTimezoneOffset() / 60);
                this.getAllDipatchInfo(this.dispInput);
            }
        }

        // this.dispService.set(this._webapi + 'api/Merc/GetDispatches/');
        // this.dispInput = new DispatchInput('System', 102, this.dispathchDate);
        // this.getDipatchInfoPost(this.dispInput);
        // //this.getDipatchInfo();
        // this.dispService.set(this._webapi + 'api/Merc/GetStores/');
        // this.acctInput = new AccountInput(102, this.dispathchDate);
        // this.getAccounts(this.acctInput);

        // this.dispService.set(this._webapi + 'api/Merc/GetRouteList/');
        // let routelistinput: RouteListInput;
        // routelistinput = new RouteListInput(this.dispathchDate, this.merchGroupId);
        // this.getRoutes(routelistinput);


        // this.dispService.set(this._webapi + 'api/Merc/GetMerchList/');
        // this.getMerchs(routelistinput);

    }

    toggleUnassigned() {
        this.unassignedStoresModal.show();
        // if(this.unassignedAcctsLength > 0)
        // {
        //     if(this.unassignedToggle)
        //         this.unassignedToggle = false;
        //     else 
        //         this.unassignedToggle = true;
        // }
        // else{
        //     this.unassignedToggle = false;
        // }
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

        //
        this.getScheduleStatusInfo();
        //

    }

    addUnassignedStore(routeid: number, routename: string, gsn: string) {
        this.dispService.set(this._webapi + 'api/Merc/InsertStorePredisp/');
        let storepredispatch: StorePreDispatch = new StorePreDispatch(new Date(this.DispathchDate.year + "-" + this.DispathchDate.month + "-" + this.DispathchDate.day),
            this.merchGroupId,
            routeid, gsn, this.unassignedSelectAcctID,
            this.lastModifiedBy);

        this.dispService.post(JSON.stringify(storepredispatch))
            .subscribe(res => {
                var data: any = res;
                let resultInsert: DispatchOutput;
                resultInsert = data;
                if (resultInsert.Message == null) {
                    // this.dispatch..routeDataInput.Stores.push(new Store(accountID, accountName, this.routeDataInput.Stores.length + 1, null,displayCnt, '', ''));//added by lakshmi
                    // this.pullInfoUpdate();
                    // this.accountSelected.emit(
                    //    { close: 'true'}
                    //  )
                    this.unassignedStoreRouteModal.hide();
                    this.loadData();
                }
            },
            error => {

                if (error.status == 401 || error.status == 404) {
                    //this.notificationService.printErrorMessage('Authentication required');
                    //this.utilityService.navigateToSignIn();
                }
            });
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


    populateNoEmptyMerch() {
        this.dispatchNoEmptyMerch = new Array<Dispatches>();

        for (var i = 0; i < this.dispatch.length; i++) {

            if (this.dispatch[i].GSN != "") {
                // this.dispatchNoEmptyMerch.push( new Dispatches(this.dispatch[i].GSN,this.dispatch[i].FirstName,this.dispatch[i].LastName,this.dispatch[i].AbsoluteURL,
                // this.dispatch[i].RouteID,1,this.dispatch[i].MerchGroupID, this.dispatch[i].DispatchDate,this.dispatch[i].LastModifiedBy,null));
                this.dispatchNoEmptyMerch.push(this.dispatch[i]);
            }
        }
    }

    getAllDipatchInfo(datainput: DispatchInput) {
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(datainput))
            .subscribe(res => {
                var data: any = res;

                //Stores
                //this.allAccts = data.Stores.AllStores;
                if (data.Stores && data.Stores.UnassignedStores) {
                    this.unassignedAccts = data.Stores.UnassignedStores;
                    this.unassignedAcctsLength = this.unassignedAccts.length;
                }
                else {
                    this.unassignedAcctsLength = 0;
                }
                //this.otherAccts = data.Stores.OtherStores;

                //Routes
                //this.routesInput = data.Routes.Routes;

                //Merchandiser

                // this.unassignedMerch = data.Merchandisers.UnassignedMerchandiser;
                // this.unassignedOtherMerch = data.Merchandisers.OtherUnassignedMerchandiser;
                if (data.Dispatches) {
                    if (data.Dispatches.Routes.length <= 0) {
                        this.msgText = "No data found for " + moment(this.DispathchDate).format('MMM D, YYYY');
                    }
                    else {
                        this.msgText = "";
                    }
                    //dispatch
                    this.dispatch = data.Dispatches.Routes;
                    this.dispatchLength = this.dispatch.length;
                    this.scheduleDateCount = data.Dispatches.ScheduleDateCount;
                    this.populateNoEmptyMerch();

                    this.pullInfoUpdate();
                    this.getScheduleStatusInfo();

                }
                else if (data.Message) {
                    this.dispatch = null;
                    this.dispatchLength = 0;
                    this.msgText = "An error occured. Please contact the system administrator.";
                }


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


    getDipatchInfo(): void {
        this.isRequesting = true;
        this.dispService.get()
            .subscribe(res => {
                var data: any = res.json();
                this.dispatch = data.Routes;

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


    getDipatchInfoPost(data: DispatchInput) {
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(data))
            .subscribe(res => {
                var data: any = res;
                this.dispatch = data.Routes;
                this.pullInfoUpdate();
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


    getAccounts(data: AccountInput) {
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(data), true)
            .subscribe(res => {
                var data: any = res;
                this.allAccts = data.AllStores;
                this.unassignedAccts = data.UnassignedStores;
                this.unassignedAcctsLength = this.unassignedAccts.length;
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
            // error => {

            //     if (error.status == 401 || error.status == 404) {
            //         //this.notificationService.printErrorMessage('Authentication required');
            //         //this.utilityService.navigateToSignIn();
            //     }
            // }
            );
    }
    // getRoutes(data: RouteListInput) {

    //     this.isRequesting = true;
    //     this.dispService.post(JSON.stringify(data))
    //         .subscribe(res => {
    //             var data: any = res;
    //             this.routesInput = data.Routes;

    //         },

    //         () => this.stopRefreshing(),
    //         () => this.stopRefreshing()
    //         // error => {

    //         //     if (error.status == 401 || error.status == 404) {
    //         //         //this.notificationService.printErrorMessage('Authentication required');
    //         //         //this.utilityService.navigateToSignIn();
    //         //     }
    //         // }

    //         );
    // }

    getMerchs(data: RouteListInput) {

        this.isRequesting = true;
        this.dispService.post(JSON.stringify(data))
            .subscribe(res => {
                var data: any = res;
                this.unassignedMerch = data.UnassignedMerchandiser;
                this.unassignedOtherMerch = data.OtherUnassignedMerchandiser;

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
    onKey(event: any) {

        this.dispatchNotes = event.target.value;
    }

    previewDispatch() {
        this.dispatchFinalModal.show();
        //     let dispatchReady:AccountInput = new AccountInput(this.merchGroupId, new Date(this.DispathchDate.year +"-" + this.DispathchDate.month + "-" + this.DispathchDate.day));

        // this.dispService.set(this._webapi + 'api/Merc/DispatchReady/');
        // this.isRequesting = true;
        // this.dispService.post(JSON.stringify(dispatchReady))
        //   .subscribe(res => {
        //       var data: any = res;
        //       this.dispatchReadyInfo = data.DispatchReadyListItems;
        //       this.dispatchReadyInfoLength = this.dispatchReadyInfo.length;
        //       this.dispatchFinalModal.show();


        //     },
        //     () => this.stopRefreshing(),
        //     () => this.stopRefreshing()
        //     // error => {

        //     //     if (error.status == 401 || error.status == 404) {
        //     //         //this.notificationService.printErrorMessage('Authentication required');
        //     //         //this.utilityService.navigateToSignIn();
        //     //     }
        //     // }
        //   );
    }
    finalDispatch() {
        let dispatchFinal: DispatchFinalInput = new DispatchFinalInput(new Date(this.dispathchDate.toString()), this.lastModifiedBy, this.merchGroupId, this.dispatchNotes);

        this.dispService.set(this._webapi + 'api/Merc/DispatchFinal/');
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(dispatchFinal))
            .subscribe(res => {
                var data: any = res;
                this.dispatchFinalResult = data.DispatchFinalResult;
                this.dispatchNotes = "";
                this.dispatchFinalModal.hide();

                if (this.dispatchFinalResult[0].DispatchInfo != 'OK') {
                    alert('Schedule was not successful');
                }
                else {
                    alert('Scheduled successfully');
                    if (this.scheduleDateCount == 0)
                        this.scheduleDateCount++;
                    this.getScheduleStatusInfo();
                }
            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            //  error => {

            // //     if (error.status == 401 || error.status == 404) {
            // //         //this.notificationService.printErrorMessage('Authentication required');
            // //         //this.utilityService.navigateToSignIn();
            // //     }
            // }
            );
    }
}