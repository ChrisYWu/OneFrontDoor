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
var router_1 = require('@angular/router');
var header_1 = require('./common/header');
var footer_1 = require('./common/footer');
// import { HeadernavService } from './services/headernav.service';
var MerchAppComponent = (function () {
    function MerchAppComponent(viewContainerRef) {
        this.title = 'Merchantiser welcome angular2  app';
        // You need this small hack in order to catch application root view container ref
        this.viewContainerRef = viewContainerRef;
    }
    MerchAppComponent.prototype.ngOnInit = function () {
    };
    MerchAppComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app',
            templateUrl: 'app.component.html',
            styleUrls: ['app.component.css'],
            directives: [router_1.ROUTER_DIRECTIVES, header_1.HeaderComponent, footer_1.FooterComponent]
        }), 
        __metadata('design:paramtypes', [core_1.ViewContainerRef])
    ], MerchAppComponent);
    return MerchAppComponent;
}());
exports.MerchAppComponent = MerchAppComponent;
//# sourceMappingURL=app.component.js.map