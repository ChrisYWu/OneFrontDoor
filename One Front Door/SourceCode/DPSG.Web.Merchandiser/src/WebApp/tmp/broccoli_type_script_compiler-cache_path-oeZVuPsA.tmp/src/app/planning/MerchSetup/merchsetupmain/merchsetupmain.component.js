"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var core_1 = require('@angular/core');
var common_1 = require('@angular/common');
var merchlist_1 = require('../merchlist');
var merchdetail_1 = require('../merchdetail');
var addmerch_1 = require('../addmerch');
var dispservice_service_1 = require('../../../services/dispservice.service');
var MerchAppConstant_1 = require('../../../../app/MerchAppConstant');
var MerchSetupClass_1 = require('../MerchSetupClass');
var headernav_service_1 = require('../../../services/headernav.service');
var MerchsetupmainComponent = (function () {
    function MerchsetupmainComponent(dispService, navService) {
        this.dispService = dispService;
        this.navService = navService;
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
        this.selectedMerchGroupID = 0;
        this.SaveMsg = false;
        this.item = new MerchSetupClass_1.MerchGroup();
        this.MerchInfoList = [];
        this.routesList = [];
        this.listIndex = 0;
        this.refreshList = new core_1.EventEmitter();
        this.cancelDetail = new core_1.EventEmitter();
        this.merchSelected = new core_1.EventEmitter();
        this.merchListSelected = new core_1.EventEmitter();
    }
    //set the selected Merch from the Merch list pop up
    MerchsetupmainComponent.prototype.setselectedMerch = function ($event) {
        this.getNewMerchDetailByGSN($event.$event.newMerch);
    };
    MerchsetupmainComponent.prototype.setListselectedMerch = function ($event) {
        this.listIndex = $event.ListIndex;
        this.SaveMsg = false;
        this.getMerchDetailByGSN($event.merchInfo);
    };
    //Refresh the Merch list left hand side and the Merch lookup list after save the Merch
    MerchsetupmainComponent.prototype.refreshMerchList = function ($event) {
        if ($event.ReturnStatus == 1)
            this.SaveMsg = true;
        else
            this.SaveMsg = false;
        this.getMerchSetUpContainer(false, $event.NewMerchInfo.GSN);
    };
    MerchsetupmainComponent.prototype.setAddedMerchIndexInList = function (newGSN) {
        for (var i = 0; i < this.MerchInfoList.length; i++) {
            if (this.MerchInfoList[i]["GSN"] == newGSN) {
                this.selMerchInfo = this.MerchInfoList[i];
                this.listIndex = i;
                break;
            }
        }
    };
    MerchsetupmainComponent.prototype.cancelDetailMerch = function ($event) {
        if (this.MerchInfoList.length > 0) {
            this.listIndex = 0;
        }
        else {
            this.selMerchInfo = null;
        }
    };
    MerchsetupmainComponent.prototype.ngOnInit = function () {
        var _this = this;
        this.subscription = this.navService.navItem$
            .subscribe(function (item) {
            _this.item = item;
            if (_this.item != null || _this.item != undefined)
                _this.loadMerchData(item);
        });
    };
    MerchsetupmainComponent.prototype.loadMerchData = function (item) {
        this.item = item;
        this.getMerchSetUpContainer(true, '');
        this.initalizeMerchDetail();
    };
    MerchsetupmainComponent.prototype.initalizeMerchDetail = function () {
        this.selDefaultRoute = new MerchSetupClass_1.RouteData();
        this.selDefaultRoute.RouteID = -1;
        this.selDefaultRoute.RouteName = 'No Default Route';
        this.SaveMsg = false;
    };
    MerchsetupmainComponent.prototype.getNewMerchDetailByGSN = function (newMerch) {
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
        this.selDefaultRoute = new MerchSetupClass_1.RouteData();
        this.selDefaultRoute.RouteID = -1;
        this.selDefaultRoute.RouteName = 'No Default Route';
        this.SaveMsg = false;
    };
    MerchsetupmainComponent.prototype.getMerchDetailByGSN = function (merch) {
        var _this = this;
        this.dispService.set(this._webapi + 'api/Merc/GetMerchDetailContainerByGSN/' + merch.GSN);
        this.dispService.get()
            .subscribe(function (res) {
            var d = res.json();
            _this.selMerchInfo = d.MerchUser;
            _this.selDefaultRoute = d.Route;
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    MerchsetupmainComponent.prototype.getMerchSetUpContainer = function (isLoadSelected, newAddedGSN) {
        var _this = this;
        this.dispService.set(this._webapi + 'api/Merc/GetMerchSetupContainer/');
        var MerchListInput = { SAPBranchID: this.item.SAPBranchID, MerchGroupID: this.item.MerchGroupID };
        this.dispService.post(JSON.stringify(MerchListInput), true)
            .subscribe(function (res) {
            var d = res;
            _this.MerchInfoList = d.MerchUsers;
            _this.routesList = d.Routes;
            if (isLoadSelected) {
                _this.selMerchInfo = d.MerchUser;
                _this.selDefaultRoute = d.Route;
            }
            else {
                _this.setAddedMerchIndexInList(newAddedGSN);
            }
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], MerchsetupmainComponent.prototype, "refreshList", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], MerchsetupmainComponent.prototype, "cancelDetail", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], MerchsetupmainComponent.prototype, "merchSelected", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], MerchsetupmainComponent.prototype, "merchListSelected", void 0);
    MerchsetupmainComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-merchsetupmain',
            templateUrl: 'merchsetupmain.component.html',
            styleUrls: ['merchsetupmain.component.css'],
            directives: [common_1.CORE_DIRECTIVES, merchlist_1.MerchlistComponent, merchdetail_1.MerchdetailComponent, addmerch_1.AddmerchComponent],
            providers: [dispservice_service_1.DispserviceService, headernav_service_1.HeadernavService]
        }), 
        __metadata('design:paramtypes', [dispservice_service_1.DispserviceService, headernav_service_1.HeadernavService])
    ], MerchsetupmainComponent);
    return MerchsetupmainComponent;
}());
exports.MerchsetupmainComponent = MerchsetupmainComponent;
//# sourceMappingURL=merchsetupmain.component.js.map