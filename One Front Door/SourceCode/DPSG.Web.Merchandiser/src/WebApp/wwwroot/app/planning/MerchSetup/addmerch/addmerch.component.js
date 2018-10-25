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
var addmerchpopup_1 = require('../addmerchpopup');
var MerchSetupClass_1 = require('../MerchSetupClass');
var AddmerchComponent = (function () {
    function AddmerchComponent() {
        this.merchLookupList = [];
        this.merchSelected = new core_1.EventEmitter();
    }
    AddmerchComponent.prototype.closedialog = function () {
        this.lgModal.hide();
    };
    AddmerchComponent.prototype.ngOnInit = function () {
    };
    AddmerchComponent.prototype.setselectedMerch = function ($event) {
        if ($event.close == 'true') {
            this.closedialog();
        }
        this.merchSelected.emit({ $event: $event });
    };
    __decorate([
        core_1.ViewChild('lgModal'), 
        __metadata('design:type', ng2_bootstrap_1.ModalDirective)
    ], AddmerchComponent.prototype, "lgModal", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', MerchSetupClass_1.MerchGroup)
    ], AddmerchComponent.prototype, "MerchGroupItem", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], AddmerchComponent.prototype, "merchLookupList", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], AddmerchComponent.prototype, "merchSelected", void 0);
    AddmerchComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-addmerch',
            templateUrl: 'addmerch.component.html',
            styleUrls: ['addmerch.component.css'],
            directives: [common_1.CORE_DIRECTIVES, addmerchpopup_1.AddmerchpopupComponent, ng2_bootstrap_1.MODAL_DIRECTIVES],
            viewProviders: [ng2_bootstrap_1.BS_VIEW_PROVIDERS],
        }), 
        __metadata('design:paramtypes', [])
    ], AddmerchComponent);
    return AddmerchComponent;
}());
exports.AddmerchComponent = AddmerchComponent;
//# sourceMappingURL=addmerch.component.js.map