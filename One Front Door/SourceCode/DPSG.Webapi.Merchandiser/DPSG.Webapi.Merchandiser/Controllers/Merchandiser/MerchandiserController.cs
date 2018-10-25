
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
using System.DirectoryServices.AccountManagement;
using DPSG.Webapi.Merchandiser.Modals;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.Controllers.Merchandiser
{
    public class MerchandiserController : BaseController
    {

        //[Route("api/Merc/GetDispatches/{date}")]
        //[HttpGet]
        //public IHttpActionResult GetDispatches(string date)
        //{

        //    try
        //    {
        //        DispatchInput di = new DispatchInput();
        //        di.DispatchDate = Convert.ToDateTime("2016-06-11");
        //        di.MerchGroupID = 101;

        //        return MSNOk<MerchandisersContainer>((new BusinessServices.Dispatch.DispatchBS()).GetDispatchesBS(di.MerchGroupID, di.DispatchDate));
        //    }
        //    catch (Exception ex)
        //    {
        //        return MSNError(ex);
        //    }
        //}


        [ResponseType(typeof(StoresContainer))]
        [Route("api/Merc/GetStores")]
        [HttpPost]
        public IHttpActionResult GetStores(StoresInput p)
        {
            return MSNOk<StoresContainer>((new BusinessServices.Dispatch.DispatchBS()).GetStoresBS(p.MerchGroupID, p.DispatchDate));
        }

        [ResponseType(typeof(StoresContainer))]
        [Route("api/Merc/GetStoresUnassigned")]
        [HttpPost]
        public IHttpActionResult GetStoresUnassigned(StoresInput p)
        {
            return MSNOk<StoresContainer>((new BusinessServices.Dispatch.DispatchBS()).GetStoresUnassignedBS(p.MerchGroupID, p.DispatchDate));
        }

        [Route("api/Merc/GetDispatches/")]
        [HttpPost]
        public async Task<IHttpActionResult> GetDispatches(DispatchInputUser dispatchInput)
        {

            try
            {
                return MSNOk<MerchandisersContainer>(await (new BusinessServices.Dispatch.DispatchBS()).GetDispatchesBS(dispatchInput.MerchGroupID, dispatchInput.DispatchDate, dispatchInput.GSN, dispatchInput.Reset, dispatchInput.TimeZoneOffsetToUTC));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }


        [Route("api/Merc/GetAllDispatch")]
        [HttpPost]
        public async Task<IHttpActionResult> GetAllDispatch(DispatchInputUser dispatchInput)
        {

            try
            {
                return MSNOk<DispatchAllListContainer>(await (new BusinessServices.Dispatch.DispatchBS()).GetDispatchAllBS(dispatchInput));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [Route("api/Merc/GetAllDispatchSliced")]
        [HttpPost]
        public async Task<IHttpActionResult> GetAllDispatchSliced(DispatchInputUser dispatchInput)
        {

            try
            {
                return MSNOk<DispatchAllListContainer>(await (new BusinessServices.Dispatch.DispatchBS()).GetDispatchAllSlicedBS(dispatchInput));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [Route("api/Merc/InsertStorePredisp/")]
        [HttpPost]
        public IHttpActionResult InsertStorePredisp(StorePredispatch pinput)
        {
            try
            {
                return MSNOk<DispatchOutput>((new BusinessServices.Dispatch.DispatchBS()).InsertStorePredispatchBS(pinput));
            }

            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [Route("api/Merc/UpdateSequence/")]
        [HttpPost]
        public IHttpActionResult UpdateSequence(ResequenceInput pinput)
        {
            try
            {
                return MSNOk<DispatchOutput>((new BusinessServices.Dispatch.DispatchBS()).UpdateSequenceBS(pinput));
            }

            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [Route("api/Merc/RemoveStore/")]
        [HttpPost]
        public IHttpActionResult RemoveStore(RemoveStoreInput pinput)
        {
            try
            {
                return MSNOk<DispatchOutput>((new BusinessServices.Dispatch.DispatchBS()).RemoveStoreBS(pinput));
            }

            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }


        [Route("api/Merc/GetStoreServicedReport/")]
        [HttpPost]
        public IHttpActionResult GetStoreServicedReport(StoreServiceInput storeSerInput)
        {
            try
            {
                return MSNOk<StoreServiceOutput>((new BusinessServices.ReportingBS().GetStoreServicedReportBS(storeSerInput)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [Route("api/Merc/GetUserMerchGroups/")]
        [HttpPost]
        public IHttpActionResult GetUserMerchGroups(UserMerchGroupInput usrGSN)
        {
            try
            {
                return MSNOk<UserMerchGroupOutput>((new BusinessServices.ReportingBS().GetUserMerchGroupsBS(usrGSN)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }


        [Route("api/Merc/GetRouteList/")]
        [HttpPost]
        public async Task<IHttpActionResult> GetRouteList(RouteListExcludeCurrentInput pinput)
        {
            try
            {
                return MSNOk<RouteList>(await (new BusinessServices.Dispatch.DispatchBS()).GetRoutesBS(pinput));
            }

            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }


        [Route("api/Merc/ReassignStore/")]
        [HttpPost]
        public IHttpActionResult ReassignStore(ReassignStoreInput pinput)
        {
            try
            {
                return MSNOk<DispatchOutput>((new BusinessServices.Dispatch.DispatchBS()).ReassignStoreBS(pinput));
            }

            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }


        [Route("api/Merc/GetMerchList/")]
        [HttpPost]
        public IHttpActionResult GetMerchListsq(RouteListInput pinput)
        {
            try
            {
                return MSNOk<MerchListContainer>((new BusinessServices.Dispatch.DispatchBS()).GetMerchListBS(pinput));
            }

            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }


        [Route("api/Merc/ReassignMerch/")]
        [HttpPost]
        public IHttpActionResult ReassignMerchandiser(ReassignMerchInput pinput)
        {
            try
            {
                return MSNOk<DispatchOutput>((new BusinessServices.Dispatch.DispatchBS()).ReassignMerchandiserBS(pinput));
            }

            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }
        [Route("api/Merc/GetMileageReport/")]
        [HttpPost]
        public IHttpActionResult GetMileageReport(MileageInput mileageInput)
        {
            try
            {
                return MSNOk<MileageOutput>((new BusinessServices.ReportingBS().GetMileageReportBS(mileageInput)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [Route("api/Merc/GetDispatchHistory/")]
        [HttpPost]
        public IHttpActionResult GetDispatchHistory(RouteListInput rl)
        {
            try
            {
                return MSNOk<DispatchHistoryContainer>((new BusinessServices.Dispatch.DispatchBS()).GetDispatchHistoryBS(rl));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }



        [Route("api/Merc/DispatchReady/")]
        [HttpPost]
        public IHttpActionResult DispatchReady(DispatchInput dispatchInput)
        {
            try
            {
                return MSNOk<DispatchReadyContainer>((new BusinessServices.Dispatch.DispatchBS()).DispatchReadyBS(dispatchInput));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [Route("api/Merc/DispatchFinal/")]
        [HttpPost]
        public IHttpActionResult DispatchFinal(DispatchFinalInput dispatchInput)
        {
            try
            {
                return MSNOk<DispatchResultsContainer>((new BusinessServices.Dispatch.DispatchBS()).DispatchFinalBS(dispatchInput));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [Route("api/Merc/InsertException/")]
        [HttpPost]
        public IHttpActionResult InsertException(MerchException merchException)
        {
            try
            {
                return MSNOk<MerchExceptionResponse>((new BusinessServices.ExceptionBS().InsertExceptionBS(merchException)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [HttpGet]
        [Route("api/Merc/CheckAuthentication")]
        public IHttpActionResult CheckAuthentication()
        {
            try
            {
               if (User.Identity.IsAuthenticated)
                {
                    return MSNOk<UserDetailOutput>((new BusinessServices.CommonUtilBS().GetUserDetailBS(User.Identity.Name)));
                }
                else
                {
                    UserDetailOutput output = new UserDetailOutput();
                    output.UserInfo.IsValid = 0;
                     return MSNOk<UserDetailOutput>(output);
                    //return BadRequest("Not authenticated");
                }
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }



        [HttpGet]
        [Route("api/Merc/CheckAuthenticationByUser")]
        public IHttpActionResult CheckAuthenticationByUser()
        {
            try
            {
                return MSNOk<UserDetailOutput>((new BusinessServices.CommonUtilBS().GetUserDetailBS("binnx001")));//MITRX008
                //if (true)
                //{
                //    //UserDetail user = new UserDetail();
                //    //user.GSN = User.Identity.Name;
                //    //user.IsValid = true;
                //    //return MSNOk<UserDetail>(user);
                    
                //}
                //else
                //{
                //    UserDetailOutput output = new UserDetailOutput();
                //    output.UserInfo.IsValid = 0;
                //    return MSNOk<UserDetailOutput>(output);
                //    //return BadRequest("Not authenticated");
                //}
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [HttpGet]
        [Route("api/Merc/GetUserData/{gsn}")]
        public IHttpActionResult CheckAuthentication(string gsn)
        {
            try
            {

                return MSNOk<UserDetailOutput>((new BusinessServices.CommonUtilBS().GetUserDetailBS(gsn)));


            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        #region Planning Route store Assignment

        [Route("api/Merc/GetRSDetailByWeekDay/")]
        [HttpPost]
        //[HttpGet]
        public IHttpActionResult GetRSDetailByWeekDay(RSInput rsInput)
        {
            //RSInput rsInput = new RSInput();
            //rsInput.MerchGroupID = 102;
            //rsInput.WeekDay = 2;
            try
            {
                return MSNOk<RSOutput>((new BusinessServices.RouteStoreAssignBS().GetRSDetailByWeekDayBS(rsInput)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [Route("api/Merc/InsertStoreWeekday/")]
        [HttpPost]
        public IHttpActionResult InsertStoreWeekday(StoreWeekDayInput sinput)
        {
            try
            {
                return MSNOk<StoreWeekDayOutput>((new BusinessServices.RouteStoreAssignBS()).InsertStoreWeekday(sinput));
            }

            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [ResponseType(typeof(StoreContainer))]
        [Route("api/Merc/GetStoreList")]
        [HttpPost]
        public IHttpActionResult GetStoreList(StoreInput p)
        {
            try
            {
                return MSNOk<StoreContainer>((new BusinessServices.RouteStoreAssignBS()).GetStoreListBS(p.MerchGroupID, p.WeekDay));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [Route("api/Merc/GetRoutes/")]
        [HttpPost]
        public IHttpActionResult GetRoutes(RouteInput pinput)
        {
            try
            {
                return MSNOk<RoutesList>((new BusinessServices.RouteStoreAssignBS()).GetRoutesBS(pinput));
            }

            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [Route("api/Merc/ReassignStorebyWeekDay/")]
        [HttpPost]
        public IHttpActionResult ReassignStorebyWeekDay(ReassignStoreInputData pinput)
        {
            try
            {
                return MSNOk<StoreWeekDayOutput>((new BusinessServices.RouteStoreAssignBS()).ReassignStorebyWeekDayBS(pinput));
            }

            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [Route("api/Merc/RemoveStoreByWeekDay/")]
        [HttpPost]
        public IHttpActionResult RemoveStoreByWeekDay(RemoveStoreInputData pinput)
        {
            try
            {
                return MSNOk<StoreWeekDayOutput>((new BusinessServices.RouteStoreAssignBS()).RemoveStoreByWeekDayBS(pinput));
            }

            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [Route("api/Merc/UpdateStoreSequence/")]
        [HttpPost]
        public IHttpActionResult UpdateStoreSequence(StoreResequenceInput pinput)
        {
            try
            {
                return MSNOk<StoreWeekDayOutput>((new BusinessServices.RouteStoreAssignBS()).UpdateStoreSequenceBS(pinput));
            }

            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        #endregion

        [Route("api/Merc/GetImageDetailByBlobID/")]
        [HttpPost]
        public IHttpActionResult GetImageDetailByBlobID(ImageInput input)
        {
            try
            {
                return MSNOk<ImageOutput>((new BusinessServices.CommonUtilBS().GetImageDetailByBlobIDBS(input)));              
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [Route("api/Merc/ExtendContainerReadSAS/")]
        [HttpPost]
        public IHttpActionResult ExtendContainerReadSAS(ExtendReadSASInput input)
        {
            try
            {
                return MSNOk<ContainerExtensionOutput>((new BusinessServices.CommonUtilBS().ExtendContainerReadSAS(input.ContainerID)));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }


        [Route("api/Merc/GetScheduleStatus/")]
        [HttpPost]
        public async Task<IHttpActionResult> GetScheduleStatus(ScheduleStatusInput input)
        {
            try
            {
                return MSNOk<ScheduleStatusOutput>(await(new BusinessServices.Dispatch.DispatchBS()).GetScheduleStatusBS(input));

            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }
    }
}

