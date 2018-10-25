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
var ng2_webstorage_1 = require('ng2-webstorage');
var core_2 = require('ng2-idle/core');
var MerchAppConstant_1 = require('../../../../app/MerchAppConstant');
var UserDropdownComponent = (function () {
    function UserDropdownComponent(http, localSt, idle) {
        this.http = http;
        this.localSt = localSt;
        this.idle = idle;
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
        idle.setIdle(1200);
        idle.setTimeout(5);
        idle.setInterrupts(core_2.DEFAULT_INTERRUPTSOURCES);
        idle.onTimeout.subscribe(function () {
            console.log('Timeout');
            window.location.href = "/logout.html";
        });
        idle.watch();
    }
    UserDropdownComponent.prototype.ngOnInit = function () {
        this.checkUserAuth();
    };
    UserDropdownComponent.prototype.checkUserAuth = function () {
        var _this = this;
        this.WebAPIPostCall().subscribe(function (res) {
            var d = res;
            if (d.UserInfo.IsValid == 1) {
                _this.localSt.store('UserGSN', d.UserInfo.GSN);
                _this.localSt.store('UserName', d.UserInfo.Name);
                _this.localSt.store('UserEmail', d.UserInfo.Email);
                _this.userName = d.UserInfo.Name;
                console.log(_this.localSt.retrieve('UserGSN'));
                console.log(_this.localSt.retrieve('UserName'));
                console.log(_this.localSt.retrieve('UserEmail'));
            }
            else {
                console.log("User is not valid");
            }
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    UserDropdownComponent.prototype.WebAPIPostCall = function () {
        return this.http.get(this._webapi + 'api/Merc/CheckAuthentication/', { withCredentials: true })
            .map(function (response) { return response.json(); });
    };
    UserDropdownComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'user-dropdown',
            templateUrl: 'user-dropdown.component.html',
            styleUrls: ['user-dropdown.component.css']
        }), 
        __metadata('design:paramtypes', [http_1.Http, ng2_webstorage_1.LocalStorageService, core_2.Idle])
    ], UserDropdownComponent);
    return UserDropdownComponent;
}());
exports.UserDropdownComponent = UserDropdownComponent;
//# sourceMappingURL=user-dropdown.component.js.map