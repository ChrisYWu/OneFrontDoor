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
var pl_route_popup_1 = require('../pl-route-popup');
var PlRouteItemComponent = (function () {
    function PlRouteItemComponent() {
        this.deleteMerch = new core_1.EventEmitter();
        this.addMerchandiser = new core_1.EventEmitter();
    }
    PlRouteItemComponent.prototype.onAddMerchandiser = function (merchandiser) {
        var _availableMerchandisers = [];
        this.DayMerch.GSN = merchandiser.GSN;
        this.DayMerch.LastName = merchandiser.LastName;
        this.DayMerch.FirstName = merchandiser.FirstName;
        this.DayMerch.Email = merchandiser.Email;
        this.DayMerch.Phone = merchandiser.Phone;
        this.DayMerch.isOffDay = merchandiser.isOffDay;
        this.DayMerch.isMerchAssigned = true;
        for (var i = 0; i < this.AvailableMerchandisers.length; i++) {
            if (merchandiser.GSN != this.AvailableMerchandisers[i].GSN) {
                _availableMerchandisers.push(this.AvailableMerchandisers[i]);
            }
        }
        this.addMerchandiser.emit({ 'merchandiser': merchandiser, 'dayOfWeek': this.DayMerch.DayOfWeek, 'availableMerchandisers': _availableMerchandisers });
    };
    PlRouteItemComponent.prototype.removeMerch = function () {
        var merch = {
            GSN: this.DayMerch.GSN,
            MerchGroupID: this.DayMerch.MerchGroupID,
            LastName: this.DayMerch.LastName,
            FirstName: this.DayMerch.FirstName,
            Email: this.DayMerch.Email,
            Phone: this.DayMerch.Phone,
            Mon: null,
            Tues: true,
            Wed: null,
            Thu: null,
            Fri: null,
            Sat: null,
            Sun: null
        };
        this.AvailableMerchandisers.splice(0, 0, merch);
        this.DayMerch.GSN = "";
        this.DayMerch.MerchGroupID = -1;
        this.DayMerch.LastName = "";
        this.DayMerch.FirstName = "";
        this.DayMerch.Email = "";
        this.DayMerch.Phone = "";
        this.DayMerch.isMerchAssigned = false;
        //  debugger 
        var dayOfWeek = this.DayMerch.DayOfWeek;
        // let val = 
        ///   { 'merch': merch, 'dayOfWeek': dayOfWeek, 'routeID': 0 }
        this.deleteMerch.emit({ 'merch': merch, 'dayOfWeek': dayOfWeek });
        // here to to bubble AvailableRoutes
        // here to call service or at parent on buble?
    };
    PlRouteItemComponent.prototype.ngOnInit = function () {
        // debugger;
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', String)
    ], PlRouteItemComponent.prototype, "Day", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], PlRouteItemComponent.prototype, "DayMerch", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], PlRouteItemComponent.prototype, "AvailableMerchandisers", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', core_1.EventEmitter)
    ], PlRouteItemComponent.prototype, "deleteMerch", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', core_1.EventEmitter)
    ], PlRouteItemComponent.prototype, "addMerchandiser", void 0);
    PlRouteItemComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'pl-route-item',
            templateUrl: 'pl-route-item.component.html',
            styleUrls: ['pl-route-item.component.css'],
            directives: [ng2_bootstrap_1.MODAL_DIRECTIVES, common_1.CORE_DIRECTIVES, pl_route_popup_1.PlRoutePopupComponent],
            viewProviders: [ng2_bootstrap_1.BS_VIEW_PROVIDERS],
        }), 
        __metadata('design:paramtypes', [])
    ], PlRouteItemComponent);
    return PlRouteItemComponent;
}());
exports.PlRouteItemComponent = PlRouteItemComponent;
//# sourceMappingURL=pl-route-item.component.js.map