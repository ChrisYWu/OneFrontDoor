using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.IPE.MasterData.Contract
{
    [DataContract]
    public class ResponseTypeEntity : Base
    {
        [DataMember]
        public int ResponseTypeID { get; set; }
        [DataMember]
        public string ResponseType { get; set; }
    }
}
