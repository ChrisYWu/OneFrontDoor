using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryTime.WebAPI.Model.Input
{
    public class DeliveryTimeUpdates
    {
        public DateTime DeliveryDate { get; set; }
        public string RouteNumber { get; set; }
        public string DriverID { get; set; }
        public string GSN { get; set; }
        public List<DeliveryTimeUpdate> DeliveryStops { get; set; }
    }

    public class DeliveryTimeUpdate
    {
        public int StopSequence { get; set; }
        public Int64 StopID { get; set; }
        public DateTime? ActualArrivalTime { get; set; }
        public string ActualArrivalTimeZone { get; set; }
        public DateTime? ActualDepartureTime { get; set; }
        public string ActualDepartureTimeZone { get; set; }
        public DateTime? EstimatedArrivalTime { get; set; }
        public string EstimatedArrivalTimeZone { get; set; }
    }
}
