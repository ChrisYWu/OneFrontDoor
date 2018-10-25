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
var storelookup_service_1 = require('../../../services/storelookup.service');
var MerchAppConstant_1 = require('../../../../app/MerchAppConstant');
var planning_1 = require('../../../services/planning');
var filter_pipe_1 = require('../../../pipes/filter.pipe');
var StorelistPopupComponent = (function () {
    function StorelistPopupComponent(elementRef, lookupService) {
        this.lookupService = lookupService;
        this.storeSelected = new core_1.EventEmitter();
        this.storeLookupList = [];
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT; //'http://localhost:8888/';
        this.isLoading = false;
        this.delay = (function () {
            var timer = 0;
            return function (callback, ms) {
                clearTimeout(timer);
                timer = setTimeout(callback, ms);
            };
        })();
        this.el = elementRef.nativeElement;
    }
    StorelistPopupComponent.prototype.ngOnInit = function () {
        var SAPBranchID = '1115';
        this.inputEl = (this.el.querySelector('#txtStoreSearch'));
        this.inputURL = this._webapi + 'api/Merc/GetStoresLookUpBySAPBranchID/' + this.MerchGroupItem.SAPBranchID + '/' + ':keyword';
        this.lookupService.sourceUrl = this.inputURL;
        this.lookupService.pathToData = "Stores";
    };
    StorelistPopupComponent.prototype.showDropdownList = function () {
        this.keyword = '';
        this.inputEl.focus();
        this.reloadList();
    };
    StorelistPopupComponent.prototype.reloadListInDelay = function () {
        var _this = this;
        var delayMs = 500;
        //executing after user stopped typing
        this.delay(function () { return _this.reloadList(); }, delayMs);
    };
    StorelistPopupComponent.prototype.reloadList = function () {
        var _this = this;
        var keyword = this.inputEl.value;
        if (keyword.length >= 3) {
            this.isLoading = true;
            var query = { keyword: keyword };
            this.inputURL = this._webapi + 'api/Merc/GetStoresLookUpBySAPBranchID/' + this.MerchGroupItem.SAPBranchID + '/' + ':keyword';
            this.lookupService.sourceUrl = this.inputURL;
            this.lookupService.getRemoteData(query)
                .subscribe(function (resp) {
                _this.storeLookupList = [];
                _this.storeLookupList = resp;
            }, function (error) { return null; }, function () { return _this.isLoading = false; } //complete
             //complete
            );
        }
    };
    StorelistPopupComponent.prototype.addStore = function (account) {
        var result = { close: 'true', Account: account };
        this.storeLookupList = [];
        this.inputEl.value = '';
        this.storeSelected.emit(result);
    };
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], StorelistPopupComponent.prototype, "storeSelected", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], StorelistPopupComponent.prototype, "storeLookupList", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', planning_1.MerchGroup)
    ], StorelistPopupComponent.prototype, "MerchGroupItem", void 0);
    StorelistPopupComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'storelist-popup',
            templateUrl: 'storelist-popup.component.html',
            styleUrls: ['storelist-popup.component.css'],
            directives: [common_1.CORE_DIRECTIVES],
            pipes: [filter_pipe_1.FilterPipe],
            providers: [storelookup_service_1.StorelookupService]
        }), 
        __metadata('design:paramtypes', [core_1.ElementRef, storelookup_service_1.StorelookupService])
    ], StorelistPopupComponent);
    return StorelistPopupComponent;
}());
exports.StorelistPopupComponent = StorelistPopupComponent;
//# sourceMappingURL=storelist-popup.component.js.map