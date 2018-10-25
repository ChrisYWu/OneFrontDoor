using System;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System.Configuration;
using DPSG.Portal.Merchandiser.WebAPI.Model.Output;
using DPSG.Portal.Merchandiser.WebAPI.Model.Input;

namespace DPSG.Portal.Merchandiser.WebAPI
{
    public sealed class Singleton
    {
        private static readonly Singleton instance = new Singleton();

        private Singleton() { }

        public string AzureStorageConnection { get; set; }

        public static Singleton Instance
        {
            get
            {
                if (string.IsNullOrWhiteSpace(instance.AzureStorageConnection))
                {
                    DataService.MerchDataService logDataService = new DataService.MerchDataService();
                    DataService.DisplayBuildDataService dataService = new DataService.DisplayBuildDataService();
                    var retval = dataService.GetAzureStorageConnection();
                    instance.AzureStorageConnection = retval.Response;
                }

                return instance;
            }
        }
    }

    public static class ImageHub
    {
        internal static BlobWithAccess GetWritableImageURL(ImageRequest request)
        {
            return GetImageURLWithPermissions(request, SharedAccessBlobPermissions.Read | SharedAccessBlobPermissions.Write);
        }

        internal static BlobWithAccess GetReadOnlyImageURL(ImageRequest request)
        {
            return GetImageURLWithPermissions(request, SharedAccessBlobPermissions.Read);
        }

        internal static string ExtendReadSAS(AzureContainer container, DateTime expirationDate)
        {
            return ExtendSAS(container, expirationDate, SharedAccessBlobPermissions.Read);
        }

        internal static string ExtendWriteSAS(AzureContainer container, DateTime expirationDate)
        {
            return ExtendSAS(container, expirationDate, SharedAccessBlobPermissions.Read | SharedAccessBlobPermissions.Write);
        }

        private static string ExtendSAS(AzureContainer container, DateTime expirationDate, SharedAccessBlobPermissions permissions)
        {
            CloudStorageAccount cloudStorageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings[container.ConnectionString].ConnectionString);

            CloudBlobClient cloudBlobClient = cloudStorageAccount.CreateCloudBlobClient();
            CloudBlobContainer cloudBlobContainer = cloudBlobClient.GetContainerReference(container.Container);

            var sasConstraints = new SharedAccessBlobPolicy();
            sasConstraints.SharedAccessStartTime = DateTime.UtcNow.AddMinutes(-5);
            sasConstraints.SharedAccessExpiryTime = expirationDate;
            sasConstraints.Permissions = permissions;
            string sas = cloudBlobContainer.GetSharedAccessSignature(sasConstraints);

            return sas;
        }

        private static BlobWithAccess GetImageURLWithPermissions(ImageRequest request, SharedAccessBlobPermissions permissions)
        {
            var imageURL = new BlobWithAccess();
            if (request != null && !string.IsNullOrWhiteSpace(request.AbsoluteURL))
            {
                if ((permissions == SharedAccessBlobPermissions.Read) && ((request.AccessLevel == "Blob") | (request.AccessLevel == "Container")))
                {
                    imageURL.AbsoluteURL = request.AbsoluteURL;
                    imageURL.SAS = string.Empty;
                }
                else
                {
                    CloudStorageAccount cloudStorageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings[request.AzureConnectionString].ConnectionString);

                    CloudBlobClient cloudBlobClient = cloudStorageAccount.CreateCloudBlobClient();
                    CloudBlobContainer cloudBlobContainer = cloudBlobClient.GetContainerReference(request.Container);
                    CloudBlockBlob fileBlobReference = cloudBlobContainer.GetBlockBlobReference(request.RelativeURL);

                    string imageUrl = string.Empty;

                    var sasConstraints = new SharedAccessBlobPolicy();
                    sasConstraints.SharedAccessStartTime = DateTime.UtcNow.AddMinutes(-5);
                    sasConstraints.SharedAccessExpiryTime = DateTime.UtcNow.AddHours(24);
                    sasConstraints.Permissions = permissions;
                    string sas = cloudBlobContainer.GetSharedAccessSignature(sasConstraints);

                    imageURL.AbsoluteURL = fileBlobReference.Uri.ToString();
                    imageURL.SAS = sas;
                }
            }
            return imageURL;
        }

        public class AzureSAS
        {
            public string SASPhrase { get; set; }
            public DateTime ExpirationDate { get; set; }
        }
    }
}