import { Component, OnInit, Input, ViewEncapsulation, ElementRef} from '@angular/core';
import { DispserviceService } from '../../services/dispservice.service';
import {AutoCompleteComponent, AutoCompleteDirective} from 'ng2-auto-complete';
import {FilterPipe} from '../../pipes/filter.pipe';
import {MaskDirective} from '../../directives/mask.directive';
import {MerchGroup, MerchGroupInput, MerchGroupDetail,
    MerchGroupRoute, MerchGroupDetailInput, MerchGroupsInput, MerchGroupCheckInput,
    MerchGroupCheckOutput, User} from '../../services/planning';

import {CORE_DIRECTIVES, Control, ControlGroup, FormBuilder, Validators} from '@angular/common';
import {FORM_DIRECTIVES, REACTIVE_FORM_DIRECTIVES, FormGroup, FormControl} from '@angular/forms';
import {Observable} from 'rxjs/Observable';
import 'rxjs/Rx';
import {MerchConstant} from '../../../app/MerchAppConstant';
import {Subscription} from 'rxjs/Subscription';
import { HeadernavService } from '../../services/headernav.service';
import { AsyncValidatorService } from '../../services/async-validator.service';
import { SpinnerComponent } from '../../common/spinner';



@Component({
    moduleId: module.id,
    selector: 'app-create-merch-group',
    templateUrl: 'create-merch-group.component.html',
    styleUrls: ['create-merch-group.component.css'],
    directives: [MaskDirective, CORE_DIRECTIVES, FORM_DIRECTIVES,
        REACTIVE_FORM_DIRECTIVES, AutoCompleteComponent, AutoCompleteDirective, SpinnerComponent],
    providers: [DispserviceService, HeadernavService, AsyncValidatorService],
    pipes: [FilterPipe],


})







export class CreateMerchGroupComponent implements OnInit {

    //Initalize 
    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;//'http://localhost:8888/';

    public merchGroupData: MerchGroup[];
    public merchGroupInput: MerchGroupInput;
    public merchGroupDetail: MerchGroupDetail;
    public dbGroupDetail: any;
    private dbGroupDetailRoutes: Array<any>;
    private dbtempRoutes: Array<any> = [];
    public selectedIdx: number = 0;
    public isRequesting: boolean;




    private groupAreaDisplay: boolean = false;
    private routeAreaDisplay: boolean = false;
    public disabled: boolean = false;

    private routeName: any;
    private IsEditRoute: boolean = false;
    private active: boolean = true;
    private submitted: boolean = false;
    form: ControlGroup;


    private modifiedRoutes: MerchGroupRoute[];
    private IsGroupNameExists: boolean = false;
    private IsRouteNameExists: boolean = false;
    public model4;
    private spanGroupName: boolean = true;
    private IsOwnerValid: boolean = true;
    private ShowSaveMsg: boolean = false;
    item: MerchGroup = new MerchGroup();
    subscription: Subscription;

    public el: HTMLElement;
    public inputGrpEl: HTMLInputElement;
    public inputRouteEl: HTMLInputElement;
    private inputURL: string;
    public isLoading: boolean = false;



    public GetADUsers: string = this._webapi + 'api/Merc/GetUserDetails/:keyword';



    onspanEditGroupName() {
        if (this.spanGroupName)
            this.spanGroupName = false;
        else
            this.spanGroupName = true;
    }


    public onAddGroupSelect() {
        this.initalize();
        this.groupAreaDisplay = true;
        this.spanGroupName = false;
        this.routeAreaDisplay = false;
        if (this.merchGroupData != null) {
            var count = this.merchGroupData.length;
            this.selectedIdx = count;
        }



    }
    public onAddRouteSelect() {
        if (this.routeAreaDisplay)
            this.routeAreaDisplay = false;
        else
            this.routeAreaDisplay = true;
    }
    public onGroupSelect(groupID: number, idx: number) {
        this.selectedIdx = idx;
        this.initalize();
        var detailInput = new MerchGroupDetailInput(this.item.SAPBranchID, groupID);
        this.getMerchGroupDetail(detailInput);
        this.groupAreaDisplay = true;
        this.routeAreaDisplay = false;
    }

