using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryTime.WebAPI.Model.Input
{
    public class RouteInput
    {
        public string RouteNumber { get; set; }
        public DateTime DeliveryDate { get; set; }
    }
}
