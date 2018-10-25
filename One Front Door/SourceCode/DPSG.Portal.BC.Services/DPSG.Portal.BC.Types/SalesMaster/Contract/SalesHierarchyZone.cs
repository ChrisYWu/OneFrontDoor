using System;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.SalesMaster.Contract
{
    [DataContract]
    public class SalesHierarchyZone : Base
    {
        [DataMember]
        public int ZoneID { get; set; }
        [DataMember]
        public string BCNodeID { get; set; }
        [DataMember]
        public string ZoneName { get; set; }
        [DataMember]
        public int SystemID { get; set; }
    }
}