    public onAddRouteSave() {
        var route = new MerchGroupRoute();
        route.RouteName = this.routeName;
        route.CanUserDelete = true;
        this.merchGroupDetail.Routes.push(route);
        //this.route_data.push(route);  
        this.routeAreaDisplay = false;
        this.routeName = '';
    }
    public onEditRoute(route: MerchGroupRoute, index: Number) {
        for (var n = 0; n < this.merchGroupDetail.Routes.length; n++) {

            if (index == n) {
                this.merchGroupDetail.Routes[n].IsEditRoute = true;
            }
            else
                this.merchGroupDetail.Routes[n].IsEditRoute = false;

        }


    }





    onRouteDelete(route: MerchGroupRoute, index: Number) {
        for (var n = 0; n < this.merchGroupDetail.Routes.length; n++) {

            if (n == index) {

                if (this.merchGroupDetail.Routes[n].RouteID == route.RouteID && route.RouteID != null && route.CanUserDelete) {
                    this.merchGroupDetail.Routes[n].IsRouteDeleted = true;
                    break;
                }

                else if (this.merchGroupDetail.Routes[n].RouteName == route.RouteName && route.RouteID == null) {

                    this.merchGroupDetail.Routes[n].IsRouteDeleted = true;
                    break;
                }
                else {
                    alert('The route cannot be deleted ');
                    break;

                }
            }

        }

        this.merchGroupDetail.Routes = this.merchGroupDetail.Routes.filter((route: any) => {
            if (route.IsRouteDeleted != true)
            { return route; }
        });

    }

    onMerchGroupDelete(group: MerchGroup) {
        if (group.CanUserDelete) {
            var input = new MerchGroupInput(this.item.SAPBranchID, group.MerchGroupID, '', '', '', '', []);
            this.deleteMerchGroupByID(input);
        }
        else {
            alert('The group cannot be deleted ');
        }
    }

    public onMerchGroupSave() {

        this.submitted = true;
        this.ShowSaveMsg = false;
        if (this.ValidationsCheck()) {
            var userdetail = this.model4;

            if (this.model4.sAMAccountName != undefined && this.model4.DisplayName != undefined) {
                this.merchGroupDetail.DefaultOwnerGSN = this.model4.sAMAccountName;
                this.merchGroupDetail.DefaultOwnerName = this.model4.DisplayName;
            }



            this.merchGroupInput = new MerchGroupInput(this.item.SAPBranchID,
                this.merchGroupDetail.MerchGroupID,
                this.merchGroupDetail.GroupName,
                this.merchGroupDetail.DefaultOwnerGSN,
                this.merchGroupDetail.DefaultOwnerName,
                this.item.LoggedInUser, this.merchGroupDetail.Routes
            );
            this.insertMerchGroupData(this.merchGroupInput);
        }
    }






    validateAsyncGroupName(): void {
        if (this.merchGroupDetail.GroupName != this.dbGroupDetail.GroupName) {
            this.inputGrpEl.focus();
            this.validateAsyncExistingGroupName();
        }
        else
            this.IsGroupNameExists = false;

    }

    validateAsyncGroupInDelay(): void {
        let delayMs = 500;
        //executing after user stopped typing
        this.delay(() => this.validateAsyncExistingGroupName(), delayMs);
    }

    validateAsyncExistingGroupName(): void {


        var URL = this._webapi + 'api/Merc/ValidateExistingMerchGroupDetails/' + this.item.SAPBranchID + '/Group/' + this.merchGroupDetail.GroupName;

        if (this.merchGroupDetail.GroupName.length != 0 && this.merchGroupDetail.GroupName != this.dbGroupDetail.GroupName) {
            this.isLoading = true;
            this.lookupService.sourceUrl = URL;
            this.lookupService.getRemoteData()
                .subscribe(
                resp => {

                    this.IsGroupNameExists = (<any>resp).IsGroupNameExists;
                },
                error => null,
                () => this.isLoading = false //complete
                );
        }
        else {
            this.IsGroupNameExists = false;
        }
    }


