export class MileageInput{
  MerchGroupIDs: string;
  FromDate: Date;
  ToDate: Date;
  
  constructor(merchGroupIDs: string, fromDate: Date, toDate: Date) {
    this.MerchGroupIDs = merchGroupIDs;
    this.FromDate = fromDate;
    this.ToDate = toDate;
  }
}

export class RouteInput{
  RouteNumber: string;
  DeliveryDate: Date;
  
  constructor(routeNumber: string, deliveryDate: Date) {
    this.RouteNumber = routeNumber;
    this.DeliveryDate = deliveryDate;
  }
}

export class Mileage
{
  Branch: string;
  GroupName: string;
  Supervisor: string;
  Merchandiser: string;
  Date: string;
  ProposedMiles: number;
  ActualMiles: number;
  IsAdhoc: number;
}

export class RouteStop
{
    DeliveryDate: Date;
    StopSequence: number;
    StopType: string;
    Store: string;
    FormattedPlannedDelivery: string;
    FormattedActualArrival: string;
    FormattedEstimatedArrival: string
}

export class UserMerchGroupInput {
  UserGSN: string;

  constructor(usrGSN: string) {
    this.UserGSN = usrGSN;
  }
}

export class UserMerchGroup
{
  id: number;
  name: string;
}