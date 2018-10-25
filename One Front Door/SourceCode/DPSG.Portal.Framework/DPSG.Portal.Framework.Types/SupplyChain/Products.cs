using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class Products
    {
        [DataMember]
        public int ProductLineID { get; set; }
        [DataMember]
        public string ProductLineName { get; set; }
    }
}
