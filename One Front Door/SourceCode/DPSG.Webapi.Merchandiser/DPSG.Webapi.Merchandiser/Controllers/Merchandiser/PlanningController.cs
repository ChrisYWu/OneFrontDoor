using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using System.Web.Http.Cors;
using DPSG.Webapi.Merchandiser.Model;
using DPSG.Webapi.Merchandiser.BusinessServices;
using System.Web;
using DPSG.Webapi.Merchandiser.Modal;

namespace DPSG.Webapi.Merchandiser.Controllers.Merchandiser
{
    public class PlanningController : BaseController
    {

        [ResponseType(typeof(MerchBranchOutput))]
        [Route("api/Merc/GetMerchBranchesByGSN")]
        [HttpPost]
        public IHttpActionResult GetMerchBranchesByGSN(MerchBranchInput p)
        {
            try
            {
                return MSNOk<MerchBranchOutput>((new BusinessServices.PlanningBS().GetMerchBranchesByGSNBS(p)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [ResponseType(typeof(MerchGroupOutput))]
        [Route("api/Merc/InsertUpdateMerchGroupDetails")]
        [HttpPost]
        public IHttpActionResult InsertUpdateMerchGroupDetails(MerchGroupInput p)
        {
            try
            {
                return MSNOk<MerchGroupOutput>((new BusinessServices.PlanningBS().InsertUpdateMerchGroupDetailsBS(p)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }


        [ResponseType(typeof(MerchGroupOutput))]
        [Route("api/Merc/DeleteMerchGroup")]
        [HttpPost]
        public IHttpActionResult DeleteMerchGroup(MerchGroupInput p)
        {
            try
            {
                return MSNOk<MerchGroupOutput>((new BusinessServices.PlanningBS().DeleteMerchGroupBS(p)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }


       

        [ResponseType(typeof(MerchGroupCheckOutput))]
        [Route("api/Merc/ValidateExistingMerchGroupDetails/")]
        [HttpPost]
        public IHttpActionResult ValidateExistingMerchGroupDetails(MerchGroupCheckInput pinput)
        {
            try
            {
              //  MerchGroupCheckInput p = new MerchGroupCheckInput();
                //p.SAPBranchID = pinput.SAPBranchID;
                //p.Mode = pinput.mode;
                //p.Name = name;                
                return MSNOk<MerchGroupCheckOutput>((new BusinessServices.PlanningBS().ValidateForExistingMerchGroupDetailsBS(pinput)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }


        [ResponseType(typeof(MerchGroups))]
        [Route("api/Merc/GetMerchGroupDetailsByBranchID")]
        [HttpPost]
        public IHttpActionResult GetMerchGroupDetailsByBranchID(MerchGroupsInput p)
        {
            try
            {
                return MSNOk<MerchGroups>((new BusinessServices.PlanningBS().GetMerchGroupDetailsByBranchIDBS(p)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
           
        }

        [ResponseType(typeof(MerchGroupDetail))]
        [Route("api/Merc/GetMerchGroupByGroupID")]
        [HttpPost]
        public IHttpActionResult GetMerchGroupDetailsByGroupID(MerchGroupDetailInput p)
        {
            try
            {
                return MSNOk<MerchGroupDetail>((new BusinessServices.PlanningBS().GetMerchGroupDetailsByGroupIDBS(p)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }

        }


        [ResponseType(typeof(UsersOutput))]
        [Route("api/Merc/GetUserDetails/{name}")]
        [HttpGet]
        public IHttpActionResult GetUserDetails(string name)
        {
            try
            {
                return MSNOk<UsersOutput>((new BusinessServices.PlanningBS().GetUserDetailsBS(name)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }

        }


        [ResponseType(typeof(StoresOutput))]
        [Route("api/Merc/GetStoresByMerchGroupID")]
        [HttpPost]
        public IHttpActionResult GetStoresByMerchGroupID(StoreListInput pinput)
        {
            try
            {
                return MSNOk<StoresOutput>((new BusinessServices.PlanningBS().GetStoresByMerchGroupIDBS(pinput)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }

        }


        [ResponseType(typeof(StoreSetupDetailContainer))]
        [Route("api/Merc/GetStoreDetailsBySAPAccountNumber/{AcctNumber}")]
        [HttpGet]
        public IHttpActionResult GetStoreDetailsBySAPAccountNumber(Int64 acctNumber)
        {
            try
            {
                return MSNOk<StoreSetupDetailContainer>((new BusinessServices.PlanningBS().GetStoreDetailsBySAPAccountNumberBS(acctNumber)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }

        }

        [ResponseType(typeof(StoresOutput))]
        [Route("api/Merc/GetStoresLookUpBySAPBranchID/{SAPBranchID}/{MerchGroupID}/{name}")]
        [HttpGet]
        public IHttpActionResult GetStoresLookUpBySAPBranchID(string SAPBranchID, int MerchGroupID, string name)
        {
            try
            {
                StoreLookupInput pinput = new StoreLookupInput();
                pinput.SAPBranchID = SAPBranchID;
                pinput.SearchName = name;
                pinput.MerchGroupID = MerchGroupID;

                return MSNOk<StoresOutput>((new BusinessServices.PlanningBS().GetStoresLookUpBySAPBranchIDBS(pinput)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }

        }

        [ResponseType(typeof(RouteOutput))]
        [Route("api/Merc/GetRoutesByMerchGroupID")]
        [HttpPost]
        public IHttpActionResult GetRoutesByMerchGroupID(StoreListInput pinput)
        {
            try
            {
                return MSNOk<RouteOutput>((new BusinessServices.PlanningBS().GetRoutesByMerchGroupIDBS(pinput)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }

        }

        [ResponseType(typeof(StoreSetUpDetailOutput))]
        [Route("api/Merc/InsertUpdateStoreSetupDetails")]
        [HttpPost]
        public IHttpActionResult InsertUpdateStoreSetupDetails(StoreSetUpDetailInput pinput)
        {
            try
            {
                return MSNOk<StoreSetUpDetailOutput>((new BusinessServices.PlanningBS().InsertUpdateStoreSetupDetailsBS(pinput)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }

        }

        [ResponseType(typeof(StoreSetupContainer))]
        [Route("api/Merc/GetStoresSetupContainer")]
        [HttpPost]
        public IHttpActionResult GetStoresSetupContainer(StoreListInput pinput)
        {
            try
            {
                return MSNOk<StoreSetupContainer>((new BusinessServices.PlanningBS().GetStoresSetupContainerBS(pinput)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }

        }

        #region Planning Merchandiser Setup

        [ResponseType(typeof(UsersOutput))]
        [Route("api/Merc/GetMerchUserDetails/{name}")]
        [HttpGet]
        public IHttpActionResult GetMerchUserDetails(string name)
        {
            try
            {
                return MSNOk<UsersOutput>((new BusinessServices.PlanningBS().GetMerchUserDetailsBS(name)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }

        }


        [ResponseType(typeof(MerchSetupContainer))]
        [Route("api/Merc/GetMerchSetupContainer")]
        [HttpPost]
        public IHttpActionResult GetMerchSetupContainer(MerchListInput pinput)
        {
            try
            {
                return MSNOk<MerchSetupContainer>((new BusinessServices.PlanningBS().GetMerchSetupContainerBS(pinput)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }




        [ResponseType(typeof(MerchDetailContainer))]
        [Route("api/Merc/GetMerchDetailContainerByGSN/{GSN}")]
        [HttpGet]
        public IHttpActionResult GetMerchDetailContainerByGSN(string GSN)
        {
            try
            {
                return MSNOk<MerchDetailContainer>((new BusinessServices.PlanningBS().GetMerchDetailContainerByGSNBS(GSN)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }

        }

        [ResponseType(typeof(RouteDataContainer))]
        [Route("api/Merc/GetRoutesByDay")]
        [HttpPost]
        public IHttpActionResult GetRoutesByDay(RoutesByDayInput pinput)
        {
            try
            {
                return MSNOk<RouteDataContainer>((new BusinessServices.PlanningBS().GetRoutesByDayBS(pinput)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [ResponseType(typeof(RouteDataContainer))]
        [Route("api/Merc/GetAvailableDefaultRoutes")]
        [HttpPost]
        public IHttpActionResult GetAvailableDefaultRoutes(MerchListInput pinput)
        {
            try
            {
                return MSNOk<RouteDataContainer>((new BusinessServices.PlanningBS().GetAvailableDefaultRoutesBS(pinput)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [ResponseType(typeof(MerchSetupDetailOutput))]
        [Route("api/Merc/InsertUpdateMerchSetupDetail")]
        [HttpPost]
        public IHttpActionResult InsertUpdateMerchSetupDetail(MerchSetupDetailInput pinput)
        {
            try
            {
                return MSNOk<MerchSetupDetailOutput>((new BusinessServices.PlanningBS().InsertUpdateMerchSetupDetailBS(pinput)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }

        }

        #endregion

        #region Delete functionality in Merchandiser

        [ResponseType(typeof(StoreDeleteOutput))]
        [Route("api/Merc/DeleteStore")]
        [HttpPost]
        public IHttpActionResult DeleteStore(StoreDeleteInput store)
        {
            try
            {
                return MSNOk<StoreDeleteOutput>((new BusinessServices.PlanningBS().DeleteStoreBS(store)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [ResponseType(typeof(RouteDeleteOutput))]
        [Route("api/Merc/DeleteRoute")]
        [HttpPost]
        public IHttpActionResult DeleteRoute(RouteDeleteInput route)
        {
            try
            {
                return MSNOk<RouteDeleteOutput>((new BusinessServices.PlanningBS().DeleteRouteBS(route)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [ResponseType(typeof(RemoveStoreWarning))]
        [Route("api/Merc/GetDeleteStoreWarning")]
        [HttpPost]
        public IHttpActionResult GetDeleteStoreWarning(StoreDeleteInput store)
        {
            try
            {
                return MSNOk<RemoveStoreWarning>((new BusinessServices.PlanningBS().GetDeleteStoreWarningBS(store)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [ResponseType(typeof(DeleteRouteWarning))]
        [Route("api/Merc/GetDeleteRouteWarning")]
        [HttpPost]
        public IHttpActionResult GetDeleteRouteWarning(RouteDeleteInput route)
        {
            try
            {
                return MSNOk<DeleteRouteWarning>((new BusinessServices.PlanningBS().GetDeleteRouteWarningBS(route)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [ResponseType(typeof(MerchDeleteOutput))]
        [Route("api/Merc/DeleteMerch")]
        [HttpPost]
        public IHttpActionResult DeleteMerch(MerchDeleteInput merch)
        {
            try
            {
                return MSNOk<MerchDeleteOutput>((new BusinessServices.PlanningBS().DeleteMerchBS(merch)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }


        #endregion
    }
}
