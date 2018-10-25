export class MerchInfo {
    GSN: string;
    MerchName: string;
    FirstName: string;
    LastName: string;
    DefaultRouteID: number;
    MonRouteInfo: string;
    TueRouteInfo: string;
    WedRouteInfo: string;
    ThuRouteInfo: string;
    FriRouteInfo: string;
    SatRouteInfo: string;
    SunRouteInfo: string;
    Phone: string;
    Mon: boolean;
    Tues: boolean;
    Wed: boolean;
    Thu: boolean;
    Fri: boolean;
    Sat: boolean;
    Sun: boolean;
    IsDelete: boolean;
}

export class RouteData
{
    RouteID: number;
    RouteName: string;
    constructor(routeId:number, routeName:string)
    {
        this.RouteID = routeId;
        this.RouteName = routeName;
    }
}

export class MerchGroup {
    MerchGroupID: number;
    GroupName: string; 
    SAPBranchID: string;
    DefaultOwnerGSN: string;
    DefaultOwnerName: string; 
    LastModified: Date;
    LastModifiedBy: string;   
    CanUserDelete :boolean;
    IsDefault:boolean;  
    LoggedInUser:string;
}

export class MerchSetupDetailInput {
    GSN: string;
    MerchName: string;
    FirstName: string;
    LastName: string;
    DefaultRouteID: number;
    MonRouteID: number;
    TueRouteID: number;
    WedRouteID: number;
    ThuRouteID: number;
    FriRouteID: number;
    SatRouteID: number;
    SunRouteID: number;
    MerchGroupID: number;
    Phone: string;
    Mon: boolean;
    Tues: boolean;
    Wed: boolean;
    Thu: boolean;
    Fri: boolean;
    Sat: boolean;
    Sun: boolean;
    LastModifiedBy: string;

     constructor(gsn: string, merchName: string, firstName: string, lastName: string, defaultRouteID: number, 
     monRouteID: number, tueRouteID: number, wedRouteID: number, thuRouteID: number, friRouteID: number, 
     satRouteID: number, sunRouteID: number, merchGroupID: number, phone: string,
       mon: boolean, tues: boolean, wed: boolean, thu: boolean, fri: boolean, sat: boolean, sun: boolean, lastModifiedBy: string) {
       this.GSN = gsn;
       this.MerchName= merchName;
       this.FirstName = firstName;
       this.LastName = lastName;
       this.DefaultRouteID = defaultRouteID;
       this.MerchGroupID= merchGroupID;
       this.Phone= phone;
       this.Mon= mon;
       this.Tues = tues;
       this.Wed = wed;
       this.Thu = thu;
       this.Fri = fri;
       this.Sat = sat;
       this.Sun = sun;
       this.LastModifiedBy = lastModifiedBy;
       this.MonRouteID = monRouteID;
       this.TueRouteID = tueRouteID;
       this.WedRouteID = wedRouteID;
       this.ThuRouteID = thuRouteID;
       this.FriRouteID = friRouteID;
       this.SatRouteID = satRouteID;
       this.SunRouteID = sunRouteID;
    }
}

export class MerchDeleteInput{
    GSN: string;

    constructor(gsn: string){
        this.GSN = gsn;
    }
}

   export class RouteMerchandiser
    {
        RouteID:number;
        RouteName:string;
        DayOfWeek:number;
        GSN:string;
    }

    export class RoutesByDayInput{
        SAPBranchID: string;
        MerchGroupID:number;
        DayOfWeek:number;
        constructor(sapbranchid:string, merchgroupid:number, dayofweek:number)
        {
            this.SAPBranchID = sapbranchid;
            this.MerchGroupID = merchgroupid;
            this.DayOfWeek = dayofweek;
        }
    }