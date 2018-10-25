using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Programs
{
    [DataContract]
    public class ProgramBottlerDetails:ResponseBase
    {
        [DataMember]
        public int BottlerID;
        [DataMember]
        public IList<int> ProgramID;
    }
}
