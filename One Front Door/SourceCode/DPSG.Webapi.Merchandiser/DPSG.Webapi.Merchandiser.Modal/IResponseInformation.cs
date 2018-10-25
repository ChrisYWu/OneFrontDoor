
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Webapi.Merchandiser.Model
{
    public interface IResponseInformation
    {
        //1 sucess, else error code
        int ReturnStatus { get; set; }
        string Message { get; set; }
        string CorrelationID { get; set; }
        string StackTrace { get; set; }
    }
}
