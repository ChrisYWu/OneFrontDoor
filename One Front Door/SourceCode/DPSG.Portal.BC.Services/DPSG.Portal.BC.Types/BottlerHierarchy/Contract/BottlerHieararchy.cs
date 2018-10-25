using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.BottlerHierarchy.Contract
{
    [DataContract]
    public class BottlerHieararchy :Base
    {
        [DataMember]
        public int Ebid { get; set; }
        [DataMember]
        public int Parent { get; set; }
        [DataMember]
        public string BcnodeID { get; set; }
        [DataMember]
        public string Ebname { get; set; }
   
    }
}
