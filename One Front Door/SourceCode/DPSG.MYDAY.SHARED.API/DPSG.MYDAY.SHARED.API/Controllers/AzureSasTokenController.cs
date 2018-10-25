using DPSG.MYDAY.SHARED.API.Models.AzureSasToken;
using Microsoft.WindowsAzure.Storage;
using System;
using System.Configuration;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using DAL = DPSG.MYDAY.SHARED.API.DataAccess;

namespace DPSG.MYDAY.SHARED.API.Controllers
{
    [RoutePrefix("api/AzureSasTokens")]
    public class AzureSasTokenController : BaseController
    {
        private readonly CloudStorageAccount _cloudStorageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings["Azure.Connect.Briefcase"].ConnectionString);

        [HttpGet]
        [ActionName("GetContainerToken")]
        [ResponseType(typeof(BriefcaseSasToken))]
        public async Task<IHttpActionResult> GetContainerToken(string container)
        {
            BriefcaseSasToken results;
            var dataservice = new DAL.AzureSasToken.Dataservice();

            try
            {
       
                results = await dataservice.GetContainerToken(container, _cloudStorageAccount);               

            }
            catch (Exception ex)
            {
                ObjWebApiLog.OperationName = GetActualAsyncMethodName(); // MethodBase.GetCurrentMethod().Name;
                ObjWebApiLog.Exception = GetException(ex);
                //ObjWebApiLog.Json = Common.Helper.JsonSerializeObject(jsonBody);
                ObjWebApiLog.ServiceName = $"{ObjWebApiLog.ServiceName}-{Common.Constants.ApplicationName.APPNAME_BRIEFCASE}";
                await ErrorLoggingService.LogErrorsAsync(ObjWebApiLog);
                return WebApiError(ex);
            }

            return WebApiSuccess(results);
        }

      

    }
}
