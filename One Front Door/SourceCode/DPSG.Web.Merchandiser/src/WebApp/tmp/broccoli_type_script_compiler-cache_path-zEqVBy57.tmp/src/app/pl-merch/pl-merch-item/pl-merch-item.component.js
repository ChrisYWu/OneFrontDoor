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
var pl_merch_popup_1 = require('../pl-merch-popup');
var PlMerchItemComponent = (function () {
    function PlMerchItemComponent() {
        this.deleteRoute = new core_1.EventEmitter();
        this.addRoute = new core_1.EventEmitter();
    }
    //onHidden(MODAL_DIRECTIVES): void
    //{
    // debugger;
    //}
    PlMerchItemComponent.prototype.onAddRoute = function (route) {
        debugger;
        this.DayRoute.RouteID = route.RouteID;
        this.DayRoute.RouteName = route.RouteName;
        this.DayRoute.isRouteAssigned = true;
        var _availableRoutes = [];
        for (var i = 0; i < this.AvailableRoutes.length; i++) {
            if (route.RouteID != this.AvailableRoutes[i].RouteID) {
                _availableRoutes.push(this.AvailableRoutes[i]);
            }
        }
        this.addRoute.emit({ 'route': route, 'dayOfWeek': this.DayRoute.DayOfWeek, 'availableRoutes': _availableRoutes });
    };
    PlMerchItemComponent.prototype.removeRoute = function () {
        var route = {
            RouteID: this.DayRoute.RouteID,
            MerchGroupID: 101,
            RouteName: this.DayRoute.RouteName
        };
        this.AvailableRoutes.splice(0, 0, route);
        this.DayRoute.RouteName = "";
        this.DayRoute.RouteID = -1;
        this.DayRoute.isRouteAssigned = false;
        // debugger 
        var dayOfWeek = this.DayRoute.DayOfWeek;
        //  let val = 
        // { 'route': route, 'dayOfWeek': dayOfWeek, 'GSN': '' }
        this.deleteRoute.emit({ 'route': route, 'dayOfWeek': dayOfWeek });
        // here to to bubble AvailableRoutes
        // here to call service or at parent on buble?
    };
    PlMerchItemComponent.prototype.ngOnInit = function () {
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', String)
    ], PlMerchItemComponent.prototype, "Day", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], PlMerchItemComponent.prototype, "DayRoute", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], PlMerchItemComponent.prototype, "AvailableRoutes", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', core_1.EventEmitter)
    ], PlMerchItemComponent.prototype, "deleteRoute", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', core_1.EventEmitter)
    ], PlMerchItemComponent.prototype, "addRoute", void 0);
    PlMerchItemComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'pl-merch-item',
            templateUrl: 'pl-merch-item.component.html',
            styleUrls: ['pl-merch-item.component.css'],
            directives: [ng2_bootstrap_1.MODAL_DIRECTIVES, common_1.CORE_DIRECTIVES, pl_merch_popup_1.PlMerchPopupComponent],
            viewProviders: [ng2_bootstrap_1.BS_VIEW_PROVIDERS],
        }), 
        __metadata('design:paramtypes', [])
    ], PlMerchItemComponent);
    return PlMerchItemComponent;
}());
exports.PlMerchItemComponent = PlMerchItemComponent;
//# sourceMappingURL=pl-merch-item.component.js.map