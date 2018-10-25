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
var image_list_1 = require('../image-list');
var MonitorPopupComponent = (function () {
    function MonitorPopupComponent() {
        this.storePictures = [];
        this.displayPictures = [];
    }
    MonitorPopupComponent.prototype.ngOnInit = function () {
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], MonitorPopupComponent.prototype, "storeModal", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], MonitorPopupComponent.prototype, "stop", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], MonitorPopupComponent.prototype, "storeDetails", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], MonitorPopupComponent.prototype, "storePictures", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], MonitorPopupComponent.prototype, "displayPictures", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], MonitorPopupComponent.prototype, "storeSignature", void 0);
    MonitorPopupComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'monitor-popup',
            templateUrl: 'monitor-popup.component.html',
            styleUrls: ['monitor-popup.component.css'],
            directives: [ng2_bootstrap_1.MODAL_DIRECTIVES, common_1.CORE_DIRECTIVES, image_list_1.ImageListComponent],
            viewProviders: [ng2_bootstrap_1.BS_VIEW_PROVIDERS],
        }), 
        __metadata('design:paramtypes', [])
    ], MonitorPopupComponent);
    return MonitorPopupComponent;
}());
exports.MonitorPopupComponent = MonitorPopupComponent;
//# sourceMappingURL=monitor-popup.component.js.map