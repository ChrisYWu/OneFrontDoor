using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract
{
    [DataContract]
    public class Channel : Base
    {
        [DataMember]
        public int ChannelID { get; set; }
        [DataMember]
        public int? SuperChannelID { get; set; }
        [DataMember]
        public string SAPChannelID { get; set; }
        [DataMember]
        public string ChannelName { get; set; }
    }
}