using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryTime.WebAPI.Model.Output
{
    public class StoreDeliveries : OutputBase
    {
        public List<StoreDelivery> Deliveries { get; set; }
    }

    public class StoreDelivery
    {
        public String DeliveryDate { get; set; }
        public String SAPAccountNumber { get; set; }
        public DateTime? PlannedArrivalTime { get; set; }
        public String PlannedArrivalTimeZone { get; set; }
        public DateTime? ActualArrivalTime { get; set; }
        public String ActualArrivalTimeZone { get; set; }
        public DateTime? ActualDepartureTime { get; set; }
        public String ActualDepartureTimeZone { get; set; }
        public DateTime? EstimatedArrivalTime { get; set; }
        public String EstimatedArrivalTimeZone { get; set; }
    }
}
