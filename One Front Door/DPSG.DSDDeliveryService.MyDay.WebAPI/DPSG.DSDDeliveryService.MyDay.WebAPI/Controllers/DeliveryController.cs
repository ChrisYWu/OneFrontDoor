//using DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Input;
using DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Output;
using System;
using System.Reflection;
using System.Web.Http;
using System.Web.Http.Description;
using Newtonsoft.Json;
using DPSG.DSDDeliveryService.MyDay.WebAPI.DataService;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.Controllers
{
    public class DeliveryController : BaseController
    {
        #region All Merch HttpGet methods

        [HttpGet]
        [ResponseType(typeof(Model.Output.MasterLists))]
        public IHttpActionResult GetMaster()
        {
            var dataService = new DataService.DeliveryDataService();
            try
            {
                var ret = new Model.Output.MasterLists();
                ret = dataService.GetMaster();
                return WebAPISuccess(ret);
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }

        }

        [HttpGet]
        [ResponseType(typeof(Model.Output.MasterLists))]
        public IHttpActionResult GetDeliveryManifest(int RouteID, DateTime? DeliveryDateUTC = null)
        {
            var dataService = new DataService.DeliveryDataService();
            try
            {
                var ret = new Model.Output.DeliveryManifest();
                ret = dataService.GetDeliveryManifest(RouteID, DeliveryDateUTC);
                return WebAPISuccess(ret);
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }

        }
        


        #endregion

    }
}
