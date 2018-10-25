export class MerchException{
  AppliationID: number;
  SeverityID: number;
  Source: string;
  UserName: string;
  Detail: string;
  StackTrace: string;
  LastModified: string;
    
  constructor(appliationID: number, severityID: number, source: string, userName: string, detail: string, stackTrace: string, lastModified: string ) {
    this.AppliationID = appliationID;
    this.SeverityID = severityID;
    this.Source = source;
    this.UserName= userName;
    this.Detail = detail;
    this.StackTrace = stackTrace;
    this.LastModified = lastModified;
  }
}