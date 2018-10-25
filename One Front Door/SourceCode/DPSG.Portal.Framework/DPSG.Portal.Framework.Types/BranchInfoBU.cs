using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
     [Serializable, DataContract]
    public class BranchInfoBU
    {
        [DataMember]
        public int BranchId { get; set; }
        [DataMember]
        public string SAPBranchID { get; set; }
        [DataMember]
        public string BranchName { get; set; }
        [DataMember]
        public int BUId { get; set; }
        [DataMember]
        public string SAPBUID { get; set; }
        [DataMember]
        public string BUName { get; set; }
        [DataMember]
        public int AreaId { get; set; }
        [DataMember]
        public string SAPAreaID { get; set; }
        [DataMember]
        public string AreaName { get; set; }
        [DataMember]
        public int RegionId { get; set; }
        [DataMember]
        public string SAPRegionID { get; set; }
        [DataMember]
        public string RegionName { get; set; }
       
       
        
    }
}
