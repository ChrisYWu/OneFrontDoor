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
var dispservice_service_1 = require('../../services/dispservice.service');
var dispatch_1 = require('../../services/dispatch');
var MerchAppConstant_1 = require('../../../app/MerchAppConstant');
var filter_pipe_1 = require('../../pipes/filter.pipe');
var StorereassignComponent = (function () {
    function StorereassignComponent(dispService) {
        this.dispService = dispService;
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
        this.routesFiltered = [];
        this.routeReassigned = new core_1.EventEmitter();
        this.merchReassigned = new core_1.EventEmitter();
    }
    StorereassignComponent.prototype.adjustSequence = function () {
        for (var i = 0; i < this.routeData.Stores.length; i++) {
            this.routeData.Stores[i].Sequence = i + 1;
        }
    };
    StorereassignComponent.prototype.getRoutes = function (data) {
        var _this = this;
        this.dispService.post(JSON.stringify(data))
            .subscribe(function (res) {
            var data = res;
            _this.routesFiltered = data.Routes;
            _this.lgModal.show();
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    StorereassignComponent.prototype.setupdatedroute = function (routeid, routename, gsn) {
        var _this = this;
        this.routeId = routeid;
        this.routeName = routename;
        this.gsn = gsn;
        this.reassignStore = new dispatch_1.ReassignStoreInput(this.routeData.DispatchDate, this.storeInput.Sequence, this.lastModifiedByInput, this.routeData.MerchGroupID, this.gsn, this.routeId, this.routeData.RouteID, this.storeInput.AccountID);
        this.dispService.set(this._webapi + 'api/Merc/ReassignStore/');
        this.dispService.post(JSON.stringify(this.reassignStore))
            .subscribe(function (res) {
            var data = res;
            _this.resultInsert = data;
            if (_this.resultInsert.Message == null) {
                _this.routeData.Stores.splice(_this.storeInput.Sequence - 1, 1);
                _this.adjustSequence();
                _this.storeInput.PullNumber = '';
                _this.routeReassigned.emit({ routeid: _this.routeId, store: _this.storeInput });
            }
            _this.lgModal.hide();
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    StorereassignComponent.prototype.openModal = function () {
        this.dispService.set(this._webapi + 'api/Merc/GetRouteList/');
        var routelistinput;
        routelistinput = new dispatch_1.RouteListExcludeCurrentInput(this.routeData.DispatchDate, this.routeData.MerchGroupID, this.routeData.RouteID);
        this.getRoutes(routelistinput);
    };
    StorereassignComponent.prototype.ngOnInit = function () {
    };
    __decorate([
        core_1.ViewChild('lgModal'), 
        __metadata('design:type', ng2_bootstrap_1.ModalDirective)
    ], StorereassignComponent.prototype, "lgModal", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', String)
    ], StorereassignComponent.prototype, "lastModifiedByInput", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', dispatch_1.Store)
    ], StorereassignComponent.prototype, "storeInput", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', dispatch_1.Dispatches)
    ], StorereassignComponent.prototype, "routeData", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', String)
    ], StorereassignComponent.prototype, "routeNameInput", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], StorereassignComponent.prototype, "routeReassigned", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], StorereassignComponent.prototype, "merchReassigned", void 0);
    StorereassignComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-storereassign',
            templateUrl: 'storereassign.component.html',
            styleUrls: ['storereassign.component.css'],
            directives: [ng2_bootstrap_1.MODAL_DIRECTIVES, ng2_bootstrap_1.DROPDOWN_DIRECTIVES, common_1.CORE_DIRECTIVES],
            viewProviders: [ng2_bootstrap_1.BS_VIEW_PROVIDERS],
            providers: [dispservice_service_1.DispserviceService],
            pipes: [filter_pipe_1.FilterPipe]
        }), 
        __metadata('design:paramtypes', [dispservice_service_1.DispserviceService])
    ], StorereassignComponent);
    return StorereassignComponent;
}());
exports.StorereassignComponent = StorereassignComponent;
//# sourceMappingURL=storereassign.component.js.map