using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Input
{
    public class MyDayLog
    {
        public string WebEndPoint { get; set; }
        public string StoredProc { get; set; }
        public string GetParameters { get; set; }
        public string PostJson { get; set; }
        public string CorrelationID { get; set; }
        public DateTime? DeliveryDateUTC { get; set; }
        public int? RouteID { get; set; }
        public string GSN { get; set; }
    }
}
