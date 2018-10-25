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
var filter_pipe_1 = require('../../../pipes/filter.pipe');
var MerchSetupClass_1 = require('../MerchSetupClass');
var AddmerchpopupComponent = (function () {
    function AddmerchpopupComponent(elementRef, lookupService) {
        this.lookupService = lookupService;
        // @Output() storeSelected = new EventEmitter();
        this.MerchLookupList = [];
        this.merchSelected = new core_1.EventEmitter();
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
        this.isLoading = false;
        this.newMerchUser = new MerchSetupClass_1.MerchInfo();
        this.delay = (function () {
            var timer = 0;
            return function (callback, ms) {
                clearTimeout(timer);
                timer = setTimeout(callback, ms);
            };
        })();
        this.el = elementRef.nativeElement;
    }
    AddmerchpopupComponent.prototype.ngOnInit = function () {
        this.inputEl = (this.el.querySelector('#txtMerchSearch'));
        this.inputURL = this._webapi + 'api/Merc/GetMerchUserDetails/:keyword';
        this.lookupService.sourceUrl = this.inputURL;
        this.lookupService.pathToData = "Users";
    };
    AddmerchpopupComponent.prototype.showDropdownList = function () {
        this.keyword = '';
        this.inputEl.focus();
        this.reloadList();
    };
    AddmerchpopupComponent.prototype.reloadListInDelay = function () {
        var _this = this;
        var delayMs = 500;
        //executing after user stopped typing
        this.delay(function () { return _this.reloadList(); }, delayMs);
    };
    AddmerchpopupComponent.prototype.reloadList = function () {
        var _this = this;
        var keyword = this.inputEl.value;
        if (keyword.length >= 3) {
            this.isLoading = true;
            var query = { keyword: keyword };
            this.lookupService.getRemoteData(query)
                .subscribe(function (resp) {
                _this.MerchLookupList = resp;
            }, function (error) { return null; }, function () { return _this.isLoading = false; } //complete
             //complete
            );
        }
    };
    AddmerchpopupComponent.prototype.addMerch = function (merch) {
        this.newMerchUser.GSN = merch.sAMAccountName;
        this.newMerchUser.MerchName = merch.givenName + ' ' + merch.sn; // merch.DisplayName;
        this.newMerchUser.FirstName = merch.givenName;
        this.newMerchUser.LastName = merch.sn;
        var result = { close: 'true', newMerch: this.newMerchUser };
        this.merchSelected.emit(result);
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], AddmerchpopupComponent.prototype, "MerchLookupList", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', MerchSetupClass_1.MerchGroup)
    ], AddmerchpopupComponent.prototype, "MerchGroupItem", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], AddmerchpopupComponent.prototype, "merchSelected", void 0);
    AddmerchpopupComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-addmerchpopup',
            templateUrl: 'addmerchpopup.component.html',
            styleUrls: ['addmerchpopup.component.css'],
            directives: [common_1.CORE_DIRECTIVES],
            pipes: [filter_pipe_1.FilterPipe],
            providers: [storelookup_service_1.StorelookupService]
        }), 
        __metadata('design:paramtypes', [core_1.ElementRef, storelookup_service_1.StorelookupService])
    ], AddmerchpopupComponent);
    return AddmerchpopupComponent;
}());
exports.AddmerchpopupComponent = AddmerchpopupComponent;
//# sourceMappingURL=addmerchpopup.component.js.map