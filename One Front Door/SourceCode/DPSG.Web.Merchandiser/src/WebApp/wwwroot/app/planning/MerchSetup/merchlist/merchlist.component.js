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
var filter_pipe_1 = require('../../../pipes/filter.pipe');
var MerchlistComponent = (function () {
    function MerchlistComponent() {
        this.selectedIdx = 0;
        this.MerchListData = [];
        this.merchListSelected = new core_1.EventEmitter();
    }
    MerchlistComponent.prototype.ngOnInit = function () {
    };
    MerchlistComponent.prototype.onMerchSelect = function (merch, idx) {
        this.selectedIdx = idx;
        var result = { merchInfo: merch, ListIndex: this.selectedIdx };
        this.merchListSelected.emit(result);
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Number)
    ], MerchlistComponent.prototype, "selectedIdx", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], MerchlistComponent.prototype, "MerchListData", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], MerchlistComponent.prototype, "merchListSelected", void 0);
    MerchlistComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-merchlist',
            templateUrl: 'merchlist.component.html',
            styleUrls: ['merchlist.component.css'],
            directives: [common_1.CORE_DIRECTIVES],
            pipes: [filter_pipe_1.FilterPipe]
        }), 
        __metadata('design:paramtypes', [])
    ], MerchlistComponent);
    return MerchlistComponent;
}());
exports.MerchlistComponent = MerchlistComponent;
//# sourceMappingURL=merchlist.component.js.map