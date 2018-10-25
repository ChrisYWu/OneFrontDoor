"use strict";
var MerchInfo = (function () {
    function MerchInfo() {
    }
    return MerchInfo;
}());
exports.MerchInfo = MerchInfo;
var RouteData = (function () {
    function RouteData() {
    }
    return RouteData;
}());
exports.RouteData = RouteData;
var MerchGroup = (function () {
    function MerchGroup() {
    }
    return MerchGroup;
}());
exports.MerchGroup = MerchGroup;
var MerchSetupDetailInput = (function () {
    function MerchSetupDetailInput(gsn, merchName, firstName, lastName, defaultRouteID, merchGroupID, phone, mon, tues, wed, thu, fri, sat, sun, lastModifiedBy) {
        this.GSN = gsn;
        this.MerchName = merchName;
        this.FirstName = firstName;
        this.LastName = lastName;
        this.DefaultRouteID = defaultRouteID;
        this.MerchGroupID = merchGroupID;
        this.Phone = phone;
        this.Mon = mon;
        this.Tues = tues;
        this.Wed = wed;
        this.Thu = thu;
        this.Fri = fri;
        this.Sat = sat;
        this.Sun = sun;
        this.LastModifiedBy = lastModifiedBy;
    }
    return MerchSetupDetailInput;
}());
exports.MerchSetupDetailInput = MerchSetupDetailInput;
//# sourceMappingURL=MerchSetupClass.js.map