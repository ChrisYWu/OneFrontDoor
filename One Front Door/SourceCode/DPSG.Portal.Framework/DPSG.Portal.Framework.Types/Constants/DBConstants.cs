using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types.Constants
{
    public class DBConstants
    {
        public const string DB_PROC_MODE_INSERT = "Insert";
        public const string DB_PROC_MODE_UPDATE = "Update";
        public const string DB_CUSTOM_CATEGORY_CORE_5 = "CORE 5";
        public const string DB_CUSTOM_CATEGORY_CORE_4 = "CORE 4";
        public const string DB_CUSTOM_CATEGORY_CORE_TEN = "TEN";
        public const string DB_CUSTOM_CATEGORY_CORE_DRPEPPER = "DR PEPPER";
        public const string DB_CUSTOM_CATEGORY_CORE_SCHWEPPES = "SCHWEPPES";
        public const string DB_CUSTOM_CATEGORY_CORE_CANADA_DRY = "CANADA DRY";


        public const string SHAREPOINT_ATTACHMENT_URL = "/Documents/";
        //Actual Cases – >  M103
        public const string salesTargetActualCases = "M103";
        // Sales QTY - > M101
        public const string callOutSalesQty = "M103";
        //Load Cases – >  M104
         public const string callOutLoadCases = "M104";
        //OTA –>  (M802/M801) * 100
         public const string callOutOTA1 = "M802";
         public const string callOutOTA2 = "M801";
        //Haulback : (M401)
         public const string callOutHaulback = "M401";
        //Stops Actuals : (M701)
         public const string callOutStopsActuals = "M701";
        //Stops Planned : (M702)
         public const string callOutStopsPlanned = "M702";
        //DOS : DOS(M203)
         public const string callOutDOS = "M203";
         public const int DB_PROC_STATUS_SUCCESS = 1;
         public const int DB_PROC_STATUS_FAIL = 0;
         public const string DB_PROC_TO_EXPORT_EXCEL = "[Playbook].[pExportPromotionsListToExcel]";
        public const string DB_PROC_TO_EXPORT_PROMOTION_FILTER = "Playbook.GetPromotionFilter";
        public const string DB_PROC_TO_CHANNEL_BY_LOCATION = "[PlayBook].[GetChannelsForLocation]";
        public const string DB_PROC_TO_INSERT_UPDATE_PROGRAM = "[NationalAccount].[pInsertUpdateProgram]";
        public const string DB_PROC_TO_ROUTE_BY_BRANCH = "[POI].[GetRoutesForBranch]";
        public const string DB_PROMOTION_STATUS_CANCELLED = "Cancelled";

        public const int MySplashNetEntityID = 5;
        public const int VIEW_PR_APPROVAL_PERMISSION_ID = 23;

        public const int DEFAULT_VALUE_RANK = 100;
    

    }
}
