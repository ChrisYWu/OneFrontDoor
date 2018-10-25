using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Store
{
    [DataContract]
    public class TieInRate : Base
    {
        [DataMember]
        public int? ConditionID { get; set; }
        [DataMember]
        public int? SystemBrandId { get; set; }
        [DataMember]
        public int SysTieInRate { get; set; }

        [DataMember]
        public int TotalPOICount { get; set; }
    }
}