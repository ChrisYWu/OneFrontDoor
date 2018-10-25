export class  StoreSignature {   
    ManagerName:string;
    SignatureName: string;
    ClientTime: string;
    ClientTimeZone: string;
    RelativeURL: string;
    AbsoluteURL: string;
    StorageAccount: string;
    Container: string;
    AccessLevel: string;
    ConnectionString: string;
    azureImageURL: string;
    constructor(managername:string = "Manager Name Not Available", sigName:string = "", clienttime:string = "", clientTimeZone:string="", 
    relativeURL:string="", absURL:string="", storageAcct:string="", container:string="", accesslevel:string="", connectStr:string="", azureImageUrl:string="")
    {
        this.ManagerName = managername;
        this.SignatureName = sigName;
        this.ClientTime = clienttime;
        this.ClientTimeZone = clientTimeZone;
        this.RelativeURL = relativeURL;
        this.AbsoluteURL = absURL;
        this.StorageAccount = storageAcct;
        this.Container = container;
        this.AccessLevel = accesslevel;
        this.ConnectionString = connectStr;
        this.azureImageURL = azureImageUrl;
    }
  }



   export class StoreDetails{
    CheckInTime:string;
    CheckOutTime:string;
    UserMileage: number;
    AtAccountTimeInMinute : number;
    TimeInStore: string;
    CasesHandeled: number;
    CasesInBackRoom: number;
    Comments:string;
    DriverName:string;
    DeliveryTime:string;
    StoreAddress:string;
    StoreImageURL:string;
    constructor(  checkInTime:string,checkOutTime:string,userMileage: number,atAccountTimeInMinute : number,timeInStore: string,casesHandeled: number,casesInBackRoom: number,comments:string,
    driverName:string,deliveryTime:string,storeAddress:string,storeImageURL:string)
    {
        this.CheckInTime = checkInTime;
        this.CheckOutTime = checkOutTime;
        this.UserMileage  =userMileage;
        this.AtAccountTimeInMinute = atAccountTimeInMinute;
        this.TimeInStore = timeInStore;
        this.CasesHandeled = casesHandeled;
        this.CasesInBackRoom  = casesInBackRoom;
        this.Comments = comments;
        this.DriverName = driverName;
        this.DeliveryTime = deliveryTime;
        this.StoreAddress = storeAddress;
        this.StoreImageURL = storeImageURL;
    }
  };