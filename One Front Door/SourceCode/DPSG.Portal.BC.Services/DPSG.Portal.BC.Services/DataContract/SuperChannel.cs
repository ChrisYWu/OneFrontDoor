using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract
{
    [DataContract]
    public class SuperChannel : Base
    {
        [DataMember]
        public int SuperChannelID { get; set; }
        [DataMember]
        public string SAPSuperChannelID { get; set; }
        [DataMember]
        public string SuperChannelName { get; set; }
    }
}