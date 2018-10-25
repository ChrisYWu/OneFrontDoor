using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Input
{
    public class UpdatedStop
    {
        public int DeliveryStopID { get; set; }
        public int Sequence { get; set; }
        public DateTime EstimatedArrivalTime { get; set; }
    }

    public class UpdatedSequence : UpdatedArrival
    {
        public int RouteID { get; set; }
        public DateTime? DeliveryDateUTC { get; set; }
        public string CommaSeperatedResequenceReasonIDs { get; set; }
        public string AddtionalReason { get; set; }
    }
}
