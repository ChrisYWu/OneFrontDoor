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
var PlRouteInfoComponent = (function () {
    function PlRouteInfoComponent() {
    }
    PlRouteInfoComponent.prototype.ngOnInit = function () {
        //debugger
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Number)
    ], PlRouteInfoComponent.prototype, "idx", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Number)
    ], PlRouteInfoComponent.prototype, "RouteId", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', String)
    ], PlRouteInfoComponent.prototype, "RouteName", void 0);
    PlRouteInfoComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'pl-route-info',
            templateUrl: 'pl-route-info.component.html',
            styleUrls: ['pl-route-info.component.css']
        }), 
        __metadata('design:paramtypes', [])
    ], PlRouteInfoComponent);
    return PlRouteInfoComponent;
}());
exports.PlRouteInfoComponent = PlRouteInfoComponent;
//# sourceMappingURL=pl-route-info.component.js.map