    checkExistingRouteList(): boolean {
        var result: boolean = false;
        if (this.routeName.length != 0) {
            this.merchGroupDetail.Routes.find((route: any) => {
                if (route.RouteName == this.routeName)
                { return result = true; }
            });
        }

        return result;
    }


    validateAsyncRouteName(): void {
        if (this.routeName.length != 0 && this.checkExistingRouteList()) {

            this.IsRouteNameExists = true;

        }
        else if (this.routeName.length == 0) {
            this.IsRouteNameExists = false;
        }
        else {
            // this.inputRouteEl.focus();
            this.validateAsyncExistingRouteName();
        }


    }

    validateAsyncRouteInDelay(): void {
        let delayMs = 500;
        //executing after user stopped typing
        this.delay(() => this.validateAsyncRouteName(), delayMs);
    }

    validateAsyncExistingRouteName(): void {

        var URL = this._webapi + 'api/Merc/ValidateExistingMerchGroupDetails/' + this.item.SAPBranchID + '/Route/' + this.routeName;

        if (this.routeName.length != 0) {
            this.isLoading = true;
            this.lookupService.sourceUrl = URL;
            this.lookupService.getRemoteData()
                .subscribe(
                resp => {

                    this.IsRouteNameExists = (<any>resp).IsRouteNameExists;
                },
                error => null,
                () => this.isLoading = false //complete
                );
        }

    }

    addRouteToList(): void {
        if (!this.IsRouteNameExists && this.routeName.length != 0)
            this.onAddRouteSave();
    }


    //  Edit RouteName from the route List


    validateAsyncEditRouteName(route: MerchGroupRoute, i: Number): void {
        var result: boolean = false;


        if (route.RouteName.length != 0) {
            route.IsRequired = false;

            for (var n = 0; n < this.merchGroupDetail.Routes.length; n++) {
                if (n != i) {
                    if (this.merchGroupDetail.Routes[n].RouteName == route.RouteName) {
                        route.IsRouteNameExists = true;
                        break;
                    }
                }
                else {
                    route.IsRouteNameExists = false;

                }
            }

            var flag: MerchGroupRoute[];
            var rName = '';
            flag = this.merchGroupDetail.Routes.filter((r: any) => {
                if (r.IsRouteNameExists)
                { return r; }
            });

            var rList = this.dbGroupDetailRoutes.filter((d: any) => {
                if (route.RouteID == d.RouteID)
                    return d;
            });

            if (route.RouteID != null) {
                if (rList.length > 0)
                    rName = rList[0].RouteName;
            }


            if (flag.length == 0 && rName != route.RouteName && route.RouteID != null) {

                this.validateAsyncExistingEditRouteName(route);
            }

            else if (flag.length == 0 && route.RouteID == null) {

                this.validateAsyncExistingEditRouteName(route);
            }

        }
        else {
            route.IsRouteNameExists = false;
            route.IsRequired = true;
        }




    }

    validateAsyncEditRouteInDelay(route: MerchGroupRoute, i: number): void {
        let delayMs = 500;
        //executing after user stopped typing
        this.delay(() => this.validateAsyncEditRouteName(route, i), delayMs);
    }

    validateAsyncExistingEditRouteName(route: MerchGroupRoute): void {

        var URL = this._webapi + 'api/Merc/ValidateExistingMerchGroupDetails/' + this.item.SAPBranchID + '/Route/' + route.RouteName;

        if (route.RouteName.length != 0) {
            this.isLoading = true;
            this.lookupService.sourceUrl = URL;
            this.lookupService.getRemoteData()
                .subscribe(
                resp => {

                    var d = (<any>resp);

                    if (d.IsRouteNameExists) {
                        route.IsRouteNameExists = true;
                    }
                    else {
                        route.IsRouteNameExists = false;
                    }
                },
                error => null,
                () => this.isLoading = false //complete
                );
        }
        else {
            route.IsRouteNameExists = false;
        }
    }

