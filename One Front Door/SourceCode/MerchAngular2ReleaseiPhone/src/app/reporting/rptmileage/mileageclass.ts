export class MileageInput {
  MerchGroupIDs: string;
  FromDate: Date;
  ToDate: Date;

  constructor(merchGroupIDs: string, fromDate: Date, toDate: Date) {
    this.MerchGroupIDs = merchGroupIDs;
    this.FromDate = fromDate;
    this.ToDate = toDate;
  }
}

export class Mileage {
  Branch: string;
  GroupName: string;
  Supervisor: string;
  Merchandiser: string;
  Date: string;
  CalculatedMiles: number;
  AdjustedMiles: number;
  ShortReason: string;
  LongReason: string;
}

export class UserMerchGroupInput {
  UserGSN: string;

  constructor(usrGSN: string) {
    this.UserGSN = usrGSN;
  }
}

export class UserMerchGroup {
  id: number;
  name: string;
}
