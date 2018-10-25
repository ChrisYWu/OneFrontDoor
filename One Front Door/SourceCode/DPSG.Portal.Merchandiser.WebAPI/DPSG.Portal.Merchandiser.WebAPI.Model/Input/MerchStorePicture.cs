using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Input
{
   public class MerchStorePicture
    {
        public DateTime ScheduleDate { get; set; }
        public string GSN { get; set; }        
        public Int64 SAPAccountNumber { get; set; }
        public int ClientPhotoID { get; set; }
        public string Caption { get; set; }
        public string PictureName { get; set; }
        public int SizeInByte { get; set; }
        public string Extension { get; set; }
        public DateTime ClientTime { get; set; }
        public string ClientTimeZone { get; set; }
        public string RelativeURL { get; set; }
        public string AbsoluteURL { get; set; }
        public string StorageAccount { get; set; }
        public string Container { get; set; }
    }
}
