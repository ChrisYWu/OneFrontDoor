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
var route_info_1 = require('../route-info');
var route_item_1 = require('../route-item');
var DispatchRowComponent = (function () {
    function DispatchRowComponent() {
    }
    DispatchRowComponent.prototype.ngOnInit = function () {
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], DispatchRowComponent.prototype, "dispatch", void 0);
    DispatchRowComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'dispatch-row',
            templateUrl: 'dispatch-row.component.html',
            styleUrls: ['dispatch-row.component.css'],
            directives: [route_item_1.RouteItemComponent, route_info_1.RouteInfoComponent]
        }), 
        __metadata('design:paramtypes', [])
    ], DispatchRowComponent);
    return DispatchRowComponent;
}());
exports.DispatchRowComponent = DispatchRowComponent;
//# sourceMappingURL=dispatch-row.component.js.map