using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Input
{
    public class StripeFormSubmit : Output.OutputBase
    {
        public string stripeToken { get; set; }
        public string stripeTokenType { get; set; }
        public string stripeEmail { get; set; }
    }

    public class StripeFormSubmitWithResult : StripeFormSubmit
    {
        public StripeFormSubmitWithResult(StripeFormSubmit input)
        {
            this.stripeEmail = input.stripeEmail;
            this.stripeToken = input.stripeToken;
            this.stripeTokenType = input.stripeTokenType;
            this.result = "Something wrong";
        }

        public string result { get; set; }
        public string Id { get; set; }
        public string Status { get; set; }
        public DateTime CreatedUTC { get; set; }
    }
}
