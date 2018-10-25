using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.IPE.MasterData.Contract
{
    [DataContract]
    public class PhaseEntity : Base 
    {
        [DataMember]
        public int PhaseID { get; set; }
        [DataMember]
        public string Name { get; set; }
        [DataMember]
        public byte SortOrder { get; set; }
    }
}
