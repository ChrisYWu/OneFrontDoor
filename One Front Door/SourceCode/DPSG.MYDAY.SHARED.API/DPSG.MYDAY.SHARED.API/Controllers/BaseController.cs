using DPSG.MYDAY.SHARED.API.DataAccess;
using DPSG.MYDAY.SHARED.API.Models;
using System;
using System.Configuration;
using System.Net;
using System.Net.Http;
using System.Runtime.CompilerServices;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http;

namespace DPSG.MYDAY.SHARED.API.Controllers
{
    public class BaseController : ApiController
    {

        private ServiceLog _webApiLog;
        private ErrorLoggerDataService _errorLoggerDataService;

        // Used to get MethodName from await / async 
        public static string GetActualAsyncMethodName([CallerMemberName]string name = null) => name;
        private static int _userAgentGsnPosition = Convert.ToInt32(ConfigurationManager.AppSettings.Get("userAgentGsnPosition"));
        private static int _userAgentLength = Convert.ToInt32(ConfigurationManager.AppSettings.Get("UserAgentLength"));
        static readonly string userAgent = System.Web.HttpContext.Current.Request.UserAgent;

        public ServiceLog ObjWebApiLog => _webApiLog ?? (_webApiLog = new ServiceLog());

        public ErrorLoggerDataService ErrorLoggingService => _errorLoggerDataService ?? (_errorLoggerDataService = new ErrorLoggerDataService());

        public BaseController()
        {
            _userAgentGsnPosition = _userAgentGsnPosition > 0 ? _userAgentGsnPosition : 4;
            _userAgentLength = _userAgentLength > 0 ? _userAgentLength : 5;

            ObjWebApiLog.ServiceName = "COMMON-API";
            ObjWebApiLog.OperationName = string.Empty;
            ObjWebApiLog.ModifiedDate = DateTime.Now;
            ObjWebApiLog.GSN = Common.Helper.GetGsnFromUserAgent(userAgent, _userAgentGsnPosition, _userAgentLength);
            ObjWebApiLog.UserAgent = userAgent;
            ObjWebApiLog.Type = "Error";
            ObjWebApiLog.Exception = string.Empty;
            ObjWebApiLog.GUID = (Guid.NewGuid()).ToString();
            ObjWebApiLog.ComputerName = Environment.MachineName;
        }

        protected internal virtual IHttpActionResult WebApiSuccess<T>(T result)
        {
            var o = result as IResponseInformation;
            if (o == null)
                throw new Exception("Not allowed. Make sure return type is derived from Response Information.");

            var response = o;
            response.ResponseStatus = 1;  //Sucess
            response.ErrorMessage = string.Empty;
            response.StackTrace = string.Empty;
            return new WebApiActionResult<T>(Request, result);

        }

        protected internal virtual IHttpActionResult WebApiError(Exception ex)
        {
            var errorInfo = new Error
            {
                ResponseStatus = 0,
                ErrorMessage = ex.Message,
                StackTrace = ex.StackTrace
            };

            return new WebApiActionResult<Error>(Request, errorInfo);
        }

        public static string GetException(Exception ex)
        {
            if (ex.InnerException != null)
            {
                return $"{ex.Message} > {GetException(ex.InnerException)} ";
            }

            var retval = ex.Message;
            if (retval == "Object reference not set to an instance of an object.")
            {
                retval = retval + "Stack Trace:" + ex.StackTrace;
            }
            return retval;
        }
    }

    public class WebApiActionResult<T> : IHttpActionResult
    {
        private readonly T _resp;
        readonly HttpRequestMessage _request;

        public WebApiActionResult(HttpRequestMessage req, T result)
        {
            _request = req;
            _resp = result;
        }

        public Task<HttpResponseMessage> ExecuteAsync(CancellationToken cancellationToken)
        {
            var response = _request.CreateResponse<T>(HttpStatusCode.OK, _resp);
            return Task.FromResult(response);
        }
    }

    class Error : Models.IResponseInformation
    {
        public string ErrorMessage { get; set; }
        public int ResponseStatus { get; set; }
        public string StackTrace { get; set; }
    }
}