    private delay = (function () {
        var timer = 0;
        return function (callback: any, ms: number) {
            clearTimeout(timer);
            timer = setTimeout(callback, ms);
        };
    })();



    onMerchGroupCancel() {

        if (this.merchGroupData.length > 0) {
            var detailInput = new MerchGroupDetailInput(this.item.SAPBranchID, this.merchGroupData[0].MerchGroupID);
            this.getMerchGroupDetail(detailInput);
            this.ShowSaveMsg = false;
            if (this.merchGroupData != null) {
                this.selectedIdx = 0;
                this.spanGroupName = true;
            }
        }
        else {
            this.groupAreaDisplay = false;
        }



    }

    ValidationsCheck(): Boolean {
        var flag: MerchGroupRoute[];
        var reqList: MerchGroupRoute[];
        flag = this.merchGroupDetail.Routes.filter((r: any) => {
            if (r.IsRouteNameExists)
            { return r; }
        });

        reqList = this.merchGroupDetail.Routes.filter((r: any) => {
            if (r.IsRequired)
            { return r; }
        });



        if (this.IsGroupNameExists || this.IsRouteNameExists || flag.length > 0 || reqList.length > 0 || !this.form.valid) {
            return false;
        }
        else
            return true;
    }


    constructor(private dispService: DispserviceService, formbuilder: FormBuilder, public navService: HeadernavService,
        elementRef: ElementRef, private lookupService: AsyncValidatorService) {



        this.form = formbuilder.group({
            groupName: ['', Validators.compose([Validators.required, Validators.maxLength(50)])],
            route_name: [],
            owner: ['', Validators.required]

        });
        this.el = elementRef.nativeElement;
        this.initalize();

    }

    private stopRefreshing() {
        this.isRequesting = false;
    }

    initalize() {
        this.dbGroupDetail = new MerchGroupDetail();
        this.merchGroupDetail = new MerchGroupDetail();
        this.merchGroupDetail.MerchGroupID = 0;
        this.dbGroupDetail.Routes = [];
        this.merchGroupDetail.Routes = [];
        //this.route_data = [];
        this.routeName = '';
        this.active = false;
        setTimeout(() => this.active = true, 0);
        this.IsGroupNameExists = false;
        this.IsRouteNameExists = false;
        this.model4 = '';
        this.submitted = false;
        this.IsOwnerValid = true;
        this.spanGroupName = true;
        this.dbtempRoutes = [];
        this.ShowSaveMsg = false;
        this.routeAreaDisplay = false;


    }

    setAddedGroupIndexInList(merchGroupID) {
        for (var i = 0; i < this.merchGroupData.length; i++) {
            if (this.merchGroupData[i]["MerchGroupID"] == merchGroupID) {
                this.selectedIdx = i;
                break;
            }
        }
    }



