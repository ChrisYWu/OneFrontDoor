using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class ChannelJSON
    {
        [DataMember]
        public int ChannelId { get; set; }
        [DataMember]
        public string ChannelName { get; set; }
        [DataMember]
        public string SAPChannelId { get; set; }

    }
}
