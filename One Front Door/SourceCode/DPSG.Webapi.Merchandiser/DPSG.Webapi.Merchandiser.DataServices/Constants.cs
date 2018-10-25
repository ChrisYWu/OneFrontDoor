
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Webapi.Merchandiser.DataServices
{
    class Constants
    {
        internal static class Dispatch
        {
            internal static class StoredProcedures
            {
                public const string GetPreDispatch = "[Planning].[pGetPreDispatch]";
                public const string GetMonitoringLanding = "Planning.pGetMornitoringLanding";
                public const string InsertException = "Shared.pInsertExceptions";
                public const string GetStores = "Planning.pGetStoresForPreDispatch";
                public const string InsertStorePredispatch = "[Planning].[pInsertStorePredispatch]";
                public const string ReSequenceStore = "[Planning].[pReSequenceStore]";
                public const string RemoveStoreFromPreDispatch = "[Planning].[pRemoveStoreFromPreDispatch]";
                public const string GetRoutesByDispatchDateGroup = "[Planning].[pGetRoutesByDispatchDateGroup]";
                public const string GetRoutesByDispatchDateGroupForReassign = "[Planning].[pGetRoutesByDispatchDateGroupForReassign]";
                
                public const string GetAvailableMerch = "[Planning].[pGetAvailableMerch]";
                public const string UpdateMerchRoutePredispatch = "[Planning].[pUpdateMerchRoutePredispatch]";
                public const string GetDispatchUpdates = "Planning.pGetDispatchUpdates";
                public const string FinalDispatch = "[Planning].[pDispatch]";
                public const string GetGetMornitoringDetail = "Operation.pGetMonitoringDetail";
            
                public const string GetStoresUnassigned = "[Planning].[pGetStoresForPreDispatchUnassigned]";
                public const string GetDispatchHistory = "[Planning].[pGetDispatchHistory]";
                public const string GetScheduleStatus = "[Planning].[pGetScheduleStatus]";


            }

        }

        internal static class Reporting
        {
            internal static class StoredProcedures
            {
                public const string GetStoreServiceReport = "Export.pGetStoreServiceReport";
                public const string GetUserMerchGroups = "Export.pGetUserMerchGroups";
                public const string GetMileageReport = "Export.pGetMileageReport";
            }
        }

        internal static class CommonUtil
        {
            internal static class StoredProcedures
            {
                public const string GetUserDetail = "Setup.pGetUserDetail";
                public const string GetImageDetailByBlobID = "Planning.pGetImageDetailByBlobID";
                public const string GetAzureContainer = "Setup.pGetAzureContainer";
                public const string ExtendContainerReadSAS = "Setup.pExtendContainerReadSAS";
                public const string ExtendContainerWriteSAS = "Setup.pExtendContainerWriteSAS";
                public const string GetAzureStorageConnection = "Setup.pGetAzureStorageConnection";
                public const string GetUserAuthorized = "Setup.pGetUserAuthorized";
            }
        }


        internal static class Planning
        {
            internal static class StoredProcedures
            {

                //Create MerchGroup
                public const string GetMerchBranches = "Planning.pGetMerchBranchesByGSN";
                public const string InsertUpdateMerchGroup = "Planning.pInsertUpdateMerchGroupDetails";
                public const string CheckForGroupDetails = "Planning.pValidateExistingMerchGroupDetails";
                public const string GetMerchGroupDetailsByBranchID = "Planning.pGetMerchGroupDetailsByBranchID";
                public const string GetMerchGroupDetailsByGroupID = "Planning.pGetMerchGroupDetailsByGroupID";
                public const string DeleteMerchGroup = "Planning.pDeleteMerchGroup";
                public const string GetUserDetails = "Planning.pGetUserDetails";

                //StoreSetup
                public const string GetStoresByMerchGroupID = "Planning.pGetStoresByMerchGroupID";
                public const string GetStoresLookup = "Planning.pGetStoresLookupByBranchID";

                //Route Store Assignment screen

                public const string GetRouteStoreDetailByWeekDay = "Planning.pGetRouteStoreDetailByWeekDay";
                public const string InsertStoreWeekday = "Planning.pInsertStoreWeekday";
                public const string GetStoresForAssignment = "Planning.pGetStoresForAssignment";
                public const string GetRoutesByWeekDay = "Planning.pGetRoutesByWeekDay";
                public const string GetRoutesByMerchGroup = "Planning.pGetRoutesByMerchGroupID";
                public const string InsertStoreSetup = "Planning.pInsertStoreDetailsByGroup";
                public const string GetStoreDetailsByAcctNumber = "Planning.pGetStoreDetailsBySAPAccountNumber";
                public const string ReassignStorebyWeekDay = "Planning.pReassignStorebyWeekDay";
                public const string RemoveStoreByWeekDay = "Planning.pRemoveStoreByWeekDay";
                public const string UpdateStoreSequence = "Planning.pUpdateStoreSequence";
                public const string GetRouteMerchandiserByMerchGroupID = "Planning.pGetRouteMerchandiserByMerchGroupID";
                public const string GetStoreSetupContainer = "Planning.pGetStoreSetupContainer";
                public const string EditRouteMerchandiser = "Planning.pEditRouteMerchandiser";

                // Merchandiser set up screen

                public const string GetMerchSetupContainer = "Planning.pGetMerchSetupContainer";
                public const string GetRoutesByDay = "Planning.pGetRoutesByDay";
                public const string GetAvailableDefaultRoutes = "Planning.pGetAvailableDefaultRoutes";
                public const string GetMerchDetailContainerByGSN = "Planning.pGetMerchDetailContainerByGSN";
                public const string GetMerchRoutesByGSN = "[Planning].[pGetMerchRoutes]";
                public const string InsertUpdateMerchDetail = "Planning.pInsertUpdateMerchDetail";
                public const string GetMerchUserDetails = "Planning.pGetMerchUserDetails";
                public const string GetStoreDeleteWarnings = "Setup.pTryDeleteStoreBySAPAccountNumber";
                public const string GetRouteDeleteWarnings = "Planning.pTryDeleteRoute";

                // Delete Store
                public const string DeleteStore = "Setup.pDeleteStoreBySAPAccountNumber";
                public const string DeleteMerch = "Setup.pDeleteMerchByGSN";
                public const string DeleteRoute = "Planning.pDeleteRoute";

            }
        }

        internal static class Exception
        {
            internal static class StoredProcedures
            {
                public const string InsertExceptions = "Shared.pInsertExceptions";
               
            }
        }


    }
}
