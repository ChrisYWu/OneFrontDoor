using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Reflection;
using System.Web.Http.Description;
using DPSG.DSDDeliveryTime.WebAPI.Model.Input;
using System.Web.Http.Cors;

namespace DPSG.DSDDeliveryTime.WebAPI.Controllers
{
    public class DeliveryController : BaseController
    {
        #region All Merch HttpGet methods

        [HttpGet]
        [ResponseType(typeof(Model.Output.DriverRouteOutput))]
        public IHttpActionResult GetNonBreakRoutesForToday(bool inverse = false)
        {
            var dataService = new DataService.DSDDeliveryDataService();
            try
            {
                var ret = new Model.Output.DriverRouteOutput();
                ret.Routes = dataService.GetNonBreakRoutesForToday(inverse);
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
        [ResponseType(typeof(Model.Output.DeliveryTimeUpdates))]
        public IHttpActionResult GetSampleUpload()
        {
            try
            {
                DeliveryTimeUpdates temp = new DeliveryTimeUpdates();
                temp.DeliveryDate = DateTime.Today;
                temp.RouteNumber = "110802221";
                temp.DriverID = "646700";
                temp.GSN = "WUXYX001";

                temp.DeliveryStops = new List<DeliveryTimeUpdate>();
                DeliveryTimeUpdate update = new DeliveryTimeUpdate();
                temp.DeliveryStops.Add(update);

                update.StopID = 11308425;
                update.StopSequence = 2;
                update.ActualArrivalTime = DateTime.Parse("2017-03-02 05:55:22");
                update.ActualArrivalTimeZone = "CST";
                update.ActualDepartureTime = DateTime.Parse("2017-03-02 06:25:33");
                update.ActualArrivalTimeZone = "CST";

                update = new DeliveryTimeUpdate();
                temp.DeliveryStops.Add(update);

                update.StopID = 11308136;
                update.StopSequence = 3;
                update.EstimatedArrivalTime = DateTime.Parse("2017-03-02 06:32:07");
                update.EstimatedArrivalTimeZone = "CST";

                update = new DeliveryTimeUpdate();
                temp.DeliveryStops.Add(update);

                update.StopID = 11308945;
                update.StopSequence = 4;
                update.EstimatedArrivalTime = DateTime.Parse("2017-03-02 07:57:52");
                update.EstimatedArrivalTimeZone = "CST";

                update = new DeliveryTimeUpdate();
                temp.DeliveryStops.Add(update);

                update.StopID = 11308945;
                update.StopSequence = 5;
                update.EstimatedArrivalTime = DateTime.Parse("2017-03-02 08:54:33");
                update.EstimatedArrivalTimeZone = "CST";

                return WebAPISuccess(temp);
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                return WebAPIError(ex);
            }
        }

        [HttpGet]
        [ResponseType(typeof(Model.Output.DeliveryTimeUpdates))]
        public IHttpActionResult GetSampleCustomerInput()
        {
            try
            {
                CustomerNumberInput input = new CustomerNumberInput();
                input.CustomerNumbers = "11522165,11520286,11521060,11521611";
                input.DeliveryDate = DateTime.Parse("2017-04-04");

                return WebAPISuccess(input);
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                return WebAPIError(ex);
            }
        }

        [HttpGet]
        [ResponseType(typeof(Model.Output.DeliveryPlan))]
        public IHttpActionResult GetDeliveryPlan(String RouteNumber, String TimeZone, DateTime? DeliveryDate = null, bool IncludeBreakRoutes = false)
        {
            var dataService = new DataService.DSDDeliveryDataService();
            try
            {
                var ret = new Model.Output.DeliveryPlan();
                ret.DeliveryStops = dataService.GetDeliveryPlan(RouteNumber, TimeZone, DeliveryDate, IncludeBreakRoutes);
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

        #region All Merch HttpPost methods

        //[HttpGet]
        [HttpPost]
        [ResponseType(typeof(Model.Output.Deliveries))]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        //[BindJson(typeof(RouteInput), "json")]
        public IHttpActionResult GetDeliveryByRoute(RouteInput json)
        {
            var dataService = new DataService.DSDDeliveryDataService();
            try
            {
                var ret = new Model.Output.Deliveries();
                ret.DeliveryStops = dataService.GetDeliveryByRoute(json.RouteNumber.Trim(), json.DeliveryDate);
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

        [HttpPost]
        [ResponseType(typeof(Model.Output.Deliveries))]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public IHttpActionResult ResetRoute(RouteInput json)
        {
            var dataService = new DataService.DSDDeliveryDataService();
            try
            {
                var ret = new Model.Output.OutputBase();
                ret = dataService.ResetRoute(json.RouteNumber, json.DeliveryDate);
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

        [HttpPost]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public IHttpActionResult UploadDeliveryTime(DeliveryTimeUpdates updates)
        {
            var dataService = new DataService.DSDDeliveryDataService();
            try
            {
                return WebAPISuccess(dataService.UpdateDeliveryTime(updates));
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
        [ResponseType(typeof(Model.Output.StoreDeliveries))]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public IHttpActionResult GetCustomerDeliveries(string customerNumbers, DateTime deliveryDate)
        {
            var dataService = new DataService.DSDDeliveryDataService();
            try
            {
                CustomerNumberInput input = new CustomerNumberInput()
                {
                    CustomerNumbers = customerNumbers,
                    DeliveryDate = deliveryDate
                };
                Model.Output.StoreDeliveries ret = new Model.Output.StoreDeliveries();
                ret.Deliveries = dataService.GetDeliveryByCustomerNumbers(input);
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
    }
    #endregion

    public class BindJson : System.Web.Http.Filters.ActionFilterAttribute
    {
        Type _type;
        string _queryStringKey;
        public BindJson(Type type, string queryStringKey)
        {
            _type = type;
            _queryStringKey = queryStringKey;
        }
        public override void OnActionExecuting(System.Web.Http.Controllers.HttpActionContext actionContext)
        {
            var json = actionContext.Request.RequestUri.ParseQueryString()[_queryStringKey];
            var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            actionContext.ActionArguments[_queryStringKey] = serializer.Deserialize(json, _type);
        }
    }

}


