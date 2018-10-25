export class MerchBranch {
    SAPBranchID: string;
    BranchName: string;
    IsDefault: boolean;
    // constructor(bracnchid:string, branchname:string, isdefault:boolean)
    // {
    //     this.SAPBranchID = bracnchid;
    //     this.BranchName = branchname;
    //     this.IsDefault = isdefault;
    // }
}

export class MerchGroup {
    MerchGroupID: number;
    GroupName: string;
    SAPBranchID: string;
    DefaultOwnerGSN: string;
    DefaultOwnerName: string;
    LastModified: Date;
    LastModifiedBy: string;
    CanUserDelete: boolean;
    IsDefault: boolean;
    LoggedInUser: string;
    // constructor(merchgroupid:number, groupname:string, branchid:string, defaultownergsn:string, default)
    // {

    // }

}
export class MerchGroupsInput {
    SAPBranchID: string;
    constructor(sapbranchID: string) {
        this.SAPBranchID = sapbranchID;
    }
}

export class MerchGroupDetail {
    MerchGroupID: number;
    GroupName: string;
    DefaultOwnerGSN: string;
    DefaultOwnerName: string;
    LastModified: Date;
    LastModifiedBy: string;
    Routes: MerchGroupRoute[];
}

export class MerchGroupDetailInput {
    SAPBranchID: string;
    MerchGroupID: number;
    constructor(sapbranchID: string, merchgroupId: number) {
        this.SAPBranchID = sapbranchID;
        this.MerchGroupID = merchgroupId;
    }
}

export class MerchGroupInput {
    SAPBranchID: string;
    MerchGroupID: number;
    GroupName: string;
    DefaultOwnerGSN: string;
    DefaultOwnerName: string;
    GSN: string;
    Routes: MerchGroupRoute[];

    constructor(sapbranchID: string, merchgroupId: number, groupName: string, ownerGSN: string, ownerName: string, gsn: string, routes: MerchGroupRoute[]) {
        this.SAPBranchID = sapbranchID;
        this.MerchGroupID = merchgroupId;
        this.GroupName = groupName;
        this.DefaultOwnerGSN = ownerGSN;
        this.DefaultOwnerName = ownerName;
        this.GSN = gsn;
        this.Routes = routes;
    }

}
export class MerchGroupRoute {
    RouteID: number;
    RouteName: string;
    LastModified: Date;
    LastModifiedBy: string;
    IsRouteModified: boolean;
    IsRouteDeleted: boolean;
    IsEditRoute: boolean;
    IsRouteNameExists: boolean;
    CanUserDelete: boolean;
    IsRequired: boolean;
}

export class MerchBranchInput {
    GSN: string;
    constructor(gsn: string) {
        this.GSN = gsn;

    }

}

export class MerchBranches {
    Branches: MerchBranch[];
    MerchGroupList: MerchGroup[];
    constructor(branches: MerchBranch[], merchgroupList: MerchGroup[]) {
        this.Branches = branches;
        this.MerchGroupList = merchgroupList;
    }
}

export class MerchGroupCheckOutput {
    IsGroupNameExists: boolean;
    IsRouteNameExists: boolean;

}

export class MerchGroupCheckInput {
    SAPBranchID: string
    GroupName: string
    RouteName: string
    Mode: string
    constructor(sapbranchID: string, groupName: string, routeName: string, mode: string) {
        this.SAPBranchID = sapbranchID;
        this.GroupName = groupName;
        this.RouteName = routeName;
        this.Mode = mode;
    }

}



export class User {
    DisplayName: string;
    mail: string;
    sAMAccountName: string;
    givenName: string;
    sn: string;
    initials: string;
    userPrincipalName: string;
    title: string;
}


export class StoreInfo {
    AccountName: string;
    AccountNumber: number;
    Address: string;
    City: string;
    State: string;
    PostalCode: string;
    ImageURL: string;

}

export class RouteInfo {
    RouteID: number;
    RouteName: string;

}

export class StoreSetupDOW {
    Weeknumber: number;
    WeekName: string;
    FirstPull: boolean;
    SecondPull: boolean;
    RouteName: string;
    RouteNameBackup: string;
}

export class StoreSetupDetailContainer {
    StoreDetail: StoreInfo;
    Detail: RouteInfo;
    WeekDays: StoreSetupDOW[];
}

export class StoreDeleteInput {
    SAPAccountNumber: number;
    MerchGroupID: number;
    GSN: string;

    constructor(sapAccountNumber: number, merchgroupID: number, gsn: string) {
        this.SAPAccountNumber = sapAccountNumber;
        this.MerchGroupID = merchgroupID;
        this.GSN = gsn;
    }
}

export class StoreRemovalDispatchWarning {
    DispatchDate: string;
    RouteName: string;
    SequenceList: string;
    Note: string;
    Action: string;
}

export class RouteRemovalInput {
    RouteID: number;
    MerchGroupID: number;
    GSN: string;

    constructor(routeID:number, merchGroupID:number, gsn:string)
    {
        this.RouteID = routeID;
        this.MerchGroupID = merchGroupID;
        this.GSN = gsn;
    }
}

export class RouteRemovalWarning {
    DispatchDate: Date;
    Action: string;
    PDNote: string;
} 


