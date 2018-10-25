using DPSG.Webapi.Merchandiser.DataServices;
using DPSG.Webapi.Merchandiser.Modal;
using DPSG.Webapi.Merchandiser.Modals;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System.Configuration;

namespace DPSG.Webapi.Merchandiser.BusinessServices
{
    public class CommonUtilBS
    {
        public UserDetailOutput GetUserDetailBS(string GSN)
        {
            GSN = GSN.Substring(GSN.LastIndexOf('\\') + 1);
            CommonUtilDS ds = new CommonUtilDS();
            return ds.GetUserDetailDS(GSN);
        }

    

        public ImageOutput GetImageDetailByBlobIDBS(ImageInput input)
        {
            CommonUtilDS ds = new CommonUtilDS();
            return ds.GetImageDetailByBlobIDDS(input);
        }

        public ContainerExtensionOutput ExtendContainerReadSAS(int input)
        {
            CommonUtilDS ds = new CommonUtilDS();
            var container = ds.GetAzureContainer(input).Containers.FirstOrDefault();
            DateTime expiration = DateTime.UtcNow.AddHours(24);
            CloudStorageAccount cloudStorageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings[container.ConnectionString].ConnectionString);

            CloudBlobClient cloudBlobClient = cloudStorageAccount.CreateCloudBlobClient();
            CloudBlobContainer cloudBlobContainer = cloudBlobClient.GetContainerReference(container.Container);

            var sasConstraints = new SharedAccessBlobPolicy();
            sasConstraints.SharedAccessStartTime = DateTime.UtcNow.AddMinutes(-5);
            sasConstraints.SharedAccessExpiryTime = expiration;
            sasConstraints.Permissions = SharedAccessBlobPermissions.Read;
            string sas = cloudBlobContainer.GetSharedAccessSignature(sasConstraints);

            ds.ExtendContrainerReadSAS(input, expiration, sas);

            ContainerExtensionOutput output = new ContainerExtensionOutput();
            output.Response = sas;
            output.ReturnStatus = 0;
            output.Message = "Ok";
            return output; 
        }

        
    }
}
