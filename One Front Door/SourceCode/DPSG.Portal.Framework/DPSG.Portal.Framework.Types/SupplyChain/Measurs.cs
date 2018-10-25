using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class Measurs
    {
        [DataMember]
        public int MeasursID { get; set; }
        [DataMember]
        public int? DeptID { get; set; }
        [DataMember]
        public string MeasursType { get; set; }
    }
}
