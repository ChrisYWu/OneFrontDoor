"use strict";
var MerchConstant = (function () {
    function MerchConstant() {
    }
    Object.defineProperty(MerchConstant, "WebAPI_ENDPOINT", {
        get: function () { return 'http://localhost/DPSG.Webapi.Merchandiser/'; },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(MerchConstant, "MYDAY_WebAPI_ENDPOINT", {
        get: function () { return 'http://localhost/DPSG.Portal.Merchandiser.WebAPI/'; },
        enumerable: true,
        configurable: true
    });
    return MerchConstant;
}());
exports.MerchConstant = MerchConstant;
//# sourceMappingURL=MerchAppConstant.js.map