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
var dispservice_service_1 = require('../../services/dispservice.service');
var ng2_auto_complete_1 = require('ng2-auto-complete');
var filter_pipe_1 = require('../../pipes/filter.pipe');
var mask_directive_1 = require('../../directives/mask.directive');
var planning_1 = require('../../services/planning');
var common_1 = require('@angular/common');
var forms_1 = require('@angular/forms');
require('rxjs/Rx');
var MerchAppConstant_1 = require('../../../app/MerchAppConstant');
var headernav_service_1 = require('../../services/headernav.service');
var async_validator_service_1 = require('../../services/async-validator.service');
var spinner_1 = require('../../common/spinner');
var CreateMerchGroupComponent = (function () {
    function CreateMerchGroupComponent(dispService, formbuilder, navService, elementRef, lookupService) {
        this.dispService = dispService;
        this.navService = navService;
        this.lookupService = lookupService;
        //Initalize 
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT; //'http://localhost:8888/';
        this.dbtempRoutes = [];
        this.selectedIdx = 0;
        this.groupAreaDisplay = false;
        this.routeAreaDisplay = false;
        this.disabled = false;
        this.IsEditRoute = false;
        this.active = true;
        this.submitted = false;
        this.IsGroupNameExists = false;
        this.IsRouteNameExists = false;
        this.spanGroupName = true;
        this.IsOwnerValid = true;
        this.ShowSaveMsg = false;
        this.item = new planning_1.MerchGroup();
        this.isLoading = false;
        this.GetADUsers = this._webapi + 'api/Merc/GetUserDetails/:keyword';
        this.delay = (function () {
            var timer = 0;
            return function (callback, ms) {
                clearTimeout(timer);
                timer = setTimeout(callback, ms);
            };
        })();
        this.form = formbuilder.group({
            groupName: ['', common_1.Validators.compose([common_1.Validators.required, common_1.Validators.maxLength(50)])],
            route_name: [],
            owner: ['', common_1.Validators.required]
        });
        this.el = elementRef.nativeElement;
        this.initalize();
    }
    CreateMerchGroupComponent.prototype.onspanEditGroupName = function () {
        if (this.spanGroupName)
            this.spanGroupName = false;
        else
            this.spanGroupName = true;
    };
    CreateMerchGroupComponent.prototype.onAddGroupSelect = function () {
        this.initalize();
        this.groupAreaDisplay = true;
        this.spanGroupName = false;
        this.routeAreaDisplay = false;
        if (this.merchGroupData != null) {
            var count = this.merchGroupData.length;
            this.selectedIdx = count;
        }
    };
    CreateMerchGroupComponent.prototype.onAddRouteSelect = function () {
        if (this.routeAreaDisplay)
            this.routeAreaDisplay = false;
        else
            this.routeAreaDisplay = true;
    };
    CreateMerchGroupComponent.prototype.onGroupSelect = function (groupID, idx) {
        this.selectedIdx = idx;
        this.initalize();
        var detailInput = new planning_1.MerchGroupDetailInput(this.item.SAPBranchID, groupID);
        this.getMerchGroupDetail(detailInput);
        this.groupAreaDisplay = true;
        this.routeAreaDisplay = false;
    };
    CreateMerchGroupComponent.prototype.onAddRouteSave = function () {
        var route = new planning_1.MerchGroupRoute();
        route.RouteName = this.routeName;
        route.CanUserDelete = true;
        this.merchGroupDetail.Routes.push(route);
        //this.route_data.push(route);  
        this.routeAreaDisplay = false;
        this.routeName = '';
    };
    CreateMerchGroupComponent.prototype.onEditRoute = function (route, index) {
        for (var n = 0; n < this.merchGroupDetail.Routes.length; n++) {
            if (index == n) {
                this.merchGroupDetail.Routes[n].IsEditRoute = true;
            }
            else
                this.merchGroupDetail.Routes[n].IsEditRoute = false;
        }
    };
    CreateMerchGroupComponent.prototype.onRouteDelete = function (route, index) {
        for (var n = 0; n < this.merchGroupDetail.Routes.length; n++) {
            if (n == index) {
                if (this.merchGroupDetail.Routes[n].RouteID == route.RouteID && route.RouteID != null && route.CanUserDelete) {
                    this.merchGroupDetail.Routes[n].IsRouteDeleted = true;
                    break;
                }
                else if (this.merchGroupDetail.Routes[n].RouteName == route.RouteName && route.RouteID == null) {
                    this.merchGroupDetail.Routes[n].IsRouteDeleted = true;
                    break;
                }
                else {
                    alert('The route cannot be deleted ');
                    break;
                }
            }
        }
        this.merchGroupDetail.Routes = this.merchGroupDetail.Routes.filter(function (route) {
            if (route.IsRouteDeleted != true) {
                return route;
            }
        });
    };
    CreateMerchGroupComponent.prototype.onMerchGroupDelete = function (group) {
        if (group.CanUserDelete) {
            var input = new planning_1.MerchGroupInput(this.item.SAPBranchID, group.MerchGroupID, '', '', '', '', []);
            this.deleteMerchGroupByID(input);
        }
        else {
            alert('The group cannot be deleted ');
        }
    };
    CreateMerchGroupComponent.prototype.onMerchGroupSave = function () {
        this.submitted = true;
        this.ShowSaveMsg = false;
        if (this.ValidationsCheck()) {
            var userdetail = this.model4;
            if (this.model4.sAMAccountName != undefined && this.model4.DisplayName != undefined) {
                this.merchGroupDetail.DefaultOwnerGSN = this.model4.sAMAccountName;
                this.merchGroupDetail.DefaultOwnerName = this.model4.DisplayName;
            }
            this.merchGroupInput = new planning_1.MerchGroupInput(this.item.SAPBranchID, this.merchGroupDetail.MerchGroupID, this.merchGroupDetail.GroupName, this.merchGroupDetail.DefaultOwnerGSN, this.merchGroupDetail.DefaultOwnerName, this.item.LoggedInUser, this.merchGroupDetail.Routes);
            this.insertMerchGroupData(this.merchGroupInput);
        }
    };
    CreateMerchGroupComponent.prototype.validateAsyncGroupName = function () {
        if (this.merchGroupDetail.GroupName != this.dbGroupDetail.GroupName) {
            this.inputGrpEl.focus();
            this.validateAsyncExistingGroupName();
        }
        else
            this.IsGroupNameExists = false;
    };
    CreateMerchGroupComponent.prototype.validateAsyncGroupInDelay = function () {
        var _this = this;
        var delayMs = 500;
        //executing after user stopped typing
        this.delay(function () { return _this.validateAsyncExistingGroupName(); }, delayMs);
    };
    CreateMerchGroupComponent.prototype.validateAsyncExistingGroupName = function () {
        var _this = this;
        var URL = this._webapi + 'api/Merc/ValidateExistingMerchGroupDetails/' + this.item.SAPBranchID + '/Group/' + this.merchGroupDetail.GroupName;
        if (this.merchGroupDetail.GroupName.length != 0 && this.merchGroupDetail.GroupName != this.dbGroupDetail.GroupName) {
            this.isLoading = true;
            this.lookupService.sourceUrl = URL;
            this.lookupService.getRemoteData()
                .subscribe(function (resp) {
                _this.IsGroupNameExists = resp.IsGroupNameExists;
            }, function (error) { return null; }, function () { return _this.isLoading = false; } //complete
             //complete
            );
        }
        else {
            this.IsGroupNameExists = false;
        }
    };
    CreateMerchGroupComponent.prototype.checkExistingRouteList = function () {
        var _this = this;
        var result = false;
        if (this.routeName.length != 0) {
            this.merchGroupDetail.Routes.find(function (route) {
                if (route.RouteName == _this.routeName) {
                    return result = true;
                }
            });
        }
        return result;
    };
    CreateMerchGroupComponent.prototype.validateAsyncRouteName = function () {
        if (this.routeName.length != 0 && this.checkExistingRouteList()) {
            this.IsRouteNameExists = true;
        }
        else if (this.routeName.length == 0) {
            this.IsRouteNameExists = false;
        }
        else {
            // this.inputRouteEl.focus();
            this.validateAsyncExistingRouteName();
        }
    };
    CreateMerchGroupComponent.prototype.validateAsyncRouteInDelay = function () {
        var _this = this;
        var delayMs = 500;
        //executing after user stopped typing
        this.delay(function () { return _this.validateAsyncRouteName(); }, delayMs);
    };
    CreateMerchGroupComponent.prototype.validateAsyncExistingRouteName = function () {
        var _this = this;
        var URL = this._webapi + 'api/Merc/ValidateExistingMerchGroupDetails/' + this.item.SAPBranchID + '/Route/' + this.routeName;
        if (this.routeName.length != 0) {
            this.isLoading = true;
            this.lookupService.sourceUrl = URL;
            this.lookupService.getRemoteData()
                .subscribe(function (resp) {
                _this.IsRouteNameExists = resp.IsRouteNameExists;
            }, function (error) { return null; }, function () { return _this.isLoading = false; } //complete
             //complete
            );
        }
    };
    CreateMerchGroupComponent.prototype.addRouteToList = function () {
        if (!this.IsRouteNameExists && this.routeName.length != 0)
            this.onAddRouteSave();
    };
    //  Edit RouteName from the route List
    CreateMerchGroupComponent.prototype.validateAsyncEditRouteName = function (route, i) {
        var result = false;
        if (route.RouteName.length != 0) {
            route.IsRequired = false;
            for (var n = 0; n < this.merchGroupDetail.Routes.length; n++) {
                if (n != i) {
                    if (this.merchGroupDetail.Routes[n].RouteName == route.RouteName) {
                        route.IsRouteNameExists = true;
                        break;
                    }
                }
                else {
                    route.IsRouteNameExists = false;
                }
            }
            var flag;
            var rName = '';
            flag = this.merchGroupDetail.Routes.filter(function (r) {
                if (r.IsRouteNameExists) {
                    return r;
                }
            });
            var rList = this.dbGroupDetailRoutes.filter(function (d) {
                if (route.RouteID == d.RouteID)
                    return d;
            });
            if (route.RouteID != null) {
                if (rList.length > 0)
                    rName = rList[0].RouteName;
            }
            if (flag.length == 0 && rName != route.RouteName && route.RouteID != null) {
                this.validateAsyncExistingEditRouteName(route);
            }
            else if (flag.length == 0 && route.RouteID == null) {
                this.validateAsyncExistingEditRouteName(route);
            }
        }
        else {
            route.IsRouteNameExists = false;
            route.IsRequired = true;
        }
    };
    CreateMerchGroupComponent.prototype.validateAsyncEditRouteInDelay = function (route, i) {
        var _this = this;
        var delayMs = 500;
        //executing after user stopped typing
        this.delay(function () { return _this.validateAsyncEditRouteName(route, i); }, delayMs);
    };
    CreateMerchGroupComponent.prototype.validateAsyncExistingEditRouteName = function (route) {
        var _this = this;
        var URL = this._webapi + 'api/Merc/ValidateExistingMerchGroupDetails/' + this.item.SAPBranchID + '/Route/' + route.RouteName;
        if (route.RouteName.length != 0) {
            this.isLoading = true;
            this.lookupService.sourceUrl = URL;
            this.lookupService.getRemoteData()
                .subscribe(function (resp) {
                var d = resp;
                if (d.IsRouteNameExists) {
                    route.IsRouteNameExists = true;
                }
                else {
                    route.IsRouteNameExists = false;
                }
            }, function (error) { return null; }, function () { return _this.isLoading = false; } //complete
             //complete
            );
        }
        else {
            route.IsRouteNameExists = false;
        }
    };
    CreateMerchGroupComponent.prototype.onMerchGroupCancel = function () {
        if (this.merchGroupData.length > 0) {
            var detailInput = new planning_1.MerchGroupDetailInput(this.item.SAPBranchID, this.merchGroupData[0].MerchGroupID);
            this.getMerchGroupDetail(detailInput);
            this.ShowSaveMsg = false;
            if (this.merchGroupData != null) {
                this.selectedIdx = 0;
                this.spanGroupName = true;
            }
        }
        else {
            this.groupAreaDisplay = false;
        }
    };
    CreateMerchGroupComponent.prototype.ValidationsCheck = function () {
        var flag;
        var reqList;
        flag = this.merchGroupDetail.Routes.filter(function (r) {
            if (r.IsRouteNameExists) {
                return r;
            }
        });
        reqList = this.merchGroupDetail.Routes.filter(function (r) {
            if (r.IsRequired) {
                return r;
            }
        });
        if (this.IsGroupNameExists || this.IsRouteNameExists || flag.length > 0 || reqList.length > 0 || !this.form.valid) {
            return false;
        }
        else
            return true;
    };
    CreateMerchGroupComponent.prototype.stopRefreshing = function () {
        this.isRequesting = false;
    };
    CreateMerchGroupComponent.prototype.initalize = function () {
        var _this = this;
        this.dbGroupDetail = new planning_1.MerchGroupDetail();
        this.merchGroupDetail = new planning_1.MerchGroupDetail();
        this.merchGroupDetail.MerchGroupID = 0;
        this.dbGroupDetail.Routes = [];
        this.merchGroupDetail.Routes = [];
        //this.route_data = [];
        this.routeName = '';
        this.active = false;
        setTimeout(function () { return _this.active = true; }, 0);
        this.IsGroupNameExists = false;
        this.IsRouteNameExists = false;
        this.model4 = '';
        this.submitted = false;
        this.IsOwnerValid = true;
        this.spanGroupName = true;
        this.dbtempRoutes = [];
        this.ShowSaveMsg = false;
        this.routeAreaDisplay = false;
    };
    CreateMerchGroupComponent.prototype.setAddedGroupIndexInList = function (merchGroupID) {
        for (var i = 0; i < this.merchGroupData.length; i++) {
            if (this.merchGroupData[i]["MerchGroupID"] == merchGroupID) {
                this.selectedIdx = i;
                break;
            }
        }
    };
    CreateMerchGroupComponent.prototype.insertMerchGroupData = function (input) {
        var _this = this;
        this.isRequesting = true;
        this.dispService.set(this._webapi + 'api/Merc/InsertUpdateMerchGroupDetails/');
        this.dispService.post(JSON.stringify(input))
            .subscribe(function (res) {
            var data = res;
            //   this.groupAreaDisplay = false;
            if (data.ReturnStatus == 1) {
                _this.ShowSaveMsg = true;
                _this.getMerchGroups();
                if (_this.merchGroupDetail.MerchGroupID == 0) {
                    _this.merchGroupDetail.MerchGroupID = data.NewGroupID;
                    var merchItem = new planning_1.MerchGroup();
                    merchItem.MerchGroupID = data.NewGroupID;
                    merchItem.GroupName = input.GroupName;
                    merchItem.SAPBranchID = input.SAPBranchID;
                    if (_this.item.LoggedInUser == _this.merchGroupDetail.DefaultOwnerGSN)
                        merchItem.IsDefault = true;
                    else
                        merchItem.IsDefault = false;
                    _this.navService.changeToaddMerchGroup(merchItem);
                }
                // Refresh inserted data
                var detailInput = new planning_1.MerchGroupDetailInput(_this.item.SAPBranchID, _this.merchGroupDetail.MerchGroupID);
                _this.getMerchGroupDetail(detailInput);
            }
            else
                _this.ShowSaveMsg = false;
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    CreateMerchGroupComponent.prototype.getmerchgroupContainer = function () {
        var _this = this;
        var merchgroupsInput = new planning_1.MerchGroupsInput(this.item.SAPBranchID);
        this.isRequesting = true;
        this.dispService.set(this._webapi + 'api/Merc/GetMerchGroupDetailsByBranchID/');
        this.dispService.post(JSON.stringify(merchgroupsInput), true)
            .subscribe(function (res) {
            var d = res;
            _this.merchGroupData = d.MerchGroupList;
            _this.groupAreaDisplay = true;
            if (_this.merchGroupData.length > 0) {
                var detailInput = new planning_1.MerchGroupDetailInput(_this.item.SAPBranchID, _this.merchGroupData[0].MerchGroupID);
                _this.getMerchGroupDetail(detailInput);
                _this.selectedIdx = 0;
            }
            else {
                _this.groupAreaDisplay = false;
            }
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    CreateMerchGroupComponent.prototype.getMerchGroups = function () {
        var _this = this;
        var merchgroupsInput = new planning_1.MerchGroupsInput(this.item.SAPBranchID);
        this.isRequesting = true;
        this.dispService.set(this._webapi + 'api/Merc/GetMerchGroupDetailsByBranchID/');
        this.dispService.post(JSON.stringify(merchgroupsInput), true)
            .subscribe(function (res) {
            var d = res;
            _this.merchGroupData = d.MerchGroupList;
            _this.setAddedGroupIndexInList(_this.merchGroupDetail.MerchGroupID);
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    CreateMerchGroupComponent.prototype.getMerchGroupDetail = function (detailInput) {
        var _this = this;
        this.dispService.set(this._webapi + 'api/Merc/GetMerchGroupDetailsByGroupID/');
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(detailInput), true)
            .subscribe(function (res) {
            var d = res;
            _this.dbGroupDetail = Object.assign({}, d);
            _this.merchGroupDetail = d;
            _this.dbGroupDetailRoutes = [];
            for (var i = 0; i < d.Routes.length; i++) {
                var item = {};
                item.RouteID = _this.merchGroupDetail.Routes[i].RouteID;
                item.RouteName = _this.merchGroupDetail.Routes[i].RouteName;
                _this.dbGroupDetailRoutes.push(item);
            }
            var userdetail;
            userdetail = new planning_1.User();
            userdetail.DisplayName = _this.merchGroupDetail.DefaultOwnerName;
            userdetail.sAMAccountName = _this.merchGroupDetail.DefaultOwnerGSN;
            _this.model4 = _this.merchGroupDetail.DefaultOwnerName;
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    CreateMerchGroupComponent.prototype.deleteMerchGroupByID = function (input) {
        var _this = this;
        this.dispService.set(this._webapi + 'api/Merc/DeleteMerchGroup/');
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(input), true)
            .subscribe(function (res) {
            var d = res;
            _this.getMerchGroups();
            var detailInput = new planning_1.MerchGroupDetailInput(_this.item.SAPBranchID, _this.merchGroupData[0].MerchGroupID);
            _this.getMerchGroupDetail(detailInput);
            _this.ShowSaveMsg = false;
            _this.selectedIdx = 1;
        }, function () { return _this.stopRefreshing(); }, function () { return _this.stopRefreshing(); });
    };
    CreateMerchGroupComponent.prototype.ngOnInit = function () {
        var _this = this;
        //Subscribe
        this.subscription = this.navService.navItem$.subscribe(function (item) { _this.item = item; _this.loadmerchGroupData(item); });
    };
    CreateMerchGroupComponent.prototype.ngOnDestroy = function () {
        // prevent memory leak when component is destroyed
        this.subscription.unsubscribe();
    };
    CreateMerchGroupComponent.prototype.loadmerchGroupData = function (item) {
        this.item = item;
        this.initalize();
        if (this.item != null || this.item != undefined)
            this.getmerchgroupContainer();
    };
    CreateMerchGroupComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-create-merch-group',
            templateUrl: 'create-merch-group.component.html',
            styleUrls: ['create-merch-group.component.css'],
            directives: [mask_directive_1.MaskDirective, common_1.CORE_DIRECTIVES, forms_1.FORM_DIRECTIVES,
                forms_1.REACTIVE_FORM_DIRECTIVES, ng2_auto_complete_1.AutoCompleteComponent, ng2_auto_complete_1.AutoCompleteDirective, spinner_1.SpinnerComponent],
            providers: [dispservice_service_1.DispserviceService, headernav_service_1.HeadernavService, async_validator_service_1.AsyncValidatorService],
            pipes: [filter_pipe_1.FilterPipe],
        }), 
        __metadata('design:paramtypes', [dispservice_service_1.DispserviceService, common_1.FormBuilder, headernav_service_1.HeadernavService, core_1.ElementRef, async_validator_service_1.AsyncValidatorService])
    ], CreateMerchGroupComponent);
    return CreateMerchGroupComponent;
}());
exports.CreateMerchGroupComponent = CreateMerchGroupComponent;
//# sourceMappingURL=create-merch-group.component.js.map