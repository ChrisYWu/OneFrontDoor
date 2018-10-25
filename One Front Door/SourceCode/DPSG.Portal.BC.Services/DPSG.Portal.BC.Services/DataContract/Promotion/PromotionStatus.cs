using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Promotion
{
    [DataContract]
    public class Status
    {
        [DataMember]
        public int StatusID;
        [DataMember]
        public string StatusMessage;
    }
}