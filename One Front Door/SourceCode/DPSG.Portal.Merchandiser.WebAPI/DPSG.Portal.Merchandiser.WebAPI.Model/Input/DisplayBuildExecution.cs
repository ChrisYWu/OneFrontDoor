using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Input
{
    public class DisplayBuildExecution
    {
        public Int64 SAPAccountNumber { get; set; }
        public string GSN { get; set; }
        public int PromotionID { get; set; }
        public int DisplayBuildID { get; set; }
        public int BuildStatusID { get; set; }
        public DateTime ClientTime { get; set; }
        public string ClientTimeZone { get; set; }
        public string ClientAppSource { get; set; }
        public int? DisplayLocationID { get; set; }
        public int? DisplayTypeID { get; set; }
        public int? BuildRefusalReasonID { get; set; }
        public decimal? Longitude { get; set; }
        public decimal? Latitude { get; set; }
        public string BuildNote { get; set; }
        public string ImageName { get; set; }
        public string RelativeURL { get; set; }
        public string AbsoluteURL { get; set; }
        public string StorageAccount { get; set; }
        public string Container { get; set; }

    }
}
