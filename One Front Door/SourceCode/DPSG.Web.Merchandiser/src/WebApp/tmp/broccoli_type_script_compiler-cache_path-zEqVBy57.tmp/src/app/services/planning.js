"use strict";
var MerchBranch = (function () {
    function MerchBranch() {
    }
    return MerchBranch;
}());
exports.MerchBranch = MerchBranch;
var MerchGroup = (function () {
    function MerchGroup() {
    }
    return MerchGroup;
}());
exports.MerchGroup = MerchGroup;
var MerchGroupsInput = (function () {
    function MerchGroupsInput(sapbranchID) {
        this.SAPBranchID = sapbranchID;
    }
    return MerchGroupsInput;
}());
exports.MerchGroupsInput = MerchGroupsInput;
var MerchGroupDetail = (function () {
    function MerchGroupDetail() {
    }
    return MerchGroupDetail;
}());
exports.MerchGroupDetail = MerchGroupDetail;
var MerchGroupDetailInput = (function () {
    function MerchGroupDetailInput(sapbranchID, merchgroupId) {
        this.SAPBranchID = sapbranchID;
        this.MerchGroupID = merchgroupId;
    }
    return MerchGroupDetailInput;
}());
exports.MerchGroupDetailInput = MerchGroupDetailInput;
var MerchGroupInput = (function () {
    function MerchGroupInput(sapbranchID, merchgroupId, groupName, ownerGSN, ownerName, gsn, routes) {
        this.SAPBranchID = sapbranchID;
        this.MerchGroupID = merchgroupId;
        this.GroupName = groupName;
        this.DefaultOwnerGSN = ownerGSN;
        this.DefaultOwnerName = ownerName;
        this.GSN = gsn;
        this.Routes = routes;
    }
    return MerchGroupInput;
}());
exports.MerchGroupInput = MerchGroupInput;
var MerchGroupRoute = (function () {
    function MerchGroupRoute() {
    }
    return MerchGroupRoute;
}());
exports.MerchGroupRoute = MerchGroupRoute;
var MerchBranchInput = (function () {
    function MerchBranchInput(gsn) {
        this.GSN = gsn;
    }
    return MerchBranchInput;
}());
exports.MerchBranchInput = MerchBranchInput;
var MerchBranches = (function () {
    function MerchBranches(branches, merchgroupList) {
        this.Branches = branches;
        this.MerchGroupList = merchgroupList;
    }
    return MerchBranches;
}());
exports.MerchBranches = MerchBranches;
var MerchGroupCheckOutput = (function () {
    function MerchGroupCheckOutput() {
    }
    return MerchGroupCheckOutput;
}());
exports.MerchGroupCheckOutput = MerchGroupCheckOutput;
var MerchGroupCheckInput = (function () {
    function MerchGroupCheckInput(sapbranchID, groupName, routeName, mode) {
        this.SAPBranchID = sapbranchID;
        this.GroupName = groupName;
        this.RouteName = routeName;
        this.Mode = mode;
    }
    return MerchGroupCheckInput;
}());
exports.MerchGroupCheckInput = MerchGroupCheckInput;
var User = (function () {
    function User() {
    }
    return User;
}());
exports.User = User;
var StoreInfo = (function () {
    function StoreInfo() {
    }
    return StoreInfo;
}());
exports.StoreInfo = StoreInfo;
var RouteInfo = (function () {
    function RouteInfo() {
    }
    return RouteInfo;
}());
exports.RouteInfo = RouteInfo;
var StoreSetupDOW = (function () {
    function StoreSetupDOW() {
    }
    return StoreSetupDOW;
}());
exports.StoreSetupDOW = StoreSetupDOW;
var StoreSetupDetailContainer = (function () {
    function StoreSetupDetailContainer() {
    }
    return StoreSetupDetailContainer;
}());
exports.StoreSetupDetailContainer = StoreSetupDetailContainer;
//# sourceMappingURL=planning.js.map