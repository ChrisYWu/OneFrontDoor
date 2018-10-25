import { Component, OnInit, Output, EventEmitter, ViewChild } from '@angular/core';
import {CORE_DIRECTIVES} from '@angular/common';
import { StoresListComponent } from '../stores-list';
import { StoredetailComponent } from '../storedetail';
import { StoreitemComponent } from '../storeitem';
import { DispserviceService } from '../../../services/dispservice.service';
import {MerchConstant} from '../../../../app/MerchAppConstant';
import {MerchBranch, StoreInfo, StoreSetupDetailContainer, StoreSetupDOW, RouteInfo, MerchGroup} from '../../../services/planning';
import { StorelistPopupComponent } from '../storelist-popup';
import {Subscription} from 'rxjs/Subscription';
import { HeadernavService } from '../../../services/headernav.service';
import { SpinnerComponent } from '../../../common/spinner';



@Component({
    moduleId: module.id,
    selector: 'app-storesetup-main',
    templateUrl: 'storesetup-main.component.html',
    styleUrls: ['storesetup-main.component.css'],
    directives: [CORE_DIRECTIVES, StoresListComponent, StoredetailComponent, StoreitemComponent, SpinnerComponent],
    providers: [DispserviceService, HeadernavService]


})
export class StoresetupMainComponent implements OnInit {
    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;//'http://localhost:8888/';
    private selectedBranch: MerchBranch = new MerchBranch();
    private selectedMerchGroupID: number = 0;
    private inputAcctList: Array<any> = [];
    private inputAcctLookupList: Array<any> = [];
    private SaveMsg: boolean = false;
    public isRequesting: boolean;
    item: MerchGroup = new MerchGroup();
    subscription: Subscription;


    private listIndex: number = 0;


    //StoreDetail Variables
    @Output() storeSelected = new EventEmitter();
    @Output() storeListSelected = new EventEmitter();
    @Output() refreshList = new EventEmitter();
    @Output() cancelDetail = new EventEmitter();

    private routesList: Array<any> = [];
    private selStoreInfo: StoreInfo;
    private selDefaultRoute: RouteInfo;
    public weekDays: Array<StoreSetupDOW> = [];
    private removeStore: StoreInfo;

    //set the selected store from the store list pop up
    setselectedStore($event) {
        //this.initalizeStoreDetail();      
        // this.selStoreInfo = $event.$event.Account; 
        this.initalizeStoreDetailsByAccountNumber($event.$event.Account);

    }

    //set the selected store from the store list left side
    setListselectedStore($event) {
        this.listIndex = $event.ListIndex;
        this.SaveMsg = false;
        this.getStoreDetailsByAccountNumber($event.Account);
    }


    //Refresh the store list left hand side and the store lookup list after save the store
    refreshStoreList($event) {
        if ($event.ReturnStatus == 1)
            this.SaveMsg = true;
        else
            this.SaveMsg = false;

        // this.getStoresListByMerchGroupID();
        this.getStoreSetUpContainer(false, $event.Account.SAPAccountNumber);

    }

    setAddedStoreIndexInList(newStore) {
        for (var i = 0; i < this.inputAcctList.length; i++) {
            if (this.inputAcctList[i]["SAPAccountNumber"] == newStore) {
                this.selStoreInfo = this.inputAcctList[i];
                this.listIndex = i;
                break;
            }
        }
    }

    cancelDetailStore($event) {
        if (this.inputAcctList.length > 0) {
            this.getStoreDetailsByAccountNumber(this.inputAcctList[0]);
            this.listIndex = 0;
        }
        else {
            this.selStoreInfo = null;
        }
    }




    constructor(private dispService: DispserviceService, public navService: HeadernavService) {


    }

    private stopRefreshing() {
        this.isRequesting = false;
    }

    ngOnDestroy() {
        // prevent memory leak when component is destroyed
        this.subscription.unsubscribe();
    }


    initalizeStoreDetail() {
        this.weekDays = [{ Weeknumber: 2, WeekName: 'Monday', FirstPull: false, SecondPull: false },
            { Weeknumber: 3, WeekName: 'Tuesday', FirstPull: false, SecondPull: false },
            { Weeknumber: 4, WeekName: 'Wednesday', FirstPull: false, SecondPull: false },
            { Weeknumber: 5, WeekName: 'Thursday', FirstPull: false, SecondPull: false },
            { Weeknumber: 6, WeekName: 'Friday', FirstPull: false, SecondPull: false },
            { Weeknumber: 7, WeekName: 'Saturday', FirstPull: false, SecondPull: false },
            { Weeknumber: 1, WeekName: 'Sunday', FirstPull: false, SecondPull: false }];
        this.selDefaultRoute = new RouteInfo();
        this.selDefaultRoute.RouteID = null;
        this.selDefaultRoute.RouteName = 'Default Route';
        this.SaveMsg = false;
    }
    ngOnInit() {
        //Subscribe
        this.subscription = this.navService.navItem$
            .subscribe(item => {
                this.item = item;
                if (this.item != null || this.item != undefined)
                    this.loadStoreData(item);
            }

            );


    }

