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
var monitor_popup_1 = require('../monitor-popup');
var monitor_service_1 = require('../../services/monitor.service');
var MerchReport_1 = require('../../reporting/storeservice/MerchReport');
var MerchAppConstant_1 = require('../../../app/MerchAppConstant');
var dispservice_service_1 = require('../../services/dispservice.service');
var RouteItemComponent = (function () {
    function RouteItemComponent(monitorService, dispService) {
        this.monitorService = monitorService;
        this.dispService = dispService;
        this.storeDetails = {
            CheckInTime: " ",
            CheckOutTime: " ",
            UserMileage: 0,
            AtAccountTimeInMinute: 0,
            TimeInStore: " ",
            CasesHandeled: 0,
            CaessInBackroom: 0,
            Comments: " "
        };
        this.storePictures = [];
        this.displayPictures = [];
        this.storeSignature = {
            ManagerName: "Name not available",
            SignatureName: "",
            ClientTime: "",
            ClientTimeZone: "",
            RelativeURL: "",
            AbsoluteURL: "",
            StorageAccount: "",
            Container: "",
            AccessLevel: "",
            ConnectionString: "",
            azureImageURL: ""
        };
        this.mydayWebAPI = MerchAppConstant_1.MerchConstant.MYDAY_WebAPI_ENDPOINT;
    }
    RouteItemComponent.prototype.seprateStoreCode = function () {
        if (this.stop != null) {
            var _accountName = this.stop.AccountName;
            var _lastIndex = _accountName.lastIndexOf(" ");
            var _length = _accountName.length;
            var _accName = _accountName.substring(0, _lastIndex);
            var _accNo = _accountName.substring(_lastIndex, _length);
            this.stop.accName = _accName.trim();
            this.stop.accNo = _accNo.trim();
        }
    };
    RouteItemComponent.prototype.showPopup = function (storeModal, stopMerchStopID) {
        var _this = this;
        if (stopMerchStopID > 0) {
            this.monitorService.getStoreDetailsData(stopMerchStopID)
                .subscribe(function (res) {
                var data = res.json();
                _this.storeDetails = data.Details[0];
                var _sps = data.StorePictures;
                _this.storeSignature = data.StoreSignature[0];
                if (_this.storeSignature != null) {
                    _this.getStoreSignaturePicture(_this.storeSignature);
                }
                if (_sps.length > 0) {
                    _this.getStorePictures(_sps);
                }
                //this.displayPictures = this.getDisplayPictures();
                // (1) here to add display pictures 
                storeModal.show();
            }, function (error) {
                if (error.status == 401 || error.status == 404) {
                }
            });
        }
    };
    RouteItemComponent.prototype.getDisplayPictures = function () {
        var _excPictures = [];
        _excPictures
            = [{
                    'ImageURL': 'contents/img/store3.PNG',
                    'Name': '2016 Dr Pepper Event',
                }, {
                    'ImageURL': 'contents/img/nostoreimage.PNG',
                    'Name': '2016 Dr. Pepper Celebration No Time',
                }, {
                    'ImageURL': 'contents/img/nostoreimage.PNG',
                    'Name': '2016 Canada Dry Celebration No Time',
                },
                {
                    'ImageURL': 'contents/img/nostoreimage.PNG',
                    'Name': '2016 Dr. Pepper Celebration No Time 2',
                }, {
                    'ImageURL': 'contents/img/nostoreimage.PNG',
                    'Name': '2016 Canada Dry Celebration No Time 2',
                },
            ];
        return _excPictures;
    };
    RouteItemComponent.prototype.getStopCSS = function (stop) {
        //[class]="stop.ConnectorType == 'Solid'? 'stop-circle circle-green' : 'stop-circle circle-gray'"
        var css = "stop-circle circle-gray-fill";
        if (stop.ConnectorType.toLowerCase() == 'solid') {
            if (stop.DisplayBuildStatus.toLowerCase() == "not done") {
                css = "stop-circle circle-red-fill";
            }
            else {
                css = "stop-circle circle-green-fill";
            }
        }
        else {
            css = "stop-circle circle-gray-fill";
        }
        return css;
    };
    RouteItemComponent.prototype.getStoreSignaturePicture = function (storeSignature) {
        var _this = this;
        this.dispService.set(this.mydayWebAPI + 'MerchWebAPI/api/Imaging/GetReadOnlyImageURL');
        this.storeSignature.azureImageURL = "";
        var imgURLInput = new MerchReport_1.ImageURLInput(storeSignature.RelativeURL, storeSignature.AbsoluteURL, storeSignature.Container, storeSignature.StorageAccount, storeSignature.AccessLevel, storeSignature.ConnectionString);
        this.dispService.post(JSON.stringify(imgURLInput), true)
            .subscribe(function (res) {
            //  debugger;
            var d = res;
            _this.storeSignature.azureImageURL = d.Response;
        }, function (error) {
            if (error.status == 401 || error.status == 404) { }
        });
    };
    RouteItemComponent.prototype.getStorePictures = function (storePics) {
        var _this = this;
        this.storePictures = [];
        this.dispService.set(this.mydayWebAPI + 'MerchWebAPI/api/Imaging/GetReadOnlyImageURL');
        var _loop_1 = function(i) {
            var imgURLInput = new MerchReport_1.ImageURLInput(storePics[i].RelativeURL, storePics[i].AbsoluteURL, storePics[i].Container, storePics[i].StorageAccount, storePics[i].AccessLevel, storePics[i].ConnectionString);
            this_1.dispService.post(JSON.stringify(imgURLInput), true)
                .subscribe(function (res) {
                //debugger;
                var d = res;
                _this.storePictures.push({
                    'ImageURL': d.Response,
                    'Name': storePics[i].Caption
                });
            }, function (error) {
                if (error.status == 401 || error.status == 404) { }
            });
        };
        var this_1 = this;
        for (var i = 0; i < storePics.length; i++) {
            _loop_1(i);
        }
    };
    RouteItemComponent.prototype.getImageURL = function (inputdata) {
        //  debugger;
        var azureImgURL = "";
        this.dispService.set(this.mydayWebAPI + 'MerchWebAPI/api/Imaging/GetReadOnlyImageURL');
        this.dispService.post(JSON.stringify(inputdata), true)
            .subscribe(function (res) {
            //  debugger;
            var d = res;
            // Add image URL in imageList
            azureImgURL = d.Response;
        }, function (error) {
            //   debugger;
            if (error.status == 401 || error.status == 404) { }
        });
        return azureImgURL;
    };
    RouteItemComponent.prototype.ngOnInit = function () {
        this.seprateStoreCode();
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], RouteItemComponent.prototype, "stop", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Number)
    ], RouteItemComponent.prototype, "idx", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Number)
    ], RouteItemComponent.prototype, "count", void 0);
    RouteItemComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'route-item',
            templateUrl: 'route-item.component.html',
            styleUrls: ['route-item.component.css'],
            directives: [ng2_bootstrap_1.MODAL_DIRECTIVES, common_1.CORE_DIRECTIVES, monitor_popup_1.MonitorPopupComponent],
            viewProviders: [ng2_bootstrap_1.BS_VIEW_PROVIDERS],
            providers: [monitor_service_1.MonitorService, dispservice_service_1.DispserviceService]
        }), 
        __metadata('design:paramtypes', [monitor_service_1.MonitorService, dispservice_service_1.DispserviceService])
    ], RouteItemComponent);
    return RouteItemComponent;
}());
exports.RouteItemComponent = RouteItemComponent;
//# sourceMappingURL=route-item.component.js.map