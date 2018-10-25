using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Output
{
    public class DeliveryStopsAdded : OutputBase
    {
        public List<DeliveryStopAdded> Stops { get; set; }
    }

    public class DeliveryStopAdded: OutputBase
    {
        public int DeliveryStopID { get; set; }
        public string SAPAccountNumber { get; set; }
        public decimal? Latitude { get; set; }
        public decimal? Longitude { get; set; }
    }
}
