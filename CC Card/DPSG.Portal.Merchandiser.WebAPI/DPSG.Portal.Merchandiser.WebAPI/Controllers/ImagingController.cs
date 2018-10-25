using DPSG.Portal.Merchandiser.WebAPI.Model.Input;
using DPSG.Portal.Merchandiser.WebAPI.Model.Output;
using System;
using System.Reflection;
using System.Web.Http;
using System.Web.Http.Description;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System.Web.Http.Cors;

namespace DPSG.Portal.Merchandiser.WebAPI.Controllers
{
    public class ImagingController : BaseController
    {
        #region HttpGet methods
        [HttpGet]
        [ResponseType(typeof(Model.Output.ImagePostingURL))]
        public IHttpActionResult GetImagePostingURL(string imageType, string fileExtension, string clientIdentifier = "default")
        {
            NameValueCollection azureBlobContainerCollection = (NameValueCollection)ConfigurationManager.GetSection("AzureBlobStorageContainers");
            CloudStorageAccount cloudStorageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings[Singleton.Instance.AzureStorageConnection].ConnectionString);
            DataService.MerchDataService logDataService = new DataService.MerchDataService();
            string azureBlobAccountName = cloudStorageAccount.Credentials.AccountName;

            try
            {
                string container = azureBlobContainerCollection[imageType];
                if (string.IsNullOrWhiteSpace(container))
                {
                    throw new ArgumentException("Input parameter ImageType({ImageType}) is couldn't be found in configurations.");
                }

                if (!fileExtension.StartsWith("."))
                {
                    throw new ArgumentException("Input parameter fileExtension({fileExtension}) does not start with [.].");
                }

                CloudBlobClient cloudBlobClient = cloudStorageAccount.CreateCloudBlobClient();
                CloudBlobContainer cloudBlobContainer = cloudBlobClient.GetContainerReference(container);
                DateTime current = DateTime.Now;
                string folderPrefix = current.Year.ToString() + "/" + current.Month.ToString().PadLeft(2, '0') + "/" + current.Day.ToString().PadLeft(2, '0') + "/";
                //string relativePath = folderPrefix + System.IO.Path.GetFileNameWithoutExtension(fileName) + current.Ticks.ToString() + System.IO.Path.GetExtension(fileName);
                string random = Guid.NewGuid().ToString().Substring(30);
                string relativePath = folderPrefix + clientIdentifier + "-" + current.Ticks.ToString() + '-' + random + fileExtension;
                //string relativePath = folderPrefix + clientIdentifier + "-" + current.Ticks.ToString().Substring(current.Ticks.ToString().Length - 4, 4) + '-' + Guid.NewGuid().ToString() + fileExtension;

                CloudBlockBlob blob = cloudBlobContainer.GetBlockBlobReference(relativePath);

                string imageUrl = string.Empty;

                SharedAccessBlobPolicy sasConstraints = new SharedAccessBlobPolicy();
                sasConstraints.SharedAccessStartTime = DateTime.UtcNow.AddMinutes(-5);
                sasConstraints.SharedAccessExpiryTime = DateTime.UtcNow.AddHours(24);
                sasConstraints.Permissions = SharedAccessBlobPermissions.Read | SharedAccessBlobPermissions.Write;
                imageUrl = blob.Uri + blob.GetSharedAccessSignature(sasConstraints);

                ImagePostingURL retval = new ImagePostingURL();

                retval.AbsolutePath = blob.Uri.AbsoluteUri;
                retval.PostingPath = imageUrl;
                retval.RelativePath = relativePath;
                retval.StorageAccount = azureBlobAccountName;
                retval.Container = container;

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

        [HttpPost]
        [ResponseType(typeof(Model.Output.StringResponse))]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        //For backward compitability
        public IHttpActionResult GetReadOnlyImageURL(ImageRequest request)
        {
            DataService.MerchDataService logDataService = new DataService.MerchDataService();
            try
            {
                var result = ImageHub.GetReadOnlyImageURL(request);
                return WebAPISuccess(new StringResponse() { Response = $"{result.AbsoluteURL}{result.SAS}" });
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
        [ResponseType(typeof(Model.Output.StringResponse))]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public IHttpActionResult ExtendContainerReadSAS(int ContainerID)
        {
            StringResponse retval = new StringResponse();
            DataService.MerchDataService logDataService = new DataService.MerchDataService();
            DataService.DisplayBuildDataService dataService = new DataService.DisplayBuildDataService();
            try
            {
                var containers = dataService.GetAzureContainer(ContainerID);
                DateTime expiration = DateTime.UtcNow.AddHours(24);
                string readSAS = ImageHub.ExtendReadSAS(containers.Containers[0], expiration);
                dataService.ExtendContrainerReadSAS(ContainerID, expiration, readSAS);

                retval.Response = readSAS;

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

        [HttpPost]
        [ResponseType(typeof(Model.Output.StringResponse))]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public IHttpActionResult ExtendContainerReadSAS(ExtendReadSASInput input)
        {
            StringResponse retval = new StringResponse();
            DataService.MerchDataService logDataService = new DataService.MerchDataService();
            DataService.DisplayBuildDataService dataService = new DataService.DisplayBuildDataService();
            try
            {
                var containers = dataService.GetAzureContainer(input.ContainerID);
                DateTime expiration = DateTime.UtcNow.AddHours(24);
                string readSAS = ImageHub.ExtendReadSAS(containers.Containers[0], expiration);
                dataService.ExtendContrainerReadSAS(input.ContainerID, expiration, readSAS);

                retval.Response = readSAS;

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

    }
}
