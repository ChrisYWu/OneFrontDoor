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
var _1 = require('../rstabs/');
var dispservice_service_1 = require('../../services/dispservice.service');
var RouteStoreAssignment_1 = require('../RouteStoreAssignment');
var MerchAppConstant_1 = require('../../../app/MerchAppConstant');
var RsaddstoreComponent = (function () {
    function RsaddstoreComponent() {
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
        this.accountSelected = new core_1.EventEmitter();
        this.emptyStore = new RouteStoreAssignment_1.Store(null, null, null, null);
    }
    RsaddstoreComponent.prototype.closedialog = function () {
        this.lgModal.hide();
    };
    RsaddstoreComponent.prototype.setselectedAcct = function ($event) {
        if ($event.$event.close == 'true') {
            this.closedialog();
        }
        this.accountSelected.emit({ $event: $event });
    };
    RsaddstoreComponent.prototype.ngOnInit = function () {
    };
    __decorate([
        core_1.ViewChild('lgModal'), 
        __metadata('design:type', ng2_bootstrap_1.ModalDirective)
    ], RsaddstoreComponent.prototype, "lgModal", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], RsaddstoreComponent.prototype, "unassignedInputAccts", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], RsaddstoreComponent.prototype, "allInputAccts", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', String)
    ], RsaddstoreComponent.prototype, "lastModifiedByInput", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', RouteStoreAssignment_1.Dispatches)
    ], RsaddstoreComponent.prototype, "routeDataInput", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Number)
    ], RsaddstoreComponent.prototype, "selectedWeekDayInput", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], RsaddstoreComponent.prototype, "accountSelected", void 0);
    RsaddstoreComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-rsaddstore',
            templateUrl: 'rsaddstore.component.html',
            styleUrls: ['rsaddstore.component.css'],
            directives: [ng2_bootstrap_1.MODAL_DIRECTIVES, common_1.CORE_DIRECTIVES, _1.RstabsComponent],
            viewProviders: [ng2_bootstrap_1.BS_VIEW_PROVIDERS],
            providers: [dispservice_service_1.DispserviceService]
        }), 
        __metadata('design:paramtypes', [])
    ], RsaddstoreComponent);
    return RsaddstoreComponent;
}());
exports.RsaddstoreComponent = RsaddstoreComponent;
//# sourceMappingURL=rsaddstore.component.js.map