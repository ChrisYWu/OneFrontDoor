using DPSG.Webapi.Merchandiser.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.Modal
{
    class MerchSetupModel
    {
    }

    public class MerchDetailContainer : IResponseInformation
    {
        public MerchInfo MerchUser { get; set; }
        public RouteData Route { get; set; }
        public int Result { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class MerchSetupContainer : IResponseInformation
    {
        public List<MerchInfo> MerchUsers { get; set; }
        public List<RouteData> Routes { get; set; }
        public MerchInfo MerchUser { get; set; }
        public RouteData Route { get; set; }
        public List<RouteData> RoutesAll { get; set; }
        public int Result { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class MerchListInput
    {
        public string SAPBranchID { get; set; }
        public int? MerchGroupID { get; set; }

    }

    public class RoutesByDayInput
    {
        public string SAPBranchID { get; set; }
        public int? MerchGroupID { get; set; }
        public int? DayOfWeek { get; set; }

    }

    public class RouteDataContainer : IResponseInformation
    {
        public List<RouteData> Routes { get; set; }
        public int Result { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }
    public class MerchInfo
    {
        public string GSN { get; set; }
        public string MerchName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int? DefaultRouteID { get; set; }      
        public string Phone { get; set; }
        public bool Mon { get; set; }
        public bool Tues { get; set; }
        public bool Wed { get; set; }
        public bool Thu { get; set; }
        public bool Fri { get; set; }
        public bool Sat { get; set; }
        public bool Sun { get; set; }

        public string MonRouteInfo { get; set; }
        public string TueRouteInfo { get; set; }
        public string WedRouteInfo { get; set; }
        public string ThuRouteInfo { get; set; }
        public string FriRouteInfo { get; set; }
        public string SatRouteInfo { get; set; }
        public string SunRouteInfo { get; set; }

        public int IsDelete { get; set; }
    }

    public class RouteData
    {
        public int RouteID { get; set; }
        public string RouteName { get; set; }
    }


    public class MerchSetupDetailInput
    {
        public string GSN { get; set; }
        public string MerchName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int? DefaultRouteID { get; set; }
        public int MerchGroupID { get; set; }
        public string Phone { get; set; }
        public bool Mon { get; set; }
        public bool Tues { get; set; }
        public bool Wed { get; set; }
        public bool Thu { get; set; }
        public bool Fri { get; set; }
        public bool Sat { get; set; }
        public bool Sun { get; set; }
        public string LastModifiedBy { get; set; }
        public int MonRouteID { get; set; }
        public int TueRouteID { get; set; }
        public int WedRouteID { get; set; }
        public int ThuRouteID { get; set; }
        public int FriRouteID { get; set; }
        public int SatRouteID { get; set; }
        public int SunRouteID { get; set; }
        
    }

    public class MerchSetupDetailOutput : IResponseInformation
    {
        public int Result { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }
}

