using System.Globalization;
using Microsoft.WindowsAzure.Storage;
using System.Threading.Tasks;

using DTO = DPSG.MYDAY.SHARED.API.Models.AzureSasToken;

namespace DPSG.MYDAY.SHARED.API.DataAccess.AzureSasToken
{
    public class Dataservice
    {
        public async Task<DTO.BriefcaseSasToken> GetContainerToken(string container, CloudStorageAccount cloudStorageAccount = null)
        {
            var results = new DTO.BriefcaseSasToken();

            try
            {
                if (cloudStorageAccount != null)
                {
                    var cloudBlobClient = cloudStorageAccount.CreateCloudBlobClient();
                    var cloudBlobContainer = cloudBlobClient.GetContainerReference(container);

                    // FetchAttributesAsync, throws exception if container does not exist.
                    await cloudBlobContainer.FetchAttributesAsync();

                    // To handle manually, if needed 
                    // bool containerExists =  await cloudBlobContainer.ExistsAsync();

                    var sharedAccessBlobPolicy = Common.AzureSasManager.GetContainerSasUri(cloudBlobContainer);
                    var sasContainerToken = cloudBlobContainer.GetSharedAccessSignature(sharedAccessBlobPolicy, null);
                    results.Briefcase.Add(new DTO.BriefcaseSasToken.SasTokenInfo()
                    {
                        SasContainerToken = sasContainerToken,
                        Container = container,
                        BaseUrl = cloudBlobContainer.Uri.ToString(),
                        SasExpirationDate = sharedAccessBlobPolicy.SharedAccessExpiryTime.GetValueOrDefault().DateTime.ToString(CultureInfo.InvariantCulture)
                    });
                }
            }
            catch (StorageException ex)
            {
                throw ex;
            }

            return results;
        }
    }
}