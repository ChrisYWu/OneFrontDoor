using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class Region
    {
        [DataMember]
        public int regionId { get; set; }
        [DataMember]
        public string regionName { get; set; }
        [DataMember]
        public string SAPRegionId { get; set; }
    }
}
