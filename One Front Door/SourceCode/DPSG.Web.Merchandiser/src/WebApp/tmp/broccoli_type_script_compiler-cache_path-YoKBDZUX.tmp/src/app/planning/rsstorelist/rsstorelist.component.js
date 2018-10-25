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
var filter_pipe_1 = require('../../pipes/filter.pipe');
var RouteStoreAssignment_1 = require('../RouteStoreAssignment');
var dispservice_service_1 = require('../../services/dispservice.service');
var MerchAppConstant_1 = require('../../../app/MerchAppConstant');
var RsstorelistComponent = (function () {
    function RsstorelistComponent(dispService) {
        this.dispService = dispService;
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
        this.localTabAccts = [];
        this.accountSelected = new core_1.EventEmitter();
    }
    RsstorelistComponent.prototype.pullInfoUpdate = function () {
        var tempStores = this.routeDataInput.Stores.slice();
        for (var j = 0; j < tempStores.length; j++) {
            var pullcount = 0;
            for (var k = 0; k < this.routeDataInput.Stores.length; k++) {
                if (tempStores[j].AccountID == this.routeDataInput.Stores[k].AccountID) {
                    pullcount++;
                    if (pullcount == 1) {
                        this.routeDataInput.Stores[k].PullNumber = "";
                    }
                    else if (pullcount == 2) {
                        this.routeDataInput.Stores[k].PullNumber = pullcount + "nd Pull";
                    }
                    else if (pullcount == 3) {
                        this.routeDataInput.Stores[k].PullNumber = pullcount + "rd Pull";
                    }
                    else {
                        this.routeDataInput.Stores[k].PullNumber = pullcount + "th Pull";
                    }
                }
            }
        }
    };
    RsstorelistComponent.prototype.addStore = function (accountID, accountName, address) {
        var _this = this;
        this.dispService.set(this._webapi + 'api/Merc/InsertStoreWeekday/');
        var storeWeekDayInput = new RouteStoreAssignment_1.StoreWeekDayInput(this.routeDataInput.MerchGroupID, this.selectedWeekDayInput, this.routeDataInput.RouteID, accountID, this.lastModifiedByInput);
        this.dispService.post(JSON.stringify(storeWeekDayInput))
            .subscribe(function (res) {
            var data = res;
            var resultInsert;
            resultInsert = data;
            if (resultInsert.ReturnStatus == 1) {
                _this.routeDataInput.Stores.push(new RouteStoreAssignment_1.Store(accountID, accountName, _this.routeDataInput.Stores.length + 1, null));
                _this.pullInfoUpdate();
                _this.accountSelected.emit({ close: 'true' });
            }
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    RsstorelistComponent.prototype.ngOnInit = function () {
        //   this.localTabAccts.push(new Account(0, '', ''));
        //     if (this.currentTabAccts && this.currentTabAccts.length > 0) {
        //         this.localTabAccts = this.currentTabAccts;
        //     }
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], RsstorelistComponent.prototype, "currentTabAccts", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', RouteStoreAssignment_1.Dispatches)
    ], RsstorelistComponent.prototype, "routeDataInput", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', String)
    ], RsstorelistComponent.prototype, "lastModifiedByInput", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Number)
    ], RsstorelistComponent.prototype, "selectedWeekDayInput", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], RsstorelistComponent.prototype, "accountSelected", void 0);
    RsstorelistComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-rsstorelist',
            templateUrl: 'rsstorelist.component.html',
            styleUrls: ['rsstorelist.component.css'],
            pipes: [filter_pipe_1.FilterPipe],
            directives: [common_1.CORE_DIRECTIVES]
        }), 
        __metadata('design:paramtypes', [dispservice_service_1.DispserviceService])
    ], RsstorelistComponent);
    return RsstorelistComponent;
}());
exports.RsstorelistComponent = RsstorelistComponent;
//# sourceMappingURL=rsstorelist.component.js.map