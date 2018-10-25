using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract
{
    [DataContractAttribute]
    public class ResponseBase
    {
        int responseStatus = DPSG.Portal.BC.Common.Constants.RESPONSE_STATUS_PASS;
        [DataMember]
        public int ResponseStatus { get { return responseStatus; } set { responseStatus = value; } }

        [DataMember]
        public string ErrorMessage { get; set; }
        [DataMember]
        public string StackTrace { get; set; }

    }
}