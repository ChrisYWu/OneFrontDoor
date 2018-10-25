using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class GEOListItem
    {
        [DataMember]
        public string ID { get; set; }
        [DataMember]
        public string Text { get; set; }
        [DataMember]
        public string SystemName { get; set; }
        [DataMember]
        public PromoGeoType Type { get; set; }
    }
}
