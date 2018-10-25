using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryTime.WebAPI.Model.Output
{
    public class Deliveries: OutputBase
    {
        public List<DriverDelivery> DeliveryStops { get; set; }
    }

    public class DriverDelivery
    {
        public String DeliveryDate { get; set; }
        public int StoreSequence { get; set; }
        public string StopType { get; set; }
        public string Store { get; set; }
        public string FormattedPlannedDelivery { get; set; }
        public string FormattedActualArrvial { get; set; }
        public string FormattedEstimatedArrvial { get; set; }
        public int? Plan_VS_Actual { get; set; }
        public int? Estimated_VS_Actual { get; set; }

    }
}
