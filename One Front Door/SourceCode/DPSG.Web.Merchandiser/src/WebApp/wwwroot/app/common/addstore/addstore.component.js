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
var _1 = require('../tabs/');
var dispservice_service_1 = require('../../services/dispservice.service');
var dispatch_1 = require('../../services/dispatch');
var MerchAppConstant_1 = require('../../../app/MerchAppConstant');
var AddstoreComponent = (function () {
    function AddstoreComponent(dispService) {
        this.dispService = dispService;
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
        this.accountSelected = new core_1.EventEmitter();
        this.emptyStore = new dispatch_1.Store(null, null, null, null);
    }
    AddstoreComponent.prototype.closedialog = function () {
        this.lgModal.hide();
    };
    AddstoreComponent.prototype.setselectedAcct = function ($event) {
        if ($event.$event.close == 'true') {
            this.closedialog();
        }
        this.accountSelected.emit({ $event: $event });
    };
    AddstoreComponent.prototype.ngOnInit = function () {
    };
    __decorate([
        core_1.ViewChild('lgModal'), 
        __metadata('design:type', ng2_bootstrap_1.ModalDirective)
    ], AddstoreComponent.prototype, "lgModal", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], AddstoreComponent.prototype, "unassignedInputAccts", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], AddstoreComponent.prototype, "allInputAccts", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], AddstoreComponent.prototype, "otherInputAccts", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', String)
    ], AddstoreComponent.prototype, "lastModifiedByInput", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', dispatch_1.Dispatches)
    ], AddstoreComponent.prototype, "routeDataInput", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], AddstoreComponent.prototype, "accountSelected", void 0);
    AddstoreComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-addstore',
            templateUrl: 'addstore.component.html',
            styleUrls: ['addstore.component.css'],
            directives: [ng2_bootstrap_1.MODAL_DIRECTIVES, common_1.CORE_DIRECTIVES, _1.TabsComponent],
            viewProviders: [ng2_bootstrap_1.BS_VIEW_PROVIDERS],
            providers: [dispservice_service_1.DispserviceService]
        }), 
        __metadata('design:paramtypes', [dispservice_service_1.DispserviceService])
    ], AddstoreComponent);
    return AddstoreComponent;
}());
exports.AddstoreComponent = AddstoreComponent;
//# sourceMappingURL=addstore.component.js.map