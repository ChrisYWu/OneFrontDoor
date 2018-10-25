using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryTime.WebAPI.Model
{
    public interface IResponseInformation
    {             
        string ErrorMessage { get; set; }
        int ResponseStatus { get; set; }
        string StackTrace { get; set; }
        string Information { get; set; }
    }
}
