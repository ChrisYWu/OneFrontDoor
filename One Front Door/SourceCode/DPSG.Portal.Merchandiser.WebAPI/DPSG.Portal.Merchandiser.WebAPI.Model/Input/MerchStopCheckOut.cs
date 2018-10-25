using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Input
{
    public class MerchStopCheckOut
    {
        public DateTime ScheduleDate { get; set; }
        public string GSN { get; set; }       
        public int ClientSequence { get; set; }
        public int SameStoreSequence { get; set; }
        public int MerchGroupID { get; set; }
        public Int64 SAPAccountNumber { get; set; }
        public DateTime ClientCheckOutTime { get; set; }
        public string ClientCheckOutTimeZone { get; set; }        
        public decimal CheckOutLatitude { get; set; }
        public decimal CheckOutLongitude { get; set; }
        public int CasesHandeled { get; set; }
        public int CasesInBackroom { get; set; }
        public string Comments { get; set; }
        public int AtAccountTimeInMinute { get; set; }
    }
}
