using DPSG.Portal.Merchandiser.WebAPI.Model.Input;
using DPSG.Portal.Merchandiser.WebAPI.Model.Output;
using System;
using System.Reflection;
using System.Web.Http;
using System.Web.Http.Description;
using System.Collections.Generic;

namespace DPSG.Portal.Merchandiser.WebAPI.Controllers
{
    public class DisplayController : BaseController
    {
        #region All Merch HttpGet methods
        [HttpGet]
        [ResponseType(typeof(Model.Output.MerchBuildMaster))]
        public IHttpActionResult GetMerchBuildMaster(DateTime? LastModified = null)
        {
            DataService.MerchDataService logDataService = new DataService.MerchDataService();
            DataService.DisplayBuildDataService dataService = new DataService.DisplayBuildDataService();
            try
            {
                return WebAPISuccess(dataService.GetMerchBuildMaster(LastModified));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                logDataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpGet]
        [ResponseType(typeof(Model.Output.DisplayBuildWithLatestStatus))]
        public IHttpActionResult GetDisplayBuildWithLatestStatus(string SAPAccountNumber, DateTime? DispatchDate = null, bool IncludeBuiltOnes = false)
        {
            DataService.MerchDataService logDataService = new DataService.MerchDataService();
            DataService.DisplayBuildDataService dataService = new DataService.DisplayBuildDataService();
            try
            {
                var raw = dataService.GetDisplayBuildWithLatestStatus(SAPAccountNumber, DispatchDate, IncludeBuiltOnes);
                DisplayBuildWithLatestStatus retval = ApplyImageTranslation(raw);

                return WebAPISuccess(retval);
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                logDataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        private static DisplayBuildWithLatestStatus ApplyImageTranslation(DisplayBuildWithLatestStatusRaw raw)
        {
            DisplayBuildWithLatestStatus retval = new DisplayBuildWithLatestStatus();

            retval.DisplayBuilds = new List<DisplayBuildOutputTranslated>();
            foreach (var v in raw.DisplayBuilds)
            {
                var img = ImageHub.GetWritableImageURL(new ImageRequest()
                {
                    AbsoluteURL = v.AbsoluteURL,
                    AccessLevel = v.AccessLevel,
                    AzureConnectionString = v.ConnectionString,
                    Container = v.Container,
                    RelativeURL = v.RelativeURL,
                    StorageAccount = v.StorageAccount
                });
                var tr = new DisplayBuildOutputTranslated(v);
                tr.InstructionImageURL = img.AbsoluteURL;
                tr.InstructionImageSAS = img.SAS;

                img = ImageHub.GetWritableImageURL(new ImageRequest()
                {
                    AbsoluteURL = v.ExecAbsoluteURL,
                    AccessLevel = v.ExecAccessLevel,
                    AzureConnectionString = v.ExecConnectionString,
                    Container = v.ExecContainer,
                    RelativeURL = v.ExecRelativeURL,
                    StorageAccount = v.ExecStorageAccount
                });

                tr.ImageURL = img.AbsoluteURL;
                tr.ImageSAS = img.SAS;

                retval.DisplayBuilds.Add(tr);
            }

            return retval;
        }

        [HttpGet]
        [ResponseType(typeof(Model.Output.DisplayBuildWithLatestStatus))]
        public IHttpActionResult GetDisplayBuildWithLatestStatusByRouteNumber(string RouteNumber)
        {
            DataService.MerchDataService logDataService = new DataService.MerchDataService();
            DataService.DisplayBuildDataService dataService = new DataService.DisplayBuildDataService();
            try
            {
                var raw = dataService.GetDisplayBuildWithLatestStatusByRouteNumber(RouteNumber);
                DisplayBuildWithLatestStatus retval = ApplyImageTranslation(raw);

                return WebAPISuccess(retval);
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                logDataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }
        #endregion

        #region All Merch HttpPost methods

        [HttpPost]
        public IHttpActionResult UploadDisplayBuild(DisplayBuild displayBuild)
        {
            DataService.DisplayBuildDataService dataService = new DataService.DisplayBuildDataService();
            DataService.MerchDataService logDataService = new DataService.MerchDataService();
            try
            {               
                return WebAPISuccess(dataService.InsertDisplayBuild(displayBuild));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                logDataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult UploadDisplayBuildExecution(DisplayBuildExecution displayBuildExecution)
        {
            DataService.DisplayBuildDataService dataService = new DataService.DisplayBuildDataService();
            DataService.MerchDataService logDataService = new DataService.MerchDataService();
            try
            {
                return WebAPISuccess(dataService.UpsertDisplayBuildExecution(displayBuildExecution));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                logDataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        #endregion

    }
}
