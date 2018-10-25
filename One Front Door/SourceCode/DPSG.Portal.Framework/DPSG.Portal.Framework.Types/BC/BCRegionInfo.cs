using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    [DataContract]
    public class BCRegionInfo
    {
        [DataMember]
        public int SystemID { get; set; }
        [DataMember]
        public string SystemName { get; set; }
        [DataMember]
        public int ZoneID { get; set; }
        [DataMember]
        public string ZoneName { get; set; }
        [DataMember]
        public int DivisionID { get; set; }
        [DataMember]
        public string DivisionName { get; set; }
        [DataMember]
        public int RegionID { get; set; }
        [DataMember]
        public string RegionName { get; set; }
    }
}
