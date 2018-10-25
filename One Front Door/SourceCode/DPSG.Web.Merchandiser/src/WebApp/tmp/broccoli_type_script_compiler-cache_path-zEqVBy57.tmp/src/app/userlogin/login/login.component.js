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
var MerchAppConstant_1 = require('../../../app/MerchAppConstant');
var ng2_webstorage_1 = require('ng2-webstorage');
var core_2 = require('ng2-idle/core');
var LoginComponent = (function () {
    // @SessionStorage() public UserName: string = "";
    function LoginComponent(http, localSt, idle) {
        // let _build = (<any> http)._backend._browserXHR.build;
        // (<any> http)._backend._browserXHR.build = () => {
        //     let _xhr =  _build();
        //     _xhr.withCredentials = true;
        //     return _xhr;
        // };
        this.http = http;
        this.localSt = localSt;
        this.idle = idle;
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
        this.localSt.store('UserGSN', 'TIWNX001');
        console.log(this.localSt.retrieve('UserGSN'));
        idle.setIdle(50000);
        idle.setTimeout(50000);
        idle.setInterrupts(core_2.DEFAULT_INTERRUPTSOURCES);
        idle.onIdleStart.subscribe(function () {
            console.log('IdleStart');
        });
        idle.onIdleEnd.subscribe(function () {
            console.log('IdleEnd');
        });
        idle.onTimeoutWarning.subscribe(function (countdown) {
            console.log('TimeoutWarning: ' + countdown);
        });
        idle.onTimeout.subscribe(function () {
            console.log('Timeout');
        });
        idle.watch();
    }
    LoginComponent.prototype.ngOnInit = function () {
        this.checkUserAuth();
        //this.sendRequest();
        // this.localSt.observe('key')
        //           .subscribe((value) => console.log('new value', value));
    };
    LoginComponent.prototype.checkUserAuth = function () {
        var _this = this;
        this.WebAPIPostCall().subscribe(function (res) {
            var d = res;
            if (d.UserInfo.IsValid == 1) {
                _this.localSt.store('UserGSN', d.UserInfo.GSN);
                _this.localSt.store('UserName', d.UserInfo.Name);
                _this.localSt.store('UserEmail', d.UserInfo.Email);
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
    LoginComponent.prototype.WebAPIPostCall = function () {
        // let headers = new Headers({ 'Content-Type': 'application/json' });
        //   let options = new RequestOptions({
        //   headers: headers
        //  // , withCredentials: true
        //   });
        //   let body :string = '';
        //   return this.http.post(this._webapi + 'api/Merc/CheckAuthentication/', body, options)
        //   .map((res: Response) => res.json());
        //   //.subscribe(res => {this.result = res;});
        //   // headers.append('Content-Type', 'application/json');
        return this.http.get(this._webapi + 'api/Merc/CheckAuthentication/', { withCredentials: true })
            .map(function (response) { return response.json(); });
    };
    LoginComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-login',
            templateUrl: 'login.component.html',
            styleUrls: ['login.component.css'] //,
        }), 
        __metadata('design:paramtypes', [http_1.Http, ng2_webstorage_1.LocalStorageService, core_2.Idle])
    ], LoginComponent);
    return LoginComponent;
}());
exports.LoginComponent = LoginComponent;
//# sourceMappingURL=login.component.js.map