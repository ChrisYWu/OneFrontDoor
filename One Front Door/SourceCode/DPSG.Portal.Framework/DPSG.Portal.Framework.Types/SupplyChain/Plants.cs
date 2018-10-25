using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class Plants
    {
        [DataMember]
        public int PlantID { get; set; }
        [DataMember]
        public string PlantName { get; set; }
        [DataMember]
        public int MeasursID { get; set; }
    }
}
