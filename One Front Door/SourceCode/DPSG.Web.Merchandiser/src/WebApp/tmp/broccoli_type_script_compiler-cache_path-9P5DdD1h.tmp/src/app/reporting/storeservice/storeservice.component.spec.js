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
var dispservice_service_1 = require('../../services/dispservice.service');
var MerchReport_1 = require('./MerchReport');
var header_pipe_1 = require("ng2-easy-table/app/pipes/header-pipe");
var pagination_pipe_1 = require("ng2-easy-table/app/pipes/pagination-pipe");
var global_search_pipe_1 = require("ng2-easy-table/app/pipes/global-search-pipe");
var filters_service_1 = require("ng2-easy-table/app/services/filters-service");
var config_service_1 = require("ng2-easy-table/app/services/config-service");
var resource_service_1 = require("ng2-easy-table/app/services/resource-service");
var global_search_component_1 = require("ng2-easy-table/app/components/global-search/global-search.component");
var csv_export_component_1 = require("ng2-easy-table/app/components/dropdown/csv-export.component");
var header_component_1 = require("ng2-easy-table/app/components/header/header.component");
var pagination_component_1 = require("ng2-easy-table/app/components/pagination/pagination.component");
var ng2_datepicker_1 = require('ng2-datepicker/ng2-datepicker');
var NamePipe_1 = require('./NamePipe');
var multiselect_dropdown_1 = require('./multiselect-dropdown');
var StoreserviceComponent = (function () {
    function StoreserviceComponent(filtersService, config, resource, dispService) {
        this.filtersService = filtersService;
        this.config = config;
        this.resource = resource;
        this.dispService = dispService;
        this._webapi = 'http://merchandiser/';
        this.selectedGeo = [];
        this.showNoDataMessage = false;
        this.mySettings = {
            pullRight: false,
            enableSearch: false,
            checkedStyle: 'checkboxes',
            buttonClasses: 'btn btn-default',
            selectionLimit: 5,
            closeOnSelect: false,
            showCheckAll: false,
            showUncheckAll: false,
            dynamicTitleMaxItems: 0,
            maxHeight: '300px',
        };
        this.myTexts = {
            checkAll: 'Check all',
            uncheckAll: 'Uncheck all',
            checked: 'checked',
            checkedPlural: 'checked',
            searchPlaceholder: 'Search...',
            defaultTitle: 'Select Groups',
        };
        this.numberOfItems = 1;
    }
    StoreserviceComponent.prototype.ngOnInit = function () {
        // Set previous week from and to date
        var curr = new Date; // get current date
        var first = curr.getDate() - curr.getDay(); // First day is the day of the month - the day of the week
        var last = first + 6; // last day is the first day + 6
        this.FromDate = new Date(curr.setDate(first - 7)).toISOString().split('T')[0];
        this.ToDate = new Date(curr.setDate(last - 7)).toISOString().split('T')[0];
        // Assign default user merch Group
        this.selectedGeo[0] = 101;
        this.getMerchGroups();
        this.loadData();
    };
    StoreserviceComponent.prototype.optionsUpdated = function ($event) {
        this.selectedGeo = $event;
    };
    StoreserviceComponent.prototype.getMerchGroups = function () {
        this.dispService.set(this._webapi + 'api/Merc/GetUserMerchGroups/');
        this.usrGeo = new MerchReport_1.UserMerchGroupInput('AGYAX003');
        this.getUserMerchGroups(this.usrGeo);
    };
    StoreserviceComponent.prototype.getUserMerchGroups = function (inputdata) {
        var _this = this;
        this.dispService.post(JSON.stringify(inputdata), true)
            .subscribe(function (res) {
            var d = res;
            _this.usrAllGeo = d.UserMerchGroups;
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    StoreserviceComponent.prototype.loadData = function () {
        this.dispService.set(this._webapi + 'api/Merc/GetStoreServicedReport/');
        this.storeInput = new MerchReport_1.StoreServiceInput(this.selectedGeo.join(','), new Date(this.FromDate), new Date(this.ToDate));
        this.getAllStoreReport(this.storeInput);
    };
    StoreserviceComponent.prototype.getAllStoreReport = function (inputdata) {
        var _this = this;
        this.dispService.post(JSON.stringify(inputdata), true)
            .subscribe(function (res) {
            var d = res;
            _this.reportdata = d.StoreServices;
            _this.numberOfItems = d.StoreServices.length;
            if (d.StoreServices.length > 0) {
                _this.showNoDataMessage = false;
                _this.keys = Object.keys(d.StoreServices[0]);
                _this.resource.keys = _this.keys;
            }
            else {
                _this.showNoDataMessage = true;
            }
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    StoreserviceComponent.prototype.FilterReportData = function () {
        if (this.ToDate < this.FromDate) {
            alert("To Date cannot be less than From Date.");
            return;
        }
        else if (this.selectedGeo.length <= 0) {
            alert("Please select Geo.");
            return;
        }
        else if (this.days_between(this.ToDate, this.FromDate) > 31) {
            alert("Date range cannot exceed 31 days.");
            return;
        }
        this.storeInput = new MerchReport_1.StoreServiceInput(this.selectedGeo.join(','), new Date(this.FromDate), new Date(this.ToDate));
        this.getAllStoreReport(this.storeInput);
    };
    StoreserviceComponent.prototype.orderBy = function (key) {
        this.reportdata = this.resource.sortBy(key);
    };
    StoreserviceComponent.prototype.parseDate = function (input) {
        var parts = input.match(/(\d+)/g);
        return new Date(parts[0], parts[1] - 1, parts[2]); // months are 0-based
    };
    StoreserviceComponent.prototype.days_between = function (date1, date2) {
        // The number of milliseconds in one day
        var ONE_DAY = 1000 * 60 * 60 * 24;
        var d1 = this.parseDate(date1);
        var d2 = this.parseDate(date2);
        // Convert both dates to milliseconds
        var date1_ms = d1.getTime();
        var date2_ms = d2.getTime();
        // Calculate the difference in milliseconds
        var difference_ms = Math.abs(date1_ms - date2_ms);
        // Convert back to days and return
        return Math.round(difference_ms / ONE_DAY);
    };
    StoreserviceComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-storeservice',
            templateUrl: 'storeservice.component.html',
            styleUrls: ['storeservice.component.css'],
            directives: [header_component_1.Header, pagination_component_1.Pagination, global_search_component_1.GlobalSearch, csv_export_component_1.CsvExport, ng2_datepicker_1.DatePicker, common_1.FORM_DIRECTIVES, multiselect_dropdown_1.MultiselectDropdown],
            providers: [filters_service_1.FiltersService, resource_service_1.ResourceService, config_service_1.ConfigService, dispservice_service_1.DispserviceService],
            pipes: [header_pipe_1.SearchPipe, pagination_pipe_1.PaginationPipe, global_search_pipe_1.GlobalSearchPipe, NamePipe_1.ChangeNamePipe]
        }), 
        __metadata('design:paramtypes', [filters_service_1.FiltersService, config_service_1.ConfigService, resource_service_1.ResourceService, dispservice_service_1.DispserviceService])
    ], StoreserviceComponent);
    return StoreserviceComponent;
}());
exports.StoreserviceComponent = StoreserviceComponent;
//# sourceMappingURL=storeservice.component.spec.js.map