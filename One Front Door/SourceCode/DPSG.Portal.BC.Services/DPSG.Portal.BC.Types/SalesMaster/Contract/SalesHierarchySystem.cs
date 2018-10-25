using System;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.SalesMaster.Contract
{
    [DataContract]
    public class SalesHierarchySystem : Base
    {
        [DataMember]
        public int SystemID { get; set; }
        [DataMember]
        public string BCNodeID { get; set; }
        [DataMember]
        public string SystemName { get; set; }
        [DataMember]
        public int CountryID { get; set; }
    }
}
