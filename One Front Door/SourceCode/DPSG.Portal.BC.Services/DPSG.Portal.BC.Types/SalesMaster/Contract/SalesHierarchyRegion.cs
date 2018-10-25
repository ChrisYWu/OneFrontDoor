using System;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.SalesMaster.Contract
{
    [DataContract]
    public class SalesHierarchyRegion : Base
    {
        [DataMember]
        public int RegionID { get; set; }
        [DataMember]
        public string BCNodeID { get; set; }
        [DataMember]
        public string RegionName { get; set; }
        [DataMember]
        public int DivisionID { get; set; }
    }
}
