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
var stores_list_1 = require('../stores-list');
var storedetail_1 = require('../storedetail');
var storeitem_1 = require('../storeitem');
var dispservice_service_1 = require('../../../services/dispservice.service');
var MerchAppConstant_1 = require('../../../../app/MerchAppConstant');
var planning_1 = require('../../../services/planning');
var headernav_service_1 = require('../../../services/headernav.service');
var StoresetupMainComponent = (function () {
    function StoresetupMainComponent(dispService, navService) {
        this.dispService = dispService;
        this.navService = navService;
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT; //'http://localhost:8888/';
        this.selectedBranch = new planning_1.MerchBranch();
        this.selectedMerchGroupID = 0;
        this.inputAcctList = [];
        this.inputAcctLookupList = [];
        this.SaveMsg = false;
        this.item = new planning_1.MerchGroup();
        this.listIndex = 0;
        //StoreDetail Variables
        this.storeSelected = new core_1.EventEmitter();
        this.storeListSelected = new core_1.EventEmitter();
        this.refreshList = new core_1.EventEmitter();
        this.cancelDetail = new core_1.EventEmitter();
        this.routesList = [];
        this.weekDays = [];
    }
    //set the selected store from the store list pop up
    StoresetupMainComponent.prototype.setselectedStore = function ($event) {
        //this.initalizeStoreDetail();      
        // this.selStoreInfo = $event.$event.Account; 
        this.initalizeStoreDetailsByAccountNumber($event.$event.Account);
    };
    //set the selected store from the store list left side
    StoresetupMainComponent.prototype.setListselectedStore = function ($event) {
        this.listIndex = $event.ListIndex;
        this.SaveMsg = false;
        this.getStoreDetailsByAccountNumber($event.Account);
    };
    //Refresh the store list left hand side and the store lookup list after save the store
    StoresetupMainComponent.prototype.refreshStoreList = function ($event) {
        if ($event.ReturnStatus == 1)
            this.SaveMsg = true;
        else
            this.SaveMsg = false;
        // this.getStoresListByMerchGroupID();
        this.getStoreSetUpContainer(false, $event.Account.SAPAccountNumber);
    };
    StoresetupMainComponent.prototype.setAddedStoreIndexInList = function (newStore) {
        for (var i = 0; i < this.inputAcctList.length; i++) {
            if (this.inputAcctList[i]["SAPAccountNumber"] == newStore) {
                this.selStoreInfo = this.inputAcctList[i];
                this.listIndex = i;
                break;
            }
        }
    };
    StoresetupMainComponent.prototype.cancelDetailStore = function ($event) {
        if (this.inputAcctList.length > 0) {
            this.getStoreDetailsByAccountNumber(this.inputAcctList[0]);
            this.listIndex = 0;
        }
        else {
            this.selStoreInfo = null;
        }
    };
    StoresetupMainComponent.prototype.ngOnDestroy = function () {
        // prevent memory leak when component is destroyed
        this.subscription.unsubscribe();
    };
    StoresetupMainComponent.prototype.initalizeStoreDetail = function () {
        this.weekDays = [{ Weeknumber: 2, WeekName: 'Monday', FirstPull: false, SecondPull: false },
            { Weeknumber: 3, WeekName: 'Tuesday', FirstPull: false, SecondPull: false },
            { Weeknumber: 4, WeekName: 'Wednesday', FirstPull: false, SecondPull: false },
            { Weeknumber: 5, WeekName: 'Thursday', FirstPull: false, SecondPull: false },
            { Weeknumber: 6, WeekName: 'Friday', FirstPull: false, SecondPull: false },
            { Weeknumber: 7, WeekName: 'Saturday', FirstPull: false, SecondPull: false },
            { Weeknumber: 1, WeekName: 'Sunday', FirstPull: false, SecondPull: false }];
        this.selDefaultRoute = new planning_1.RouteInfo();
        this.selDefaultRoute.RouteID = null;
        this.selDefaultRoute.RouteName = 'Default Route';
        this.SaveMsg = false;
    };
    StoresetupMainComponent.prototype.ngOnInit = function () {
        var _this = this;
        //Subscribe
        this.subscription = this.navService.navItem$
            .subscribe(function (item) {
            _this.item = item;
            if (_this.item != null || _this.item != undefined)
                _this.loadStoreData(item);
        });
    };
    StoresetupMainComponent.prototype.loadStoreData = function (item) {
        this.item = item;
        this.initalizeStoreDetail();
        this.getStoreSetUpContainer(true, '');
    };
    StoresetupMainComponent.prototype.getStoreSetUpContainer = function (isLoad, newStore) {
        var _this = this;
        this.dispService.set(this._webapi + 'api/Merc/GetStoresSetupContainer/');
        var storeListInput = { SAPBranchID: this.item.SAPBranchID, MerchGroupID: this.item.MerchGroupID };
        this.dispService.post(JSON.stringify(storeListInput), true)
            .subscribe(function (res) {
            var d = res;
            _this.inputAcctList = d.Stores;
            _this.routesList = d.Routes;
            if (isLoad) {
                _this.selStoreInfo = d.StoreDetail;
                if (d.RouteDetail != null)
                    _this.selDefaultRoute = d.RouteDetail;
                var _loop_1 = function(w) {
                    _this.weekDays.map(function (item) {
                        if (item.Weeknumber == d.WeekDays[w].Weeknumber) {
                            item.FirstPull = d.WeekDays[w].FirstPull;
                            item.SecondPull = d.WeekDays[w].SecondPull;
                        }
                    });
                };
                for (var w = 0; w < d.WeekDays.length; w++) {
                    _loop_1(w);
                }
                if (_this.inputAcctList == null || _this.inputAcctList.length == 0) {
                    _this.selStoreInfo = null;
                }
                _this.listIndex = 0;
            }
            else {
                _this.setAddedStoreIndexInList(newStore);
            }
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    StoresetupMainComponent.prototype.getStoresListByMerchGroupID = function () {
        var _this = this;
        this.dispService.set(this._webapi + 'api/Merc/GetStoresByMerchGroupID/');
        var storeListInput = { SAPBranchID: this.item.SAPBranchID, MerchGroupID: this.item.MerchGroupID };
        this.dispService.post(JSON.stringify(storeListInput), true)
            .subscribe(function (res) {
            var d = res;
            _this.inputAcctList = d.Stores;
            if (_this.inputAcctList != null && _this.inputAcctList.length > 0 && !_this.SaveMsg) {
                _this.getStoreDetailsByAccountNumber(_this.inputAcctList[0]);
            }
            if (_this.inputAcctList == null || _this.inputAcctList.length == 0) {
                _this.selStoreInfo = null;
            }
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    StoresetupMainComponent.prototype.getRoutesByMerchGroupID = function () {
        var _this = this;
        this.dispService.set(this._webapi + 'api/Merc/GetRoutesByMerchGroupID/');
        var storeListInput = { SAPBranchID: this.item.SAPBranchID, MerchGroupID: this.item.MerchGroupID };
        this.dispService.post(JSON.stringify(storeListInput), true)
            .subscribe(function (res) {
            var d = res;
            _this.routesList = d.Routes;
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    StoresetupMainComponent.prototype.getStoresLookupListBySAPBranchID = function () {
        var _this = this;
        this.dispService.set(this._webapi + 'api/Merc/GetStoresLookUpBySAPBranchID/');
        var storeListInput = { SAPBranchID: this.item.SAPBranchID };
        this.dispService.post(JSON.stringify(storeListInput), true)
            .subscribe(function (res) {
            var d = res;
            _this.inputAcctLookupList = d.Stores;
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    StoresetupMainComponent.prototype.getStoreDetailsByAccountNumber = function (store) {
        var _this = this;
        this.dispService.set(this._webapi + 'api/Merc/GetStoreDetailsBySAPAccountNumber/' + store.SAPAccountNumber);
        this.dispService.get()
            .subscribe(function (res) {
            var data = res.json();
            var result = { details: data, Account: store };
            _this.initalizeStoreDetail();
            // this.selStoreInfo = store; 
            var result = data;
            _this.selStoreInfo = result.StoreDetail;
            if (result.Detail != null)
                _this.selDefaultRoute = result.Detail;
            var _loop_2 = function(w) {
                _this.weekDays.map(function (item) {
                    if (item.Weeknumber == result.WeekDays[w].Weeknumber) {
                        item.FirstPull = result.WeekDays[w].FirstPull;
                        item.SecondPull = result.WeekDays[w].SecondPull;
                    }
                });
            };
            for (var w = 0; w < result.WeekDays.length; w++) {
                _loop_2(w);
            }
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    StoresetupMainComponent.prototype.initalizeStoreDetailsByAccountNumber = function (store) {
        var _this = this;
        this.dispService.set(this._webapi + 'api/Merc/GetStoreDetailsBySAPAccountNumber/' + store.SAPAccountNumber);
        this.dispService.get()
            .subscribe(function (res) {
            var data = res.json();
            // var result : any = { details: data,Account:store};
            _this.initalizeStoreDetail();
            // this.selStoreInfo = store; 
            // var result = data;
            _this.selStoreInfo = data.StoreDetail;
            // if(result.Detail!=null)
            // this.selDefaultRoute = result.Detail;
            // for(let w=0;w<result.WeekDays.length;w++)
            // {
            //     this.weekDays.map((item: any) => {
            //     if (item.Weeknumber == result.WeekDays[w].Weeknumber)
            //     { item.FirstPull = result.WeekDays[w].FirstPull;
            //     item.SecondPull = result.WeekDays[w].SecondPull; }
            // });
            // }      
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], StoresetupMainComponent.prototype, "storeSelected", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], StoresetupMainComponent.prototype, "storeListSelected", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], StoresetupMainComponent.prototype, "refreshList", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], StoresetupMainComponent.prototype, "cancelDetail", void 0);
    StoresetupMainComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-storesetup-main',
            templateUrl: 'storesetup-main.component.html',
            styleUrls: ['storesetup-main.component.css'],
            directives: [common_1.CORE_DIRECTIVES, stores_list_1.StoresListComponent, storedetail_1.StoredetailComponent, storeitem_1.StoreitemComponent],
            providers: [dispservice_service_1.DispserviceService, headernav_service_1.HeadernavService]
        }), 
        __metadata('design:paramtypes', [dispservice_service_1.DispserviceService, headernav_service_1.HeadernavService])
    ], StoresetupMainComponent);
    return StoresetupMainComponent;
}());
exports.StoresetupMainComponent = StoresetupMainComponent;
//# sourceMappingURL=storesetup-main.component.js.map