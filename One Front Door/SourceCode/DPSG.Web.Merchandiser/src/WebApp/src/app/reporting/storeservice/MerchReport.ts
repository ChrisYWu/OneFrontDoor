export class StoreServiceInput {
    MerchGroupIDs: string;
    FromDate: Date;
    ToDate: Date;

    constructor(merchGroupIDs: string, fromDate: Date, toDate: Date) {
        this.MerchGroupIDs = merchGroupIDs;
        this.FromDate = fromDate;
        this.ToDate = toDate;
    }
}

export class StoreService {
    Branch: string;
    Merchandiser: string;
    Date: string;
    Chain: string;
    StoreName: string;
    StartTime: string;
    EndTime: string;
    ManagerName: string;
    ManagerSignature: string;
    CasesWorked: number;
    CasesInBackStop: number;
    StorePics: string;
    PicsLocation: string;
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

export class ImageInput {
    BlobIDs: string;

    constructor(blobid: string) {
        this.BlobIDs = blobid;
    }
}

export class ImageDetail {
    AbsoluteURL: string;
    ContainerID: number;
    ReadSAS: string;
    IsReadSASValid: boolean;
}

export class ImageURLInput {
    AbsoluteURL: string;
    ContainerID: number;
    ReadSAS: string;
    IsReadSASValid: boolean;

    constructor(absoluteURL: string, containerID: number, readSAS: string, isReadSASValid: boolean) {
        this.AbsoluteURL = absoluteURL;
        this.ContainerID = containerID;
        this.ReadSAS = readSAS;
        this.IsReadSASValid = isReadSASValid;
    }
}

export class Dictionary {
    [Key: number] : string;
}

export class ExtendReadSASInput {
    ContainerID;
}
