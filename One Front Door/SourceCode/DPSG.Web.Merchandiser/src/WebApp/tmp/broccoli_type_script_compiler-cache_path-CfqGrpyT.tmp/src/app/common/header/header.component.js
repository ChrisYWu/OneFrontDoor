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
var http_1 = require('@angular/http');
var router_1 = require('@angular/router');
var ng2_bootstrap_1 = require('ng2-bootstrap/ng2-bootstrap');
var ng2_webstorage_1 = require('ng2-webstorage');
var core_2 = require('ng2-idle/core');
var MerchAppConstant_1 = require('../../../app/MerchAppConstant');
var planning_1 = require('../../services/planning');
var headernav_service_1 = require('../../services/headernav.service');
// import { TopMenuComponent }   from '../menu/top-menu';
// import { TopSubMenuComponent }   from '../menu/top-sub-menu';
// import { UserDropdownComponent }   from '../menu/user-dropdown';
var HeaderComponent = (function () {
    function HeaderComponent(http, localSt, idle, navService) {
        this.http = http;
        this.localSt = localSt;
        this.idle = idle;
        this.navService = navService;
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
        this.merchGroups = [];
        this.nobranch = false;
        this.nomerchgroup = false;
        this.menushowreport = false;
        this.menushowplanning = false;
        this.item = new planning_1.MerchGroup();
        this.merchitem = new planning_1.MerchGroup();
        this.isGeoVisible = true;
        this.disabled = false;
        this.status = { isopen: false };
        this.items = ['The first choice!',
            'And another choice for you.', 'but wait! A third!'];
        idle.setIdle(1200);
        idle.setTimeout(5);
        idle.setInterrupts(core_2.DEFAULT_INTERRUPTSOURCES);
        idle.onTimeout.subscribe(function () {
            console.log('Timeout');
            window.location.href = "/logout.html";
        });
        idle.watch();
    }
    HeaderComponent.prototype.toggled = function (open) {
        console.log('Dropdown is now: ', open);
    };
    HeaderComponent.prototype.toggleDropdown = function ($event) {
        $event.preventDefault();
        $event.stopPropagation();
        this.status.isopen = !this.status.isopen;
    };
    HeaderComponent.prototype.ngOnInit = function () {
        var _this = this;
        this.selectedBranch = new planning_1.MerchBranch();
        this.selectedGroup = new planning_1.MerchGroup();
        this.checkUserAuth();
        this.subscription = this.navService.navMerchItem$.subscribe(function (newitem) { _this.merchitem = newitem; _this.addMerchItem(newitem); });
    };
    HeaderComponent.prototype.addMerchItem = function (merchitem) {
        this.merchitem = merchitem;
        if (this.merchitem.MerchGroupID != undefined) {
            this.merchGroups.push(this.merchitem);
            this.filterMerchGroups(merchitem.SAPBranchID);
        }
    };
    HeaderComponent.prototype.hideGeo = function (flag) {
        if (flag == 1)
            this.isGeoVisible = false;
        else
            this.isGeoVisible = true;
    };
    HeaderComponent.prototype.onBranchSelect = function (branch) {
        this.selectedBranch = branch;
        this.filterMerchGroups(branch.SAPBranchID);
        this.selectedGroup.LoggedInUser = this.localSt.retrieve("UserGSN");
        this.navService.changeNav(this.selectedGroup);
    };
    HeaderComponent.prototype.onGroupSelect = function (group) {
        this.selectedGroup = group;
        this.item = this.selectedGroup;
        this.item.LoggedInUser = this.localSt.retrieve("UserGSN");
        this.navService.changeNav(this.item);
    };
    HeaderComponent.prototype.filterMerchGroups = function (sapBranchID) {
        this.merchTargetGroups = this.merchGroups.filter(function (d) {
            if (d.SAPBranchID == sapBranchID)
                return d;
        });
        var grp = this.merchTargetGroups.filter(function (d) {
            if (d.IsDefault == true)
                return d;
        });
        if (this.merchTargetGroups.length == 0) {
            this.merchTargetGroups = [];
            this.selectedGroup.SAPBranchID = sapBranchID;
            this.selectedGroup.GroupName = '';
            this.selectedGroup.MerchGroupID = null;
        }
        else if (grp.length == 0) {
            this.selectedGroup = this.merchTargetGroups[0];
        }
        else {
            this.selectedGroup = grp[0];
        }
    };
    HeaderComponent.prototype.checkUserAuth = function () {
        var _this = this;
        this.WebAPIPostCall().subscribe(function (res) {
            var d = res;
            if (d.UserInfo.IsValid == 1) {
                _this.localSt.store('UserGSN', d.UserInfo.GSN);
                _this.localSt.store('UserName', d.UserInfo.Name);
                _this.localSt.store('UserEmail', d.UserInfo.Email);
                _this.userName = d.UserInfo.Name;
                if (d.Branches.length >= 0) {
                    var brch = d.Branches.filter(function (d) {
                        if (d.IsDefault == true)
                            return d;
                    });
                    if (brch.length == 0) {
                        _this.selectedBranch = d.Branches[0];
                    }
                    else {
                        _this.selectedBranch = brch[0];
                    }
                    _this.merchBranches = d.Branches;
                    _this.nobranch = true;
                }
                if (d.Groups.length >= 0) {
                    _this.merchGroups = d.Groups;
                    _this.merchTargetGroups = Object.assign(_this.merchGroups);
                    _this.filterMerchGroups(_this.selectedBranch.SAPBranchID);
                    _this.nomerchgroup = true;
                }
                _this.item = _this.selectedGroup;
                _this.item.LoggedInUser = _this.localSt.retrieve("UserGSN");
                _this.navService.changeNav(_this.item);
                console.log(_this.localSt.retrieve('UserGSN'));
                console.log(_this.localSt.retrieve('UserName'));
                console.log(_this.localSt.retrieve('UserEmail'));
            }
            else {
                console.log("User GSN - " + d.UserInfo.GSN + " is not valid.");
                window.location.href = "/InvalidUser.html?GSN=" + d.UserInfo.GSN;
            }
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    HeaderComponent.prototype.WebAPIPostCall = function () {
        return this.http.get(this._webapi + 'api/Merc/CheckAuthenticationByUser/')
            .map(function (response) { return response.json(); });
    };
    HeaderComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-header',
            templateUrl: 'header.component.html',
            styleUrls: ['header.component.css'],
            directives: [router_1.ROUTER_DIRECTIVES, ng2_bootstrap_1.DROPDOWN_DIRECTIVES],
            providers: [headernav_service_1.HeadernavService]
        }), 
        __metadata('design:paramtypes', [http_1.Http, ng2_webstorage_1.LocalStorageService, core_2.Idle, headernav_service_1.HeadernavService])
    ], HeaderComponent);
    return HeaderComponent;
}());
exports.HeaderComponent = HeaderComponent;
//# sourceMappingURL=header.component.js.map