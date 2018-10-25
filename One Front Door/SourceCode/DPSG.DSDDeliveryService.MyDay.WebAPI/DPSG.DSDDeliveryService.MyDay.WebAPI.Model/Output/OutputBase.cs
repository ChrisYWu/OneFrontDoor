using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Output
{
    public class OutputBase : Model.IResponseInformation
    {
        public string ErrorMessage { get; set; }
        public int ResponseStatus { get; set; }
        public string StackTrace { get; set; }

    }
}
