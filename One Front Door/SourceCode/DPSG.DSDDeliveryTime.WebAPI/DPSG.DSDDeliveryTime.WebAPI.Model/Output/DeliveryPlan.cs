using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryTime.WebAPI.Model.Output
{
    public class DeliveryPlan: OutputBase
    {
        public List<DeliveryStop> DeliveryStops { get; set; }
    }

    public class DeliveryStop
    {
        public String DeliveryDate { get; set; }
        public string RouteNumber { get; set; }
        public string DriverID { get; set; }
        public int StopSequence { get; set; }
        public string StopType { get; set; }
        public Int64? StopID { get; set; }
        public DateTime? PlannedArrivalTime { get; set; }
        public DateTime? ActualArrivalTime { get; set; }
        public string TimeZone { get; set; }
        public int? PlannedServiceTimeInSec { get; set; }
    }
}
