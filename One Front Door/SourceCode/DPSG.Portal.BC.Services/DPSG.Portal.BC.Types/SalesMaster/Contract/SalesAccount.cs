using System;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.SalesMaster.Contract
{
    [DataContract]
    public class SalesAccount : Base
    {
        [DataMember]
        public int BCSalesAccountabilityID { get; set; }
        [DataMember]
        public string GSN { get; set; }
        [DataMember]
        public int? TotalCompanyID { get; set; }
        [DataMember]
        public int? CountryID { get; set; }
        [DataMember]
        public int? SystemID { get; set; }
        [DataMember]
        public int? ZoneID { get; set; }
        [DataMember]
        public int? DivisionID { get; set; }
        [DataMember]
        public int? RegionID { get; set; }
        [DataMember]
        public bool IsPrimary { get; set; }
        [DataMember]
        public bool IsSystemLoad { get; set; }

    }
}
