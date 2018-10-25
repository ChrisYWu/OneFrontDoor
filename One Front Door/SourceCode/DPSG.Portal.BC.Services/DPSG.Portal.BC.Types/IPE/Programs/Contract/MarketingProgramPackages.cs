using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;
using DPSG.Portal.BC.Types.Programs.Contract.Region;

namespace DPSG.Portal.BC.Types.IPE.Programs.Contract
{
    [DataContract]
    public class MarketingProgramPackages : Base
    {
        [DataMember]
        public int ProgramID { get; set; }
        [DataMember]
        public int PackageID { get; set; }
    }
}
