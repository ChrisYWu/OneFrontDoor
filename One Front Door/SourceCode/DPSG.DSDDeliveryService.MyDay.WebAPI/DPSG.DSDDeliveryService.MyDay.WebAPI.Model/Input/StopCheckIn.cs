using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Input
{
    public class StopCheckIn : UpdatedArrival
    {
        public int CurrentDeliveryStopID { get; set; }
        public DateTime CheckInTime { get; set; }
        public DateTime? ArrivalTime { get; set; }
        public int? CheckInFarAwayReasonID { get; set; }
        public Decimal CheckInDistance { get; set; }
        public Decimal CheckInLatitude { get; set; }
        public Decimal CheckInLongitude { get; set; }

    }
}
