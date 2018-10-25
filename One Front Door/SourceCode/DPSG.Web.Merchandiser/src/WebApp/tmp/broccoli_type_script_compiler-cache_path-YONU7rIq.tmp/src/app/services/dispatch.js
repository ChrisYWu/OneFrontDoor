"use strict";
var Dispatches = (function () {
    function Dispatches(gsn, firstName, lastName, routeID, precedence, merchGroupID, dispatchDate, lastModifiedBy, stores) {
        this.RouteID = routeID;
        this.GSN = gsn;
        this.FirstName = firstName;
        this.LastName = lastName;
        this.MerchGroupID = merchGroupID;
        this.Stores = stores;
        this.DispatchDate = dispatchDate;
        this.LastModifiedBy = lastModifiedBy;
    }
    return Dispatches;
}());
exports.Dispatches = Dispatches;
var Store = (function () {
    function Store(acctID, accountName, sequence, pullnumber) {
        this.AccountID = acctID;
        this.AccountName = accountName;
        this.Sequence = sequence;
        this.PullNumber = pullnumber;
    }
    return Store;
}());
exports.Store = Store;
var DispatchInput = (function () {
    function DispatchInput(gsn, merchGroupID, dispatchDate) {
        this.GSN = gsn;
        this.DispatchDate = dispatchDate;
        this.MerchGroupID = merchGroupID;
    }
    return DispatchInput;
}());
exports.DispatchInput = DispatchInput;
var Accounts = (function () {
    function Accounts(unassignedstores, otherstores, allstores) {
        this.UnassignedStores = unassignedstores;
        this.OtherStores = allstores;
        this.AllStores = allstores;
    }
    return Accounts;
}());
exports.Accounts = Accounts;
var Account = (function () {
    function Account(acctid, acctname, address, city, state, postalcode) {
        this.SAPAccountNumber = acctid;
        this.AccountName = acctname;
        this.Address = address;
        this.City = city;
        this.State = state;
        this.PostalCode = postalcode;
    }
    return Account;
}());
exports.Account = Account;
var AccountInput = (function () {
    function AccountInput(merchGroupID, dispatchDate) {
        this.DispatchDate = dispatchDate;
        this.MerchGroupID = merchGroupID;
    }
    return AccountInput;
}());
exports.AccountInput = AccountInput;
var StorePreDispatch = (function () {
    function StorePreDispatch(dispatchDate, merchGroupID, routeID, gsn, sapAccountNumber, lastModifiedBy) {
        this.DispatchDate = dispatchDate;
        this.MerchGroupID = merchGroupID;
        this.RouteID = routeID;
        this.GSN = gsn;
        this.SAPAccountNumber = sapAccountNumber;
        this.LastModifiedBy = lastModifiedBy;
    }
    return StorePreDispatch;
}());
exports.StorePreDispatch = StorePreDispatch;
var DispatchOutput = (function () {
    function DispatchOutput() {
    }
    return DispatchOutput;
}());
exports.DispatchOutput = DispatchOutput;
var ResequenceInput = (function () {
    function ResequenceInput(dispDate, routeID, moveFrom, moveTo, lastModifiedBy) {
        this.DispatchDate = dispDate;
        this.RouteID = routeID;
        this.MoveFrom = moveFrom;
        this.MoveTo = moveTo;
        this.LastModifiedBy = lastModifiedBy;
    }
    return ResequenceInput;
}());
exports.ResequenceInput = ResequenceInput;
var RemoveStoreinput = (function () {
    function RemoveStoreinput(dispDate, routeID, sequence, lastModifiedBy) {
        this.DispatchDate = dispDate;
        this.RouteID = routeID;
        this.Sequence = sequence;
        this.LastModifiedBy = lastModifiedBy;
    }
    return RemoveStoreinput;
}());
exports.RemoveStoreinput = RemoveStoreinput;
var RouteListInput = (function () {
    function RouteListInput(dispatchDate, merchGroupID) {
        this.DispatchDate = dispatchDate;
        this.MerchGroupID = merchGroupID;
    }
    return RouteListInput;
}());
exports.RouteListInput = RouteListInput;
var RouteListExcludeCurrentInput = (function () {
    function RouteListExcludeCurrentInput(dispatchDate, merchGroupID, routeID) {
        this.DispatchDate = dispatchDate;
        this.MerchGroupID = merchGroupID;
        this.RouteID = routeID;
    }
    return RouteListExcludeCurrentInput;
}());
exports.RouteListExcludeCurrentInput = RouteListExcludeCurrentInput;
var Route = (function () {
    function Route(routeid, routename, gsn) {
        this.RouteID = routeid;
        this.RouteName = routename;
        this.GSN = gsn;
    }
    return Route;
}());
exports.Route = Route;
var ReassignStoreInput = (function () {
    function ReassignStoreInput(dispDate, sequence, lastModifiedBy, merchGroupID, gsn, targetRouteID, sourceRouteID, sapAccountNumber) {
        this.DispatchDate = dispDate;
        this.Sequence = sequence;
        this.LastModifiedBy = lastModifiedBy;
        this.MerchGroupID = merchGroupID;
        this.GSN = gsn;
        this.TargetRouteID = targetRouteID;
        this.SourceRouteID = sourceRouteID;
        this.SAPAccountNumber = sapAccountNumber;
    }
    return ReassignStoreInput;
}());
exports.ReassignStoreInput = ReassignStoreInput;
var Merchandiser = (function () {
    function Merchandiser(gsn, fname, lname) {
        this.GSN = gsn;
        this.FirstName = fname;
        this.LastName = lname;
    }
    return Merchandiser;
}());
exports.Merchandiser = Merchandiser;
var ReassignMerchInput = (function () {
    function ReassignMerchInput(dispDate, lastModifiedBy, merchGroupID, gsn, routeID) {
        this.DispatchDate = dispDate;
        this.LastModifiedBy = lastModifiedBy;
        this.MerchGroupID = merchGroupID;
        this.GSN = gsn;
        this.RouteID = routeID;
    }
    return ReassignMerchInput;
}());
exports.ReassignMerchInput = ReassignMerchInput;
var DispatchReady = (function () {
    function DispatchReady(disptype, changenote, gsn, lastname, firstname, routeid, sequence, sapacctno, accoutname) {
        this.DispatchType = disptype;
        this.ChangeNote = changenote;
        this.GSN = gsn;
        this.LastName = lastname;
        this.FirstNam = firstname;
        this.RouteID = routeid;
        this.Sequence = sequence;
        this.SAPAccountNumber = sapacctno;
        this.AccountName = accoutname;
    }
    return DispatchReady;
}());
exports.DispatchReady = DispatchReady;
var DispatchFinalInput = (function () {
    function DispatchFinalInput(dispdate, releaseby, merchgroupid, dispatchnote) {
        this.DispatchDate = dispdate;
        this.ReleaseBy = releaseby;
        this.MerchGroupID = merchgroupid;
        this.DispatchNote = dispatchnote;
    }
    return DispatchFinalInput;
}());
exports.DispatchFinalInput = DispatchFinalInput;
var DispatchFinalResult = (function () {
    function DispatchFinalResult(dispatchinfo, batchid) {
        this.DispatchInfo = dispatchinfo;
        this.BatchID = batchid;
    }
    return DispatchFinalResult;
}());
exports.DispatchFinalResult = DispatchFinalResult;
var DispatchHistory = (function () {
    function DispatchHistory(batchnote, releasetime, firstname, lastname) {
        this.BatchNote = batchnote;
        this.ReleaseTime = releasetime;
        this.FirstName = firstname;
        this.LastName = lastname;
    }
    return DispatchHistory;
}());
exports.DispatchHistory = DispatchHistory;
//# sourceMappingURL=dispatch.js.map