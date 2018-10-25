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
var MerchAppConstant_1 = require('../../../app/MerchAppConstant');
var multiselect_dropdown_1 = require('./multiselect-dropdown');
var headernav_service_1 = require('../../services/headernav.service');
var planning_1 = require('../../services/planning');
var spinner_1 = require('../../common/spinner');
var StoreserviceComponent = (function () {
    function StoreserviceComponent(filtersService, config, resource, dispService, navService) {
        this.filtersService = filtersService;
        this.config = config;
        this.resource = resource;
        this.dispService = dispService;
        this.navService = navService;
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
        this.mydayWebAPI = MerchAppConstant_1.MerchConstant.MYDAY_WebAPI_ENDPOINT;
        this.item = new planning_1.MerchGroup();
        this.selectedGeo = [];
        this.showNoDataMessage = false;
        this.imgURLList = [];
        this.readSASDictionary = {};
        this.mySettings = {
            pullRight: false,
            enableSearch: false,
            checkedStyle: 'checkboxes',
            buttonClasses: 'btn btn-default',
            selectionLimit: 10,
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
        this.config.rows = 25;
    }
    StoreserviceComponent.prototype.ngOnInit = function () {
        var _this = this;
        // Set previous week from and to date
        var curr = new Date; // get current date
        var firstday = new Date(curr.setDate(curr.getDate() - curr.getDay() - 7));
        var lastday = new Date(curr.setDate(curr.getDate() - curr.getDay() + 6));
        this.FromDate = firstday.toISOString().split('T')[0];
        this.ToDate = lastday.toISOString().split('T')[0];
        this.subscription = this.navService.navItem$
            .subscribe(function (item) {
            _this.item = item;
            if (_this.item.MerchGroupID) {
                _this.getMerchGroups(_this.item);
                _this.selectedGeo = [];
                _this.selectedGeo[0] = _this.item.MerchGroupID;
                _this.loadData();
            }
        });
    };
    StoreserviceComponent.prototype.getImageDetails = function (imageBlobID) {
        this.imgURLList = [];
        if (imageBlobID) {
            //  //Call WebAPI to get the details
            this.dispService.set(this._webapi + 'api/Merc/GetImageDetailByBlobID/');
            this.imgInput = new MerchReport_1.ImageInput(imageBlobID);
            this.getImageDetailByBlobID(this.imgInput);
        }
        else {
            alert("There is no image.");
        }
    };
    StoreserviceComponent.prototype.getEachImageURL = function () {
        // // Call WebAPI to get list of image URLs
        for (var i = 0; i < this.imgDetail.length; i++) {
            // Call web service to get the URL              
            this.imgURLInput = new MerchReport_1.ImageURLInput(this.imgDetail[i].AbsoluteURL, this.imgDetail[i].ContainerID, this.imgDetail[i].ReadSAS, this.imgDetail[i].IsReadSASValid);
            this.getImageURL(this.imgURLInput);
        }
        this.lgModal.show();
    };
    StoreserviceComponent.prototype.getImageURL = function (inputdata) {
        var _this = this;
        var imageURL;
        if (inputdata.IsReadSASValid == true) {
            imageURL = inputdata.AbsoluteURL + inputdata.ReadSAS;
            this.imgURLList.push(imageURL);
        }
        else {
            if (!this.readSASDictionary[inputdata.ContainerID]) {
                this.dispService.set(this.mydayWebAPI + 'api/Imaging/ExtendContainerReadSAS');
                var extendingReadSASInput = new MerchReport_1.ExtendReadSASInput();
                extendingReadSASInput.ContainerID = inputdata.ContainerID;
                this.dispService.post(JSON.stringify(extendingReadSASInput), true)
                    .subscribe(function (res) {
                    var d = res;
                    // Add image ReadSAS to Dictionary
                    _this.readSASDictionary[inputdata.ContainerID] = d.Response;
                    imageURL = inputdata.AbsoluteURL + _this.readSASDictionary[inputdata.ContainerID];
                    _this.imgURLList.push(imageURL);
                }, function (error) {
                    if (error.status == 401 || error.status == 404) {
                    }
                });
            }
            else {
                imageURL = inputdata.AbsoluteURL + this.readSASDictionary[inputdata.ContainerID];
                this.imgURLList.push(imageURL);
            }
        }
    };
    StoreserviceComponent.prototype.getImageDetailByBlobID = function (inputdata) {
        var _this = this;
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(inputdata), true)
            .subscribe(function (res) {
            var d = res;
            _this.imgDetail = d.Images;
            _this.getEachImageURL();
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    StoreserviceComponent.prototype.stopRefreshing = function () {
        this.isRequesting = false;
    };
    StoreserviceComponent.prototype.optionsUpdated = function ($event) {
        this.selectedGeo = $event;
    };
    StoreserviceComponent.prototype.getMerchGroups = function (itemMerchGroup) {
        this.dispService.set(this._webapi + 'api/Merc/GetUserMerchGroups/');
        this.usrGeo = new MerchReport_1.UserMerchGroupInput(itemMerchGroup.LoggedInUser);
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
        this.storeInput = new MerchReport_1.StoreServiceInput(this.selectedGeo.join(','), new Date(this.FromDate), new Date(this.ToDate));
        this.getAllStoreReport(this.storeInput);
    };
    StoreserviceComponent.prototype.getAllStoreReport = function (inputdata) {
        var _this = this;
        this.dispService.set(this._webapi + 'api/Merc/GetStoreServicedReport/');
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
    __decorate([
        core_1.ViewChild('lgModal'), 
        __metadata('design:type', ng2_bootstrap_1.ModalDirective)
    ], StoreserviceComponent.prototype, "lgModal", void 0);
    StoreserviceComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-storeservice',
            templateUrl: 'storeservice.component.html',
            styleUrls: ['storeservice.component.css'],
            directives: [header_component_1.Header, pagination_component_1.Pagination, global_search_component_1.GlobalSearch, csv_export_component_1.CsvExport, ng2_datepicker_1.DatePicker, common_1.FORM_DIRECTIVES, multiselect_dropdown_1.MultiselectDropdown, ng2_bootstrap_1.MODAL_DIRECTIVES, common_1.CORE_DIRECTIVES, spinner_1.SpinnerComponent],
            providers: [filters_service_1.FiltersService, resource_service_1.ResourceService, config_service_1.ConfigService, dispservice_service_1.DispserviceService, headernav_service_1.HeadernavService],
            viewProviders: [ng2_bootstrap_1.BS_VIEW_PROVIDERS],
            pipes: [header_pipe_1.SearchPipe, pagination_pipe_1.PaginationPipe, global_search_pipe_1.GlobalSearchPipe, NamePipe_1.ChangeNamePipe]
        }), 
        __metadata('design:paramtypes', [filters_service_1.FiltersService, config_service_1.ConfigService, resource_service_1.ResourceService, dispservice_service_1.DispserviceService, headernav_service_1.HeadernavService])
    ], StoreserviceComponent);
    return StoreserviceComponent;
}());
exports.StoreserviceComponent = StoreserviceComponent;
//# sourceMappingURL=storeservice.component.js.map