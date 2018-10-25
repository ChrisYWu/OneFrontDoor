"use strict";
var router_1 = require('@angular/router');
var dispatch_1 = require('../../dispatch');
var merc_main_1 = require('../../merc-main');
var storeservice_1 = require('../../reporting/storeservice');
var mileage_1 = require('../../reporting/mileage');
var create_merch_group_1 = require('../../planning/create-merch-group');
var rsassignment_1 = require('../../planning/rsassignment');
var storesetup_main_1 = require('../../planning/StoreSetup/storesetup-main');
var photo_1 = require('../photo');
var pl_merch_1 = require('../../pl-merch');
var merchsetupmain_1 = require('../../planning/MerchSetup/merchsetupmain');
// import {} from ''
var routes = [
    { path: '', component: dispatch_1.DispatchComponent },
    { path: 'merchandise', component: merc_main_1.MercMainComponent },
    { path: 'monitor', component: dispatch_1.DispatchComponent },
    { path: 'plmerch', component: pl_merch_1.PlMerchComponent },
    { path: 'rptstoreservice', component: storeservice_1.StoreserviceComponent },
    { path: 'rptmileage', component: mileage_1.MileageComponent },
    { path: 'plnmerchgroup', component: create_merch_group_1.CreateMerchGroupComponent },
    { path: 'plnmerchsetup', component: merchsetupmain_1.MerchsetupmainComponent },
    { path: 'plnrsassignment', component: rsassignment_1.RsassignmentComponent },
    { path: 'plnstore', component: storesetup_main_1.StoresetupMainComponent },
    { path: 'playphoto', component: photo_1.PhotoComponent }
];
exports.headerRouteProviders = [
    router_1.provideRouter(routes)
];
//# sourceMappingURL=header-route-providers.js.map