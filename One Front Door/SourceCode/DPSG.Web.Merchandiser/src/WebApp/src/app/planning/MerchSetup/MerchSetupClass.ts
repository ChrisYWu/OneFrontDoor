export class MerchInfo {
    GSN: string;
    MerchName: string;
    FirstName: string;
    LastName: string;
    DefaultRouteID: number;
    Phone: string;
    Mon: boolean;
    Tues: boolean;
    Wed: boolean;
    Thu: boolean;
    Fri: boolean;
    Sat: boolean;
    Sun: boolean;
}

export class RouteData
{
    RouteID: number;
    RouteName: string;
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

     constructor(gsn: string, merchName: string, firstName: string, lastName: string, defaultRouteID: number, merchGroupID: number, phone: string,
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
    }
}