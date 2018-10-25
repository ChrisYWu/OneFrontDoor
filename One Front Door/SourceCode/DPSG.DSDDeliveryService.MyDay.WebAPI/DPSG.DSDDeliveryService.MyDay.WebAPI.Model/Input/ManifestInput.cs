using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Input
{
    public class ManifestInput
    {
        public DateTime DeliveryDateUTC { get; set; }
        public int RouteID { get; set; }
    }
}
