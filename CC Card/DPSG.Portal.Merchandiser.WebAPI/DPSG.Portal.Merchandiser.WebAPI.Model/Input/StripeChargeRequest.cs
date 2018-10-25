using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Input
{
    public class StripeChargeRequest
    {
        public string Token { get; set; }
        public int? Amount { get; set; }
        public string Currency { get; set; }
        public string Description { get; set; }
    }
}
