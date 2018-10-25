using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.DataService
{
    class Constant
    {
        internal static class StoredProcedureName
        {
            //DisplayBuild
            public const string InsertDisplayBuild = "Operation.pInsertUpdateDisplayBuild";
            public const string UpsertBuildExecution = "Operation.pUpsertBuildExecution";
            public const string GetDisplayBuildWithLatestStatus = "Operation.pGetDisplayBuildWithLatestStatus";
            public const string GetDisplayBuildWithLatestStatusByRouteID = "Operation.pGetDisplayBuildWithLatestStatusByRouteID";
            public const string GetMerchBuildMaster = "Operation.pGetMerchBuildMaster";

            public const string GetAzureContainer = "Setup.pGetAzureContainer";
            public const string ExtendContainerReadSAS = "Setup.pExtendContainerReadSAS";
            public const string ExtendContainerWriteSAS = "Setup.pExtendContainerWriteSAS";
            public const string GetAzureStorageConnection = "Setup.pGetAzureStorageConnection";

            //Merch
            public const string GetStoresBySAPBranchID = "Planning.pGetStoresBySAPBranchID";
            public const string GetMerchProfileByGSN = "Planning.pGetMerchProfileByGSN";
            public const string GetMerchSchedule = "Planning.pGetMerchSchedule";
            public const string GetMerchPlan = "Planning.pGetMerchPlan";            
            public const string GetMerchStoreVisitDetailsByGSN = "Operation.pGetMerchStoreVisitDetailsByGSN";
            public const string GetMerchStoreDelivery = "Operation.pGetMerchStoreDelivery";
            public const string GetMerchandisingDetails = "Operation.pGetMerchandisingDetails";            
            public const string GetItemMaster = "Setup.pGetItemMaster";

            public const string InsertMerchStopCheckIn = "Operation.pInsertMerchStopCheckIn";
            public const string InsertMerchStopCheckOut = "Operation.pInsertMerchStopCheckOut";
            public const string InsertMerchStoreSignature = "Operation.pInsertMerchStoreSignature";
            public const string InsertMerchStorePicture = "Operation.pInsertMerchStorePicture";
            public const string InsertMerchProfilePicture = "Operation.pInsertMerchProfilePicture";
            public const string InsertAdhocMileage = "Operation.pInsertAdhocMileage";
            public const string UpsertMerchPhoneNumber = "Operation.pUpsertMerchPhoneNumber";
            public const string InsertMerchStopDNS = "Operation.pInsertMerchStopDNS";

            public const string InsertWebAPILog = "Setup.pInsertWebAPILog";
        }
    }
}
