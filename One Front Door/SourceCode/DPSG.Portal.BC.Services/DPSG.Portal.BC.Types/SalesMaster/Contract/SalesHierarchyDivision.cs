using System;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.SalesMaster.Contract
{
    [DataContract]
    public class SalesHierarchyDivision : Base
    {
        [DataMember]
        public int ZoneID { get; set; }
        [DataMember]
        public string DivisionName { get; set; }
        [DataMember]
        public int DivisionID { get; set; }
        [DataMember]
        public string BCNodeID { get; set; }
    }
}
