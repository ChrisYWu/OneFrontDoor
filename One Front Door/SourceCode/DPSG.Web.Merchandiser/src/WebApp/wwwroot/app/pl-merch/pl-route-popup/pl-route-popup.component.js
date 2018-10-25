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
var pl_merch_info_select_1 = require('../pl-merch-info-select');
var PlRoutePopupComponent = (function () {
    function PlRoutePopupComponent() {
        this.addMerchandiser = new core_1.EventEmitter();
    }
    PlRoutePopupComponent.prototype.selectMerchandiser = function (merchandiser) {
        this.plRouteModal.hide();
        this.addMerchandiser.emit(merchandiser);
    };
    PlRoutePopupComponent.prototype.ngOnInit = function () {
        //debugger;
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], PlRoutePopupComponent.prototype, "plRouteModal", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], PlRoutePopupComponent.prototype, "AvailableMerchandisers", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', core_1.EventEmitter)
    ], PlRoutePopupComponent.prototype, "addMerchandiser", void 0);
    PlRoutePopupComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'pl-route-popup',
            templateUrl: 'pl-route-popup.component.html',
            styleUrls: ['pl-route-popup.component.css'],
            directives: [ng2_bootstrap_1.MODAL_DIRECTIVES, common_1.CORE_DIRECTIVES, pl_merch_info_select_1.PlMerchInfoSelectComponent],
            viewProviders: [ng2_bootstrap_1.BS_VIEW_PROVIDERS],
        }), 
        __metadata('design:paramtypes', [])
    ], PlRoutePopupComponent);
    return PlRoutePopupComponent;
}());
exports.PlRoutePopupComponent = PlRoutePopupComponent;
//# sourceMappingURL=pl-route-popup.component.js.map