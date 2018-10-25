using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Programs
{  
    [DataContract]
    public class ProgramBottlerDetails
    {
        [DataMember]
        public int BottlerID {get;set;}
        
        [DataMember]
        public IList<int> ProgramID {get;set;}
    }
}
