using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.Model
{

    public class DispatchOutput : IResponseInformation
    {
        public int Result { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }
    public class MerchandisersContainer : IResponseInformation
    {
        public List<RouteTileContainer> Routes { get; set; }
        public int? TaskCount { get; set; }
        public int? ScheduleDateCount { get; set; }

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class RouteTileContainer
    {
        public System.Int32 MerchGroupID { get; set; }

        public string GSN { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string AbsoluteURL { get; set; }

        public System.Int32 RouteID { get; set; }
        public string RouteName { get; set; }
        public DateTime DispatchDate { get; set; }
        public string LastModifiedBy { get; set; }
        public List<AccountsContainer> Stores { get; set; }


    }

    public class AccountsContainer
    {
        public System.Int64 AccountID { get; set; }
        public string AccountName { get; set; }
        public int Sequence { get; set; }
        public int? DisplayTaskCount { get; set; }
        public string CheckInGSN { get; set; }
        public string ActualArrival { get; set; }        
    }

    public class DispatchRawData
    {
        public DateTime DispatchDate { get; set; }
        public System.Int32 MerchGroupID { get; set; }
        public System.Int64 SAPAccountNumber { get; set; }
        public string Accountname { get; set; }
        public int Sequence { get; set; }
        public string GSN { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string AbsoluteURL { get; set; }
        public System.Int32 RouteID { get; set; }
        public string RouteName { get; set; }

        public DateTime LastModified { get; set; }

        public string LastModifiedBy { get; set; }
        public string CheckInGSN { get; set; }
        public string ActualArrival { get; set; }
        public int? DisplayTaskCount { get; set; }

    }

    public class DispatchRawDataOutput
    {
        public List<DispatchRawData> DisplayTabularData { get; set; }

        public int? ScheduleDateCount { get; set; }

    }


    public class DispatchInput
    {
        public DateTime DispatchDate { get; set; }
        public System.Int32 MerchGroupID { get; set; }

    }

    public class DispatchInputUser
    {
        public DateTime DispatchDate { get; set; }
        public System.Int32 MerchGroupID { get; set; }

        public String GSN { get; set; }
        public bool Reset { get; set; }

        public int TimeZoneOffsetToUTC { get; set; }

    }
    public class ResequenceInput
    {
        public DateTime DispatchDate { get; set; }
        public System.Int32 RouteID { get; set; }
        public System.Int32 MoveFrom { get; set; }
        public System.Int32 MoveTo { get; set; }
        public string LastModifiedBy { get; set; }


    }

    public class RemoveStoreInput
    {
        public DateTime DispatchDate { get; set; }
        public System.Int32 RouteID { get; set; }
        public System.Int32 Sequence { get; set; }
        public string LastModifiedBy { get; set; }


    }

    public class RouteListInput
    {
        public DateTime DispatchDate { get; set; }
        public System.Int32 MerchGroupID { get; set; }
    }

    public class RouteListExcludeCurrentInput
    {
        public DateTime DispatchDate { get; set; }
        public System.Int32 MerchGroupID { get; set; }

        public System.Int32 RouteID { get; set; }
    }

    public class Route
    {
        public System.Int32 RouteID { get; set; }
        public String RouteName { get; set; }
        public string GSN { get; set; }
    }


    public class RouteList: IResponseInformation
    {
        public List<Route> Routes { get; set; }
          public int? TaskCount { get; set; }

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class ReassignStoreInput
    {
        public DateTime DispatchDate { get; set; }
        public int Sequence { get; set; }
        public string LastModifiedBy { get; set; }
        public int MerchGroupID { get; set; }
        public string GSN { get; set; }
        public int TargetRouteID { get; set; }
        public int SourceRouteID { get; set; }
        public int SAPAccountNumber { get; set; }
    }

    public class MerchListContainer : IResponseInformation
    {

        public List<MerchandiserContainer> UnassignedMerchandiser { get; set; }
        public List<MerchandiserContainer> OtherUnassignedMerchandiser { get; set; }
        public int? TaskCount { get; set; }

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }


    }

    public class MerchandiserContainer
    {
        public string GSN { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string AbsoluteURL { get; set; }
        public string MerchGroupName { get; set; }

    }


    public class ReassignMerchInput
    {
        public DateTime DispatchDate { get; set; }
        public string LastModifiedBy { get; set; }
        public int MerchGroupID { get; set; }
        public string GSN { get; set; }
        public int RouteID { get; set; }
    
    }

    public class DispatchReady 
    {
        public int DispatchType { get; set; }
        
        public string ChangeNote { get; set; }

        public string GSN { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }

        public int RouteID { get; set; }
        public string RouteName { get; set; }

        public int Sequence { get; set; }

        public System.Int64 SAPAccountNumber { get; set; }
        public string AccountName { get; set; }


    }

    public class DispatchReadyContainer : IResponseInformation
    {
        public List<DispatchReady> DispatchReadyListItems { get; set; }

        public int? TaskCount { get; set; }

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }

    }

    public class DispatchFinalResult
    {
        public string DispatchInfo { get; set; }

        public int BatchID { get; set; }
    }
    public class DispatchResultsContainer : IResponseInformation
    {

        public List<DispatchFinalResult> DispatchFinalResult { get; set; }

        public int? TaskCount { get; set; }

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }

    }

    public class DispatchFinalInput
    {
        public DateTime DispatchDate { get; set; }
        public string ReleaseBy { get; set; }
        public int MerchGroupID { get; set; }
        public string DispatchNote { get; set; }
  
    }

    public class DispatchAllListContainer : IResponseInformation
    {

        public MerchandisersContainer Dispatches { get; set; }
        public StoresContainer Stores { get; set; }
        //public RouteList Routes { get; set; }
        public MerchListContainer Merchandisers { get; set; }
        
        public int? TaskCount { get; set; }      

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }


    }

    public class DispatchHistory
    {
        private DateTime _releaseTime;
    
        public DateTime ReleaseTime
        {
            get { return _releaseTime; }
            set
            {
                _releaseTime = value.ToLocalTime();
             
            }
        }   
        public string BatchNote { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }





    }
    public class DispatchHistoryContainer : IResponseInformation
    {

        public List<DispatchHistory> DispatchHistory { get; set; }
        public int? TaskCount { get; set; }

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }


    }


    public class ScheduleStatusOutput : IResponseInformation
    {

        public string StatusText { get; set; }
        public string StatusBackGround { get; set; }
        public bool EnableDispatch { get; set; }
        public bool EnableReset { get; set; }
        public string GMTTime { get; set; }
        public int? TaskCount { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }

    }

    public class ScheduleStatusInput
    {
        public int MerchGroupID { get; set; }
        public DateTime DispatchDate { get; set; }

    }





}
