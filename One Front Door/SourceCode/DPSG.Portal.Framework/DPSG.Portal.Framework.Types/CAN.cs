using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class CAN
    {
        [DataMember]
        public int canId { get; set; }
        [DataMember]
        public string canName { get; set; }
        
    }
}
