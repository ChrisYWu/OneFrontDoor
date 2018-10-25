using DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Input;
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
        public IHttpActionResult GetMaster(int? RouteID = null, DateTime? DeliveryDateUTC = null, string GSN = null)
        {
            string guid = Guid.NewGuid().ToString();
            var dataService = new DataService.DeliveryDataService();
            try
            {
                MyDayLog log = new MyDayLog()
                {
                    CorrelationID = guid,
                    WebEndPoint = MethodBase.GetCurrentMethod().Name,
                    StoredProc = DataService.StoredProcedureName.GetMaster,
                    GetParameters = String.Empty,
                    RouteID = RouteID,
                    DeliveryDateUTC = DeliveryDateUTC,
                    GSN = GSN
                };
                dataService.InsertMeshMyDayLog(log);

                var ret = new Model.Output.MasterLists();
                ret = dataService.GetMaster();
                return WebAPISuccess(ret);
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.CorrelationID = guid;
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpGet]
        public IHttpActionResult GetDeliveryManifest(int RouteID, DateTime? DeliveryDateUTC = null, string GSN = null)
        {
            string guid = Guid.NewGuid().ToString();

            var dataService = new DataService.DeliveryDataService();
            try
            {
                MyDayLog log = new MyDayLog()
                {
                    CorrelationID = guid,
                    WebEndPoint = MethodBase.GetCurrentMethod().Name,
                    StoredProc = DataService.StoredProcedureName.GetDeliveryManifest,
                    GetParameters = string.Format("{{RouteID:{0}, DeliveryDateUTC:{1}}}", RouteID.ToString(), DeliveryDateUTC==null?"Null": DeliveryDateUTC.ToString()),
                    RouteID = RouteID,
                    DeliveryDateUTC = DeliveryDateUTC,
                    GSN = GSN
                };
                dataService.InsertMeshMyDayLog(log);

                var ret = new Model.Output.DeliveryManifest();
                ret = dataService.GetDeliveryManifest(RouteID, DeliveryDateUTC);
                return WebAPISuccess(ret);
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.CorrelationID = guid;
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpGet]
        public IHttpActionResult DeleteStop(int deliveryStopID, int? RouteID = null, DateTime? DeliveryDateUTC = null, string GSN = null)
        {
            string guid = Guid.NewGuid().ToString();

            var dataService = new DataService.DeliveryDataService();
            try
            {
                MyDayLog log = new MyDayLog()
                {
                    CorrelationID = guid,
                    WebEndPoint = MethodBase.GetCurrentMethod().Name,
                    StoredProc = DataService.StoredProcedureName.DeleteStop,
                    GetParameters = string.Format("{{DeliveryStopID:{0}}}", deliveryStopID.ToString()),
                    RouteID = RouteID,
                    DeliveryDateUTC = DeliveryDateUTC,
                    GSN = GSN
                };
                dataService.InsertMeshMyDayLog(log);

                dataService.DeleteStop(deliveryStopID);
                return WebAPISuccess(new OutputBase());
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.CorrelationID = guid;
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        #endregion

        #region All Merch HttpPost methods

        [HttpPost]
        public IHttpActionResult UploadRouteCheckout(RouteCheckout routeCheckout)
        {
            string guid = Guid.NewGuid().ToString();
            string json = routeCheckout.Equals(null) ? string.Empty : JsonConvert.SerializeObject(routeCheckout, Formatting.None);
            var dataService = new DataService.DeliveryDataService();
            try
            {
                MyDayLog log = new MyDayLog()
                {
                    CorrelationID = guid,
                    WebEndPoint = MethodBase.GetCurrentMethod().Name,
                    StoredProc = DataService.StoredProcedureName.UploadRouteCheckout,
                    PostJson = json,
                    RouteID = routeCheckout.RouteID,
                    DeliveryDateUTC = routeCheckout.DeliveryDateUTC,
                    GSN = routeCheckout.ActualStartGSN
                };
                dataService.InsertMeshMyDayLog(log);

                return WebAPISuccess(dataService.UploadRouteCheckout(routeCheckout));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.CorrelationID = guid;
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult UploadAddedStop(AddedStop obj)
        {
            string guid = Guid.NewGuid().ToString();
            string json = obj.Equals(null) ? string.Empty : JsonConvert.SerializeObject(obj, Formatting.None);
            var dataService = new DataService.DeliveryDataService();
            try
            {
                MyDayLog log = new MyDayLog()
                {
                    CorrelationID = guid,
                    WebEndPoint = MethodBase.GetCurrentMethod().Name,
                    StoredProc = DataService.StoredProcedureName.UploadAddedStop,
                    PostJson = json,
                    RouteID = obj.RouteID,
                    DeliveryDateUTC = obj.DeliveryDateUTC,
                    GSN = obj.LastModifiedBy
                };
                dataService.InsertMeshMyDayLog(log);

                return WebAPISuccess(dataService.UploadAddedStop(obj));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.CorrelationID = guid;
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult UploadAddedStops(AddedStops obj)
        {
            string guid = Guid.NewGuid().ToString();
            string json = obj.Equals(null) ? string.Empty : JsonConvert.SerializeObject(obj, Formatting.None);
            var dataService = new DataService.DeliveryDataService();
            try
            {
                MyDayLog log = new MyDayLog()
                {
                    CorrelationID = guid,
                    WebEndPoint = MethodBase.GetCurrentMethod().Name,
                    StoredProc = DataService.StoredProcedureName.UploadAddedStop + "(multi:" + obj.Stops.Count.ToString() + ")",
                    PostJson = json,
                    RouteID = obj.Stops[0].RouteID,
                    DeliveryDateUTC = obj.Stops[0].DeliveryDateUTC,
                    GSN = obj.Stops[0].LastModifiedBy
                };
                dataService.InsertMeshMyDayLog(log);

                return WebAPISuccess(dataService.UploadAddedStops(obj));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.CorrelationID = guid;
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult UpdateEstimatedArrivals(UpdatedArrival obj)
        {
            string guid = Guid.NewGuid().ToString();
            string json = obj.Equals(null) ? string.Empty : JsonConvert.SerializeObject(obj, Formatting.None);
            var dataService = new DataService.DeliveryDataService();
            try
            {
                MyDayLog log = new MyDayLog()
                {
                    CorrelationID = guid,
                    WebEndPoint = MethodBase.GetCurrentMethod().Name,
                    StoredProc = DataService.StoredProcedureName.UpdateEstimatedArrivals,
                    PostJson = json,
                    RouteID = obj.RouteID,
                    DeliveryDateUTC = obj.DeliveryDateUTC,
                    GSN = obj.LastModifiedBy
                };
                dataService.InsertMeshMyDayLog(log);

                return WebAPISuccess(dataService.UploadEstimatedArrivals(obj));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.CorrelationID = guid;
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult CheckInDeliveryStop(StopCheckIn obj)
        {
            string guid = Guid.NewGuid().ToString();
            string json = obj.Equals(null) ? string.Empty : JsonConvert.SerializeObject(obj, Formatting.None);
            var dataService = new DataService.DeliveryDataService();
            try
            {
                MyDayLog log = new MyDayLog()
                {
                    CorrelationID = guid,
                    WebEndPoint = MethodBase.GetCurrentMethod().Name,
                    StoredProc = DataService.StoredProcedureName.CheckInDeliveryStop,
                    PostJson = json,
                    RouteID = obj.RouteID,
                    DeliveryDateUTC = obj.DeliveryDateUTC,
                    GSN = obj.LastModifiedBy

                };
                dataService.InsertMeshMyDayLog(log);

                return WebAPISuccess(dataService.CheckInDeliveryStop(obj));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.CorrelationID = guid;
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult CheckOutDeliveryStop(StopCheckOut obj)
        {
            string guid = Guid.NewGuid().ToString();
            string json = obj.Equals(null) ? string.Empty : JsonConvert.SerializeObject(obj, Formatting.None);
            var dataService = new DataService.DeliveryDataService();
            try
            {
                MyDayLog log = new MyDayLog()
                {
                    CorrelationID = guid,
                    WebEndPoint = MethodBase.GetCurrentMethod().Name,
                    StoredProc = DataService.StoredProcedureName.CheckOutDeliveryStop,
                    PostJson = json,
                    RouteID = obj.RouteID,
                    DeliveryDateUTC = obj.DeliveryDateUTC,
                    GSN = obj.LastModifiedBy
                };
                dataService.InsertMeshMyDayLog(log);

                return WebAPISuccess(dataService.CheckOutDeliveryStop(obj));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.CorrelationID = guid;
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult UploadStopsDNS(StopDNS obj)
        {
            string guid = Guid.NewGuid().ToString();
            string json = obj.Equals(null) ? string.Empty : JsonConvert.SerializeObject(obj, Formatting.None);
            var dataService = new DataService.DeliveryDataService();
            try
            {
                MyDayLog log = new MyDayLog()
                {
                    CorrelationID = guid,
                    WebEndPoint = MethodBase.GetCurrentMethod().Name,
                    StoredProc = DataService.StoredProcedureName.UploadStopsDNS,
                    PostJson = json,
                    RouteID = obj.RouteID,
                    DeliveryDateUTC = obj.DeliveryDateUTC,
                    GSN = obj.LastModifiedBy
                };
                dataService.InsertMeshMyDayLog(log);

                return WebAPISuccess(dataService.UploadStopsDNS(obj));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.CorrelationID = guid;
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult CancelStopsDNS(StopDNSCancel obj)
        {
            string guid = Guid.NewGuid().ToString();
            string json = obj.Equals(null) ? string.Empty : JsonConvert.SerializeObject(obj, Formatting.None);
            var dataService = new DataService.DeliveryDataService();
            try
            {
                MyDayLog log = new MyDayLog()
                {
                    CorrelationID = guid,
                    WebEndPoint = MethodBase.GetCurrentMethod().Name,
                    StoredProc = DataService.StoredProcedureName.UploadStopsDNS,
                    PostJson = json,
                    RouteID = obj.RouteID,
                    DeliveryDateUTC = obj.DeliveryDateUTC,
                    GSN = obj.LastModifiedBy
                };
                dataService.InsertMeshMyDayLog(log);

                return WebAPISuccess(dataService.CancelStopsDNS(obj));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.CorrelationID = guid;
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult UploadNewSequence(UpdatedSequence obj)
        {
            string guid = Guid.NewGuid().ToString();
            string json = obj.Equals(null) ? string.Empty : JsonConvert.SerializeObject(obj, Formatting.None);
            var dataService = new DataService.DeliveryDataService();
            try
            {
                MyDayLog log = new MyDayLog()
                {
                    CorrelationID = guid,
                    WebEndPoint = MethodBase.GetCurrentMethod().Name,
                    StoredProc = DataService.StoredProcedureName.UploadNewSequence,
                    PostJson = json,
                    RouteID = obj.RouteID,
                    DeliveryDateUTC = obj.DeliveryDateUTC,
                    GSN = obj.LastModifiedBy
                };
                dataService.InsertMeshMyDayLog(log);

                return WebAPISuccess(dataService.UploadNewSequence(obj));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.CorrelationID = guid;
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult UploadInvoice(Invoice obj)
        {
            string guid = Guid.NewGuid().ToString();
            string json = obj.Equals(null) ? string.Empty : JsonConvert.SerializeObject(obj, Formatting.None);
            var dataService = new DataService.DeliveryDataService();
            try
            {
                MyDayLog log = new MyDayLog()
                {
                    CorrelationID = guid,
                    WebEndPoint = MethodBase.GetCurrentMethod().Name,
                    StoredProc = DataService.StoredProcedureName.UploadInvoice,
                    PostJson = json,
                    RouteID = obj.RouteID,
                    DeliveryDateUTC = obj.DeliveryDateUTC,
                    GSN = obj.LastModifiedBy
                };
                dataService.InsertMeshMyDayLog(log);

                return WebAPISuccess(dataService.UploadInvoice(obj));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.CorrelationID = guid;
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        #endregion

    }
}
