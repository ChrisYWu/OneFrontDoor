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
var ImageCaption = (function () {
    function ImageCaption(orginalText) {
        var n = 25;
        if (orginalText.length > 25) {
            this.Name1 = orginalText.substring(0, 24);
            this.Name2 = orginalText.substring(24, orginalText.length + 1);
        }
        else {
            this.Name1 = orginalText;
            this.Name2 = " ";
        }
    }
    return ImageCaption;
}());
exports.ImageCaption = ImageCaption;
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
        this.readSASDictionary = {};
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
                if (data.StoreSignature[0] != null || data.StoreSignature[0] != undefined) {
                    _this.storeSignature = data.StoreSignature[0];
                    if (_this.storeSignature != null) {
                        _this.getStoreSignaturePicture(_this.storeSignature);
                    }
                }
                if (data.StorePictures != null || data.StorePictures != undefined) {
                    var _sps = data.StorePictures;
                    if (_sps.length > 0) {
                        _this.getStorePictures(_sps);
                    }
                }
                if (data.BuildExecution != null || data.BuildExecution != undefined) {
                    if (data.BuildExecution.length > 0) {
                        _this.getBuildExecution(data.BuildExecution);
                    }
                }
                //here to add display pictures -- this.displayPictures = this.getDisplayPictures();  
                //below change implement latter on, once all senario check at local data, currently no data for all senarios 
                //  if(isStoreSignature && isStorePictures )
                //  {
                //   storeModal.show();
                //  }
                storeModal.show();
            }, function (error) {
                if (error.status == 401 || error.status == 404) {
                }
            });
        }
    };
    /*
      getDisplayPictures() {
        let _excPictures: any = []
    
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
          ]
    
        return _excPictures;
      }
      */
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
        if (storeSignature.IsReadSASValid) {
            this.storeSignature.azureImageURL = storeSignature.AbsoluteURL + storeSignature.ReadSAS;
        }
        else {
            if (!this.readSASDictionary[storeSignature.ContainerID]) {
                this.dispService.set(this.mydayWebAPI + 'api/Imaging/ExtendContainerReadSAS');
                var extendingReadSASInput = new MerchReport_1.ExtendReadSASInput();
                extendingReadSASInput.ContainerID = storeSignature.ContainerID;
                this.dispService.post(JSON.stringify(extendingReadSASInput), true)
                    .subscribe(function (res) {
                    var d = res;
                    // Add image ReadSAS to Dictionary
                    _this.readSASDictionary[storeSignature.ContainerID] = d.Response;
                    _this.storeSignature.azureImageURL = storeSignature.AbsoluteURL + _this.readSASDictionary[storeSignature.ContainerID];
                }, function (error) {
                    if (error.status == 401 || error.status == 404) {
                    }
                });
            }
            else {
                this.storeSignature.azureImageURL = storeSignature.AbsoluteURL + this.readSASDictionary[storeSignature.ContainerID];
            }
        }
    };
    RouteItemComponent.prototype.getStorePictures = function (storePics) {
        var _this = this;
        this.storePictures = [];
        var _loop_1 = function(i) {
            cap = new ImageCaption(storePics[i].Caption);
            if (storePics[i].IsReadSASValid) {
                this_1.storePictures.push({
                    'ImageURL': storePics[i].AbsoluteURL + storePics[i].ReadSAS,
                    'Name1': cap.Name1,
                    'Name2': cap.Name2
                });
            }
            else {
                if (!this_1.readSASDictionary[storePics[i].ContainerID]) {
                    this_1.dispService.set(this_1.mydayWebAPI + 'api/Imaging/ExtendContainerReadSAS');
                    extendingReadSASInput = new MerchReport_1.ExtendReadSASInput();
                    extendingReadSASInput.ContainerID = storePics[i].ContainerID;
                    this_1.dispService.post(JSON.stringify(extendingReadSASInput), true)
                        .subscribe(function (res) {
                        var d = res;
                        // Add image ReadSAS to Dictionary
                        _this.readSASDictionary[storePics[i].ContainerID] = d.Response;
                        var imageURL = storePics[i].AbsoluteURL + _this.readSASDictionary[storePics[i].ContainerID];
                        _this.storePictures.push({
                            'ImageURL': imageURL,
                            'Name1': cap.Name1,
                            'Name2': cap.Name2
                        });
                    }, function (error) {
                        if (error.status == 401 || error.status == 404) {
                        }
                    });
                }
                else {
                    imageURL = storePics[i].AbsoluteURL + this_1.readSASDictionary[storePics[i].ContainerID];
                    this_1.storePictures.push({
                        'ImageURL': imageURL,
                        'Name1': cap.Name1,
                        'Name2': cap.Name2
                    });
                }
            }
        };
        var this_1 = this;
        var cap, extendingReadSASInput, imageURL;
        for (var i = 0; i < storePics.length; i++) {
            _loop_1(i);
        }
    };
    RouteItemComponent.prototype.getBuildExecution = function (builds) {
        var _this = this;
        this.displayPictures = [];
        var _loop_2 = function(i) {
            cap = new ImageCaption(builds[i].PromotionName);
            if (builds[i].IsReadSASValid) {
                this_2.displayPictures.push({
                    'ImageURL': builds[i].AbsoluteURL + builds[i].ReadSAS,
                    'Name1': cap.Name1,
                    'Name2': cap.Name2
                });
            }
            else {
                if (!this_2.readSASDictionary[builds[i].ContainerID]) {
                    this_2.dispService.set(this_2.mydayWebAPI + 'api/Imaging/ExtendContainerReadSAS');
                    extendingReadSASInput = new MerchReport_1.ExtendReadSASInput();
                    extendingReadSASInput.ContainerID = builds[i].ContainerID;
                    this_2.dispService.post(JSON.stringify(extendingReadSASInput), true)
                        .subscribe(function (res) {
                        var d = res;
                        // Add image ReadSAS to Dictionary
                        _this.readSASDictionary[builds[i].ContainerID] = d.Response;
                        var imageURL = builds[i].AbsoluteURL + _this.readSASDictionary[builds[i].ContainerID];
                        _this.displayPictures.push({
                            'ImageURL': imageURL,
                            'Name1': cap.Name1,
                            'Name2': cap.Name2
                        });
                    }, function (error) {
                        if (error.status == 401 || error.status == 404) {
                        }
                    });
                }
                else {
                    imageURL = builds[i].AbsoluteURL + this_2.readSASDictionary[builds[i].ContainerID];
                    this_2.displayPictures.push({
                        'ImageURL': imageURL,
                        'Name1': cap.Name1,
                        'Name2': cap.Name2
                    });
                }
            }
        };
        var this_2 = this;
        var cap, extendingReadSASInput, imageURL;
        for (var i = 0; i < builds.length; i++) {
            _loop_2(i);
        }
    };
    RouteItemComponent.prototype.getImageURL = function (inputdata) {
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