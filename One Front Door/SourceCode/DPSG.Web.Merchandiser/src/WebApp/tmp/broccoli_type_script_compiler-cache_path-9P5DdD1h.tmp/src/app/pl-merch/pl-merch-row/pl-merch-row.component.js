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
var pl_merch_info_1 = require('../pl-merch-info');
var pl_merch_item_1 = require('../pl-merch-item');
var PlMerchRowComponent = (function () {
    function PlMerchRowComponent() {
        this.deleteRoute = new core_1.EventEmitter();
        this.addRoute = new core_1.EventEmitter();
        // public items: any[] = [0,1,2,null,4,5,6];
        this.days = ['Monday', 'Tuseday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    }
    PlMerchRowComponent.prototype.onDeleteRoute = function (val) {
        //here go update 
        // val.GSN = this.MerchToDayRoute.GSN;
        this.deleteRoute.emit({ 'route': val.route, 'dayOfWeek': val.dayOfWeek, 'GSN': this.MerchToDayRoute.GSN });
    };
    PlMerchRowComponent.prototype.onAddRoute = function (val) {
        switch (val.dayOfWeek) {
            case 1:
                this.RouteToAssigne.Monday = val.availableRoutes;
                break;
            case 2:
                this.RouteToAssigne.Tuesday = val.availableRoutes;
                break;
            case 3:
                this.RouteToAssigne.Wednesday = val.availableRoutes;
                break;
            case 4:
                this.RouteToAssigne.Thursday = val.availableRoutes;
                break;
            case 5:
                this.RouteToAssigne.Friday = val.availableRoutes;
                break;
            case 6:
                this.RouteToAssigne.Saturday = val.availableRoutes;
                break;
            case 7:
                this.RouteToAssigne.Sunday = val.availableRoutes;
                break;
        }
        //  this.addRoute.emit(val)
        // debugger
        this.addRoute.emit({ 'route': val.route, 'dayOfWeek': val.dayOfWeek, 'merchToDayRoute': this.MerchToDayRoute });
    };
    PlMerchRowComponent.prototype.ngOnInit = function () {
        //debugger;
        //Get data AssignedDays and convert in to to assign here 
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], PlMerchRowComponent.prototype, "idx", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], PlMerchRowComponent.prototype, "MerchToDayRoute", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], PlMerchRowComponent.prototype, "RouteToAssigne", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], PlMerchRowComponent.prototype, "RouteList", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', core_1.EventEmitter)
    ], PlMerchRowComponent.prototype, "deleteRoute", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', core_1.EventEmitter)
    ], PlMerchRowComponent.prototype, "addRoute", void 0);
    PlMerchRowComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'pl-merch-row',
            templateUrl: 'pl-merch-row.component.html',
            styleUrls: ['pl-merch-row.component.css'],
            directives: [pl_merch_info_1.PlMerchInfoComponent, pl_merch_item_1.PlMerchItemComponent]
        }), 
        __metadata('design:paramtypes', [])
    ], PlMerchRowComponent);
    return PlMerchRowComponent;
}());
exports.PlMerchRowComponent = PlMerchRowComponent;
//# sourceMappingURL=pl-merch-row.component.js.map