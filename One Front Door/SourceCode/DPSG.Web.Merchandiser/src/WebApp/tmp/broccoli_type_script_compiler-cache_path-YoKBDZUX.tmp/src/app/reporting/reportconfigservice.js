"use strict";
var ConfigService = (function () {
    function ConfigService() {
        this.searchEnabled = false;
        this.orderEnabled = true;
        this.globalSearchEnabled = false;
        this.footerEnabled = false;
        this.paginationEnabled = false;
        this.exportEnabled = false;
        this.editEnabled = false;
        this.resourceUrl = "../data.json";
        this.rows = 10;
    }
    return ConfigService;
}());
exports.ConfigService = ConfigService;
//# sourceMappingURL=reportconfigservice.js.map