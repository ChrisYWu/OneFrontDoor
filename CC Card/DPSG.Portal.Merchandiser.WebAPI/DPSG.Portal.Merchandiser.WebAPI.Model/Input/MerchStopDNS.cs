using System;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Input
{
   public class MerchStopDNS
    {
        public int DNSReasonID { get; set; }
        public DateTime DispatchDate { get; set; }
        public String GSN { get; set; }
        public int MerchGroupID { get; set; }
        public int RouteID { get; set; }
        public int ClientSequence { get; set; }
        public Int64 SAPAccountNumber { get; set; }
        public bool IsOffRouteStop { get; set; }
        public int SameStoreSequence { get; set; }
        public DateTime DNSCheckInTime { get; set; }
        public String DNSCheckInTimeZone { get; set; }
        public decimal DNSCheckInLatitude { get; set; }
        public decimal DNSCheckInLongitude { get; set; }
    }
}

