using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class BusinessUnit
    {
        [DataMember]
        public int buId { get; set; }
        [DataMember]
        public string buName { get; set; }
        [DataMember]
        public string SAPBUId { get; set; }
    }
}
