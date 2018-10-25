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
var ng2_bootstrap_1 = require('ng2-bootstrap/ng2-bootstrap');
var dispservice_service_1 = require('../../../services/dispservice.service');
var MerchAppConstant_1 = require('../../../../app/MerchAppConstant');
var ng2_bootstrap_2 = require('ng2-bootstrap/ng2-bootstrap');
var MerchSetupClass_1 = require('../MerchSetupClass');
var MerchdetailComponent = (function () {
    function MerchdetailComponent(dispService) {
        this.dispService = dispService;
        this.disabled = false;
        this.status = { isopen: false };
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
        this.ShowSaveMsg = false;
        this.refreshList = new core_1.EventEmitter();
        this.cancelDetail = new core_1.EventEmitter();
    }
    MerchdetailComponent.prototype.toggled = function (open) {
        //console.log('Dropdown is now: ', open);
    };
    MerchdetailComponent.prototype.toggleDropdown = function ($event) {
        $event.preventDefault();
        $event.stopPropagation();
        this.status.isopen = !this.status.isopen;
    };
    MerchdetailComponent.prototype.onSelectRoute = function (route) {
        this.selectedRoute = route;
    };
    MerchdetailComponent.prototype.onCancel = function () {
        this.cancelDetail.emit({});
    };
    MerchdetailComponent.prototype.onSave = function () {
        this.merchInput = new MerchSetupClass_1.MerchSetupDetailInput(this.merchSelectedInfo.GSN, this.merchSelectedInfo.MerchName, this.merchSelectedInfo.FirstName, this.merchSelectedInfo.LastName, this.selectedRoute.RouteID, this.MerchGroupItem.MerchGroupID, this.merchSelectedInfo.Phone, this.merchSelectedInfo.Mon, this.merchSelectedInfo.Tues, this.merchSelectedInfo.Wed, this.merchSelectedInfo.Thu, this.merchSelectedInfo.Fri, this.merchSelectedInfo.Sat, this.merchSelectedInfo.Sun, this.MerchGroupItem.LoggedInUser);
        this.insertMerchSetUpData(this.merchInput);
    };
    MerchdetailComponent.prototype.insertMerchSetUpData = function (merch) {
        var _this = this;
        this.dispService.set(this._webapi + 'api/Merc/InsertUpdateMerchSetupDetail/');
        this.dispService.post(JSON.stringify(merch))
            .subscribe(function (res) {
            var data = res;
            if (data.ReturnStatus == 1) {
                var result = { ReturnStatus: data.ReturnStatus, NewMerchInfo: merch };
                _this.refreshList.emit(result);
            }
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    MerchdetailComponent.prototype.ngOnInit = function () {
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], MerchdetailComponent.prototype, "routeList", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', MerchSetupClass_1.RouteData)
    ], MerchdetailComponent.prototype, "selectedRoute", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Boolean)
    ], MerchdetailComponent.prototype, "ShowSaveMsg", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], MerchdetailComponent.prototype, "refreshList", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', MerchSetupClass_1.MerchGroup)
    ], MerchdetailComponent.prototype, "MerchGroupItem", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], MerchdetailComponent.prototype, "cancelDetail", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', MerchSetupClass_1.MerchInfo)
    ], MerchdetailComponent.prototype, "merchSelectedInfo", void 0);
    MerchdetailComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-merchdetail',
            templateUrl: 'merchdetail.component.html',
            styleUrls: ['merchdetail.component.css'],
            providers: [dispservice_service_1.DispserviceService],
            directives: [common_1.CORE_DIRECTIVES, ng2_bootstrap_1.DROPDOWN_DIRECTIVES, ng2_bootstrap_2.MODAL_DIRECTIVES],
            viewProviders: [ng2_bootstrap_2.BS_VIEW_PROVIDERS]
        }), 
        __metadata('design:paramtypes', [dispservice_service_1.DispserviceService])
    ], MerchdetailComponent);
    return MerchdetailComponent;
}());
exports.MerchdetailComponent = MerchdetailComponent;
//# sourceMappingURL=merchdetail.component.js.map