    insertMerchGroupData(input: MerchGroupInput) {
        this.isRequesting = true;
        this.dispService.set(this._webapi + 'api/Merc/InsertUpdateMerchGroupDetails/');
        this.dispService.post(JSON.stringify(input))
            .subscribe(res => {
                var data: any = res;
                //   this.groupAreaDisplay = false;
                if (data.ReturnStatus == 1) {
                    this.ShowSaveMsg = true;
                    this.getMerchGroups();
                    if (this.merchGroupDetail.MerchGroupID == 0) {
                        this.merchGroupDetail.MerchGroupID = data.NewGroupID;
                        var merchItem = new MerchGroup();
                        merchItem.MerchGroupID = data.NewGroupID;
                        merchItem.GroupName = input.GroupName;
                        merchItem.SAPBranchID = input.SAPBranchID;
                        if (this.item.LoggedInUser == this.merchGroupDetail.DefaultOwnerGSN)
                            merchItem.IsDefault = true;
                        else
                            merchItem.IsDefault = false;
                        this.navService.changeToaddMerchGroup(merchItem);
                    }
                    // Refresh inserted data
                    var detailInput = new MerchGroupDetailInput(this.item.SAPBranchID, this.merchGroupDetail.MerchGroupID);
                    this.getMerchGroupDetail(detailInput);
                }
                else
                    this.ShowSaveMsg = false;
            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            );
    }

    getmerchgroupContainer() {
        var merchgroupsInput: MerchGroupsInput = new MerchGroupsInput(this.item.SAPBranchID);
        this.isRequesting = true;
        this.dispService.set(this._webapi + 'api/Merc/GetMerchGroupDetailsByBranchID/');

        this.dispService.post(JSON.stringify(merchgroupsInput), true)
            .subscribe(res => {
                var d: any = res;
                this.merchGroupData = d.MerchGroupList;
                this.groupAreaDisplay = true;
                if (this.merchGroupData.length > 0) {
                    var detailInput = new MerchGroupDetailInput(this.item.SAPBranchID, this.merchGroupData[0].MerchGroupID);
                    this.getMerchGroupDetail(detailInput);
                    this.selectedIdx = 0;
                }
                else {
                    this.groupAreaDisplay = false;
                }
            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            );
    }

    getMerchGroups() {
        var merchgroupsInput: MerchGroupsInput = new MerchGroupsInput(this.item.SAPBranchID);
        this.isRequesting = true;
        this.dispService.set(this._webapi + 'api/Merc/GetMerchGroupDetailsByBranchID/');

        this.dispService.post(JSON.stringify(merchgroupsInput), true)
            .subscribe(res => {
                var d: any = res;
                this.merchGroupData = d.MerchGroupList;
                this.setAddedGroupIndexInList(this.merchGroupDetail.MerchGroupID);
            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            );
    }


    getMerchGroupDetail(detailInput: MerchGroupDetailInput) {
        this.dispService.set(this._webapi + 'api/Merc/GetMerchGroupDetailsByGroupID/');
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(detailInput), true)
            .subscribe(res => {
                var d: any = res;
                this.dbGroupDetail = Object.assign({}, d);
                this.merchGroupDetail = d;
                this.dbGroupDetailRoutes = [];

                for (var i = 0; i < d.Routes.length; i++) {
                    var item: any = {};
                    item.RouteID = this.merchGroupDetail.Routes[i].RouteID;
                    item.RouteName = this.merchGroupDetail.Routes[i].RouteName;

                    this.dbGroupDetailRoutes.push(item);
                }
                var userdetail: User;
                userdetail = new User();
                userdetail.DisplayName = this.merchGroupDetail.DefaultOwnerName;
                userdetail.sAMAccountName = this.merchGroupDetail.DefaultOwnerGSN;
                this.model4 = this.merchGroupDetail.DefaultOwnerName;
            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            );
    }

    deleteMerchGroupByID(input: MerchGroupInput) {
        this.dispService.set(this._webapi + 'api/Merc/DeleteMerchGroup/');
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(input), true)
            .subscribe(res => {
                var d: any = res;
                this.getMerchGroups();
                var detailInput = new MerchGroupDetailInput(this.item.SAPBranchID, this.merchGroupData[0].MerchGroupID);
                this.getMerchGroupDetail(detailInput);
                this.ShowSaveMsg = false;
                this.selectedIdx = 1;
            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            );
    }

    ngOnInit() {
        //Subscribe
        this.subscription = this.navService.navItem$.subscribe(item => { this.item = item; this.loadmerchGroupData(item); });

    }
    ngOnDestroy() {
        // prevent memory leak when component is destroyed
        this.subscription.unsubscribe();
    }

    loadmerchGroupData(item) {
        this.item = item;
        this.initalize();
        if (this.item != null || this.item != undefined)
            this.getmerchgroupContainer();

    }

}
