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
var ng2_datepicker_1 = require('ng2-datepicker/ng2-datepicker');
var moment = require('moment');
var dispservice_service_1 = require('../services/dispservice.service');
var _1 = require('../common/route/');
var dispatch_1 = require('../services/dispatch');
var MerchAppConstant_1 = require('../../app/MerchAppConstant');
var headernav_service_1 = require('../services/headernav.service');
var spinner_1 = require('../common/spinner');
var MercMainComponent = (function () {
    function MercMainComponent(dispService, navService) {
        this.dispService = dispService;
        this.navService = navService;
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
        this.dispHistoryLength = 0;
        this.dispatchLength = 0;
        this.DispathchDate = new Date().toISOString().split('T')[0];
        this.unassignedAcctsLength = 0;
        this.unassignedMerch = [];
        this.unassignedOtherMerch = [];
        this.dispatchReadyInfoLength = 0;
        this.dispatchNotes = '';
        this.unassignedToggle = false;
        this.changeeventtimeout = true; // this is a global variable.
        this.msgText = "";
    }
    MercMainComponent.prototype.stopRefreshing = function () {
        this.isRequesting = false;
    };
    MercMainComponent.prototype.setDispatchDate = function () {
        this.dispathchDate = this.DispathchDate.toString();
    };
    MercMainComponent.prototype.ngOnInit = function () {
        var _this = this;
        //this.DispathchDate = new Date().toISOString().split('T')[0];
        // this.setDispatchDate();
        // this.loadData();
        this.setDispatchDate();
        this.subscription = this.navService.navItem$.subscribe(function (item) { _this.merchGroupId = item.MerchGroupID; _this.lastModifiedBy = item.LoggedInUser; _this.loadData(); });
    };
    MercMainComponent.prototype.ngOnDestroy = function () {
        // prevent memory leak when component is destroyed
        this.subscription.unsubscribe();
    };
    MercMainComponent.prototype.onChange = function ($event) {
        if (this.dispathchDate != this.DispathchDate) {
            this.loadData();
            this.setDispatchDate();
        }
    };
    MercMainComponent.prototype.setselectedAcct = function ($event) {
        this.dispService.set(this._webapi + 'api/Merc/GetStores/');
        this.acctInput = new dispatch_1.AccountInput(this.merchGroupId, new Date(this.DispathchDate.toString()));
        this.getUnassignedAccounts(this.acctInput);
    };
    MercMainComponent.prototype.dispatchHistory = function () {
        var _this = this;
        this.dispService.set(this._webapi + 'api/Merc/GetDispatchHistory/');
        var routelistinput;
        routelistinput = new dispatch_1.RouteListInput(new Date(this.DispathchDate.toString()), this.merchGroupId);
        this.getRoutes(routelistinput);
        this.dispService.post(JSON.stringify(routelistinput), true)
            .subscribe(function (res) {
            var data = res;
            _this.dispHistory = data.DispatchHistory;
            _this.dispHistoryLength = _this.dispHistory.length;
            _this.lgDispatchHistoryModal.show();
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    MercMainComponent.prototype.loadData = function () {
        this.msgText = "";
        this.dispService.set(this._webapi + 'api/Merc/GetAllDispatch/');
        this.dispInput = new dispatch_1.DispatchInput(this.lastModifiedBy, this.merchGroupId, new Date(this.DispathchDate.toString()));
        this.getAllDipatchInfo(this.dispInput);
        // this.dispService.set(this._webapi + 'api/Merc/GetDispatches/');
        // this.dispInput = new DispatchInput('System', 102, this.dispathchDate);
        // this.getDipatchInfoPost(this.dispInput);
        // //this.getDipatchInfo();
        // this.dispService.set(this._webapi + 'api/Merc/GetStores/');
        // this.acctInput = new AccountInput(102, this.dispathchDate);
        // this.getAccounts(this.acctInput);
        // this.dispService.set(this._webapi + 'api/Merc/GetRouteList/');
        // let routelistinput: RouteListInput;
        // routelistinput = new RouteListInput(this.dispathchDate, this.merchGroupId);
        // this.getRoutes(routelistinput);
        // this.dispService.set(this._webapi + 'api/Merc/GetMerchList/');
        // this.getMerchs(routelistinput);
    };
    MercMainComponent.prototype.toggleUnassigned = function () {
        if (this.unassignedAcctsLength > 0) {
            if (this.unassignedToggle)
                this.unassignedToggle = false;
            else
                this.unassignedToggle = true;
        }
        else {
            this.unassignedToggle = false;
        }
    };
    MercMainComponent.prototype.setupdatedroute = function ($event) {
        var targetRouteId = $event.value.routeid;
        var reassignStore = $event.value.store;
        for (var i = 0; i < this.dispatch.length; i++) {
            if (targetRouteId == this.dispatch[i].RouteID) {
                reassignStore.Sequence = this.dispatch[i].Stores.length + 1;
                this.dispatch[i].Stores.push(reassignStore);
            }
        }
        this.pullInfoUpdate();
    };
    MercMainComponent.prototype.pullInfoUpdate = function () {
        for (var i = 0; i < this.dispatch.length; i++) {
            var tempStores = this.dispatch[i].Stores.slice();
            for (var j = 0; j < tempStores.length; j++) {
                var pullcount = 0;
                for (var k = 0; k < this.dispatch[i].Stores.length; k++) {
                    if (tempStores[j].AccountID == this.dispatch[i].Stores[k].AccountID) {
                        pullcount++;
                        if (pullcount == 1) {
                            this.dispatch[i].Stores[k].PullNumber = "";
                        }
                        else if (pullcount == 2) {
                            this.dispatch[i].Stores[k].PullNumber = pullcount + "nd Pull";
                        }
                        else if (pullcount == 3) {
                            this.dispatch[i].Stores[k].PullNumber = pullcount + "rd Pull";
                        }
                        else {
                            this.dispatch[i].Stores[k].PullNumber = pullcount + "th Pull";
                        }
                    }
                }
            }
        }
    };
    MercMainComponent.prototype.getAllDipatchInfo = function (data) {
        var _this = this;
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(data))
            .subscribe(function (res) {
            var data = res;
            if (data.Dispatches.Routes.length <= 0) {
                _this.msgText = "No data found for " + moment(_this.dispathchDate).format('MMM D, YYYY');
            }
            else {
                _this.msgText = "";
            }
            //dispatch
            _this.dispatch = data.Dispatches.Routes;
            _this.dispatchLength = _this.dispatch.length;
            _this.pullInfoUpdate();
            //Stores
            _this.allAccts = data.Stores.AllStores;
            _this.unassignedAccts = data.Stores.UnassignedStores;
            _this.unassignedAcctsLength = _this.unassignedAccts.length;
            _this.otherAccts = data.Stores.OtherStores;
            //Routes
            _this.routesInput = data.Routes.Routes;
            //Merchandiser
            _this.unassignedMerch = data.Merchandisers.UnassignedMerchandiser;
            _this.unassignedOtherMerch = data.Merchandisers.OtherUnassignedMerchandiser;
            _this.pullInfoUpdate();
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    MercMainComponent.prototype.getDipatchInfo = function () {
        var _this = this;
        this.isRequesting = true;
        this.dispService.get()
            .subscribe(function (res) {
            var data = res.json();
            _this.dispatch = data.Routes;
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    MercMainComponent.prototype.getDipatchInfoPost = function (data) {
        var _this = this;
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(data))
            .subscribe(function (res) {
            var data = res;
            _this.dispatch = data.Routes;
            _this.pullInfoUpdate();
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    MercMainComponent.prototype.getAccounts = function (data) {
        var _this = this;
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(data), true)
            .subscribe(function (res) {
            var data = res;
            _this.allAccts = data.AllStores;
            _this.unassignedAccts = data.UnassignedStores;
            _this.unassignedAcctsLength = _this.unassignedAccts.length;
            _this.otherAccts = data.OtherStores;
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    MercMainComponent.prototype.getUnassignedAccounts = function (data) {
        var _this = this;
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(data), true)
            .subscribe(function (res) {
            var data = res;
            _this.unassignedAccts = data.UnassignedStores;
            _this.unassignedAcctsLength = _this.unassignedAccts.length;
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    MercMainComponent.prototype.getRoutes = function (data) {
        var _this = this;
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(data))
            .subscribe(function (res) {
            var data = res;
            _this.routesInput = data.Routes;
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    MercMainComponent.prototype.getMerchs = function (data) {
        var _this = this;
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(data))
            .subscribe(function (res) {
            var data = res;
            _this.unassignedMerch = data.UnassignedMerchandiser;
            _this.unassignedOtherMerch = data.OtherUnassignedMerchandiser;
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    MercMainComponent.prototype.onKey = function (event) {
        this.dispatchNotes = event.target.value;
    };
    MercMainComponent.prototype.previewDispatch = function () {
        var _this = this;
        var dispatchReady = new dispatch_1.AccountInput(this.merchGroupId, new Date(this.DispathchDate.toString()));
        this.dispService.set(this._webapi + 'api/Merc/DispatchReady/');
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(dispatchReady))
            .subscribe(function (res) {
            var data = res;
            _this.dispatchReadyInfo = data.DispatchReadyListItems;
            _this.dispatchReadyInfoLength = _this.dispatchReadyInfo.length;
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    MercMainComponent.prototype.finalDispatch = function () {
        var _this = this;
        var dispatchFinal = new dispatch_1.DispatchFinalInput(new Date(this.DispathchDate.toString()), this.lastModifiedBy, this.merchGroupId, this.dispatchNotes);
        this.dispService.set(this._webapi + 'api/Merc/DispatchFinal/');
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(dispatchFinal))
            .subscribe(function (res) {
            var data = res;
            _this.dispatchFinalResult = data.DispatchFinalResult;
            if (_this.dispatchFinalResult[0].DispatchInfo != 'OK') {
                alert('Dispatch was not successfull!');
            }
            else {
                alert('Dispatch successfull!');
            }
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    __decorate([
        core_1.ViewChild('lgDispatchHistoryModal'), 
        __metadata('design:type', ng2_bootstrap_1.ModalDirective)
    ], MercMainComponent.prototype, "lgDispatchHistoryModal", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], MercMainComponent.prototype, "itemsObservables", void 0);
    MercMainComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-merc-main',
            templateUrl: 'merc-main.component.html',
            styleUrls: ['merc-main.component.css'],
            directives: [ng2_bootstrap_1.MODAL_DIRECTIVES, common_1.CORE_DIRECTIVES, common_1.FORM_DIRECTIVES, _1.RouteComponent, ng2_datepicker_1.DatePicker, spinner_1.SpinnerComponent],
            providers: [dispservice_service_1.DispserviceService, headernav_service_1.HeadernavService],
            viewProviders: [ng2_bootstrap_1.BS_VIEW_PROVIDERS]
        }), 
        __metadata('design:paramtypes', [dispservice_service_1.DispserviceService, headernav_service_1.HeadernavService])
    ], MercMainComponent);
    return MercMainComponent;
}());
exports.MercMainComponent = MercMainComponent;
//# sourceMappingURL=merc-main.component.js.map