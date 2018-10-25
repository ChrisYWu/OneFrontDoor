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
var _1 = require('../storelist/');
//import { DispserviceService } from '../../services/dispservice.service';
//import {Accounts} from '../../services/dispatch';
var dispatch_1 = require('../../services/dispatch');
//import {AccountInput} from '../../services/dispatch';
var TabsComponent = (function () {
    function TabsComponent() {
        this.accountSelected = new core_1.EventEmitter();
    }
    TabsComponent.prototype.setselectedAcct = function ($event) {
        this.accountSelected.emit({ $event: $event });
    };
    TabsComponent.prototype.setActiveTab = function (index) {
        this.tabAccts = this.allInputAccts;
    };
    ;
    TabsComponent.prototype.ngOnInit = function () {
        this.tabAccts = this.allInputAccts;
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], TabsComponent.prototype, "unassignedInputAccts", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], TabsComponent.prototype, "allInputAccts", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], TabsComponent.prototype, "otherInputAccts", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', dispatch_1.Dispatches)
    ], TabsComponent.prototype, "routeDataInput", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', String)
    ], TabsComponent.prototype, "lastModifiedByInput", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], TabsComponent.prototype, "accountSelected", void 0);
    TabsComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-tabs',
            directives: [common_1.CORE_DIRECTIVES, ng2_bootstrap_1.TAB_DIRECTIVES, _1.StorelistComponent],
            templateUrl: 'tabs.component.html',
            styleUrls: ['tabs.component.css']
        }), 
        __metadata('design:paramtypes', [])
    ], TabsComponent);
    return TabsComponent;
}());
exports.TabsComponent = TabsComponent;
//# sourceMappingURL=tabs.component.js.map