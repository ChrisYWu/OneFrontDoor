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
var dispservice_service_1 = require('../../services/dispservice.service');
var _1 = require('../rsroute/');
var RouteStoreAssignment_1 = require('../RouteStoreAssignment');
var MerchAppConstant_1 = require('../../../app/MerchAppConstant');
var headernav_service_1 = require('../../services/headernav.service');
var planning_1 = require('../../services/planning');
var spinner_1 = require('../../common/spinner');
var RsassignmentComponent = (function () {
    function RsassignmentComponent(dispService, navService) {
        this.dispService = dispService;
        this.navService = navService;
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
        this.item = new planning_1.MerchGroup();
        this.lastModifiedBy = 'satrk001';
        this.merchGroupId = 102;
        this.selectedWeekDay = 2;
        this.unassignedAcctsLength = 0;
        this.unassignedToggle = false;
    }
    RsassignmentComponent.prototype.stopRefreshing = function () {
        this.isRequesting = false;
    };
    RsassignmentComponent.prototype.ngOnInit = function () {
        var _this = this;
        this.subscription = this.navService.navItem$
            .subscribe(function (item) {
            _this.item = item;
            if (_this.item.MerchGroupID) {
                _this.merchGroupId = _this.item.MerchGroupID;
                _this.lastModifiedBy = _this.item.LoggedInUser;
                _this.loadData();
            }
        });
    };
    RsassignmentComponent.prototype.setselectedAcct = function ($event) {
        this.dispService.set(this._webapi + 'api/Merc/GetStoreList/');
        this.acctInput = new RouteStoreAssignment_1.AccountInput(this.merchGroupId, this.selectedWeekDay);
        this.getUnassignedAccounts(this.acctInput);
    };
    RsassignmentComponent.prototype.setSelectedWeekDay = function (tabIndex) {
        this.selectedWeekDay = tabIndex;
        this.loadData();
    };
    RsassignmentComponent.prototype.loadData = function () {
        this.dispService.set(this._webapi + 'api/Merc/GetRSDetailByWeekDay/');
        this.rsInput = new RouteStoreAssignment_1.RSInput(this.merchGroupId, this.selectedWeekDay);
        this.getDipatchInfoPost(this.rsInput);
    };
    RsassignmentComponent.prototype.toggleUnassigned = function () {
        if (this.unassignedAcctsLength > 0) {
            if (this.unassignedToggle)
                this.unassignedToggle = false;
            else
                this.unassignedToggle = true;
        }
    };
    RsassignmentComponent.prototype.setupdatedroute = function ($event) {
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
    RsassignmentComponent.prototype.pullInfoUpdate = function () {
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
    RsassignmentComponent.prototype.getDipatchInfo = function () {
        var _this = this;
        this.dispService.get()
            .subscribe(function (res) {
            var data = res.json();
            _this.dispatch = data.Routes;
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    RsassignmentComponent.prototype.removeNullAccount = function () {
        for (var i = 0; i < this.dispatch.length; i++) {
            for (var j = 0; j < this.dispatch[i].Stores.length; j++) {
                if (this.dispatch[i].Stores[j].AccountID == null) {
                    this.dispatch[i].Stores.pop();
                }
            }
        }
    };
    RsassignmentComponent.prototype.getDipatchInfoPost = function (data) {
        var _this = this;
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(data))
            .subscribe(function (res) {
            var data = res;
            _this.dispatch = data.RoutesTile;
            _this.routesInput = data.Routes;
            _this.allAccts = data.AllStores;
            _this.unassignedAccts = data.UnassignedStores;
            _this.unassignedAcctsLength = _this.unassignedAccts.length;
            _this.removeNullAccount();
            _this.pullInfoUpdate();
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    RsassignmentComponent.prototype.getUnassignedAccounts = function (data) {
        var _this = this;
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(data), true)
            .subscribe(function (res) {
            var data = res;
            _this.unassignedAccts = data.UnassignedStores;
            _this.unassignedAcctsLength = _this.unassignedAccts.length;
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], RsassignmentComponent.prototype, "itemsObservables", void 0);
    RsassignmentComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-rsassignment',
            templateUrl: 'rsassignment.component.html',
            styleUrls: ['rsassignment.component.css'],
            directives: [ng2_bootstrap_1.MODAL_DIRECTIVES, common_1.CORE_DIRECTIVES, common_1.FORM_DIRECTIVES, _1.RsrouteComponent, spinner_1.SpinnerComponent],
            providers: [dispservice_service_1.DispserviceService, headernav_service_1.HeadernavService],
            viewProviders: [ng2_bootstrap_1.BS_VIEW_PROVIDERS]
        }), 
        __metadata('design:paramtypes', [dispservice_service_1.DispserviceService, headernav_service_1.HeadernavService])
    ], RsassignmentComponent);
    return RsassignmentComponent;
}());
exports.RsassignmentComponent = RsassignmentComponent;
//# sourceMappingURL=rsassignment.component.js.map