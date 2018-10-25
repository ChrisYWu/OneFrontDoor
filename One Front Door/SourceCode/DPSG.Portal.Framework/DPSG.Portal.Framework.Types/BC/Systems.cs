using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    [DataContract]
    public class Systems
    {
        [DataMember]
        public int SystemID { get; set; }
        [DataMember]
        public string SystemName { get; set; }
    }

    [DataContract]
    public class Zone
    {
        [DataMember]
        public int ZoneID { get; set; }
        [DataMember]
        public string ZoneName { get; set; }
    }

    [DataContract]
    public class Division
    {
        [DataMember]
        public int DivisionID { get; set; }
        [DataMember]
        public string DivisionName { get; set; }
    }
   
}