    loadStoreData(item) {

        this.item = item;
        this.initalizeStoreDetail();

        this.getStoreSetUpContainer(true, '');
    }


    getStoreSetUpContainer(isLoad, newStore) {
        this.dispService.set(this._webapi + 'api/Merc/GetStoresSetupContainer/');
        this.isRequesting = true;
        var storeListInput: any = { SAPBranchID: this.item.SAPBranchID, MerchGroupID: this.item.MerchGroupID }

        this.dispService.post(JSON.stringify(storeListInput), true)
            .subscribe(res => {
                var d: any = res;
                this.inputAcctList = d.Stores;
                this.routesList = d.Routes;

                if (isLoad) {
                    this.selStoreInfo = d.StoreDetail;
                    if (d.RouteDetail != null)
                        this.selDefaultRoute = d.RouteDetail;

                    for (let w = 0; w < d.WeekDays.length; w++) {
                        this.weekDays.map((item: any) => {
                            if (item.Weeknumber == d.WeekDays[w].Weeknumber) {
                                item.FirstPull = d.WeekDays[w].FirstPull;
                                item.SecondPull = d.WeekDays[w].SecondPull;
                            }
                        });
                    }


                    if (this.inputAcctList == null || this.inputAcctList.length == 0) {
                        this.selStoreInfo = null;
                    }
                    this.listIndex = 0;
                }

                else {
                    this.setAddedStoreIndexInList(newStore);
                }

            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()

            );
    }


    getStoresListByMerchGroupID() {
        this.dispService.set(this._webapi + 'api/Merc/GetStoresByMerchGroupID/');
        this.isRequesting = true;
        var storeListInput: any = { SAPBranchID: this.item.SAPBranchID, MerchGroupID: this.item.MerchGroupID }

        this.dispService.post(JSON.stringify(storeListInput), true)
            .subscribe(res => {
                var d: any = res;
                this.inputAcctList = d.Stores;


                if (this.inputAcctList != null && this.inputAcctList.length > 0 && !this.SaveMsg) {
                    this.getStoreDetailsByAccountNumber(this.inputAcctList[0]);

                }

                if (this.inputAcctList == null || this.inputAcctList.length == 0) {
                    this.selStoreInfo = null;
                }
            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            );
    }

    getRoutesByMerchGroupID() {
        this.dispService.set(this._webapi + 'api/Merc/GetRoutesByMerchGroupID/');
        this.isRequesting = true;
        var storeListInput: any = { SAPBranchID: this.item.SAPBranchID, MerchGroupID: this.item.MerchGroupID }

        this.dispService.post(JSON.stringify(storeListInput), true)
            .subscribe(res => {
                var d: any = res;
                this.routesList = d.Routes;

            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()

            );
    }


    getStoresLookupListBySAPBranchID() {
        this.dispService.set(this._webapi + 'api/Merc/GetStoresLookUpBySAPBranchID/');
        this.isRequesting = true;
        var storeListInput: any = { SAPBranchID: this.item.SAPBranchID }
        this.dispService.post(JSON.stringify(storeListInput), true)
            .subscribe(res => {
                var d: any = res;
                this.inputAcctLookupList = d.Stores;

            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()

            );
    }


    getStoreDetailsByAccountNumber(store: any) {
        this.dispService.set(this._webapi + 'api/Merc/GetStoreDetailsBySAPAccountNumber/' + store.SAPAccountNumber);
        this.isRequesting = true;
        this.dispService.get()
            .subscribe(res => {
                var data: any = res.json();
                var result: any = { details: data, Account: store };
                this.initalizeStoreDetail();
                // this.selStoreInfo = store; 
                var result = data;
                this.selStoreInfo = result.StoreDetail;

                if (result.Detail != null)
                    this.selDefaultRoute = result.Detail;
                for (let w = 0; w < result.WeekDays.length; w++) {
                    this.weekDays.map((item: any) => {
                        if (item.Weeknumber == result.WeekDays[w].Weeknumber) {
                            item.FirstPull = result.WeekDays[w].FirstPull;
                            item.SecondPull = result.WeekDays[w].SecondPull;
                        }
                    });

                }

            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            );
    }


    initalizeStoreDetailsByAccountNumber(store: any) {
        this.isRequesting = true;
        this.dispService.set(this._webapi + 'api/Merc/GetStoreDetailsBySAPAccountNumber/' + store.SAPAccountNumber);
        this.dispService.get()
            .subscribe(res => {
                var data: any = res.json();
                // var result : any = { details: data,Account:store};


                this.initalizeStoreDetail();
                // this.selStoreInfo = store; 
                // var result = data;
                this.selStoreInfo = data.StoreDetail;

                // if(result.Detail!=null)
                // this.selDefaultRoute = result.Detail;
                // for(let w=0;w<result.WeekDays.length;w++)
                // {
                //     this.weekDays.map((item: any) => {
                //     if (item.Weeknumber == result.WeekDays[w].Weeknumber)
                //     { item.FirstPull = result.WeekDays[w].FirstPull;
                //     item.SecondPull = result.WeekDays[w].SecondPull; }
                // });

                // }      

            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            );
    }


}
