using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Input
{
   public class MerchProfilePicture
    {
        public string GSN { get; set; }
        public string RelativeURL { get; set; }
        public string AbsoluteURL { get; set; }
        public string StorageAccount { get; set; }
        public string Container { get; set; }
        public DateTime ClientTime { get; set; }
        public string ClientTimeZone { get; set; }
    }
}
