using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Input
{
   public class MerchStoreSignature
    {
        public DateTime ScheduleDate { get; set; }
        public string GSN { get; set; }
        public Int64 SAPAccountNumber { get; set; }
        public string ManagerName { get; set; }
        public string SignatureName { get; set; }
        public DateTime ClientTime { get; set; }
        public string ClientTimeZone { get; set; }
        public string RelativeURL { get; set; }
        public string AbsoluteURL { get; set; }
        public string StorageAccount { get; set; }
        public string Container { get; set; }
    }
}
