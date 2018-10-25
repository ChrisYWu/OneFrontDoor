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
var dispatch_row_1 = require('./dispatch-row');
var filter_pipe_1 = require('../pipes/filter.pipe');
var moment = require('moment');
var monitor_service_1 = require('../services/monitor.service');
var planning_1 = require('../services/planning');
var headernav_service_1 = require('../services/headernav.service');
var spinner_1 = require('../common/spinner');
var DispatchComponent = (function () {
    //  to remove -   refreshData() { //to move at getMonitorData
    //        this.refreshTime = moment().format("h:mm:ss A");
    //    }
    function DispatchComponent(monitorService, navService) {
        this.monitorService = monitorService;
        this.navService = navService;
        this.isShowDropDown = false;
        this.ddDates = [];
        this.selectedDate = moment().format('MMM D, YYYY');
        this.selectedIndex = 0;
        this.refreshTime = '';
        this.msgText = "";
        this.errText = "";
        this.item = new planning_1.MerchGroup();
        this.getDdDates();
        //Note - belw will relpaced with getMonitorData and getMonitorDataStatic() function to remove 
        //this.getMonitorDataStatic();
    }
    DispatchComponent.prototype.getDdDates = function () {
        for (var i = 0; i <= 7; i++) {
            this.ddDates.push(moment().subtract(i, 'days').format("MMM D, YYYY"));
        }
        ;
    };
    DispatchComponent.prototype.nextDate = function () {
        this.isShowDropDown = false;
        if (this.selectedIndex == 7) {
            this.selectedIndex = 0;
        }
        else {
            this.selectedIndex = this.selectedIndex + 1;
        }
        this.setSelectedDate();
        this.getMonitorData();
    };
    DispatchComponent.prototype.priorDate = function () {
        this.isShowDropDown = false;
        if (this.selectedIndex == 0) {
            this.selectedIndex = 7;
        }
        else {
            this.selectedIndex = this.selectedIndex - 1;
        }
        this.setSelectedDate();
        this.getMonitorData();
    };
    DispatchComponent.prototype.setSelectedDate = function () {
        // this.selectedDate = moment().subtract(this.selectedIndex, 'days').format("MMM D, YYYY");
        this.selectedDate = moment('2016-09-19').format("MMM D, YYYY");
    };
    DispatchComponent.prototype.ddDateSelected = function (i) {
        this.isShowDropDown = false;
        this.selectedIndex = i;
        this.setSelectedDate();
        this.getMonitorData();
    };
    DispatchComponent.prototype.stopRefreshing = function () {
        this.isRequesting = false;
    };
    DispatchComponent.prototype.ngOnInit = function () {
        var _this = this;
        this.msgText = "";
        this.errText = "";
        this.subscription = this.navService.navItem$.subscribe(function (item) { _this.item = item; _this.loadMonitorData(_this.item); });
    };
    DispatchComponent.prototype.loadMonitorData = function (item) {
        this.item = item;
        if (this.item != null || this.item != undefined) {
            // debugger;  
            this.monitorData = [];
            this.msgText = "";
            this.errText = "";
            // to remove static data, it is for test to get all combination 
            this.getMonitorData();
        }
    };
    DispatchComponent.prototype.ngOnDestroy = function () {
        // prevent memory leak when component is destroyed
        this.msgText = "";
        this.errText = "";
        this.subscription.unsubscribe();
    };
    DispatchComponent.prototype.getMonitorData = function () {
        var _this = this;
        // debugger
        this.msgText = "";
        this.errText = "";
        var _selectedDate = moment(this.selectedDate).format('YYYY-MM-DD');
        //bug: 69 fix
        if ((this.item != null || this.item != undefined) && (this.item.MerchGroupID != undefined || this.item.MerchGroupID != null)) {
            this.isRequesting = true;
            this.monitorService.getMonitoringData(_selectedDate, this.item.MerchGroupID)
                .subscribe(function (res) {
                var data = res.json();
                _this.errText = "";
                if (data.length <= 0) {
                    _this.msgText = "No data found for " + _this.selectedDate;
                }
                else {
                    _this.msgText = "";
                    _this.monitorData = data;
                    _this.refreshTime = moment().format("h:mm A");
                }
            }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
        }
    };
    DispatchComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'dispatch',
            templateUrl: 'dispatch.component.html',
            styleUrls: ['dispatch.component.css'],
            directives: [dispatch_row_1.DispatchRowComponent, spinner_1.SpinnerComponent],
            pipes: [filter_pipe_1.FilterPipe],
            providers: [monitor_service_1.MonitorService, headernav_service_1.HeadernavService]
        }), 
        __metadata('design:paramtypes', [monitor_service_1.MonitorService, headernav_service_1.HeadernavService])
    ], DispatchComponent);
    return DispatchComponent;
}());
exports.DispatchComponent = DispatchComponent;
//# sourceMappingURL=dispatch.component.js.map