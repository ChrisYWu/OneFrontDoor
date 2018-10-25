"use strict";
var StoreServiceInput = (function () {
    function StoreServiceInput(merchGroupIDs, fromDate, toDate) {
        this.MerchGroupIDs = merchGroupIDs;
        this.FromDate = fromDate;
        this.ToDate = toDate;
    }
    return StoreServiceInput;
}());
exports.StoreServiceInput = StoreServiceInput;
var StoreService = (function () {
    function StoreService() {
    }
    return StoreService;
}());
exports.StoreService = StoreService;
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
var ImageInput = (function () {
    function ImageInput(blobid, isSign) {
        this.BlobID = blobid;
        this.IsSignature = isSign;
    }
    return ImageInput;
}());
exports.ImageInput = ImageInput;
var ImageDetail = (function () {
    function ImageDetail() {
    }
    return ImageDetail;
}());
exports.ImageDetail = ImageDetail;
var ImageURLInput = (function () {
    function ImageURLInput(relativeURL, absoluteURL, container, storageaccount, accesslevel, connectionstring) {
        this.RelativeURL = relativeURL;
        this.AbsoluteURL = absoluteURL;
        this.Container = container;
        this.StorageAccount = storageaccount;
        this.AccessLevel = accesslevel;
        this.AzureConnectionString = connectionstring;
    }
    return ImageURLInput;
}());
exports.ImageURLInput = ImageURLInput;
//# sourceMappingURL=MerchReport.js.map