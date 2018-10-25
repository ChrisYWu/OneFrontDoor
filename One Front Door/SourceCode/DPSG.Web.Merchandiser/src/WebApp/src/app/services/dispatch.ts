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


    constructor(gsn: string,
        firstName: string,
        lastName:string,
        routeID: number,
        precedence: number,
        merchGroupID: number,
        dispatchDate: Date,
        lastModifiedBy: string,
        stores: Store[]) {
        this.RouteID = routeID;
        this.GSN = gsn;
        this.FirstName = firstName;
        this.LastName = lastName;
        this.MerchGroupID = merchGroupID;
        this.Stores = stores;
        this.DispatchDate = dispatchDate;
        this.LastModifiedBy = lastModifiedBy;
    }
}
export class Store {
    AccountID: number;
    AccountName: string;
    Sequence: number;
    PullNumber: string;
    constructor(acctID: number, accountName: string, sequence: number, pullnumber:string) {
        this.AccountID = acctID;
        this.AccountName = accountName;
        this.Sequence = sequence;
        this.PullNumber = pullnumber;

    }
}


export class DispatchInput {
    GSN: string;
    MerchGroupID: number;
    DispatchDate: Date;
    constructor(gsn: string, merchGroupID: number, dispatchDate: Date) {
        this.GSN = gsn;
        this.DispatchDate = dispatchDate;
        this.MerchGroupID = merchGroupID;
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
    City:string;
    State:string;
    PostalCode:string;
    constructor(acctid:number, acctname:string, address:string, city:string, state:string, postalcode:string)
    {
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
    DispatchDate: Date;
    constructor(merchGroupID: number, dispatchDate: Date) {
        this.DispatchDate = dispatchDate;
        this.MerchGroupID = merchGroupID;
    }
}

export class StorePreDispatch {
    DispatchDate: Date;
    MerchGroupID: number;
    RouteID: number;
    GSN: string;
    SAPAccountNumber: number;
    LastModifiedBy: string;

    constructor(dispatchDate: Date, merchGroupID: number, routeID: number, gsn: string, sapAccountNumber: number, lastModifiedBy:string) {
        this.DispatchDate = dispatchDate;
        this.MerchGroupID = merchGroupID;
        this.RouteID = routeID;
        this.GSN = gsn;
        this.SAPAccountNumber = sapAccountNumber;
        this.LastModifiedBy = lastModifiedBy;
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
    DispatchDate: Date;
    RouteID: number;
    MoveFrom: number;
    MoveTo: number;
    LastModifiedBy: string;
    constructor(dispDate, routeID, moveFrom, moveTo, lastModifiedBy) {
        this.DispatchDate = dispDate;
        this.RouteID = routeID;
        this.MoveFrom = moveFrom;
        this.MoveTo = moveTo;
        this.LastModifiedBy = lastModifiedBy;
    }
}

export class RemoveStoreinput {
    DispatchDate: Date;
    RouteID: number;
    Sequence: number;
    LastModifiedBy: string;
    constructor(dispDate, routeID, sequence, lastModifiedBy) {
        this.DispatchDate = dispDate;
        this.RouteID = routeID;
        this.Sequence = sequence;
        this.LastModifiedBy = lastModifiedBy;
    }
}

export class RouteListInput {

    DispatchDate: Date;
    MerchGroupID: number;
 
    constructor(dispatchDate: Date, merchGroupID: number) {
        this.DispatchDate = dispatchDate;
        this.MerchGroupID = merchGroupID;
    }
}
export class RouteListExcludeCurrentInput {

    DispatchDate: Date;
    MerchGroupID: number;
    RouteID: number;
 
    constructor(dispatchDate: Date, merchGroupID: number, routeID) {
        this.DispatchDate = dispatchDate;
        this.MerchGroupID = merchGroupID;
        this.RouteID = routeID;
    }
}


export class Route {

    RouteID: number;
    RouteName: string;
    GSN: string;

    constructor(routeid: number, routename: string, gsn:string) {
        this.RouteID = routeid;
        this.RouteName = routename;
        this.GSN = gsn;
    }
}


export class ReassignStoreInput {
    DispatchDate: Date;
    Sequence: number;
    LastModifiedBy: string;
    MerchGroupID: number;
    GSN: string;
    TargetRouteID: number;
    SourceRouteID: number;
    SAPAccountNumber: number;
    constructor(dispDate, sequence, lastModifiedBy, merchGroupID, gsn, targetRouteID, sourceRouteID, sapAccountNumber) {
        this.DispatchDate = dispDate;
        this.Sequence = sequence;
        this.LastModifiedBy = lastModifiedBy;
        this.MerchGroupID = merchGroupID;
        this.GSN = gsn;
        this.TargetRouteID = targetRouteID;
        this.SourceRouteID = sourceRouteID;
        this.SAPAccountNumber = sapAccountNumber;
    }
}


export class Merchandiser {
    GSN: string;
    FirstName: string;
    LastName: string;
    constructor(gsn: string, fname: string, lname: string) {
        this.GSN = gsn;
        this.FirstName = fname;
        this.LastName = lname;
    }
}

export class ReassignMerchInput {
    DispatchDate: Date;
    LastModifiedBy: string;
    MerchGroupID: number;
    GSN: string;
    RouteID: number;
    constructor(dispDate, lastModifiedBy, merchGroupID, gsn, routeID) {
        this.DispatchDate = dispDate;
        this.LastModifiedBy = lastModifiedBy;
        this.MerchGroupID = merchGroupID;
        this.GSN = gsn;
        this.RouteID = routeID;
    }
}

 export class DispatchReady 
    {
        DispatchType:number;
        ChangeNote: string;
        GSN: string;
        LastName:string;
        FirstNam:string;
        RouteID:number;
        Sequence:number;
        SAPAccountNumber:number;
        AccountName:string;
        constructor(disptype:number,changenote:string, gsn:string,lastname:string,firstname:string,routeid:number,sequence:number, sapacctno:number, accoutname:string)
        {
            this.DispatchType = disptype;
            this.ChangeNote = changenote;
            this.GSN = gsn;
            this.LastName = lastname;
            this.FirstNam = firstname;
            this.RouteID = routeid;
            this.Sequence = sequence;
            this.SAPAccountNumber = sapacctno;
            this.AccountName  = accoutname;
        }


    }
  export class DispatchFinalInput
    {
        DispatchDate:Date;
        ReleaseBy:string;
        MerchGroupID:number;
        DispatchNote:string;
        constructor(dispdate:Date, releaseby:string, merchgroupid:number, dispatchnote:string){
            this.DispatchDate = dispdate;
            this.ReleaseBy = releaseby;
            this.MerchGroupID = merchgroupid;
            this.DispatchNote = dispatchnote;
        }
  
    }

    export class DispatchFinalResult{
        DispatchInfo:string;
        BatchID:number;

        constructor(dispatchinfo:string, batchid:number){
            this.DispatchInfo = dispatchinfo;
            this.BatchID = batchid;
        }
    }

 export class DispatchHistory{
        BatchNote:string;
        ReleaseTime:Date;
        FirstName:string;
        LastName:string;

        constructor(batchnote:string, releasetime:Date, firstname:string, lastname:string){
            this.BatchNote = batchnote;
            this.ReleaseTime = releasetime;
            this.FirstName = firstname;
            this.LastName = lastname;
        }
    }

