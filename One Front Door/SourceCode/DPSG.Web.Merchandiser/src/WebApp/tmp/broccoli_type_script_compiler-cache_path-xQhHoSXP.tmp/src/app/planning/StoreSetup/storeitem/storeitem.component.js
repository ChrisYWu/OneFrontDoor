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
var storelist_popup_1 = require('../storelist-popup');
var planning_1 = require('../../../services/planning');
var StoreitemComponent = (function () {
    function StoreitemComponent() {
        this.storeSelected = new core_1.EventEmitter();
        this.storeLookupList = [];
    }
    StoreitemComponent.prototype.closedialog = function () {
        this.lgModal.hide();
    };
    StoreitemComponent.prototype.ngOnInit = function () {
    };
    StoreitemComponent.prototype.setselectedStore = function ($event) {
        if ($event.close == 'true') {
            this.closedialog();
        }
        this.storeSelected.emit({ $event: $event });
    };
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], StoreitemComponent.prototype, "storeSelected", void 0);
    __decorate([
        core_1.ViewChild('lgModal'), 
        __metadata('design:type', ng2_bootstrap_1.ModalDirective)
    ], StoreitemComponent.prototype, "lgModal", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], StoreitemComponent.prototype, "storeLookupList", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', planning_1.MerchGroup)
    ], StoreitemComponent.prototype, "MerchGroupItem", void 0);
    StoreitemComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'storeitem',
            templateUrl: 'storeitem.component.html',
            styleUrls: ['storeitem.component.css'],
            directives: [common_1.CORE_DIRECTIVES, storelist_popup_1.StorelistPopupComponent, ng2_bootstrap_1.MODAL_DIRECTIVES],
            viewProviders: [ng2_bootstrap_1.BS_VIEW_PROVIDERS],
        }), 
        __metadata('design:paramtypes', [])
    ], StoreitemComponent);
    return StoreitemComponent;
}());
exports.StoreitemComponent = StoreitemComponent;
//# sourceMappingURL=storeitem.component.js.map