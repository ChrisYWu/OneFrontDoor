using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.Model
{
    public class MerchBranchInput
    {
        public string GSN { get; set; }

    }

    public class MerchBranch
    {
        public string SAPBranchID { get; set; }
        public string BranchName { get; set; }
        public Boolean IsDefault { get; set; }

    }

    public class MerchBranchOutput : IResponseInformation
    {
        public List<MerchBranch> Branches { get; set; }
        public List<MerchGroup> MerchGroupList { get; set; }

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class MerchGroupInput
    {
        public string SAPBranchID { get; set; }
        public int? MerchGroupID { get; set; }
        public string GroupName { get; set; }
        public string DefaultOwnerGSN { get; set; }
        public string DefaultOwnerName { get; set; }
        public string GSN { get; set; }

        public List<MerchGroupRoute> Routes { get; set; }
    }


    public class MerchGroupsInput
    {
        public string SAPBranchID { get; set; }

    }

    public class MerchGroup
    {
        public string SAPBranchID { get; set; }
        public int? MerchGroupID { get; set; }
        public string GroupName { get; set; }
        public string DefaultOwnerGSN { get; set; }
        public string DefaultOwnerName { get; set; }
        public DateTime LastModified { get; set; }
        public string LastModifiedBy { get; set; }
        public bool? CanUserDelete { get; set; }
        public Boolean IsDefault { get; set; }

    }

    public class MerchGroups : IResponseInformation
    {
        public List<MerchGroup> MerchGroupList { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class MerchGroupDetailInput
    {
        public string SAPBranchID { get; set; }
        public int? MerchGroupID { get; set; }

    }

    public class MerchGroupDetail : IResponseInformation
    {
        public int? MerchGroupID { get; set; }
        public string GroupName { get; set; }
        public string DefaultOwnerGSN { get; set; }
        public string DefaultOwnerName { get; set; }
        public DateTime LastModified { get; set; }
        public string LastModifiedBy { get; set; }
        public List<MerchGroupRoute> Routes { get; set; }

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }

    }

    public class MerchGroupRoute
    {
        public int? RouteID { get; set; }
        public string RouteName { get; set; }
        public DateTime? LastModified { get; set; }
        public string LastModifiedBy { get; set; }
        public bool? IsRouteModified { get; set; }
        public bool? IsRouteDeleted { get; set; }
        public bool? CanUserDelete { get; set; }

    }

    public class MerchGroupOutput : IResponseInformation
    {
        public int? NewGroupID { get; set; }
        public int Result { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class MerchGroupCheckInput
    {
        public string SAPBranchID { get; set; }
        public string Name { get; set; }
        public string Mode { get; set; }



    }

    public class MerchGroupCheckOutput : IResponseInformation
    {
        public bool? IsGroupNameExists { get; set; }
        public bool? IsRouteNameExists { get; set; }

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }


    }

    public class User
    {
        public string DisplayName { get; set; }
        public string mail { get; set; }
        public string sAMAccountName { get; set; }

        public string givenName { get; set; }
        public string sn { get; set; }
        public string initials { get; set; }

        public string userPrincipalName { get; set; }
        public string title { get; set; }
    }

    public class UserInput
    {
        public string Name { get; set; }
    }


    public class UsersOutput : IResponseInformation
    {
        public List<User> Users { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class StoresOutput : IResponseInformation
    {
        public List<StoreInfo> Stores { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class StoreLookupInput
    {
        public string SAPBranchID { get; set; }
        public int MerchGroupID { get; set; }
        public string SearchName { get; set; }

    }
    public class StoreInfo : Store
    {

        public string City { get; set; }
        public string State { get; set; }
        public string PostalCode { get; set; }
        public string ImageURL { get; set; }
        public int IsDelete { get; set; }
    }

    public class RouteInfo
    {
        public int RouteID { get; set; }
        public string RouteName { get; set; }
    }

    public class StoreListInput
    {
        public string SAPBranchID { get; set; }
        public int? MerchGroupID { get; set; }

    }



    public class RouteOutput : IResponseInformation
    {
        public List<RouteInfo> Routes { get; set; }

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class StoreSetupDOW
    {
        public int Weeknumber { get; set; }
        public string WeekName { get; set; }
        public bool FirstPull { get; set; }
        public bool SecondPull { get; set; }
        public string RouteName { get; set; }
    }

    public class StoreSetupDetailContainer : IResponseInformation
    {
        public StoreInfo StoreDetail { get; set; }
        public RouteInfo Detail { get; set; }
        public List<StoreSetupDOW> WeekDays { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }


    public class StoreSetUpDetailInput
    {
        public string SAPBranchID { get; set; }
        public int? MerchGroupID { get; set; }
        public System.Int64 SAPAccountNumber { get; set; }
        public int? DefaultRouteID { get; set; }
        public List<StoreSetupDOW> WeekDays { get; set; }
        public string GSN { get; set; }
        public string WeekDaysXML { get; set; }
    }

    public class StoreSetUpDetailOutput : IResponseInformation
    {
        public int Result { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class StoreSetupContainer : IResponseInformation
    {
        public List<StoreInfo> Stores { get; set; }
        public List<RouteInfo> Routes { get; set; }
        public StoreInfo StoreDetail { get; set; }
        public RouteInfo RouteDetail { get; set; }
        public List<StoreSetupDOW> WeekDays { get; set; }

        public int Result { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class ImpactedPlan
    {
        public int Number { get; set; }
        public string DateName { get; set; }
        public string RouteName { get; set; }
        public int Sequence { get; set; }
        public string Note { get; set; }
    }

    public class ImpactedDipatch
    {
        public string DispatchDate {get; set;}
        public string RouteName { get; set; }
        public string SequenceList { get; set; }
        public string PDNote { get; set; }
        public string Action { get; set; }
    }

    public class RemoveStoreWarning : IResponseInformation
    {
        public List<ImpactedPlan> PlanChanges { get; set; }
        public List<ImpactedDipatch> DispatchChanges { get; set; }
        public int Result { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class DeleteRouteDispatchImpact
    {
        public DateTime DispatchDate { get; set; }
        public string Action { get; set; }
        public string PDNote { get; set; }
    }

    public class DeleteRouteWarning : IResponseInformation
    {
        public List<DeleteRouteDispatchImpact> DispatchChanges { get; set; }
        public int Result { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class StoreDeleteInput
    {
        public System.Int64 SAPAccountNumber { get; set; }
        public int MerchGroupID { get; set; }
        public string GSN { get; set; }
    }

    public class RouteDeleteInput
    {
        public int RouteID { get; set; }
        public int MerchGroupID { get; set; }
        public string GSN { get; set; }
    }


    public class StoreDeleteOutput : IResponseInformation
    {
        public int Result { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }

    }

    public class RouteDeleteOutput : IResponseInformation
    {
        public int Result { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }

    }

    public class MerchDeleteInput
    {
        public string GSN { get; set; }
    }

    public class MerchDeleteOutput : IResponseInformation
    {
        public int Result { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }

    }

}
