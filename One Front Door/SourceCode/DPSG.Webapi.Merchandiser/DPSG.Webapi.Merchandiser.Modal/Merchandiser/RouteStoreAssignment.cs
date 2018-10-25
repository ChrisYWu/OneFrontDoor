using DPSG.Webapi.Merchandiser.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.Modal
{
    public class RouteStoreAssignment
    {
    }

 

    public class RSInput
    {
        public int MerchGroupID { get; set; }
        public int WeekDay { get; set; }
    }

    public class StoreInput
    {
        public System.Int32 MerchGroupID { get; set; }
        public int WeekDay { get; set; }
    }

    public class RouteInput
    { 
        public System.Int32 MerchGroupID { get; set; }
        public int WeekDay { get; set; }
    }
    public class RouteDetail
    {
        public System.Int32 RouteID { get; set; }
        public String RouteName { get; set; }   
    }

    public class RemoveStoreInputData
    {
        public int WeekDay { get; set; }
        public System.Int32 RouteID { get; set; }
        public System.Int32 Sequence { get; set; }
        public string LastModifiedBy { get; set; }
    }

    public class ReassignStoreInputData
    {
        public int MerchGroupID { get; set; }
        public int WeekDay { get; set; }
        public int TargetRouteID { get; set; }
        public int SourceRouteID { get; set; }
        public int SAPAccountNumber { get; set; }      
        public string LastModifiedBy { get; set; }
        public int Sequence { get; set; }
    }


    public class RoutesList : IResponseInformation
    {
        public List<RouteDetail> Routes { get; set; }
        public int? TaskCount { get; set; }

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class StoreWeekDayInput
    {
        public int MerchGroupID { get; set; }
        public int Weekday { get; set; }     
        public int RouteID { get; set; }        
        public Int64 SAPAccountNumber { get; set; }
        public string LastModifiedBy { get; set; }
    }

    public class StoreResequenceInput
    {
        public int WeekDay { get; set; }
        public System.Int32 RouteID { get; set; }
        public System.Int32 MoveFrom { get; set; }
        public System.Int32 MoveTo { get; set; }
        public string LastModifiedBy { get; set; }

    }

    public class StoreWeekDayOutput : IResponseInformation
    {
        public int Result { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class RouteStoreRawData
    {
        public System.Int32 MerchGroupID { get; set; }
        public System.Int64? SAPAccountNumber { get; set; }
        public string Accountname { get; set; }
        public int? Sequence { get; set; }        
        public System.Int32? RouteID { get; set; }
        public string RouteName { get; set; }
    }

    public class RSOutput : IResponseInformation
    {
        public List<RouteTile> RoutesTile { get; set; }
        public List<RouteDetail> Routes { get; set; }
        public List<Store> UnassignedStores { get; set; }
        public List<Store> AllStores { get; set; }
      
        public int? TaskCount { get; set; }

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }


    public class RouteTile
    {
        public System.Int32 MerchGroupID { get; set; }
        public System.Int32? RouteID { get; set; }
        public string RouteName { get; set; }
        public List<Account> Stores { get; set; }
    }

    public class Account
    {
        public System.Int64? AccountID { get; set; }
        public string AccountName { get; set; }
        public int? Sequence { get; set; }
    }

    
}
