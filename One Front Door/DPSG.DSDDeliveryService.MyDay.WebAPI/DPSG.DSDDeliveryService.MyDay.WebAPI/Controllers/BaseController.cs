using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Threading;
using System.Threading.Tasks;
using DPSG.DSDDeliveryService.MyDay.WebAPI.Model;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.Controllers
{
    public class BaseController : ApiController
    {
        private WebAPILog _webApiLog;

        public WebAPILog objWebAPILog
        {
            get
            {
                if (_webApiLog == null)
                {
                    _webApiLog = new WebAPILog();
                }
                return _webApiLog;
            }
        }

        string gsn = "";
        protected string GSN
        {
            get
            {
                if (gsn == "")
                {
                    try
                    {
                        gsn = System.Web.HttpContext.Current.Request.UserAgent.Split(',')[4];
                    }
                    catch { }
                }
                return gsn;
            }
        }

        string userAgent = "";
        protected string UserAgent
        {
            get
            {
                if (userAgent == "")
                {
                    try
                    {
                        userAgent = System.Web.HttpContext.Current.Request.UserAgent.ToString();
                    }
                    catch { }
                }
                return userAgent;
            }
        }

        public BaseController()
        {
            objWebAPILog.ServiceName = "Merch WebAPI";
            objWebAPILog.OperationName = "";
            objWebAPILog.ModifiedDate = System.DateTime.Now;
            objWebAPILog.GSN = GSN;
            objWebAPILog.UserAgent = UserAgent;
            objWebAPILog.Type = "Error";
            objWebAPILog.Exception = "";
            objWebAPILog.GUID = (Guid.NewGuid()).ToString();
            objWebAPILog.ComputerName = Environment.MachineName;
        }

        protected internal virtual IHttpActionResult WebAPISuccess<T>(T result)
        {
            if (result is Model.IResponseInformation)
            {
                Model.IResponseInformation response = (Model.IResponseInformation)(object)result;
                response.ResponseStatus = 1;  //Sucess
                response.ErrorMessage = string.Empty;
                response.StackTrace = string.Empty;
                return new WebAPIActionResult<T>(Request, result);
            }
            else
                throw new Exception("Not allowed. Make sure return type is derived from Response Information.");
        }

        protected internal virtual IHttpActionResult WebAPIError(Exception ex)
        {
            var errorInfo = new Error();
            errorInfo.ResponseStatus = 0;
            errorInfo.ErrorMessage = ex.Message;
            errorInfo.StackTrace = ex.StackTrace;       
            return new WebAPIActionResult<Error>(Request, errorInfo);
        }

        public static string GetException(Exception ex)
        {
            if (ex.InnerException != null)
            {
                return string.Format("{0} > {1} ", ex.Message, GetException(ex.InnerException));
            }
            else
            {
                string retval = ex.Message;
                if (retval == "Object reference not set to an instance of an object.")
                {
                    retval = retval + "Stack Trace:" + ex.StackTrace;
                }
                return retval;
            }
        }
    }

    public class WebAPIActionResult<T> : IHttpActionResult
    {
        T resp;
        HttpRequestMessage _request;

        public WebAPIActionResult(HttpRequestMessage req, T result)
        {
            _request = req;
            resp = result;
        }

        public Task<HttpResponseMessage> ExecuteAsync(CancellationToken cancellationToken)
        {
            HttpResponseMessage response = _request.CreateResponse<T>(HttpStatusCode.OK, resp);
            return Task.FromResult(response);
        }
    }

    class Error : Model.IResponseInformation
    {
        public string ErrorMessage { get; set; }
        public int ResponseStatus { get; set; }        
        public string StackTrace { get; set; }
    }
}
