using DPSG.Webapi.Merchandiser.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.Modal
{
    class MerchImage
    {
    }

    public class ImageOutput : IResponseInformation
    {
        public List<ImageDetail> Images { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class ContainerList : IResponseInformation
    {
        public List<AzureContainer> Containers { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class AzureContainer
    {
        public int ContainerID { get; set; }
        public string ConnectionString { get; set; }
        public string Container { get; set; }

    }

    public class ImageInput
    {
        public string BlobIDs { get; set; }
    }

    public class ExtendReadSASInput
    {
        public int ContainerID { get; set; }
    }

    public class ImageDetail
    {
        public string AbsoluteURL { get; set; }
        public int ContainerID { get; set; }
        public string ReadSAS { get; set; }
        public bool IsReadSASValid { get; set; }
    }

    public class ContainerExtensionOutput : IResponseInformation
    {
        public string Response { get; set; }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }
}
