using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.Model
{
    public class MerchandisingProgress
    {
        public string GSN { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string AbsoluteURL { get; set; }
        public string RouteName { get; set; }
        public string MileageTotalLabel { get; set; }
        public string MilageAdhocLabel { get; set; }
        public string TotalTimeLabel { get; set; }
        public string RouteStatusLabel { get; set; }
        public List<MerchandisingStop> Stops { get; set; }
    }

    public class MerchandisingProgressRAW
    {
        public string GSN { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string AbsoluteURL { get; set; }
        public string RouteName { get; set; }
        public string MileageTotalLabel { get; set; }
        public string MilageAdhocLabel { get; set; }
        public string TotalTimeLabel { get; set; }
        public string RouteStatusLabel { get; set; }
    }


    public class MerchandisingStop
    {
        public int SequenceOrder { get; set; }
        public string SequenceLabel { get; set; }
        public string AccountName { get; set; }
        public string TimeSpan { get; set; }
        public string DriveTime { get; set; }
        public string Mileage { get; set; }
        public string EndDriveTime { get; set; }
        public string EndMileage { get; set; }
        public string ConnectorType { get; set; }
        public string EndConnectorType { get; set; }
        public string DisplayBuildStatus { get; set; }
        public Int32 MerchStopID { get; set; }
        public string DNSReason { get; set; }
    }

    public class MerchandisingStopRaw
    {
        public string GSN { get; set; }
        public int SequenceOrder { get; set; }
        public string SequenceLabel { get; set; }
        public string AccountName { get; set; }
        public string TimeSpan { get; set; }
        public string DriveTime { get; set; }
        public string Mileage { get; set; }
        public string ConnectorType { get; set; }
        public string DisplayBuildStatus { get; set; }
        public Int32 MerchStopID { get; set; }
        public string DNSReason { get; set; }
    }

    public class MonitorLandingOutput : List<MerchandisingProgress>, IResponseInformation
    {
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class MonitorLandingInput
    {
        public DateTime DispatchDate { get; set; }
        public System.Int32 MerchGroupID { get; set; }
        public string FilterPhrase { get; set; }
    }

    public class MonitorDetailOutput : IResponseInformation
    {
        public List<MonitorDetail> Details { get; set; }
        public List<MonitorStorePicture> StorePictures { get; set; }
        public List<MonitorStoreSignature> StoreSignature { get; set; }
        public List<DisplayBuildExecution> BuildExecution { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class MonitorDetail
    {
        public string CheckInTime { get; set; }
        public string CheckOutTime { get; set; }
        public string DeliveryTime { get; set;}
        public string DriverName { get; set; }
        public decimal UserMileage { get; set; }
        public int? AtAccountTimeInMinute { get; set; }
        public string TimeInStore { get; set; }
        public int CasesHandeled { get; set; }
        public int CasesInBackRoom { get; set; }
        public string Comments { get; set; }

        public string StoreImageURL { get; set; }

        public string StoreAddress { get; set; }
        
    }


    public class StrogeImage
    {
        public DateTime ClientTime { get; set; }
        public string ClientTimeZone { get; set; }
        public string AbsoluteURL { get; set; }
        public int? ContainerID { get; set; }
        public string ReadSAS { get; set; }
        public bool? IsReadSASValid { get; set; }
    }

    public class MonitorStorePicture : StrogeImage
    {
        public string Caption { get; set; }
    }

    public class MonitorStoreSignature : StrogeImage
    {
        public string ManagerName { get; set; }
        public string SignatureName { get; set; }
    }

    public class DisplayBuildExecution : StrogeImage
    {
        public string PromotionName { get; set; }
        public string BuildStatus { get; set; }
        public string RefusalReason { get; set; }
        public string BuildNote { get; set; }
        public string ImageName { get; set; }
    }

    //   ManagerName, SignatureName, sig.ClientTime, sig.ClientTimeZone, ab.RelativeURL, ab.AbsoluteURL, abc.StorageAccount, abc.Container, abc.AccessLevel, abc.ConnectionString

}
