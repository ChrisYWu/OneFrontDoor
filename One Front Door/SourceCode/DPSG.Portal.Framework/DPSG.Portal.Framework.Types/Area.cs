using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class Area
    {
        [DataMember]
        public int AreaId { get; set; }
        [DataMember]
        public string AreaName { get; set; }
        [DataMember]
        public string SAPAreaId { get; set; }
    }
}
