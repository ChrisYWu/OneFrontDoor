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
var http_1 = require('@angular/http');
var core_1 = require('@angular/core');
require('rxjs/add/operator/map');
require('rxjs/add/operator/toPromise');
var MerchAppConstant_1 = require('../../app/MerchAppConstant');
var MonitorService = (function () {
    function MonitorService(http) {
        this.http = http;
        this._baseUri = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
    }
    MonitorService.prototype.set = function (baseUri) {
        this._baseUri = baseUri;
    };
    MonitorService.prototype.getMonitoringData = function (selectedDate, merchGroupID) {
        //"2016-06-11" 
        var uri = this._baseUri;
        var uri = this._baseUri + "api/Monitoring/GetMornitoringLanding?dispatchDate=" + selectedDate + "&merchGroupID=" + merchGroupID;
        return this.http.get(uri)
            .map(function (response) { return (response); });
    };
    MonitorService.prototype.getStoreDetailsData = function (merchStopID) {
        //debugger
        //merchStopID=3
        var uri = this._baseUri;
        var uri = this._baseUri + "api/Monitoring/GetMornitoringDetail?merchStopID=" + merchStopID;
        return this.http.get(uri)
            .map(function (response) { return (response); });
    };
    MonitorService.prototype.getRouteMerchandiserByMerchGroupID = function (merchGroupID) {
        // debugger
        //merchStopID=3
        var uri = this._baseUri;
        var uri = this._baseUri + "api/Monitoring/GetRouteMerchandiserByMerchGroupID?merchGroupID=" + merchGroupID;
        return this.http.get(uri)
            .map(function (response) { return (response); });
    };
    MonitorService.prototype.editRouteMerchandiser = function (routeID, dayOfWeek, GSN, isForDelete) {
        // debugger
        //merchStopID=3
        var uri = this._baseUri;
        var uri = this._baseUri + "api/Monitoring/EditRouteMerchandiser?routeID=" + routeID + "&dayOfWeek=" + dayOfWeek + "&GSN=" + GSN + "&isForDelete=" + isForDelete;
        return this.http.get(uri)
            .map(function (response) { return (response); });
    };
    MonitorService = __decorate([
        core_1.Injectable(), 
        __metadata('design:paramtypes', [http_1.Http])
    ], MonitorService);
    return MonitorService;
}());
exports.MonitorService = MonitorService;
//# sourceMappingURL=monitor.service.js.map