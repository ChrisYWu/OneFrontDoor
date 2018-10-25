using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Programs.Contract.Region
{
    [DataContract]
    public class ProgramAccounts
    {
        [DataMember]
        public int ProgramID { get; set; }
        [DataMember]
        public int  NationalChainID { get; set; }
        [DataMember]
        public int  RegionalChainID {get; set;}
        [DataMember]
        public int LocalChainID {get; set;}

    }
}
