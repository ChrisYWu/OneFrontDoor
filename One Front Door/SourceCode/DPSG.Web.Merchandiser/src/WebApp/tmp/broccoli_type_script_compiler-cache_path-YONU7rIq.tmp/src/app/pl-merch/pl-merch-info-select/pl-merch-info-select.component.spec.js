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
var pl_merch_info_select_component_1 = require('./pl-merch-info-select.component');
testing_1.describe('Component: PlMerchInfoSelect', function () {
    var builder;
    testing_1.beforeEachProviders(function () { return [pl_merch_info_select_component_1.PlMerchInfoSelectComponent]; });
    testing_1.beforeEach(testing_1.inject([testing_2.TestComponentBuilder], function (tcb) {
        builder = tcb;
    }));
    testing_1.it('should inject the component', testing_1.inject([pl_merch_info_select_component_1.PlMerchInfoSelectComponent], function (component) {
        testing_1.expect(component).toBeTruthy();
    }));
    testing_1.it('should create the component', testing_1.inject([], function () {
        return builder.createAsync(PlMerchInfoSelectComponentTestController)
            .then(function (fixture) {
            var query = fixture.debugElement.query(platform_browser_1.By.directive(pl_merch_info_select_component_1.PlMerchInfoSelectComponent));
            testing_1.expect(query).toBeTruthy();
            testing_1.expect(query.componentInstance).toBeTruthy();
        });
    }));
});
var PlMerchInfoSelectComponentTestController = (function () {
    function PlMerchInfoSelectComponentTestController() {
    }
    PlMerchInfoSelectComponentTestController = __decorate([
        core_1.Component({
            selector: 'test',
            template: "\n    <app-pl-merch-info-select></app-pl-merch-info-select>\n  ",
            directives: [pl_merch_info_select_component_1.PlMerchInfoSelectComponent]
        }), 
        __metadata('design:paramtypes', [])
    ], PlMerchInfoSelectComponentTestController);
    return PlMerchInfoSelectComponentTestController;
}());
//# sourceMappingURL=pl-merch-info-select.component.spec.js.map