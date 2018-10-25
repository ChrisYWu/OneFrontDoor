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
var testing_1 = require('@angular/core/testing');
var testing_2 = require('@angular/compiler/testing');
var core_1 = require('@angular/core');
var platform_browser_1 = require('@angular/platform-browser');
var storeitem_component_1 = require('./storeitem.component');
testing_1.describe('Component: Storeitem', function () {
    var builder;
    testing_1.beforeEachProviders(function () { return [storeitem_component_1.StoreitemComponent]; });
    testing_1.beforeEach(testing_1.inject([testing_2.TestComponentBuilder], function (tcb) {
        builder = tcb;
    }));
    testing_1.it('should inject the component', testing_1.inject([storeitem_component_1.StoreitemComponent], function (component) {
        testing_1.expect(component).toBeTruthy();
    }));
    testing_1.it('should create the component', testing_1.inject([], function () {
        return builder.createAsync(StoreitemComponentTestController)
            .then(function (fixture) {
            var query = fixture.debugElement.query(platform_browser_1.By.directive(storeitem_component_1.StoreitemComponent));
            testing_1.expect(query).toBeTruthy();
            testing_1.expect(query.componentInstance).toBeTruthy();
        });
    }));
});
var StoreitemComponentTestController = (function () {
    function StoreitemComponentTestController() {
    }
    StoreitemComponentTestController = __decorate([
        core_1.Component({
            selector: 'test',
            template: "\n    <app-storeitem></app-storeitem>\n  ",
            directives: [storeitem_component_1.StoreitemComponent]
        }), 
        __metadata('design:paramtypes', [])
    ], StoreitemComponentTestController);
    return StoreitemComponentTestController;
}());
//# sourceMappingURL=storeitem.component.spec.js.map