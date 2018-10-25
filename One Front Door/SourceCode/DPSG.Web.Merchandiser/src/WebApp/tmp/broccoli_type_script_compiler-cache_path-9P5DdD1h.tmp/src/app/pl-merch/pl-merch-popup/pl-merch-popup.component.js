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
var pl_route_select_1 = require('../pl-route-select');
var PlMerchPopupComponent = (function () {
    //Not using, thoise are snipptes may use 
    /*
    addRouteX(route: any)
    {
         let idx: number = -1;
         for (let i = 0; i < this.AvailableRoutes.length; i++)
         {
         //  debugger ;
           if(route.RouteID == this.AvailableRoutes[i].RouteID)
           {     idx= i;
                 break;
           }
         }
    
         this.AvailableRoutes.Splice(idx, 1);
    
           this.AvailableRoutes.Splice(this.AvailableRoutes.indexOf(route), 1);
    
    
    
    let _availableRoutes = [];
    
    for (let i = 0; i < this.AvailableRoutes.length; i++)
         {
    
           if(route.RouteID != this.AvailableRoutes[i].RouteID)
           {
             _availableRoutes.push(this.AvailableRoutes[i])
           }
         }
    
          // debugger ;
          this.AvailableRoutes = _availableRoutes;
    
          this.plMerchModal.hide();
    
           //Splice did not work? Why? to find
           //this.AvailableRoutes.Splice(0, 1);
    
    
    }
    */
    function PlMerchPopupComponent() {
        this.items = [0, 1, 2, 3, 4, 5, 6];
        this.AvailableRoutes = [];
        this.addRoute = new core_1.EventEmitter();
    }
    PlMerchPopupComponent.prototype.selectRoute = function (route) {
        this.plMerchModal.hide();
        this.addRoute.emit(route);
    };
    PlMerchPopupComponent.prototype.ngOnInit = function () {
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], PlMerchPopupComponent.prototype, "plMerchModal", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], PlMerchPopupComponent.prototype, "AvailableRoutes", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', core_1.EventEmitter)
    ], PlMerchPopupComponent.prototype, "addRoute", void 0);
    PlMerchPopupComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'pl-merch-popup',
            templateUrl: 'pl-merch-popup.component.html',
            styleUrls: ['pl-merch-popup.component.css'],
            directives: [ng2_bootstrap_1.MODAL_DIRECTIVES, common_1.CORE_DIRECTIVES, pl_route_select_1.PlRouteSelectComponent],
            viewProviders: [ng2_bootstrap_1.BS_VIEW_PROVIDERS],
        }), 
        __metadata('design:paramtypes', [])
    ], PlMerchPopupComponent);
    return PlMerchPopupComponent;
}());
exports.PlMerchPopupComponent = PlMerchPopupComponent;
//# sourceMappingURL=pl-merch-popup.component.js.map