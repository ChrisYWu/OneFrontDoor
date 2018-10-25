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
var _1 = require('../rsstorelist/');
var RouteStoreAssignment_1 = require('../RouteStoreAssignment');
var RstabsComponent = (function () {
    function RstabsComponent() {
        this.accountSelected = new core_1.EventEmitter();
    }
    RstabsComponent.prototype.setselectedAcct = function ($event) {
        this.accountSelected.emit({ $event: $event });
    };
    RstabsComponent.prototype.setActiveTab = function (index) {
        this.tabAccts = this.allInputAccts;
    };
    ;
    RstabsComponent.prototype.ngOnInit = function () {
        this.tabAccts = this.allInputAccts;
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], RstabsComponent.prototype, "unassignedInputAccts", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], RstabsComponent.prototype, "allInputAccts", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], RstabsComponent.prototype, "otherInputAccts", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', RouteStoreAssignment_1.Dispatches)
    ], RstabsComponent.prototype, "routeDataInput", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', String)
    ], RstabsComponent.prototype, "lastModifiedByInput", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], RstabsComponent.prototype, "accountSelected", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Number)
    ], RstabsComponent.prototype, "selectedWeekDayInput", void 0);
    RstabsComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-rstabs',
            directives: [common_1.CORE_DIRECTIVES, ng2_bootstrap_1.TAB_DIRECTIVES, _1.RsstorelistComponent],
            templateUrl: 'rstabs.component.html',
            styleUrls: ['rstabs.component.css']
        }), 
        __metadata('design:paramtypes', [])
    ], RstabsComponent);
    return RstabsComponent;
}());
exports.RstabsComponent = RstabsComponent;
//# sourceMappingURL=rstabs.component.js.map