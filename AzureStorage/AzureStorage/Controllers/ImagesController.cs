using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;

namespace AzureStorage.Controllers
{
    
    public class ImagesController : ApiController
    {
        private IEnumerable<IListBlobItem> blobs { get; set; }
        private SharedAccessBlobPolicy sasConstraints { get; set; }

        private CloudStorageAccount cloudStorageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings["Azure.Connect"].ConnectionString);

        /// <summary>
        /// Example of 
        /// </summary>
        /// <param name="container"></param>
        /// <param name="folderPath"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<List<string>> GetImages(string container, string folderPath)
        {
            //string container = "images";

            try
            {
                CloudBlobClient cloudBlobClient = cloudStorageAccount.CreateCloudBlobClient();
                CloudBlobContainer cloudBlobContainer = cloudBlobClient.GetContainerReference(container);

                blobs = string.IsNullOrEmpty(folderPath) ? cloudBlobContainer.ListBlobs() : cloudBlobContainer.ListBlobs(prefix: $"{folderPath}/");

                var imageUrls = new List<string>();
                foreach (var blob in blobs)
                {
                    sasConstraints = new SharedAccessBlobPolicy();
                    sasConstraints.SharedAccessStartTime = DateTime.UtcNow.AddMinutes(-5);
                    sasConstraints.SharedAccessExpiryTime = DateTime.UtcNow.AddHours(24);
                    sasConstraints.Permissions = SharedAccessBlobPermissions.Read;
                    string sas = cloudBlobContainer.GetSharedAccessSignature(sasConstraints);

                    imageUrls.Add($"{blob.Uri}{sas}");
                }

                return imageUrls;
            }
            catch (StorageException ex)
            {

                throw ex;
            }

        }

        /// <summary>
        /// Example get by file name
        /// </summary>
        /// <param name="container"></param>
        /// <param name="fileName"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<List<string>> GetImageByFilename(string container, string fileName)
        {
            try
            {
                CloudBlobClient cloudBlobClient = cloudStorageAccount.CreateCloudBlobClient();
                CloudBlobContainer cloudBlobContainer = cloudBlobClient.GetContainerReference(container);


                CloudBlockBlob fileBlobReference = cloudBlobContainer.GetBlockBlobReference(fileName);

                //blobs = string.IsNullOrEmpty(folderPath) ? cloudBlobContainer.ListBlobs() : cloudBlobContainer.ListBlobs(prefix: $"{folderPath}/");

                var imageUrls = new List<string>();

                sasConstraints = new SharedAccessBlobPolicy();
                sasConstraints.SharedAccessStartTime = DateTime.UtcNow.AddMinutes(-5);
                sasConstraints.SharedAccessExpiryTime = DateTime.UtcNow.AddHours(24);
                sasConstraints.Permissions = SharedAccessBlobPermissions.Read;
                string sas = cloudBlobContainer.GetSharedAccessSignature(sasConstraints);

                imageUrls.Add($"{fileBlobReference.Uri.ToString()}{sas}");

                return imageUrls;
            }
            catch (StorageException ex)
            {

                throw ex;
            }

        }


        /// <summary>
        /// Example Async via pages for bulk
        /// </summary>
        /// <param name="container"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<List<string>> GetImages(string container)
        {
            // Async Paging example: container = "images"

            try
            {
                CloudBlobClient cloudBlobClient = cloudStorageAccount.CreateCloudBlobClient();
                CloudBlobContainer cloudBlobContainer = cloudBlobClient.GetContainerReference(container);

                int i = 0;
                BlobContinuationToken blobContinuationToken = null;
                BlobResultSegment blobResultsSegment = null;
                var imageUrls = new List<string>();
                do
                {
                    blobResultsSegment = await cloudBlobContainer.ListBlobsSegmentedAsync("", true, BlobListingDetails.All, 5, blobContinuationToken, null, null);
                    if (blobResultsSegment.Results.Count() > 0) { imageUrls.Add($"Page: {++i}"); }

                    foreach (var blob in blobResultsSegment.Results)
                    {
                        imageUrls.Add($"{blob.Uri}");
                    }

                    blobContinuationToken = blobResultsSegment.ContinuationToken;
                }
                while (blobContinuationToken != null);

                return imageUrls;
            }
            catch (StorageException ex)
            {

                throw ex;
            }

        }


        private SharedAccessBlobPolicy GetAzureSasPolicy(SharedAccessBlobPolicy policyConstraints, int startTimeMinutes, int expireTimeHours, SharedAccessBlobPermissions permissions)
        {
            //var sasConstraints = new SharedAccessBlobPolicy();
            policyConstraints.SharedAccessStartTime = DateTime.UtcNow.AddMinutes(startTimeMinutes);
            policyConstraints.SharedAccessExpiryTime = DateTime.UtcNow.AddHours(expireTimeHours);
            policyConstraints.Permissions = SharedAccessBlobPermissions.Read;

            return policyConstraints;
        }

    }
}
