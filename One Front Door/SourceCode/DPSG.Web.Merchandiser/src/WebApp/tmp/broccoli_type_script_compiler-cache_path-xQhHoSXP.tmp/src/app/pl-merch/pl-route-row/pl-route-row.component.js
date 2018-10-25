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
var pl_route_info_1 = require('../pl-route-info');
var pl_route_item_1 = require('../pl-route-item');
var PlRouteRowComponent = (function () {
    function PlRouteRowComponent() {
        this.deleteMerch = new core_1.EventEmitter();
        this.addMerchandiser = new core_1.EventEmitter();
        //public items: any[] = [0,1,2,null,4,5,6];
        this.days = ['Monday', 'Tuseday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    }
    PlRouteRowComponent.prototype.onAddMerchandiser = function (val) {
        debugger;
        switch (val.dayOfWeek) {
            case 1:
                this.MerchToAssigne.Monday = val.availableMerchandisers;
                break;
            case 2:
                this.MerchToAssigne.Tuesday = val.availableMerchandisers;
                break;
            case 3:
                this.MerchToAssigne.Wednesday = val.availableMerchandisers;
                break;
            case 4:
                this.MerchToAssigne.Thursday = val.availableMerchandisers;
                break;
            case 5:
                this.MerchToAssigne.Friday = val.availableMerchandisers;
                break;
            case 6:
                this.MerchToAssigne.Saturday = val.availableMerchandisers;
                break;
            case 7:
                this.MerchToAssigne.Sunday = val.availableMerchandisers;
                break;
        }
        this.addMerchandiser.emit({ 'merchandiser': val.merchandiser, 'dayOfWeek': val.dayOfWeek, 'routeToDayMerch': this.RouteToDayMerch });
    };
    PlRouteRowComponent.prototype.onDeleteMerch = function (val) {
        //here go update 
        // val.routeID = this.RouteToDayMerch.RouteID;
        this.deleteMerch.emit({ 'merch': val.merch, 'dayOfWeek': val.dayOfWeek, 'routeID': this.RouteToDayMerch.RouteID });
    };
    PlRouteRowComponent.prototype.ngOnInit = function () {
        //debugger;
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], PlRouteRowComponent.prototype, "idx", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], PlRouteRowComponent.prototype, "RouteToDayMerch", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], PlRouteRowComponent.prototype, "MerchToAssigne", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], PlRouteRowComponent.prototype, "MerchandiserList", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', core_1.EventEmitter)
    ], PlRouteRowComponent.prototype, "deleteMerch", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', core_1.EventEmitter)
    ], PlRouteRowComponent.prototype, "addMerchandiser", void 0);
    PlRouteRowComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'pl-route-row',
            templateUrl: 'pl-route-row.component.html',
            styleUrls: ['pl-route-row.component.css'],
            directives: [pl_route_info_1.PlRouteInfoComponent, pl_route_item_1.PlRouteItemComponent]
        }), 
        __metadata('design:paramtypes', [])
    ], PlRouteRowComponent);
    return PlRouteRowComponent;
}());
exports.PlRouteRowComponent = PlRouteRowComponent;
//# sourceMappingURL=pl-route-row.component.js.map