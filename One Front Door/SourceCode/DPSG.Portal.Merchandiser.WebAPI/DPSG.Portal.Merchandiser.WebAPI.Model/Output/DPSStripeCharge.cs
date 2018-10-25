using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Output
{
    public class DPSStripeCharge : OutputBase
    {
        public string Id { get; set; }
        public string Status { get; set; }
        public DateTime CreatedUTC { get; set; }
        public string PaymentURL { get; set; }
    }
}
