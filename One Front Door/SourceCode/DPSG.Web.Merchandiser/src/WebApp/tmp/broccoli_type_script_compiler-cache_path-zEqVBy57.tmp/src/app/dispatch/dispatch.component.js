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
var DispatchComponent = (function () {
    //  to remove -   refreshData() { //to move at getMonitorData
    //        this.refreshTime = moment().format("h:mm:ss A");
    //    }
    function DispatchComponent(monitorService, navService) {
        this.monitorService = monitorService;
        this.navService = navService;
        this.isShowDropDown = false;
        this.ddDates = [];
        this.selectedDate = moment().format('D MMM, YYYY');
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
            this.ddDates.push(moment().subtract(i, 'days').format("D MMM, YYYY"));
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
        this.selectedDate = moment().subtract(this.selectedIndex, 'days').format("D MMM, YYYY");
    };
    DispatchComponent.prototype.ddDateSelected = function (i) {
        this.isShowDropDown = false;
        this.selectedIndex = i;
        this.setSelectedDate();
        this.getMonitorData();
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
                    _this.refreshTime = moment().format("h:mm:ss A");
                }
            }, function (error) {
                _this.msgText = "";
                _this.errText = "Error occur when getting data " + _this.selectedDate;
                if (error.status == 401 || error.status == 404) {
                }
            });
        }
    };
    DispatchComponent.prototype.getMonitorDataStatic = function () {
        this.setSelectedDate();
        this.monitorData =
            [{
                    GSN: "ARMDZ001",
                    LastName: "Armstrong",
                    FirstName: "Dylan",
                    RouteName: "Route#10133",
                    MileageTotalLabel: "105.20 mi",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Completed",
                    Stops: [{
                            SequenceOrder: 1,
                            SequenceLabel: "11",
                            AccountName: "Walmart Sc 003777",
                            TimeSpan: "04:43 ~ 05:49",
                            DriveTime: "0 min",
                            Mileage: "0 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 3
                        }, {
                            SequenceOrder: 2,
                            SequenceLabel: "12",
                            AccountName: "Kroger 000547",
                            TimeSpan: "05:53 ~ 06:59",
                            DriveTime: "4 min",
                            Mileage: "14 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "Done",
                            MerchStopID: 4
                        }, {
                            SequenceOrder: 3,
                            SequenceLabel: "13",
                            AccountName: "Market Street 000562",
                            TimeSpan: "07:07 ~ 08:20",
                            DriveTime: "8 min",
                            Mileage: "17 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 5
                        }, {
                            SequenceOrder: 4,
                            SequenceLabel: "14",
                            AccountName: "Super Target 002338",
                            TimeSpan: "08:31 ~ 10:42",
                            DriveTime: "11 min",
                            Mileage: "11 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 6
                        }, {
                            SequenceOrder: 5,
                            SequenceLabel: "15",
                            AccountName: "Kroger 000547",
                            TimeSpan: "10:49 ~ 12:34",
                            DriveTime: "7 min",
                            Mileage: "19 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "Done",
                            MerchStopID: 7
                        }, {
                            SequenceOrder: 6,
                            SequenceLabel: "16",
                            AccountName: "Walmart Sc 003777",
                            TimeSpan: "12:43 ~ 15:17",
                            DriveTime: "9 min",
                            Mileage: "6 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 8
                        }, {
                            SequenceOrder: 7,
                            SequenceLabel: "P",
                            AccountName: "Walmart Sc 002973",
                            TimeSpan: "15:28 ~ ",
                            DriveTime: "11 min",
                            Mileage: "1 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 16
                        }]
                }, {
                    GSN: "AUDRP001",
                    LastName: "Audette",
                    FirstName: "Raymond",
                    RouteName: "Route#10120",
                    MileageTotalLabel: "16.00 mi",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Started",
                    Stops: [{
                            SequenceOrder: 1,
                            SequenceLabel: "2",
                            AccountName: "Walmart Nm 003199",
                            TimeSpan: "05:20 ~ 06:21",
                            DriveTime: "0 min",
                            Mileage: "0 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 10
                        }, {
                            SequenceOrder: 2,
                            SequenceLabel: "1",
                            AccountName: "Walmart Nm 006851",
                            TimeSpan: "06:27 ~ 08:06",
                            DriveTime: "6 min",
                            Mileage: "15 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "Done",
                            MerchStopID: 12
                        }, {
                            SequenceOrder: 3,
                            SequenceLabel: "3",
                            AccountName: "Walmart Sc 005673",
                            TimeSpan: "08:09 ~ 09:45",
                            DriveTime: "3 min",
                            Mileage: "1 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 11
                        }, {
                            SequenceOrder: 2001,
                            SequenceLabel: "1",
                            AccountName: "Super Target 001514",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2002,
                            SequenceLabel: "2",
                            AccountName: "Albertsons 004101",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2003,
                            SequenceLabel: "3",
                            AccountName: "Walmart Nm 003199",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2004,
                            SequenceLabel: "4",
                            AccountName: "Walmart Sc 005673",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2005,
                            SequenceLabel: "5",
                            AccountName: "Albertsons 004101",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2006,
                            SequenceLabel: "6",
                            AccountName: "Walmart Nm 006851",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }, {
                    GSN: "BELJS001",
                    LastName: "Bellamy",
                    FirstName: "Joseph",
                    RouteName: "Route#10123",
                    MileageTotalLabel: "52.00 mi",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Started",
                    Stops: [{
                            SequenceOrder: 1,
                            SequenceLabel: "1",
                            AccountName: "Terrys Supermarket 000009",
                            TimeSpan: "05:02 ~ 07:36",
                            DriveTime: "0 min",
                            Mileage: "0 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 14
                        }, {
                            SequenceOrder: 2,
                            SequenceLabel: "2",
                            AccountName: "Brookshire's 000076",
                            TimeSpan: "07:44 ~ 08:40",
                            DriveTime: "8 min",
                            Mileage: "18 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 15
                        }, {
                            SequenceOrder: 3,
                            SequenceLabel: "5",
                            AccountName: "Kroger 000563",
                            TimeSpan: "08:56 ~ 10:23",
                            DriveTime: "16 min",
                            Mileage: "19 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 18
                        }, {
                            SequenceOrder: 4,
                            SequenceLabel: "P",
                            AccountName: "Kroger 000546",
                            TimeSpan: "10:31 ~ ",
                            DriveTime: "8 min",
                            Mileage: "15 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 24
                        }, {
                            SequenceOrder: 2001,
                            SequenceLabel: "1",
                            AccountName: "Walmart Sc 002973",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2002,
                            SequenceLabel: "2",
                            AccountName: "Walmart Sc 002973",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2003,
                            SequenceLabel: "3",
                            AccountName: "Brookshire's 000076",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2004,
                            SequenceLabel: "4",
                            AccountName: "Walmart Nm 006078",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2006,
                            SequenceLabel: "6",
                            AccountName: "Terrys Supermarket 000009",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }, {
                    GSN: "BURJX556",
                    LastName: "Burgess",
                    FirstName: "Joshua",
                    RouteName: "Route#10134",
                    MileageTotalLabel: "21.00 mi",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Started",
                    Stops: [{
                            SequenceOrder: 1,
                            SequenceLabel: "2",
                            AccountName: "Super Target 002142",
                            TimeSpan: "04:32 ~ 07:05",
                            DriveTime: "0 min",
                            Mileage: "0 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 21
                        }, {
                            SequenceOrder: 2,
                            SequenceLabel: "4",
                            AccountName: "Total Wine & More 000506",
                            TimeSpan: "07:18 ~ 09:51",
                            DriveTime: "13 min",
                            Mileage: "4 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 23
                        }, {
                            SequenceOrder: 3,
                            SequenceLabel: "P",
                            AccountName: "Kroger 000580",
                            TimeSpan: "09:53 ~ ",
                            DriveTime: "2 min",
                            Mileage: "17 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 25
                        }, {
                            SequenceOrder: 2001,
                            SequenceLabel: "1",
                            AccountName: "Kroger 000546",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2003,
                            SequenceLabel: "3",
                            AccountName: "Kroger 000580",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2005,
                            SequenceLabel: "5",
                            AccountName: "Kroger 000546",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }, {
                    GSN: "EADHE001",
                    LastName: "Eaddy",
                    FirstName: "Herbert",
                    RouteName: "Route#10125",
                    MileageTotalLabel: "17.00 mi",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Started",
                    Stops: [{
                            SequenceOrder: 1,
                            SequenceLabel: "1",
                            AccountName: "Walmart Sc 000206",
                            TimeSpan: "05:12 ~ 06:57",
                            DriveTime: "0 min",
                            Mileage: "0 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 26
                        }, {
                            SequenceOrder: 2,
                            SequenceLabel: "4",
                            AccountName: "Super 1 Foods 000641",
                            TimeSpan: "07:13 ~ 08:05",
                            DriveTime: "16 min",
                            Mileage: "11 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 29
                        }, {
                            SequenceOrder: 3,
                            SequenceLabel: "3",
                            AccountName: "Super Target 002335",
                            TimeSpan: "08:20 ~ 09:27",
                            DriveTime: "15 min",
                            Mileage: "6 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 28
                        }, {
                            SequenceOrder: 2001,
                            SequenceLabel: "1",
                            AccountName: "Kroger 000488",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2002,
                            SequenceLabel: "2",
                            AccountName: "Walmart Sc 000206",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2003,
                            SequenceLabel: "3",
                            AccountName: "Super 1 Foods 000641",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2004,
                            SequenceLabel: "4",
                            AccountName: "Walmart Sc 000206",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2005,
                            SequenceLabel: "5",
                            AccountName: "Super Target 002335",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2006,
                            SequenceLabel: "6",
                            AccountName: "Albertsons 004193",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2007,
                            SequenceLabel: "7",
                            AccountName: "Albertsons 004102",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }, {
                    GSN: "FAUMX002",
                    LastName: "faulkner",
                    FirstName: "marchello",
                    RouteName: "Route#10132",
                    MileageTotalLabel: "",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Pending",
                    Stops: [{
                            SequenceOrder: 2001,
                            SequenceLabel: "1",
                            AccountName: "Super Target 002550",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2002,
                            SequenceLabel: "2",
                            AccountName: "Kroger 000578",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2003,
                            SequenceLabel: "3",
                            AccountName: "Albertsons 004239",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2004,
                            SequenceLabel: "4",
                            AccountName: "Walmart Sc 005210",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2005,
                            SequenceLabel: "5",
                            AccountName: "Kroger 000578",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2006,
                            SequenceLabel: "6",
                            AccountName: "Walmart Sc 005210",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }, {
                    GSN: "FELCR001",
                    LastName: "Feller",
                    FirstName: "Christopher",
                    RouteName: "Route#10130",
                    MileageTotalLabel: "52.00 mi",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Started",
                    Stops: [{
                            SequenceOrder: 1,
                            SequenceLabel: "1",
                            AccountName: "Kroger 000544",
                            TimeSpan: "04:50 ~ 06:09",
                            DriveTime: "0 min",
                            Mileage: "0 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "Done",
                            MerchStopID: 31
                        }, {
                            SequenceOrder: 2,
                            SequenceLabel: "3",
                            AccountName: "Market Street 000563",
                            TimeSpan: "06:12 ~ 08:41",
                            DriveTime: "3 min",
                            Mileage: "9 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "Not done",
                            MerchStopID: 33
                        }, {
                            SequenceOrder: 3,
                            SequenceLabel: "2",
                            AccountName: "Tom Thumb 003579",
                            TimeSpan: "08:44 ~ 09:28",
                            DriveTime: "3 min",
                            Mileage: "17 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "Not done",
                            MerchStopID: 32
                        }, {
                            SequenceOrder: 4,
                            SequenceLabel: "5",
                            AccountName: "Kroger 000544",
                            TimeSpan: "09:33 ~ 10:47",
                            DriveTime: "5 min",
                            Mileage: "22 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "Done",
                            MerchStopID: 35
                        }, {
                            SequenceOrder: 5,
                            SequenceLabel: "P",
                            AccountName: "Walmart Sc 005672",
                            TimeSpan: "10:53 ~ ",
                            DriveTime: "6 min",
                            Mileage: "4 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 36
                        }, {
                            SequenceOrder: 2004,
                            SequenceLabel: "4",
                            AccountName: "Walmart Sc 005672",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }, {
                    GSN: "GRAMX023",
                    LastName: "Graham",
                    FirstName: "Marcus",
                    RouteName: "Route#10121",
                    MileageTotalLabel: "38.00 mi",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Started",
                    Stops: [{
                            SequenceOrder: 1,
                            SequenceLabel: "2",
                            AccountName: "Kroger 000560",
                            TimeSpan: "04:58 ~ 07:28",
                            DriveTime: "0 min",
                            Mileage: "0 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 38
                        }, {
                            SequenceOrder: 2,
                            SequenceLabel: "1",
                            AccountName: "Tom Thumb 002581",
                            TimeSpan: "07:35 ~ 08:37",
                            DriveTime: "7 min",
                            Mileage: "7 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 37
                        }, {
                            SequenceOrder: 3,
                            SequenceLabel: "3",
                            AccountName: "Super Target 001763",
                            TimeSpan: "08:53 ~ 10:10",
                            DriveTime: "16 min",
                            Mileage: "15 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 39
                        }, {
                            SequenceOrder: 4,
                            SequenceLabel: "4",
                            AccountName: "Walmart Sc 005866",
                            TimeSpan: "10:23 ~ 12:47",
                            DriveTime: "13 min",
                            Mileage: "16 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 40
                        }, {
                            SequenceOrder: 2001,
                            SequenceLabel: "1",
                            AccountName: "Walmart Sc 005866",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2002,
                            SequenceLabel: "2",
                            AccountName: "Kroger 000488",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2003,
                            SequenceLabel: "3",
                            AccountName: "Kroger 000560",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2004,
                            SequenceLabel: "4",
                            AccountName: "Kroger 000560",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2005,
                            SequenceLabel: "5",
                            AccountName: "Tom Thumb 002581",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2006,
                            SequenceLabel: "6",
                            AccountName: "Albertsons 004198",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }, {
                    GSN: "HILAM001",
                    LastName: "Hilburn",
                    FirstName: "Aaron",
                    RouteName: "Route#10127",
                    MileageTotalLabel: "34.00 mi",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Started",
                    Stops: [{
                            SequenceOrder: 1,
                            SequenceLabel: "1",
                            AccountName: "Winco Foods 000122",
                            TimeSpan: "04:44 ~ 05:27",
                            DriveTime: "0 min",
                            Mileage: "0 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 43
                        }, {
                            SequenceOrder: 2,
                            SequenceLabel: "2",
                            AccountName: "Albertsons 000296",
                            TimeSpan: "05:31 ~ 06:36",
                            DriveTime: "4 min",
                            Mileage: "3 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 44
                        }, {
                            SequenceOrder: 3,
                            SequenceLabel: "3",
                            AccountName: "Walmart Nm 006966",
                            TimeSpan: "06:38 ~ 07:35",
                            DriveTime: "2 min",
                            Mileage: "9 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 45
                        }, {
                            SequenceOrder: 4,
                            SequenceLabel: "+",
                            AccountName: "Kroger 000548",
                            TimeSpan: "07:41 ~ 09:33",
                            DriveTime: "6 min",
                            Mileage: "16 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 67
                        }, {
                            SequenceOrder: 5,
                            SequenceLabel: "+",
                            AccountName: "Walmart Sc 001117",
                            TimeSpan: "09:40 ~ 12:17",
                            DriveTime: "7 min",
                            Mileage: "5 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 59
                        }, {
                            SequenceOrder: 6,
                            SequenceLabel: "P",
                            AccountName: "Kroger 000561",
                            TimeSpan: "12:25 ~ ",
                            DriveTime: "8 min",
                            Mileage: "1 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 82
                        }, {
                            SequenceOrder: 2004,
                            SequenceLabel: "4",
                            AccountName: "Winco Foods 000122",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2005,
                            SequenceLabel: "5",
                            AccountName: "Brookshire's 000076",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2006,
                            SequenceLabel: "6",
                            AccountName: "Albertsons 004193",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }, {
                    GSN: "LONDX007",
                    LastName: "Longoria",
                    FirstName: "David",
                    RouteName: "Route#10122",
                    MileageTotalLabel: "15.00 mi",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Started",
                    Stops: [{
                            SequenceOrder: 1,
                            SequenceLabel: "1",
                            AccountName: "Tom Thumb 002595",
                            TimeSpan: "04:20 ~ 06:46",
                            DriveTime: "0 min",
                            Mileage: "0 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 47
                        }, {
                            SequenceOrder: 2,
                            SequenceLabel: "3",
                            AccountName: "Kroger 000598",
                            TimeSpan: "06:58 ~ 08:42",
                            DriveTime: "12 min",
                            Mileage: "2 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 49
                        }, {
                            SequenceOrder: 3,
                            SequenceLabel: "P",
                            AccountName: "Walmart Sc 002883",
                            TimeSpan: "08:55 ~ ",
                            DriveTime: "13 min",
                            Mileage: "8 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 48
                        }, {
                            SequenceOrder: 2001,
                            SequenceLabel: "1",
                            AccountName: "Albertsons 004234",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2002,
                            SequenceLabel: "2",
                            AccountName: "Tom Thumb 002595",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2003,
                            SequenceLabel: "3",
                            AccountName: "Walmart Sc 002883",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2004,
                            SequenceLabel: "4",
                            AccountName: "Albertsons 004198",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2005,
                            SequenceLabel: "5",
                            AccountName: "Walmart Nm 002995",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2006,
                            SequenceLabel: "6",
                            AccountName: "Tom Thumb 002595",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }, {
                    GSN: "LOPSX019",
                    LastName: "lopez",
                    FirstName: "salvador",
                    RouteName: "Route#10131",
                    MileageTotalLabel: "29.00 mi",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Started",
                    Stops: [{
                            SequenceOrder: 1,
                            SequenceLabel: "1",
                            AccountName: "Tom Thumb 003641",
                            TimeSpan: "05:18 ~ 07:20",
                            DriveTime: "0 min",
                            Mileage: "0 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 53
                        }, {
                            SequenceOrder: 2,
                            SequenceLabel: "2",
                            AccountName: "Tom Thumb 003637",
                            TimeSpan: "07:28 ~ 09:33",
                            DriveTime: "8 min",
                            Mileage: "5 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 54
                        }, {
                            SequenceOrder: 3,
                            SequenceLabel: "3",
                            AccountName: "Super Target 001775",
                            TimeSpan: "09:46 ~ 10:35",
                            DriveTime: "13 min",
                            Mileage: "17 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 55
                        }, {
                            SequenceOrder: 4,
                            SequenceLabel: "P",
                            AccountName: "Walmart Sc 003482",
                            TimeSpan: "10:46 ~ ",
                            DriveTime: "11 min",
                            Mileage: "7 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 57
                        }, {
                            SequenceOrder: 2004,
                            SequenceLabel: "4",
                            AccountName: "Walmart Sc 003482",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2006,
                            SequenceLabel: "6",
                            AccountName: "Albertsons 004150",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }, {
                    GSN: "MCBKL001",
                    LastName: "McBride",
                    FirstName: "Kenneth",
                    RouteName: "Route#10128",
                    MileageTotalLabel: "30.00 mi",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Started",
                    Stops: [{
                            SequenceOrder: 1,
                            SequenceLabel: "3",
                            AccountName: "Kroger 000568",
                            TimeSpan: "04:37 ~ 05:53",
                            DriveTime: "0 min",
                            Mileage: "0 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 60
                        }, {
                            SequenceOrder: 2,
                            SequenceLabel: "1",
                            AccountName: "Target 000067",
                            TimeSpan: "06:00 ~ 07:03",
                            DriveTime: "7 min",
                            Mileage: "13 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 58
                        }, {
                            SequenceOrder: 3,
                            SequenceLabel: "P",
                            AccountName: "Kroger 000568",
                            TimeSpan: "07:07 ~ ",
                            DriveTime: "4 min",
                            Mileage: "17 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 64
                        }, {
                            SequenceOrder: 2002,
                            SequenceLabel: "2",
                            AccountName: "Walmart Sc 001117",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2004,
                            SequenceLabel: "4",
                            AccountName: "Tom Thumb 001788",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2005,
                            SequenceLabel: "5",
                            AccountName: "Fiesta Mart 000059",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2006,
                            SequenceLabel: "6",
                            AccountName: "Walmart Sc 001117",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }, {
                    GSN: "MCDBX009",
                    LastName: "McDowell",
                    FirstName: "Brian",
                    RouteName: "Route#10129",
                    MileageTotalLabel: "38.00 mi",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Started",
                    Stops: [{
                            SequenceOrder: 1,
                            SequenceLabel: "4",
                            AccountName: "Super Target 002516",
                            TimeSpan: "05:19 ~ 06:04",
                            DriveTime: "0 min",
                            Mileage: "0 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 68
                        }, {
                            SequenceOrder: 2,
                            SequenceLabel: "5",
                            AccountName: "Walmart Sc 002918",
                            TimeSpan: "06:09 ~ 08:24",
                            DriveTime: "5 min",
                            Mileage: "18 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 69
                        }, {
                            SequenceOrder: 3,
                            SequenceLabel: "P",
                            AccountName: "Walmart Nm 003574",
                            TimeSpan: "08:34 ~ ",
                            DriveTime: "10 min",
                            Mileage: "20 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 66
                        }, {
                            SequenceOrder: 2001,
                            SequenceLabel: "1",
                            AccountName: "Target 001231",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2003,
                            SequenceLabel: "3",
                            AccountName: "Walmart Sc 002918",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2004,
                            SequenceLabel: "4",
                            AccountName: "Kroger 000548",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2005,
                            SequenceLabel: "5",
                            AccountName: "Super Target 002516",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2006,
                            SequenceLabel: "6",
                            AccountName: "Walmart Sc 002918",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }, {
                    GSN: "RAYJX513",
                    LastName: "Raymond",
                    FirstName: "Joshua",
                    RouteName: "Route#10137",
                    MileageTotalLabel: "8.00 mi",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Started",
                    Stops: [{
                            SequenceOrder: 1,
                            SequenceLabel: "1",
                            AccountName: "Brookshire's 000079",
                            TimeSpan: "05:22 ~ 06:39",
                            DriveTime: "0 min",
                            Mileage: "0 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 71
                        }, {
                            SequenceOrder: 2,
                            SequenceLabel: "2",
                            AccountName: "Brookshire Brothers 000091",
                            TimeSpan: "06:55 ~ 08:25",
                            DriveTime: "16 min",
                            Mileage: "2 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 72
                        }, {
                            SequenceOrder: 3,
                            SequenceLabel: "P",
                            AccountName: "Walmart Sc 007178",
                            TimeSpan: "08:32 ~ ",
                            DriveTime: "7 min",
                            Mileage: "6 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 74
                        }, {
                            SequenceOrder: 2003,
                            SequenceLabel: "3",
                            AccountName: "Walmart Sc 007178",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2005,
                            SequenceLabel: "5",
                            AccountName: "Albertsons 004198",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2006,
                            SequenceLabel: "6",
                            AccountName: "Albertsons 000296",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }, {
                    GSN: "SOTBX003",
                    LastName: "Soto",
                    FirstName: "Billy",
                    RouteName: "Route#10126",
                    MileageTotalLabel: "",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Pending",
                    Stops: [{
                            SequenceOrder: 2001,
                            SequenceLabel: "1",
                            AccountName: "Walmart Sc 005211",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2002,
                            SequenceLabel: "2",
                            AccountName: "Albertsons 004234",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2003,
                            SequenceLabel: "3",
                            AccountName: "Minyards Sun Fresh 000073",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2004,
                            SequenceLabel: "4",
                            AccountName: "Walmart Sc 005211",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2005,
                            SequenceLabel: "5",
                            AccountName: "H-E-B Central Market 000546",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }, {
                    GSN: "TATWD001",
                    LastName: "tatum",
                    FirstName: "willie",
                    RouteName: "Route#10135",
                    MileageTotalLabel: "43.00 mi",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Started",
                    Stops: [{
                            SequenceOrder: 1,
                            SequenceLabel: "1",
                            AccountName: "Kroger 000581",
                            TimeSpan: "05:14 ~ 06:02",
                            DriveTime: "0 min",
                            Mileage: "0 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 75
                        }, {
                            SequenceOrder: 2,
                            SequenceLabel: "2",
                            AccountName: "Walmart Nm 005657",
                            TimeSpan: "06:11 ~ 08:44",
                            DriveTime: "9 min",
                            Mileage: "14 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 76
                        }, {
                            SequenceOrder: 3,
                            SequenceLabel: "3",
                            AccountName: "Walmart Nm 004182",
                            TimeSpan: "08:46 ~ 11:12",
                            DriveTime: "2 min",
                            Mileage: "10 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 77
                        }, {
                            SequenceOrder: 4,
                            SequenceLabel: "P",
                            AccountName: "Kroger 000481",
                            TimeSpan: "11:19 ~ ",
                            DriveTime: "7 min",
                            Mileage: "19 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 78
                        }, {
                            SequenceOrder: 2001,
                            SequenceLabel: "1",
                            AccountName: "Walmart Nm 005657",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2002,
                            SequenceLabel: "2",
                            AccountName: "Walmart Nm 004182",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2003,
                            SequenceLabel: "3",
                            AccountName: "Kroger 000481",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2004,
                            SequenceLabel: "4",
                            AccountName: "Kroger 000581",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2005,
                            SequenceLabel: "5",
                            AccountName: "Kroger 000581",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }, {
                    GSN: "WARJX021",
                    LastName: "Warren",
                    FirstName: "Jason",
                    RouteName: "Route#10124",
                    MileageTotalLabel: "29.00 mi",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Started",
                    Stops: [{
                            SequenceOrder: 1,
                            SequenceLabel: "1",
                            AccountName: "Market Street 000561",
                            TimeSpan: "05:26 ~ 08:04",
                            DriveTime: "0 min",
                            Mileage: "0 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 80
                        }, {
                            SequenceOrder: 2,
                            SequenceLabel: "2",
                            AccountName: "Walmart Sc 005311",
                            TimeSpan: "08:09 ~ 09:35",
                            DriveTime: "5 min",
                            Mileage: "6 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 81
                        }, {
                            SequenceOrder: 3,
                            SequenceLabel: "4",
                            AccountName: "Walmart Sc 005311",
                            TimeSpan: "09:42 ~ 11:06",
                            DriveTime: "7 min",
                            Mileage: "4 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 83
                        }, {
                            SequenceOrder: 4,
                            SequenceLabel: "P",
                            AccountName: "Kroger 000561",
                            TimeSpan: "11:18 ~ ",
                            DriveTime: "12 min",
                            Mileage: "19 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 84
                        }, {
                            SequenceOrder: 2003,
                            SequenceLabel: "3",
                            AccountName: "Albertsons 004198",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2006,
                            SequenceLabel: "6",
                            AccountName: "Albertsons 004101",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2007,
                            SequenceLabel: "7",
                            AccountName: "Kroger 000561",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }, {
                    GSN: "WOOTX018",
                    LastName: "Woods ",
                    FirstName: "Tavaris",
                    RouteName: "Route#10136",
                    MileageTotalLabel: "30.00 mi",
                    MilageAdhocLabel: null,
                    TotalTimeLabel: null,
                    RouteStatusLabel: "Started",
                    Stops: [{
                            SequenceOrder: 1,
                            SequenceLabel: "2",
                            AccountName: "Tom Thumb 002554",
                            TimeSpan: "04:44 ~ 05:53",
                            DriveTime: "0 min",
                            Mileage: "0 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 86
                        }, {
                            SequenceOrder: 2,
                            SequenceLabel: "5",
                            AccountName: "H-E-B Central Market 000546",
                            TimeSpan: "06:06 ~ 07:08",
                            DriveTime: "13 min",
                            Mileage: "10 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 89
                        }, {
                            SequenceOrder: 3,
                            SequenceLabel: "1",
                            AccountName: "Kroger 000522",
                            TimeSpan: "07:19 ~ 09:27",
                            DriveTime: "11 min",
                            Mileage: "15 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "Not done",
                            MerchStopID: 85
                        }, {
                            SequenceOrder: 4,
                            SequenceLabel: "6",
                            AccountName: "Walmart Sc 002926",
                            TimeSpan: "09:35 ~ 11:34",
                            DriveTime: "8 min",
                            Mileage: "5 mi",
                            ConnectorType: "Solid",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: 90
                        }, {
                            SequenceOrder: 2003,
                            SequenceLabel: "3",
                            AccountName: "Tom Thumb 003645",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }, {
                            SequenceOrder: 2004,
                            SequenceLabel: "4",
                            AccountName: "Walmart Sc 002926",
                            TimeSpan: "",
                            DriveTime: "",
                            Mileage: "",
                            ConnectorType: "Dash",
                            DisplayBuildStatus: "N/A",
                            MerchStopID: -1
                        }]
                }];
    };
    DispatchComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'dispatch',
            templateUrl: 'dispatch.component.html',
            styleUrls: ['dispatch.component.css'],
            directives: [dispatch_row_1.DispatchRowComponent],
            pipes: [filter_pipe_1.FilterPipe],
            providers: [monitor_service_1.MonitorService, headernav_service_1.HeadernavService]
        }), 
        __metadata('design:paramtypes', [monitor_service_1.MonitorService, headernav_service_1.HeadernavService])
    ], DispatchComponent);
    return DispatchComponent;
}());
exports.DispatchComponent = DispatchComponent;
//# sourceMappingURL=dispatch.component.js.map