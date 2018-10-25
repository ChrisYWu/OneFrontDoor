using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Store
{
    [DataContract]
    public class DisplayDetails : Base
    {
        [DataMember]
        public int StoreConditionDisplayID { get; set; }
        [DataMember]
        public int? SystemPackageID { get; set; }
        [DataMember]
        public int? SystemBrandID { get; set; }
        [DataMember]
        public int? ConditionID { get; set; }
    }
}