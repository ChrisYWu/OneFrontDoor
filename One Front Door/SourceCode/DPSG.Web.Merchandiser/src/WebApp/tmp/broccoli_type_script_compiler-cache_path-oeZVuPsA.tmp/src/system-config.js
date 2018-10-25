/***********************************************************************************************
 * User Configuration.
 **********************************************************************************************/
/** Map relative paths to URLs. */
var map = {
    'moment': 'vendor/moment/moment.js',
    'ng2-bootstrap': 'vendor/ng2-bootstrap',
    'ng2-dnd': 'vendor/ng2-dnd',
    'ng2-easy-table': 'vendor/ng2-easy-table',
    'ng2-datepicker': 'vendor/ng2-datepicker',
    'ng2-auto-complete': 'vendor/ng2-auto-complete/dist',
    'ng2-webstorage': 'vendor/ng2-webstorage',
    'ng2-idle': 'vendor/ng2-idle',
    'ng2-map': 'vendor/ng2-map/dist',
    'rxjs': 'vendor/rxjs'
};
/** User packages configuration. */
var packages = {
    'vendor/ng2-bootstrap': {
        defaultExtension: 'js'
    },
    "vendor/ng2-dnd": {
        "defaultExtension": "js"
    },
    'vendor/ng2-easy-table': {
        format: 'register',
        defaultExtension: 'js'
    },
    'vendor/ng2-datepicker': {
        defaultExtension: 'js'
    },
    'ng2-auto-complete': {
        main: 'index.js', defaultExtension: 'js'
    },
    'vendor/ng2-webstorage': {
        main: 'index.js', defaultExtension: 'js'
    },
    'vendor/ng2-idle': {
        defaultExtension: 'js'
    },
    'ng2-map': {
        main: 'index.js', defaultExtension: 'js'
    }
};
////////////////////////////////////////////////////////////////////////////////////////////////
/***********************************************************************************************
 * Everything underneath this line is managed by the CLI.
 **********************************************************************************************/
var barrels = [
    // Angular specific barrels.
    '@angular/core',
    '@angular/common',
    '@angular/compiler',
    '@angular/http',
    '@angular/forms',
    '@angular/router',
    '@angular/platform-browser',
    '@angular/platform-browser-dynamic',
    // Thirdparty barrels.
    'rxjs',
    'ng2-bootstrap',
    'ng2-dnd',
    'ng2-easy-table',
    'ng2-datepicker',
    'ng2-map',
    // App specific barrels.
    'app',
    'app/shared',
    'app/merc-main',
    'app/shared/merc-header',
    'app/shared/merc-footer',
    'app/common/header',
    'app/common/footer',
    'app/merc-main/add-store',
    'app/common/addstore',
    'app/common/tabs',
    'app/common/storelist',
    'app/common/header-route',
    'app/dispatch/dispatch',
    'app/dispatch',
    'app/dispatch/dispatch-row',
    'app/dispatch/route-info',
    'app/dispatch/route-item',
    'app/common/header-route-providers',
    'app/common/route',
    'app/reporting/storeservice',
    'app/reporting/mileage',
    'app/common/storereassign',
    'app/planning/create-merch-group',
    'app/common/menu/top-menu',
    'app/common/menu/user-dropdown',
    'app/common/menu/top-sub-menu',
    'app/dispatch/monitor-popup',
    'app/dispatch/image-list',
    'app/common/merchreassign',
    //   'app/planning/StoreSetup/storesetup',
    'app/planning/StoreSetup/storeitem',
    'app/planning/StoreSetup/stores-list',
    'app/planning/StoreSetup/storedetail',
    'app/planning/StoreSetup/storelist-popup',
    'app/planning/rsassignment',
    'app/planning/rstabs',
    'app/planning/rsroute',
    'app/planning/rsstorelist',
    'app/planning/rsstorereassign',
    'app/planning/rsaddstore',
    'app/planning/StoreSetup/storesetup-main',
    'app/common/photo',
    'app/pl-merch',
    'app/pl-merch/pl-merch-info',
    'app/pl-merch/pl-merch-info-select',
    'app/pl-merch/pl-merch-item',
    'app/pl-merch/pl-merch-popup',
    'app/pl-merch/pl-merch-row',
    'app/pl-merch/pl-route-info',
    'app/pl-merch/pl-route-select',
    'app/pl-merch/pl-route-item',
    'app/pl-merch/pl-route-popup',
    'app/pl-merch/pl-route-row',
    'app/common/spinner',
    'app/planning/MerchSetup/merchsetupmain',
    'app/planning/MerchSetup/merchdetail',
    'app/planning/MerchSetup/addmerch',
    'app/planning/MerchSetup/addmerchpopup',
    'app/planning/MerchSetup/merchlist',
];
var cliSystemConfigPackages = {};
barrels.forEach(function (barrelName) {
    if (barrelName == 'ng2-bootstrap')
        cliSystemConfigPackages[barrelName] = { main: 'ng2-bootstrap' };
    else
        cliSystemConfigPackages[barrelName] = { main: 'index' };
});
// Apply the CLI SystemJS configuration.
System.config({
    map: {
        '@angular': 'vendor/@angular',
        'rxjs': 'vendor/rxjs',
        'ng2-bootstrap': 'vendor/ng2-bootstrap',
        'moment': 'vendor/moment/moment.js',
        'main': 'main.js'
    },
    packages: cliSystemConfigPackages
});
// Apply the user's configuration.
System.config({ map: map, packages: packages });
//# sourceMappingURL=system-config.js.map