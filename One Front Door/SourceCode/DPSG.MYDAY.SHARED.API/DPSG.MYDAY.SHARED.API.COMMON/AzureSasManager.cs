using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System;
using System.Configuration;

namespace DPSG.MYDAY.SHARED.API.Common
{
    public class AzureSasManager
    {

        //public static string GetContainerSasUri(CloudBlobContainer container, string storedPolicyName = null)
        //{
        //    string sasContainerToken;

        //    // If no stored policy is specified, create a new access policy and define its constraints.
        //    if (storedPolicyName == null)
        //    {
        //        // Note that the SharedAccessBlobPolicy class is used both to define the parameters of an ad-hoc SAS, and
        //        // to construct a shared access policy that is saved to the container's shared access policies.
        //        var adHocPolicy = new SharedAccessBlobPolicy()
        //        {
        //            // When the start time for the SAS is omitted, the start time is assumed to be the time when the storage service receives the request.
        //            // Omitting the start time for a SAS that is effective immediately helps to avoid clock skew.
        //            SharedAccessStartTime = DateTime.UtcNow.AddMinutes(-15),
        //            //SharedAccessExpiryTime = DateTime.UtcNow.AddHours(1),
        //            SharedAccessExpiryTime = DateTime.UtcNow.AddMinutes(15),
        //            Permissions = SharedAccessBlobPermissions.Read | SharedAccessBlobPermissions.List
        //        };

        //        // Generate the shared access signature on the container, setting the constraints directly on the signature.
        //        sasContainerToken = container.GetSharedAccessSignature(adHocPolicy, null);

        //        //Console.WriteLine("SAS for blob container (ad hoc): {0}", sasContainerToken);
        //        //Console.WriteLine();
        //    }
        //    else
        //    {
        //        // Generate the shared access signature on the container. In this case, all of the constraints for the
        //        // shared access signature are specified on the stored access policy, which is provided by name.
        //        // It is also possible to specify some constraints on an ad-hoc SAS and others on the stored access policy.
        //        sasContainerToken = container.GetSharedAccessSignature(null, storedPolicyName);

        //        //Console.WriteLine("SAS for blob container (stored access policy): {0}", sasContainerToken);
        //        //Console.WriteLine();
        //    }

        //    // Return the URI string for the container, including the SAS token.
        //    return container.Uri + sasContainerToken;

        //}

        public static SharedAccessBlobPolicy GetContainerSasUri(CloudBlobContainer container)
        {
            var adHocPolicy = new SharedAccessBlobPolicy
            {
                SharedAccessExpiryTime = DateTime.UtcNow.AddHours(24),
                Permissions = SharedAccessBlobPermissions.Read | SharedAccessBlobPermissions.List
            };

            return adHocPolicy;
        }
    }
}