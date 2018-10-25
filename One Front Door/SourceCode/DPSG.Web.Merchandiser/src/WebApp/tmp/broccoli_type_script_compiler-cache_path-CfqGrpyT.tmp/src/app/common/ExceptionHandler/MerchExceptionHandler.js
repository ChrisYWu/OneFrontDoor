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
var MerchException_1 = require('./MerchException');
var http_1 = require('@angular/http');
var MerchAppConstant_1 = require('../../../app/MerchAppConstant');
var MerchExceptionHandler = (function () {
    function MerchExceptionHandler(http) {
        this.http = http;
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
    }
    MerchExceptionHandler.prototype.call = function (exception, stackTrace, reason) {
        this.merchExcept = new MerchException_1.MerchException(1, 1, '', '', exception.message, stackTrace, '');
        this.insertException(this.merchExcept);
    };
    MerchExceptionHandler.prototype.insertException = function (inputdata) {
        this.WebAPIPostCall(inputdata).subscribe(function (res) {
            var d = res;
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    MerchExceptionHandler.prototype.WebAPIPostCall = function (inputdata) {
        var headers = new http_1.Headers();
        var test = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
        headers.append('Content-Type', 'application/json');
        return this.http.post(this._webapi + 'api/Merc/InsertException/', JSON.stringify(inputdata), { headers: headers })
            .map(function (response) { return response.json(); });
    };
    MerchExceptionHandler = __decorate([
        core_1.Injectable(), 
        __metadata('design:paramtypes', [http_1.Http])
    ], MerchExceptionHandler);
    return MerchExceptionHandler;
}());
exports.MerchExceptionHandler = MerchExceptionHandler;
var MerchLogger = (function () {
    function MerchLogger(http) {
        this.http = http;
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
    }
    MerchLogger.prototype.log = function (logMsg) {
        console.log(logMsg);
    };
    MerchLogger.prototype.logError = function (appliationID, severityID, source, userName, detail, stackTrace) {
        this.merchExcept = new MerchException_1.MerchException(appliationID, severityID, source, userName, detail, stackTrace, '');
        this.insertErrorLog(this.merchExcept);
    };
    MerchLogger.prototype.insertErrorLog = function (inputdata) {
        this.WebAPIPostCall(inputdata).subscribe(function (res) {
            var d = res;
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    MerchLogger.prototype.WebAPIPostCall = function (inputdata) {
        var headers = new http_1.Headers();
        headers.append('Content-Type', 'application/json');
        return this.http.post(this._webapi + 'api/Merc/InsertException/', JSON.stringify(inputdata), { headers: headers })
            .map(function (response) { return response.json(); });
    };
    MerchLogger = __decorate([
        core_1.Injectable(), 
        __metadata('design:paramtypes', [http_1.Http])
    ], MerchLogger);
    return MerchLogger;
}());
exports.MerchLogger = MerchLogger;
//# sourceMappingURL=MerchExceptionHandler.js.map