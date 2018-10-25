using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Programs.Contract.Region
{
    [DataContract]
    public class ProgramPackages
    {
        [DataMember]
        public int ProgramID { get; set; }
        [DataMember]
        public int PackageID {get; set;}

    }
}
