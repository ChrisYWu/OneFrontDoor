using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Input
{
    public class StopDNS 
    {
        public int DeliveryStopID { get; set; }
        public string DNSReasonCode { get; set; }
        public string DNSReason { get; set; }
        public string LastModifiedBy { get; set; }
        public DateTime LastModifiedUTC { get; set; }
        public DateTime? DeliveryDateUTC { get; set; }
        public int? RouteID { get; set; }
    }

    public class StopDNSCancel
    {
        public int DeliveryStopID { get; set; }
        public string LastModifiedBy { get; set; }
        public DateTime LastModifiedUTC { get; set; }
        public DateTime? DeliveryDateUTC { get; set; }
        public int? RouteID { get; set; }
    }
}
