"use strict";
var MileageInput = (function () {
    function MileageInput(merchGroupIDs, fromDate, toDate) {
        this.MerchGroupIDs = merchGroupIDs;
        this.FromDate = fromDate;
        this.ToDate = toDate;
    }
    return MileageInput;
}());
exports.MileageInput = MileageInput;
var Mileage = (function () {
    function Mileage() {
    }
    return Mileage;
}());
exports.Mileage = Mileage;
var UserMerchGroupInput = (function () {
    function UserMerchGroupInput(usrGSN) {
        this.UserGSN = usrGSN;
    }
    return UserMerchGroupInput;
}());
exports.UserMerchGroupInput = UserMerchGroupInput;
var UserMerchGroup = (function () {
    function UserMerchGroup() {
    }
    return UserMerchGroup;
}());
exports.UserMerchGroup = UserMerchGroup;
//# sourceMappingURL=mileageclass.js.map