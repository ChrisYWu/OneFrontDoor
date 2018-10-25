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
var planning_1 = require('../../../services/planning');
var ng2_map_1 = require('ng2-map');
var ng2_bootstrap_1 = require('ng2-bootstrap/ng2-bootstrap');
var dispservice_service_1 = require('../../../services/dispservice.service');
var MerchAppConstant_1 = require('../../../../app/MerchAppConstant');
var ng2_bootstrap_2 = require('ng2-bootstrap/ng2-bootstrap');
var StoredetailComponent = (function () {
    function StoredetailComponent(dispService) {
        this.dispService = dispService;
        this.disabled = false;
        this.status = { isopen: false };
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT; //'http://localhost:8888/';
        this.ShowSaveMsg = false;
        this.refreshList = new core_1.EventEmitter();
        this.cancelDetail = new core_1.EventEmitter();
        ng2_map_1.Ng2MapComponent['apiUrl'] = "https://maps.google.com/maps/api/js?key=AIzaSyCbMGRUwcqKjlYX4h4-P6t-xcDryRYLmCM";
    }
    StoredetailComponent.prototype.toggled = function (open) {
        console.log('Dropdown is now: ', open);
    };
    StoredetailComponent.prototype.toggleDropdown = function ($event) {
        $event.preventDefault();
        $event.stopPropagation();
        this.status.isopen = !this.status.isopen;
    };
    StoredetailComponent.prototype.onSelectRoute = function (route) {
        this.selectedRoute = route;
    };
    StoredetailComponent.prototype.onChkChange = function (week) {
        if (week.FirstPull)
            week.FirstPull = false;
        else
            week.FirstPull = true;
    };
    StoredetailComponent.prototype.onSecondPullChkChange = function (p) {
        if (p.SecondPull)
            p.SecondPull = false;
        else
            p.SecondPull = true;
    };
    StoredetailComponent.prototype.onCancel = function () {
        this.cancelDetail.emit({});
    };
    StoredetailComponent.prototype.onSave = function () {
        var route = this.selectedRoute;
        var week1 = this.daysofWeek;
        var input = {
            SAPBranchID: this.MerchGroupItem.SAPBranchID,
            MerchGroupID: this.MerchGroupItem.MerchGroupID,
            SAPAccountNumber: this.storeSelectedInfo.SAPAccountNumber,
            DefaultRouteID: this.selectedRoute.RouteID,
            WeekDays: this.daysofWeek,
            GSN: this.MerchGroupItem.LoggedInUser
        };
        this.insertStoreSetUpData(input, this.storeSelectedInfo);
    };
    StoredetailComponent.prototype.insertStoreSetUpData = function (input, store) {
        var _this = this;
        this.dispService.set(this._webapi + 'api/Merc/InsertUpdateStoreSetupDetails/');
        this.dispService.post(JSON.stringify(input))
            .subscribe(function (res) {
            var data = res;
            if (data.ReturnStatus == 1) {
                var result = { ReturnStatus: data.ReturnStatus, Account: store };
                _this.refreshList.emit(result);
            }
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    StoredetailComponent.prototype.ngOnInit = function () {
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], StoredetailComponent.prototype, "storeSelectedInfo", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], StoredetailComponent.prototype, "routeList", void 0);
    __decorate([
        //'http://localhost:8888/';
        core_1.Input(), 
        __metadata('design:type', planning_1.RouteInfo)
    ], StoredetailComponent.prototype, "selectedRoute", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], StoredetailComponent.prototype, "daysofWeek", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Boolean)
    ], StoredetailComponent.prototype, "ShowSaveMsg", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], StoredetailComponent.prototype, "refreshList", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', planning_1.MerchGroup)
    ], StoredetailComponent.prototype, "MerchGroupItem", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], StoredetailComponent.prototype, "cancelDetail", void 0);
    StoredetailComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'storedetail',
            templateUrl: 'storedetail.component.html',
            styleUrls: ['storedetail.component.css'],
            providers: [dispservice_service_1.DispserviceService],
            directives: [common_1.CORE_DIRECTIVES, ng2_map_1.NG2_MAP_DIRECTIVES, ng2_bootstrap_1.DROPDOWN_DIRECTIVES, ng2_bootstrap_2.MODAL_DIRECTIVES],
            viewProviders: [ng2_bootstrap_2.BS_VIEW_PROVIDERS]
        }), 
        __metadata('design:paramtypes', [dispservice_service_1.DispserviceService])
    ], StoredetailComponent);
    return StoredetailComponent;
}());
exports.StoredetailComponent = StoredetailComponent;
//# sourceMappingURL=storedetail.component.js.map