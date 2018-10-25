"use strict";
var platform_browser_dynamic_1 = require('@angular/platform-browser-dynamic');
var core_1 = require('@angular/core');
var ng2_dnd_1 = require('ng2-dnd/ng2-dnd');
var app_1 = require('./app');
var http_1 = require('@angular/http');
var _1 = require('./app/common/header-route-providers/');
var common_1 = require('@angular/common');
var MerchExceptionHandler_1 = require('./app/common/ExceptionHandler/MerchExceptionHandler');
var core_2 = require('@angular/core');
var ng2_webstorage_1 = require('ng2-webstorage');
var core_3 = require('ng2-idle/core');
//if (environment.production) {
core_1.enableProdMode();
//}
platform_browser_dynamic_1.bootstrap(app_1.MerchAppComponent, [
    http_1.HTTP_PROVIDERS,
    _1.headerRouteProviders,
    ng2_dnd_1.DND_PROVIDERS,
    MerchExceptionHandler_1.MerchLogger,
    core_1.provide(core_2.ExceptionHandler, { useClass: MerchExceptionHandler_1.MerchExceptionHandler }),
    { provide: common_1.LocationStrategy, useClass: common_1.HashLocationStrategy },
    [ng2_webstorage_1.NG2_WEBSTORAGE],
    core_3.IDLE_PROVIDERS
]).catch(function (err) { return console.error(err); });
//# sourceMappingURL=main.js.map