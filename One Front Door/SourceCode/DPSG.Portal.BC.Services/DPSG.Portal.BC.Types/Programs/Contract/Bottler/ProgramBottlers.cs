using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Programs.Contract.Bottler
{
    [DataContract]
    public class ProgramBottlers
    {
        [DataMember]
        public int BottlerID { get; set; }
        [DataMember]
        public int ProgramID {get; set;}
    }
}
