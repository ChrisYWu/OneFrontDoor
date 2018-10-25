using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryTime.WebAPI.Model.Input
{
    public class CustomerNumberInput : DPSG.DSDDeliveryTime.WebAPI.Model.Output.OutputBase
    {
        public string CustomerNumbers { get; set; }
        public DateTime DeliveryDate { get; set; }
    }
}
