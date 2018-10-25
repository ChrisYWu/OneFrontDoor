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
var BehaviorSubject_1 = require('rxjs/BehaviorSubject');
var planning_1 = require('../services/planning');
var HeadernavService = (function () {
    function HeadernavService() {
        this.navItemSource = new BehaviorSubject_1.BehaviorSubject(new planning_1.MerchGroup());
        this.navItem$ = this.navItemSource.asObservable();
        this.navMerchSource = new BehaviorSubject_1.BehaviorSubject(new planning_1.MerchGroup());
        this.navMerchItem$ = this.navMerchSource.asObservable();
        return HeadernavService.instance = HeadernavService.instance || this;
    }
    HeadernavService.prototype.changeNav = function (number) {
        this.navItemSource.next(number);
    };
    HeadernavService.prototype.changeToaddMerchGroup = function (item) {
        this.navMerchSource.next(item);
    };
    HeadernavService = __decorate([
        core_1.Injectable(), 
        __metadata('design:paramtypes', [])
    ], HeadernavService);
    return HeadernavService;
}());
exports.HeadernavService = HeadernavService;
//# sourceMappingURL=headernav.service.js.map