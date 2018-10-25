using System;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Priority.Contract
{
    [DataContract]
    public class PriorityBrand: Base
    {
        [DataMember]
        public int PriorityID { get; set; }

        [DataMember]
        public int? TradeMarkID { get; set; }

        [DataMember]
        public int? BrandID { get; set; }
    }
}