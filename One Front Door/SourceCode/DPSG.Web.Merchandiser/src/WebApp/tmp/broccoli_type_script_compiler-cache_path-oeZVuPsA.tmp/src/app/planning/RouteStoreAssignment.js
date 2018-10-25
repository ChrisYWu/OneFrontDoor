"use strict";
var Dispatches = (function () {
    function Dispatches(gsn, firstName, lastName, routeID, precedence, merchGroupID, dispatchDate, lastModifiedBy, stores, weekday) {
        this.RouteID = routeID;
        this.GSN = gsn;
        this.FirstName = firstName;
        this.LastName = lastName;
        this.MerchGroupID = merchGroupID;
        this.Stores = stores;
        this.DispatchDate = dispatchDate;
        this.LastModifiedBy = lastModifiedBy;
        this.WeekDay = weekday;
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
var StoreWeekDayOutput = (function () {
    function StoreWeekDayOutput() {
    }
    return StoreWeekDayOutput;
}());
exports.StoreWeekDayOutput = StoreWeekDayOutput;
var RSInput = (function () {
    function RSInput(merchGroupID, weekday) {
        this.MerchGroupID = merchGroupID;
        this.WeekDay = weekday;
    }
    return RSInput;
}());
exports.RSInput = RSInput;
var StoreWeekDayInput = (function () {
    function StoreWeekDayInput(merchGroupID, weekday, routeID, sapAccountNumber, lastModifiedBy) {
        this.MerchGroupID = merchGroupID;
        this.Weekday = weekday;
        this.RouteID = routeID;
        this.SAPAccountNumber = sapAccountNumber;
        this.LastModifiedBy = lastModifiedBy;
    }
    return StoreWeekDayInput;
}());
exports.StoreWeekDayInput = StoreWeekDayInput;
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
    function AccountInput(merchGroupID, weekday) {
        this.MerchGroupID = merchGroupID;
        this.WeekDay = weekday;
    }
    return AccountInput;
}());
exports.AccountInput = AccountInput;
var DispatchOutput = (function () {
    function DispatchOutput() {
    }
    return DispatchOutput;
}());
exports.DispatchOutput = DispatchOutput;
var ResequenceInput = (function () {
    function ResequenceInput(weekday, routeID, moveFrom, moveTo, lastModifiedBy) {
        this.WeekDay = weekday;
        this.RouteID = routeID;
        this.MoveFrom = moveFrom;
        this.MoveTo = moveTo;
        this.LastModifiedBy = lastModifiedBy;
    }
    return ResequenceInput;
}());
exports.ResequenceInput = ResequenceInput;
var RemoveStoreinput = (function () {
    function RemoveStoreinput(weekday, routeID, sequence, lastModifiedBy) {
        this.WeekDay = weekday;
        this.RouteID = routeID;
        this.Sequence = sequence;
        this.LastModifiedBy = lastModifiedBy;
    }
    return RemoveStoreinput;
}());
exports.RemoveStoreinput = RemoveStoreinput;
var RouteListInput = (function () {
    function RouteListInput(merchGroupID, weekday) {
        this.MerchGroupID = merchGroupID;
        this.WeekDay = weekday;
    }
    return RouteListInput;
}());
exports.RouteListInput = RouteListInput;
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
    function ReassignStoreInput(weekday, sequence, lastModifiedBy, merchGroupID, targetRouteID, sourceRouteID, sapAccountNumber) {
        this.MerchGroupID = merchGroupID;
        this.WeekDay = weekday;
        this.TargetRouteID = targetRouteID;
        this.SourceRouteID = sourceRouteID;
        this.SAPAccountNumber = sapAccountNumber;
        this.LastModifiedBy = lastModifiedBy;
        this.Sequence = sequence;
    }
    return ReassignStoreInput;
}());
exports.ReassignStoreInput = ReassignStoreInput;
//# sourceMappingURL=RouteStoreAssignment.js.map