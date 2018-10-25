using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryTime.WebAPI.DataService
{
    class Constant
    {
        internal static class StoredProcedureName
        {
            public const string GetNonBreakRouteForToday = "Testing.pGetNonBreakRouteForToday";
            public const string GetDriverDeliveryPlan = "Operation.pGetDriverDeliveryPlan";
            public const string GetDeliveryByRoute = "Operation.pGetDeliveryByRoute";
            public const string ResetRoute = "Testing.pResetRouteDeliveryTime";
            public const string GetDeliveryByCustomerNumbers = "Operation.pGetDeliveryByCustomerNumbers";

            //public const string GetDisplayBuildWithLatestStatus = "Operation.pGetDisplayBuildWithLatestStatus";
            //public const string GetDisplayBuildWithLatestStatusByRouteID = "Operation.pGetDisplayBuildWithLatestStatusByRouteID";
            //public const string GetMerchBuildMaster = "Operation.pGetMerchBuildMaster";

            public const string InsertWebAPILog = "Setup.pInsertWebAPILog";

        }
    }
}
