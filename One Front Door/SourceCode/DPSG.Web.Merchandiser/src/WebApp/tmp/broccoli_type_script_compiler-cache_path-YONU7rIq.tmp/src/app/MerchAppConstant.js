"use strict";
var MerchConstant = (function () {
    function MerchConstant() {
    }
    Object.defineProperty(MerchConstant, "WebAPI_ENDPOINT", {
        //public static get WebAPI_ENDPOINT(): string { return 'http://merchandiser-int.dpsg.net/'; }
        // public static get WebAPI_ENDPOINT(): string { return 'http://merchandiser/'; }
        get: function () { return 'http://localhost/DPSG.Webapi.Merchandiser/'; },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(MerchConstant, "MYDAY_WebAPI_ENDPOINT", {
        // public static get MYDAY_WebAPI_ENDPOINT(): string { return 'http://webservices-int.dpsg.net/'; }
        get: function () { return 'http://localhost/DPSG.Portal.Merchandiser.WebAPI/'; },
        enumerable: true,
        configurable: true
    });
    return MerchConstant;
}());
exports.MerchConstant = MerchConstant;
//# sourceMappingURL=MerchAppConstant.js.map