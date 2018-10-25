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
var pl_merch_row_1 = require('./pl-merch-row');
var pl_route_row_1 = require('./pl-route-row');
var monitor_service_1 = require('../services/monitor.service');
var planning_1 = require('../services/planning');
var headernav_service_1 = require('../services/headernav.service');
var spinner_1 = require('../common/spinner');
var PlMerchComponent = (function () {
    function PlMerchComponent(monitorService, navService) {
        this.monitorService = monitorService;
        this.navService = navService;
        this.msgText_MerchToDayRouteList = "";
        this.msgText_RouteToDayMerchList = "";
        this.errText = "";
        this.isMerchTab = true;
        this.RouteMercData = {
            ReturnStatus: 1,
            Message: null,
            CorrelationID: "",
            StackTrace: null,
            AssignedDays: {},
            RouteToAssigne: {},
            MerchToAssigne: {},
            MerchToDayRouteList: [],
            RouteList: [],
            RouteToDayMerchList: [],
            MerchandiserList: [],
            RouteMerchandiserList: []
        };
        this.item = new planning_1.MerchGroup();
        // this.getRouteMercDataStatic();
        // this.getRouteMercData(101);
    }
    //----------------------------------------------Route Methods
    PlMerchComponent.prototype.onDeleteRoute = function (val) {
        // debugger;
        var dayMerch = {
            GSN: "",
            MerchGroupID: -1,
            LastName: "",
            FirstName: "",
            Email: "",
            Phone: "",
            DayOfWeek: val.dayOfWeek,
            isOffDay: null,
            isMerchAssigned: false
        };
        var merchTA = {};
        for (var a = 0; a < this.RouteMercData.MerchandiserList.length; a++) {
            if (this.RouteMercData.MerchandiserList[a].GSN == val.GSN) {
                merchTA = this.RouteMercData.MerchandiserList[a];
                break;
            }
        }
        for (var i = 0; i < this.RouteMercData.RouteToDayMerchList.length; i++) {
            if (this.RouteMercData.RouteToDayMerchList[i].RouteID == val.route.RouteID) {
                switch (val.dayOfWeek) {
                    case 1:
                        this.RouteMercData.RouteToDayMerchList[i].Sunday = dayMerch;
                        this.RouteMercData.MerchToAssigne.Sunday.splice(0, 0, merchTA);
                        break;
                    case 2:
                        this.RouteMercData.RouteToDayMerchList[i].Monday = dayMerch;
                        this.RouteMercData.MerchToAssigne.Monday.splice(0, 0, merchTA);
                        break;
                    case 3:
                        this.RouteMercData.RouteToDayMerchList[i].Tuesday = dayMerch;
                        this.RouteMercData.MerchToAssigne.Tuesday.splice(0, 0, merchTA);
                        break;
                    case 4:
                        this.RouteMercData.RouteToDayMerchList[i].Wednesday = dayMerch;
                        this.RouteMercData.MerchToAssigne.Wednesday.splice(0, 0, merchTA);
                        break;
                    case 5:
                        this.RouteMercData.RouteToDayMerchList[i].Thursday = dayMerch;
                        this.RouteMercData.MerchToAssigne.Thursday.splice(0, 0, merchTA);
                        break;
                    case 6:
                        this.RouteMercData.RouteToDayMerchList[i].Friday = dayMerch;
                        this.RouteMercData.MerchToAssigne.Friday.splice(0, 0, merchTA);
                        break;
                    case 7:
                        this.RouteMercData.RouteToDayMerchList[i].Saturday = dayMerch;
                        this.RouteMercData.MerchToAssigne.Saturday.splice(0, 0, merchTA);
                        break;
                }
                break;
            }
        }
        //this is database delete call - maybe goiing to drop 
        this.deleteRouteMerchandiser(val.route.RouteID, val.dayOfWeek, val.GSN);
    };
    PlMerchComponent.prototype.updateMerchToAssigne = function (merchToAssigne, merchToDayRoute) {
        var _updateMerchToAssigne = [];
        for (var i = 0; i < merchToAssigne.length; i++) {
            if (merchToAssigne[i].GSN != merchToDayRoute.GSN) {
                _updateMerchToAssigne.push(merchToAssigne[i]);
            }
        }
        return _updateMerchToAssigne;
    };
    PlMerchComponent.prototype.updateRouteToDayMerchList = function (routeToDayMerch, merchToDayRoute) {
        var updateRouteToDayMerch = routeToDayMerch;
        updateRouteToDayMerch.LastName = merchToDayRoute.LastName;
        updateRouteToDayMerch.FirstName = merchToDayRoute.FirstName;
        updateRouteToDayMerch.Email = merchToDayRoute.Email;
        updateRouteToDayMerch.Phone = merchToDayRoute.Phone;
        updateRouteToDayMerch.isOffDay = merchToDayRoute.isOffDay;
        updateRouteToDayMerch.isMerchAssigned = true;
        return updateRouteToDayMerch;
    };
    PlMerchComponent.prototype.onAddRoute = function (val) {
        //{'route': val.route, 'dayOfWeek': val.DayOfWeek, 'merchToDayRoute': this.MerchToDayRoute}
        // remove from availbeRoute
        // remove from availble available Merchaniser 
        // debugger;
        var _dayOfWeek = val.dayOfWeek;
        var _route = val.route;
        var _merchToDayRoute = val.merchToDayRoute;
        var availableMerch;
        debugger;
        switch (val.dayOfWeek) {
            case 1:
                availableMerch = this.RouteMercData.MerchToAssigne.Sunday;
                this.RouteMercData.MerchToAssigne.Sunday = this.updateMerchToAssigne(availableMerch, _merchToDayRoute);
                break;
            case 2:
                availableMerch = this.RouteMercData.MerchToAssigne.Monday;
                this.RouteMercData.MerchToAssigne.Monday = this.updateMerchToAssigne(availableMerch, _merchToDayRoute);
                break;
            case 3:
                availableMerch = this.RouteMercData.MerchToAssigne.Tuesday;
                this.RouteMercData.MerchToAssigne.Tuesday = this.updateMerchToAssigne(availableMerch, _merchToDayRoute);
                break;
            case 4:
                availableMerch = this.RouteMercData.MerchToAssigne.Wednesday;
                this.RouteMercData.MerchToAssigne.Wednesday = this.updateMerchToAssigne(availableMerch, _merchToDayRoute);
                break;
            case 5:
                availableMerch = this.RouteMercData.MerchToAssigne.Thursday;
                this.RouteMercData.MerchToAssigne.Thursday = this.updateMerchToAssigne(availableMerch, _merchToDayRoute);
                break;
            case 6:
                availableMerch = this.RouteMercData.MerchToAssigne.Friday;
                this.RouteMercData.MerchToAssigne.Friday = this.updateMerchToAssigne(availableMerch, _merchToDayRoute);
                break;
            case 7:
                availableMerch = this.RouteMercData.MerchToAssigne.Saturday;
                this.RouteMercData.MerchToAssigne.Saturday = this.updateMerchToAssigne(availableMerch, _merchToDayRoute);
                break;
        }
        //----------------------------------------------RouteToDayMerchList update  ----
        // do do debug here - getting error here 
        for (var i = 0; i < this.RouteMercData.RouteToDayMerchList.length; i++) {
            if (this.RouteMercData.RouteToDayMerchList[i].RouteID == _route.RouteID) {
                var routeToDayMerch = void 0;
                switch (val.dayOfWeek) {
                    case 1:
                        routeToDayMerch = this.RouteMercData.RouteToDayMerchList[i].Sunday;
                        this.RouteMercData.RouteToDayMerchList[i].Sunday = this.updateRouteToDayMerchList(routeToDayMerch, _merchToDayRoute);
                        break;
                    case 2:
                        routeToDayMerch = this.RouteMercData.RouteToDayMerchList[i].Monday;
                        this.RouteMercData.RouteToDayMerchList[i].Monday = this.updateRouteToDayMerchList(routeToDayMerch, _merchToDayRoute);
                        break;
                    case 3:
                        routeToDayMerch = this.RouteMercData.RouteToDayMerchList[i].Tuesday;
                        this.RouteMercData.RouteToDayMerchList[i].Tuesday = this.updateRouteToDayMerchList(routeToDayMerch, _merchToDayRoute);
                        break;
                    case 4:
                        routeToDayMerch = this.RouteMercData.RouteToDayMerchList[i].Wednesday;
                        this.RouteMercData.RouteToDayMerchList[i].Wednesday = this.updateRouteToDayMerchList(routeToDayMerch, _merchToDayRoute);
                        break;
                    case 5:
                        routeToDayMerch = this.RouteMercData.RouteToDayMerchList[i].Thursday;
                        this.RouteMercData.RouteToDayMerchList[i].Thursday = this.updateRouteToDayMerchList(routeToDayMerch, _merchToDayRoute);
                        break;
                    case 6:
                        routeToDayMerch = this.RouteMercData.RouteToDayMerchList[i].Friday;
                        this.RouteMercData.RouteToDayMerchList[i].Friday = this.updateRouteToDayMerchList(routeToDayMerch, _merchToDayRoute);
                        break;
                    case 7:
                        routeToDayMerch = this.RouteMercData.RouteToDayMerchList[i].Saturday;
                        this.RouteMercData.RouteToDayMerchList[i].Saturday = this.updateRouteToDayMerchList(routeToDayMerch, _merchToDayRoute);
                        break;
                }
                break;
            }
        }
        this.addRouteMerchandiser(_route.RouteID, _dayOfWeek, _merchToDayRoute.GSN);
    };
    //---------------------------------------------Merch methods
    PlMerchComponent.prototype.onDeleteMerch = function (val) {
        var dayRoute = {
            RouteID: -1,
            RouteName: "",
            DayOfWeek: val.dayOfWeek,
            isOffDay: null,
            isRouteAssigned: false
        };
        var routeTA = {};
        for (var a = 0; a < this.RouteMercData.RouteList.length; a++) {
            if (this.RouteMercData.RouteList[a].RouteID == val.routeID) {
                routeTA = this.RouteMercData.RouteList[a];
                break;
            }
        }
        for (var i = 0; i < this.RouteMercData.MerchToDayRouteList.length; i++) {
            if (this.RouteMercData.MerchToDayRouteList[i].GSN == val.merch.GSN) {
                switch (val.dayOfWeek) {
                    case 1:
                        this.RouteMercData.MerchToDayRouteList[i].Sunday = dayRoute;
                        this.RouteMercData.RouteToAssigne.Sunday.splice(0, 0, routeTA);
                        break;
                    case 2:
                        this.RouteMercData.MerchToDayRouteList[i].Monday = dayRoute;
                        this.RouteMercData.RouteToAssigne.Monday.splice(0, 0, routeTA);
                        break;
                    case 3:
                        this.RouteMercData.MerchToDayRouteList[i].Tuesday = dayRoute;
                        this.RouteMercData.RouteToAssigne.Tuesday.splice(0, 0, routeTA);
                        break;
                    case 4:
                        this.RouteMercData.MerchToDayRouteList[i].Wednesday = dayRoute;
                        this.RouteMercData.RouteToAssigne.Wednesday.splice(0, 0, routeTA);
                        break;
                    case 5:
                        this.RouteMercData.MerchToDayRouteList[i].Thursday = dayRoute;
                        this.RouteMercData.RouteToAssigne.Thursday.splice(0, 0, routeTA);
                        break;
                    case 6:
                        this.RouteMercData.MerchToDayRouteList[i].Friday = dayRoute;
                        this.RouteMercData.RouteToAssigne.Friday.splice(0, 0, routeTA);
                        break;
                    case 7:
                        this.RouteMercData.MerchToDayRouteList[i].Saturday = dayRoute;
                        this.RouteMercData.RouteToAssigne.Saturday.splice(0, 0, routeTA);
                        break;
                }
                break;
            }
        }
        //this is database delete call - maybe goiing to drop 
        this.deleteRouteMerchandiser(val.routeID, val.dayOfWeek, val.merch.GSN);
    };
    PlMerchComponent.prototype.updateRouteToAssigne = function (routeToAssigne, routeToDayMerch) {
        var _updateRouteToAssigne = [];
        for (var i = 0; i < routeToAssigne.length; i++) {
            if (routeToAssigne[i].RouteID != routeToDayMerch.RouteID) {
                _updateRouteToAssigne.push(routeToAssigne[i]);
            }
        }
        return _updateRouteToAssigne;
    };
    PlMerchComponent.prototype.updateMerchToDayRouteList = function (merchToDayRoute, routeToDayMerch) {
        //debugger;
        var updateMerchToDayRoute = merchToDayRoute;
        updateMerchToDayRoute.RouteID = routeToDayMerch.RouteID;
        updateMerchToDayRoute.RouteName = routeToDayMerch.RouteName;
        updateMerchToDayRoute.DayOfWeek = routeToDayMerch.DayOfWeek;
        updateMerchToDayRoute.isRouteAssigned = true;
        return updateMerchToDayRoute;
    };
    PlMerchComponent.prototype.onAddMerchandiser = function (val) {
        //debugger;
        var _dayOfWeek = val.dayOfWeek;
        var _merchandiser = val.merchandiser;
        var _routeToDayMerch = val.routeToDayMerch;
        var availableRoute;
        switch (val.dayOfWeek) {
            case 1:
                availableRoute = this.RouteMercData.RouteToAssigne.Sunday;
                this.RouteMercData.RouteToAssigne.Sunday = this.updateRouteToAssigne(availableRoute, _routeToDayMerch);
                break;
            case 2:
                availableRoute = this.RouteMercData.RouteToAssigne.Monday;
                this.RouteMercData.RouteToAssigne.Monday = this.updateRouteToAssigne(availableRoute, _routeToDayMerch);
                break;
            case 3:
                availableRoute = this.RouteMercData.RouteToAssigne.Tuesday;
                this.RouteMercData.RouteToAssigne.Tuesday = this.updateRouteToAssigne(availableRoute, _routeToDayMerch);
                break;
            case 4:
                availableRoute = this.RouteMercData.RouteToAssigne.Wednesday;
                this.RouteMercData.RouteToAssigne.Wednesday = this.updateRouteToAssigne(availableRoute, _routeToDayMerch);
                break;
            case 5:
                availableRoute = this.RouteMercData.RouteToAssigne.Thursday;
                this.RouteMercData.RouteToAssigne.Thursday = this.updateRouteToAssigne(availableRoute, _routeToDayMerch);
                break;
            case 6:
                availableRoute = this.RouteMercData.RouteToAssigne.Friday;
                this.RouteMercData.RouteToAssigne.Friday = this.updateRouteToAssigne(availableRoute, _routeToDayMerch);
                break;
            case 7:
                availableRoute = this.RouteMercData.RouteToAssigne.Saturday;
                this.RouteMercData.RouteToAssigne.Saturday = this.updateRouteToAssigne(availableRoute, _routeToDayMerch);
                break;
        }
        for (var i = 0; i < this.RouteMercData.MerchToDayRouteList.length; i++) {
            if (this.RouteMercData.MerchToDayRouteList[i].GSN == _merchandiser.GSN) {
                var merchToDayRoute = void 0;
                switch (val.dayOfWeek) {
                    case 1:
                        merchToDayRoute = this.RouteMercData.MerchToDayRouteList[i].Sunday;
                        this.RouteMercData.MerchToDayRouteList[i].Sunday = this.updateMerchToDayRouteList(merchToDayRoute, _routeToDayMerch);
                        break;
                    case 2:
                        merchToDayRoute = this.RouteMercData.MerchToDayRouteList[i].Monday;
                        this.RouteMercData.MerchToDayRouteList[i].Monday = this.updateMerchToDayRouteList(merchToDayRoute, _routeToDayMerch);
                        break;
                    case 3:
                        merchToDayRoute = this.RouteMercData.MerchToDayRouteList[i].Tuesday;
                        this.RouteMercData.MerchToDayRouteList[i].Tuesday = this.updateMerchToDayRouteList(merchToDayRoute, _routeToDayMerch);
                        break;
                    case 4:
                        merchToDayRoute = this.RouteMercData.MerchToDayRouteList[i].Wednesday;
                        this.RouteMercData.MerchToDayRouteList[i].Wednesday = this.updateMerchToDayRouteList(merchToDayRoute, _routeToDayMerch);
                        break;
                    case 5:
                        merchToDayRoute = this.RouteMercData.MerchToDayRouteList[i].Thursday;
                        this.RouteMercData.MerchToDayRouteList[i].Thursday = this.updateMerchToDayRouteList(merchToDayRoute, _routeToDayMerch);
                        break;
                    case 6:
                        merchToDayRoute = this.RouteMercData.MerchToDayRouteList[i].Friday;
                        this.RouteMercData.MerchToDayRouteList[i].Friday = this.updateMerchToDayRouteList(merchToDayRoute, _routeToDayMerch);
                        break;
                    case 7:
                        merchToDayRoute = this.RouteMercData.MerchToDayRouteList[i].Saturday;
                        this.RouteMercData.MerchToDayRouteList[i].Saturday = this.updateMerchToDayRouteList(merchToDayRoute, _routeToDayMerch);
                        break;
                }
                break;
            }
        }
        this.addRouteMerchandiser(_routeToDayMerch.RouteID, _dayOfWeek, _merchandiser.GSN);
    };
    PlMerchComponent.prototype.stopRefreshing = function () {
        this.isRequesting = false;
    };
    PlMerchComponent.prototype.ngOnInit = function () {
        var _this = this;
        this.subscription = this.navService.navItem$.subscribe(function (item) { _this.item = item; _this.loadRouteMercData(_this.item); });
    };
    PlMerchComponent.prototype.ngOnDestroy = function () {
        // prevent memory leak when component is destroyed
        this.subscription.unsubscribe();
    };
    PlMerchComponent.prototype.loadRouteMercData = function (item) {
        this.item = item;
        if (this.item != null || this.item != undefined) {
            this.getRouteMercData();
        }
    };
    //------------------------------------database/service 
    PlMerchComponent.prototype.deleteRouteMerchandiser = function (routeID, dayOfWeek, GSN) {
        this.editRouteMerchandiser(routeID, dayOfWeek, GSN, true);
    };
    PlMerchComponent.prototype.addRouteMerchandiser = function (routeID, dayOfWeek, GSN) {
        this.editRouteMerchandiser(routeID, dayOfWeek, GSN, false);
    };
    PlMerchComponent.prototype.editRouteMerchandiser = function (routeID, dayOfWeek, GSN, isForDelete) {
        var _this = this;
        // isForDelete - if only to delete record than set as true, other wise it add a record, before add it delete exit record, record is as below  
        //  RouteID	DayOfWeek	GSN	LastModified	LastModifiedBy
        // 10120	1	ARMDZ001	2016-06-09 16:00:56.0083365	System
        // debugger
        var result = {};
        this.isRequesting = true;
        this.monitorService.editRouteMerchandiser(routeID, dayOfWeek, GSN, isForDelete)
            .subscribe(function (res) {
            var data = res.json();
            result = data;
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    PlMerchComponent.prototype.getRouteMercData = function () {
        var _this = this;
        this.msgText_MerchToDayRouteList = "";
        this.msgText_RouteToDayMerchList = "";
        this.errText = "";
        this.isRequesting = true;
        //  debugger
        if (this.item.MerchGroupID != undefined || this.item.MerchGroupID != null)
            this.monitorService.getRouteMerchandiserByMerchGroupID(this.item.MerchGroupID)
                .subscribe(function (res) {
                var data = res.json();
                _this.RouteMercData = data;
                _this.errText = "";
                if (_this.RouteMercData.MerchToDayRouteList.length <= 0) {
                    _this.msgText_MerchToDayRouteList = "No data found";
                }
                if (_this.RouteMercData.RouteToDayMerchList.length <= 0) {
                    _this.msgText_RouteToDayMerchList = "No data found";
                }
            }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    //below to remove latter on  
    PlMerchComponent.prototype.getRouteMercDataStatic = function () {
        //  debugger
        this.RouteMercData = {};
    };
    PlMerchComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'pl-merch',
            templateUrl: 'pl-merch.component.html',
            styleUrls: ['pl-merch.component.css'],
            directives: [pl_merch_row_1.PlMerchRowComponent, pl_route_row_1.PlRouteRowComponent, spinner_1.SpinnerComponent],
            providers: [monitor_service_1.MonitorService, headernav_service_1.HeadernavService]
        }), 
        __metadata('design:paramtypes', [monitor_service_1.MonitorService, headernav_service_1.HeadernavService])
    ], PlMerchComponent);
    return PlMerchComponent;
}());
exports.PlMerchComponent = PlMerchComponent;
//# sourceMappingURL=pl-merch.component.js.map