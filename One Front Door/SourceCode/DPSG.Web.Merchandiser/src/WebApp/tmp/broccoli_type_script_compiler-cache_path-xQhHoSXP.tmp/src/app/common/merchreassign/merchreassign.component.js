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
var filter_pipe_1 = require('../../pipes/filter.pipe');
var dispatch_1 = require('../../services/dispatch');
var dispservice_service_1 = require('../../services/dispservice.service');
var MerchAppConstant_1 = require('../../../app/MerchAppConstant');
var MerchreassignComponent = (function () {
    function MerchreassignComponent(dispService) {
        this.dispService = dispService;
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
    }
    MerchreassignComponent.prototype.reassignMerch = function (gsn, lastname, firstname) {
        var _this = this;
        var reassignMerchInput = new dispatch_1.ReassignMerchInput(this.routeData.DispatchDate, this.lastModifiedByInput, this.routeData.MerchGroupID, gsn, this.routeData.RouteID);
        var resultInsert;
        this.dispService.set(this._webapi + 'api/Merc/ReassignMerch/');
        this.dispService.post(JSON.stringify(reassignMerchInput))
            .subscribe(function (res) {
            var data = res;
            resultInsert = data;
            if (resultInsert.ReturnStatus == 1) {
                _this.routeData.GSN = gsn;
                _this.routeData.FirstName = firstname;
                _this.routeData.LastName = lastname;
            }
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    MerchreassignComponent.prototype.ngOnInit = function () {
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], MerchreassignComponent.prototype, "unassignedOtherMerchInput", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], MerchreassignComponent.prototype, "unassignedMerchInput", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', dispatch_1.Dispatches)
    ], MerchreassignComponent.prototype, "routeData", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', String)
    ], MerchreassignComponent.prototype, "lastModifiedByInput", void 0);
    MerchreassignComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-merchreassign',
            templateUrl: 'merchreassign.component.html',
            styleUrls: ['merchreassign.component.css'],
            directives: [common_1.CORE_DIRECTIVES, ng2_bootstrap_1.TAB_DIRECTIVES, ng2_bootstrap_1.MODAL_DIRECTIVES],
            pipes: [filter_pipe_1.FilterPipe],
            viewProviders: [ng2_bootstrap_1.BS_VIEW_PROVIDERS],
            providers: [dispservice_service_1.DispserviceService]
        }), 
        __metadata('design:paramtypes', [dispservice_service_1.DispserviceService])
    ], MerchreassignComponent);
    return MerchreassignComponent;
}());
exports.MerchreassignComponent = MerchreassignComponent;
//# sourceMappingURL=merchreassign.component.js.map