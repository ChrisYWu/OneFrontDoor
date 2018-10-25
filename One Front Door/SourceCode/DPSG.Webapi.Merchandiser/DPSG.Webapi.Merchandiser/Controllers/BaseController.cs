
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;
using System.Web.Http.Description;
using System.Net.Http;
using System.Threading;
using System.Net;
using System.Threading.Tasks;
using DPSG.Webapi.Merchandiser.CommonUtils;
using DPSG.Webapi.Merchandiser.Model;
using System.Web.Http.Cors;

namespace DPSG.Webapi.Merchandiser.Controllers
{

    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class BaseController : ApiController
    {
        public BaseController()
        {
            //Creating mysplashnet context
            string id = MercContext.CreateContext();
            HttpContext.Current.Items.Add("MercSessionID", id);
        }
        protected internal virtual IHttpActionResult MSNOk<T>(T result)
        {
            if (result is Model.IResponseInformation)
            {
                Model.IResponseInformation response = (Model.IResponseInformation)(object)result;
                response.ReturnStatus = 1;  //Sucess
                response.CorrelationID = MercContext.Current.CorrelationID;
                return new MercActionResult<T>(Request, result);
            }
            else
                throw new Exception("Not allowed. Make sure return type is derived from Response Information.");
        }
        protected internal virtual IHttpActionResult MSNError(Exception ex)
        {
            Error errorInfo = new Error();
            errorInfo.ReturnStatus = 0;
            errorInfo.Message = ex.Message;
            errorInfo.StackTrace = ex.StackTrace;
            errorInfo.CorrelationID = MercContext.Current.CorrelationID;
            return new MercActionResult<Error>(Request, errorInfo);
        }

        protected override OkNegotiatedContentResult<T> Ok<T>(T content)
        {
            throw new Exception("Not allowed. Please use MSNAction Result");
        }
    }

    public class MercActionResult<T> : IHttpActionResult
    {

        T resp;
        HttpRequestMessage _request;

        public MercActionResult(HttpRequestMessage req, T result)
        {
            _request = req;
            resp = result;
        }

        public Task<HttpResponseMessage> ExecuteAsync(CancellationToken cancellationToken)
        {
            var response = _request.CreateResponse<T>(HttpStatusCode.OK, resp);
            return Task.FromResult(response);
        }
    }

    class Error : Model.IResponseInformation
    {
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }
}