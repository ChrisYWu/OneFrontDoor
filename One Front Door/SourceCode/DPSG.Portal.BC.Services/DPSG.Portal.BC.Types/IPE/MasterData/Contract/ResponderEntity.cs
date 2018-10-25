using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.IPE.MasterData.Contract
{
    [DataContract]
    public class ResponderEntity : Base
    {
        [DataMember]
        public int ResponderID { get; set; }
        [DataMember]
        public string Name { get; set; }
        [DataMember]
        public string Method { get; set; }


    }
}
