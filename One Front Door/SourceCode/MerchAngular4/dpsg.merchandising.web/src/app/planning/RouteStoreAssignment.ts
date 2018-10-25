export class Dispatches {
    GSN: string;
    FirstName: string;
    LastName: string;
    RouteID: number;
    RouteName: string;
    MerchGroupID: number;
    DispatchDate: Date;
    LastModifiedBy: string;
    Stores: Store[];
    WeekDay: number;

    constructor(gsn: string,
        firstName: string,
        lastName: string,
        routeID: number,
        precedence: number,
        merchGroupID: number,
        dispatchDate: Date,
        lastModifiedBy: string,
        stores: Store[],
        weekday: number) {
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
}
export class Store {
    AccountID: number;
    AccountName: string;
    Sequence: number;
    PullNumber: string;
    constructor(acctID: number, accountName: string, sequence: number, pullnumber: string) {
        this.AccountID = acctID;
        this.AccountName = accountName;
        this.Sequence = sequence;
        this.PullNumber = pullnumber;

    }
}

export class StoreWeekDayOutput {
    Result: string;
    ReturnStatus: number;
    Message: string;
    CorrelationID: string;
    StackTrace: string;
}


export class RSInput {
    MerchGroupID: number;
    WeekDay: number;

    constructor(merchGroupID: number, weekday: number) {
        this.MerchGroupID = merchGroupID;
        this.WeekDay = weekday;
    }
}

export class StoreWeekDayInput {
    MerchGroupID: number;
    Weekday: number;
    RouteID: number;
    SAPAccountNumber: number;
    LastModifiedBy: string;

    constructor(merchGroupID: number, weekday: number, routeID: number, sapAccountNumber: number, lastModifiedBy: string) {
        this.MerchGroupID = merchGroupID;
        this.Weekday = weekday;
        this.RouteID = routeID;
        this.SAPAccountNumber = sapAccountNumber;
        this.LastModifiedBy = lastModifiedBy;
    }
}

export class Accounts {

    UnassignedStores: Account[];
    OtherStores: Account[];
    AllStores: Account[];

    constructor(unassignedstores: Account[], otherstores: Account[], allstores: Account[]) {
        this.UnassignedStores = unassignedstores;
        this.OtherStores = allstores;
        this.AllStores = allstores;

    }
}

export class Account {
    SAPAccountNumber: number;
    AccountName: string;
    Address: string;
    City: string;
    State: string;
    PostalCode: string;
    constructor(acctid: number, acctname: string, address: string, city: string, state: string, postalcode: string) {
        this.SAPAccountNumber = acctid;
        this.AccountName = acctname;
        this.Address = address;
        this.City = city;
        this.State = state;
        this.PostalCode = postalcode;
    }
}


export class AccountInput {
    MerchGroupID: number;
    WeekDay: number;
    constructor(merchGroupID: number, weekday: number) {
        this.MerchGroupID = merchGroupID;
        this.WeekDay = weekday;
    }
}

export class DispatchOutput {
    Result: string;
    ReturnStatus: number;
    Message: string;
    CorrelationID: string;
    StackTrace: string;
}

export class ResequenceInput {
    WeekDay: number;
    RouteID: number;
    MoveFrom: number;
    MoveTo: number;
    LastModifiedBy: string;
    constructor(weekday, routeID, moveFrom, moveTo, lastModifiedBy) {
        this.WeekDay = weekday;
        this.RouteID = routeID;
        this.MoveFrom = moveFrom;
        this.MoveTo = moveTo;
        this.LastModifiedBy = lastModifiedBy;
    }
}

export class RemoveStoreinput {
    WeekDay: number;
    RouteID: number;
    Sequence: number;
    LastModifiedBy: string;
    constructor(weekday, routeID, sequence, lastModifiedBy) {
        this.WeekDay = weekday;
        this.RouteID = routeID;
        this.Sequence = sequence;
        this.LastModifiedBy = lastModifiedBy;
    }
}

export class RouteListInput {

    MerchGroupID: number;
    WeekDay: number;

    constructor(merchGroupID: number, weekday: number) {
        this.MerchGroupID = merchGroupID;
        this.WeekDay = weekday;
    }
}

export class Route {

    RouteID: number;
    RouteName: string;
    GSN: string;

    constructor(routeid: number, routename: string, gsn: string) {
        this.RouteID = routeid;
        this.RouteName = routename;
        this.GSN = gsn;
    }
}


export class ReassignStoreInput {
    MerchGroupID: number;
    WeekDay: number;
    TargetRouteID: number;
    SourceRouteID: number;
    SAPAccountNumber: number;
    LastModifiedBy: string;
    Sequence: number;
    constructor(weekday, sequence, lastModifiedBy, merchGroupID, targetRouteID, sourceRouteID, sapAccountNumber) {
        this.MerchGroupID = merchGroupID;
        this.WeekDay = weekday;
        this.TargetRouteID = targetRouteID;
        this.SourceRouteID = sourceRouteID;
        this.SAPAccountNumber = sapAccountNumber;
        this.LastModifiedBy = lastModifiedBy;
        this.Sequence = sequence;
    }
}