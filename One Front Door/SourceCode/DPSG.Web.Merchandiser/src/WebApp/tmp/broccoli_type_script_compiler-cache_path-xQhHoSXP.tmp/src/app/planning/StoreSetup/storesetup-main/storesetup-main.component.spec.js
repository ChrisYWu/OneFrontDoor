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
var storesetup_main_component_1 = require('./storesetup-main.component');
testing_1.describe('Component: StoresetupMain', function () {
    var builder;
    testing_1.beforeEachProviders(function () { return [storesetup_main_component_1.StoresetupMainComponent]; });
    testing_1.beforeEach(testing_1.inject([testing_2.TestComponentBuilder], function (tcb) {
        builder = tcb;
    }));
    testing_1.it('should inject the component', testing_1.inject([storesetup_main_component_1.StoresetupMainComponent], function (component) {
        testing_1.expect(component).toBeTruthy();
    }));
    testing_1.it('should create the component', testing_1.inject([], function () {
        return builder.createAsync(StoresetupMainComponentTestController)
            .then(function (fixture) {
            var query = fixture.debugElement.query(platform_browser_1.By.directive(storesetup_main_component_1.StoresetupMainComponent));
            testing_1.expect(query).toBeTruthy();
            testing_1.expect(query.componentInstance).toBeTruthy();
        });
    }));
});
var StoresetupMainComponentTestController = (function () {
    function StoresetupMainComponentTestController() {
    }
    StoresetupMainComponentTestController = __decorate([
        core_1.Component({
            selector: 'test',
            template: "\n    <app-storesetup-main></app-storesetup-main>\n  ",
            directives: [storesetup_main_component_1.StoresetupMainComponent]
        }), 
        __metadata('design:paramtypes', [])
    ], StoresetupMainComponentTestController);
    return StoresetupMainComponentTestController;
}());
//# sourceMappingURL=storesetup-main.component.spec.js.map