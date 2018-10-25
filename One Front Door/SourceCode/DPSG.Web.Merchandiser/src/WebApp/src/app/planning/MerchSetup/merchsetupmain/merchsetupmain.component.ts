import { Component, OnInit, Output, EventEmitter, ViewChild } from '@angular/core';
import {CORE_DIRECTIVES} from '@angular/common';
import { MerchlistComponent } from '../merchlist';
import { MerchdetailComponent } from '../merchdetail';
import { AddmerchComponent } from '../addmerch';
import { DispserviceService } from '../../../services/dispservice.service';
import {MerchConstant} from '../../../../app/MerchAppConstant';
import { MerchInfo, RouteData, MerchGroup} from '../MerchSetupClass';
import { AddmerchpopupComponent } from '../addmerchpopup';
import {Subscription} from 'rxjs/Subscription';
import { HeadernavService } from '../../../services/headernav.service';
import { SpinnerComponent } from '../../../common/spinner';

@Component({
    moduleId: module.id,
    selector: 'app-merchsetupmain',
    templateUrl: 'merchsetupmain.component.html',
    styleUrls: ['merchsetupmain.component.css'],
    directives: [CORE_DIRECTIVES, MerchlistComponent, MerchdetailComponent, AddmerchComponent, SpinnerComponent],
    providers: [DispserviceService, HeadernavService]
})
export class MerchsetupmainComponent implements OnInit {

    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    private selectedMerchGroupID: number = 0;
    private SaveMsg: boolean = false;
    item: MerchGroup = new MerchGroup();
    subscription: Subscription;

    public MerchInfoList: Array<MerchInfo> = [];
    public routesList: Array<any> = [];
    public selMerchInfo: MerchInfo;
    public isRequesting: boolean;

    private listIndex: number = 0;
    @Output() refreshList = new EventEmitter();
    @Output() cancelDetail = new EventEmitter();

    @Output() merchSelected = new EventEmitter();
    @Output() merchListSelected = new EventEmitter();
    private selDefaultRoute: RouteData;

    //set the selected Merch from the Merch list pop up
    setselectedMerch($event) {
        this.getNewMerchDetailByGSN($event.$event.newMerch);
    }

    setListselectedMerch($event) {
        this.listIndex = $event.ListIndex;
        this.SaveMsg = false;
        this.getMerchDetailByGSN($event.merchInfo);
    }

    //Refresh the Merch list left hand side and the Merch lookup list after save the Merch
    refreshMerchList($event) {
        if ($event.ReturnStatus == 1)
            this.SaveMsg = true;
        else
            this.SaveMsg = false;
        this.getMerchSetUpContainer(false, $event.NewMerchInfo.GSN);
    }

    setAddedMerchIndexInList(newGSN) {
        for (var i = 0; i < this.MerchInfoList.length; i++) {
            if (this.MerchInfoList[i]["GSN"] == newGSN) {
                this.selMerchInfo = this.MerchInfoList[i];
                this.listIndex = i;
                break;
            }
        }
    }

    cancelDetailMerch($event) {
        if (this.MerchInfoList.length > 0) {
            this.listIndex = 0;
        }
        else {
            this.selMerchInfo = null;
        }
    }

    constructor(private dispService: DispserviceService, public navService: HeadernavService) { }

    private stopRefreshing() {
        this.isRequesting = false;
    }

    ngOnInit() {
        this.subscription = this.navService.navItem$
            .subscribe(item => {
                this.item = item;
                if (this.item != null || this.item != undefined)
                    this.loadMerchData(item);
            }
            );
    }

    loadMerchData(item) {
        this.item = item;
        this.getMerchSetUpContainer(true, '');
        this.initalizeMerchDetail();
    }

    initalizeMerchDetail() {
        this.selDefaultRoute = new RouteData();
        this.selDefaultRoute.RouteID = -1;
        this.selDefaultRoute.RouteName = 'No Default Route';
        this.SaveMsg = false;
    }

    getNewMerchDetailByGSN(newMerch: any) {
        this.selMerchInfo = newMerch;
        this.selMerchInfo.Mon = false;
        this.selMerchInfo.Tues = false;
        this.selMerchInfo.Wed = false;
        this.selMerchInfo.Thu = false;
        this.selMerchInfo.Fri = false;
        this.selMerchInfo.Sat = false;
        this.selMerchInfo.Sun = false;
        this.selMerchInfo.Phone = '';
        this.selMerchInfo.DefaultRouteID = -1;

        this.selDefaultRoute = new RouteData();
        this.selDefaultRoute.RouteID = -1;
        this.selDefaultRoute.RouteName = 'No Default Route';
        this.SaveMsg = false;
    }

    getMerchDetailByGSN(merch: any) {
        this.isRequesting = true;
        this.dispService.set(this._webapi + 'api/Merc/GetMerchDetailContainerByGSN/' + merch.GSN);
        this.dispService.get()
            .subscribe(res => {
                var d: any = res.json();
                this.selMerchInfo = d.MerchUser;
                this.selDefaultRoute = d.Route;
            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            );
    }

    getMerchSetUpContainer(isLoadSelected, newAddedGSN) {
        this.isRequesting = true;
        this.dispService.set(this._webapi + 'api/Merc/GetMerchSetupContainer/');
        var MerchListInput: any = { SAPBranchID: this.item.SAPBranchID, MerchGroupID: this.item.MerchGroupID }
        this.dispService.post(JSON.stringify(MerchListInput), true)
            .subscribe(res => {
                var d: any = res;
                this.MerchInfoList = d.MerchUsers;
                this.routesList = d.Routes;
                if (isLoadSelected) {
                    this.selMerchInfo = d.MerchUser;
                    this.selDefaultRoute = d.Route;
                }
                else {
                    this.setAddedMerchIndexInList(newAddedGSN);
                }
            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            );

    }
}
