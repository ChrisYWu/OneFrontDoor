using DPSG.MYDAY.SHARED.API.Models.ApplicationFeatures;
using System;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using DAL = DPSG.MYDAY.SHARED.API.DataAccess;

namespace DPSG.MYDAY.SHARED.API.Controllers
{
    [RoutePrefix("api/ApplicationFeatures")]
    public class ApplicationFeaturesController : BaseController
    {
        [HttpGet]
        [ActionName("GetFeatures")]
        [ResponseType(typeof(FeatureResults))]

        public async Task<IHttpActionResult> ApplicationFeatures(string applicationName, string branchId)
        {
            FeatureResults results;
            var dataService = new DAL.ApplicationFeatures.DataService();

            try
            {
                results = await dataService.ApplicationFeatures(applicationName,branchId);
            }
            catch (Exception ex)
            {

                ObjWebApiLog.OperationName = GetActualAsyncMethodName(); // MethodBase.GetCurrentMethod().Name;
                ObjWebApiLog.Exception = GetException(ex);
                //ObjWebApiLog.Json = Common.Helper.JsonSerializeObject(jsonBody);
                ObjWebApiLog.ServiceName = $"{ObjWebApiLog.ServiceName}-{Common.Constants.ApplicationName.APPNAME_FEATURES}";
                await ErrorLoggingService.LogErrorsAsync(ObjWebApiLog);
                return WebApiError(ex);
            }

            return WebApiSuccess(results);
        }


        [HttpGet]
        [AllowAnonymous]
        [ActionName("GetApplicationVersion")]
        [ResponseType(typeof(ApplicationVersionResults))]
        public async Task<IHttpActionResult> GetApplicationVersion(string applicationName)
        {
            ApplicationVersionResults results;
            var dataService = new DAL.ApplicationFeatures.DataService();

            try
            {
                results = await dataService.ApplicationVersion(applicationName);
            }
            catch (Exception ex )
            {
                ObjWebApiLog.OperationName = GetActualAsyncMethodName(); // MethodBase.GetCurrentMethod().Name;
                ObjWebApiLog.Exception = GetException(ex);
                //ObjWebApiLog.Json = Common.Helper.JsonSerializeObject(jsonBody);
                ObjWebApiLog.ServiceName = $"{ObjWebApiLog.ServiceName}-{Common.Constants.ApplicationName.APPNAME_FEATURES}";
                await ErrorLoggingService.LogErrorsAsync(ObjWebApiLog);
                return WebApiError(ex);
            }

            return WebApiSuccess(results);
        }
    }
}
