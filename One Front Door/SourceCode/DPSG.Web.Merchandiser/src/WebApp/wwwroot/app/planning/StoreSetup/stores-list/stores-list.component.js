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
var StoresListComponent = (function () {
    function StoresListComponent() {
        this.storeListData = [];
        this.storeListSelected = new core_1.EventEmitter();
        this.selectedIdx = 0;
    }
    StoresListComponent.prototype.ngOnInit = function () {
    };
    StoresListComponent.prototype.onStoreSelect = function (store, idx) {
        this.selectedIdx = idx;
        var result = { Account: store, ListIndex: this.selectedIdx };
        this.storeListSelected.emit(result);
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], StoresListComponent.prototype, "storeListData", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], StoresListComponent.prototype, "storeListSelected", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Number)
    ], StoresListComponent.prototype, "selectedIdx", void 0);
    StoresListComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'stores-list',
            templateUrl: 'stores-list.component.html',
            styleUrls: ['stores-list.component.css'],
            directives: [common_1.CORE_DIRECTIVES],
            pipes: [filter_pipe_1.FilterPipe]
        }), 
        __metadata('design:paramtypes', [])
    ], StoresListComponent);
    return StoresListComponent;
}());
exports.StoresListComponent = StoresListComponent;
//# sourceMappingURL=stores-list.component.js.map