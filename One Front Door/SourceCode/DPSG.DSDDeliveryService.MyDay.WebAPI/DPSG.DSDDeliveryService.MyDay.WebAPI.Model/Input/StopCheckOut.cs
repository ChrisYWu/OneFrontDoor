using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Input
{
    public class StopCheckOut : UpdatedArrival
    {
        public int CurrentDeliveryStopID { get; set; }
        public DateTime CheckOutTime { get; set; }
        public DateTime? DepartureTime { get; set; }
        public Decimal CheckOutLatitude { get; set; }
        public Decimal CheckOutLongitude { get; set; }
        public Boolean Voided { get; set; }

    }
}
