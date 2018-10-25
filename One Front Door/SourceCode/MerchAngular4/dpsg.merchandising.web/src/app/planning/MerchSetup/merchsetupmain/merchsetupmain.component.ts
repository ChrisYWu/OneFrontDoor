import { Component, OnInit, Output, EventEmitter, ViewChild } from '@angular/core';
//import {CORE_DIRECTIVES} from '@angular/common';
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
   // moduleId: module.id,
    selector: 'app-merchsetupmain',
    templateUrl: 'merchsetupmain.component.html',
    styleUrls: ['merchsetupmain.component.css'],
   // directives: [MerchlistComponent, MerchdetailComponent, AddmerchComponent, SpinnerComponent],
    providers: [DispserviceService, HeadernavService]
})
export class MerchsetupmainComponent implements OnInit {

    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    private selectedMerchGroupID: number = 0;
    public SaveMsg: boolean = false;
    item: MerchGroup = new MerchGroup();
    subscription: Subscription;

    public MerchInfoList: Array<MerchInfo> = [];
    public routesList: Array<any> = [];
    public routesListAll: Array<any> = [];
    public selMerchInfo: MerchInfo;
    public isRequesting: boolean;

    public listIndex: number = 0;
    @Output() refreshList = new EventEmitter();
    @Output() cancelDetail = new EventEmitter();

    @Output() merchSelected = new EventEmitter();
    @Output() merchListSelected = new EventEmitter();
    @ViewChild(MerchdetailComponent) public merchDetailCmp:MerchdetailComponent;
    public selDefaultRoute: RouteData;
    public selDefaultRouteMon: RouteData;
    public selDefaultRouteTue: RouteData;
    public selDefaultRouteWed: RouteData;
    public selDefaultRouteThu: RouteData;
    public selDefaultRouteFri: RouteData;
    public selDefaultRouteSat: RouteData;
    public selDefaultRouteSun: RouteData;

    
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
           this.getMerchDetailByGSN(this.MerchInfoList[0]);
        }
        else {
            this.selMerchInfo = null;
        }
    }

    constructor(private dispService: DispserviceService, public navService: HeadernavService) { }

    public stopRefreshing() {
        this.isRequesting = false;
    }

    onMerchSave()
    {
       this.merchDetailCmp.onMerchMainSave();
    }

    onMerchCancel()
    {
        this.merchDetailCmp.onCancel();
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
        this.selDefaultRoute = new RouteData(-1,  'No Default Route');
        this.selDefaultRouteMon = new RouteData(-1,  'No Default Route');
        this.selDefaultRouteTue = new RouteData(-1,  'No Default Route');
        this.selDefaultRouteWed = new RouteData(-1,  'No Default Route');
        this.selDefaultRouteThu = new RouteData(-1,  'No Default Route');
        this.selDefaultRouteFri = new RouteData(-1,  'No Default Route');
        this.selDefaultRouteSat = new RouteData(-1,  'No Default Route');
        this.selDefaultRouteSun = new RouteData(-1,  'No Default Route');

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
        this.selDefaultRoute = new RouteData(-1,  'No Default Route');
        this.selDefaultRouteMon = new RouteData(-1,  'No Default Route');
        this.selDefaultRouteTue = new RouteData(-1,  'No Default Route');
        this.selDefaultRouteWed = new RouteData(-1,  'No Default Route');
        this.selDefaultRouteThu = new RouteData(-1,  'No Default Route');
        this.selDefaultRouteFri = new RouteData(-1,  'No Default Route');
        this.selDefaultRouteSat = new RouteData(-1,  'No Default Route');
        this.selDefaultRouteSun = new RouteData(-1,  'No Default Route');

        
        this.SaveMsg = false;
    }

    SetMonSunRoutes()
    {
        if(this.selMerchInfo && this.selMerchInfo.Mon && this.selMerchInfo.MonRouteInfo)
        {
            this.selDefaultRouteMon = new RouteData(+this.selMerchInfo.MonRouteInfo.split('|')[0],  this.selMerchInfo.MonRouteInfo.split('|')[1]);
        }
        else
        {
            this.selDefaultRouteMon = new RouteData(-1,  'No Default Route');
        }

        if(this.selMerchInfo && this.selMerchInfo.Tues && this.selMerchInfo.TueRouteInfo)
        {
            this.selDefaultRouteTue = new RouteData(+this.selMerchInfo.TueRouteInfo.split('|')[0],  this.selMerchInfo.TueRouteInfo.split('|')[1]);
        }
        else
        {
            this.selDefaultRouteTue = new RouteData(-1,  'No Default Route');
        }

        if(this.selMerchInfo && this.selMerchInfo.Wed && this.selMerchInfo.WedRouteInfo)
        {
            this.selDefaultRouteWed = new RouteData(+this.selMerchInfo.WedRouteInfo.split('|')[0],  this.selMerchInfo.WedRouteInfo.split('|')[1]);
        }
        else
        {
             this.selDefaultRouteWed = new RouteData(-1,  'No Default Route');
        }
        
        if(this.selMerchInfo && this.selMerchInfo.Thu && this.selMerchInfo.ThuRouteInfo)
        {
            this.selDefaultRouteThu = new RouteData(+this.selMerchInfo.ThuRouteInfo.split('|')[0],  this.selMerchInfo.ThuRouteInfo.split('|')[1]);
        }
        else
        {
              this.selDefaultRouteThu = new RouteData(-1,  'No Default Route');
        }
        if(this.selMerchInfo && this.selMerchInfo.Fri && this.selMerchInfo.FriRouteInfo)
        {
            this.selDefaultRouteFri = new RouteData(+this.selMerchInfo.FriRouteInfo.split('|')[0],  this.selMerchInfo.FriRouteInfo.split('|')[1]);
        }
        else
        {
              this.selDefaultRouteFri = new RouteData(-1,  'No Default Route');
        }
        if(this.selMerchInfo && this.selMerchInfo.Sat && this.selMerchInfo.SatRouteInfo)
        {
            this.selDefaultRouteSat = new RouteData(+this.selMerchInfo.SatRouteInfo.split('|')[0],  this.selMerchInfo.SatRouteInfo.split('|')[1]);
        }
        else
        {
            this.selDefaultRouteSat = new RouteData(-1,  'No Default Route');
        }
        if(this.selMerchInfo && this.selMerchInfo.Sun && this.selMerchInfo.SunRouteInfo)
        {
            this.selDefaultRouteSun = new RouteData(+this.selMerchInfo.SunRouteInfo.split('|')[0],  this.selMerchInfo.SunRouteInfo.split('|')[1]);
        }
        else
        {
            this.selDefaultRouteSun = new RouteData(-1,  'No Default Route');
        }
    }

    getMerchDetailByGSN(merch: any) {
        this.isRequesting = true;
        this.dispService.set(this._webapi + 'api/Merc/GetMerchDetailContainerByGSN/' + merch.GSN);
        this.dispService.get()
            .subscribe(res => {
                var d: any = res.json();
                this.selMerchInfo = d.MerchUser;
                this.selDefaultRoute = d.Route;
                this.SetMonSunRoutes();
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
                this.routesListAll = d.RoutesAll;
                if (isLoadSelected) {
                    this.selMerchInfo = d.MerchUser;
                    this.selDefaultRoute = d.Route;
                    this.SetMonSunRoutes();
                    
                }
                else {
                    this.setAddedMerchIndexInList(newAddedGSN);
                }
            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            );

    }

   refreshDeletedMerchList()
    {
        this.getMerchSetUpContainer(true, '');
    }
}
