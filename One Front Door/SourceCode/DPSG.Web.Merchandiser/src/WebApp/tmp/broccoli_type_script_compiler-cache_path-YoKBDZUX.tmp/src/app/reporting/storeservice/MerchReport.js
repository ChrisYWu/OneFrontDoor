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
    function ImageInput(blobid) {
        this.BlobIDs = blobid;
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
    function ImageURLInput(absoluteURL, containerID, readSAS, isReadSASValid) {
        this.AbsoluteURL = absoluteURL;
        this.ContainerID = containerID;
        this.ReadSAS = readSAS;
        this.IsReadSASValid = isReadSASValid;
    }
    return ImageURLInput;
}());
exports.ImageURLInput = ImageURLInput;
var Dictionary = (function () {
    function Dictionary() {
    }
    return Dictionary;
}());
exports.Dictionary = Dictionary;
var ExtendReadSASInput = (function () {
    function ExtendReadSASInput() {
    }
    return ExtendReadSASInput;
}());
exports.ExtendReadSASInput = ExtendReadSASInput;
//# sourceMappingURL=MerchReport.js.map