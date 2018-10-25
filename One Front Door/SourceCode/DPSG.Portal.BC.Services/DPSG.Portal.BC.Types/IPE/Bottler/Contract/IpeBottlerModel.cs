using System;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.IPE.Bottler.Contract
{
    [DataContract]
    public class IpeBottlerModel : Base
    {
        [DataMember]
        public int BottlerID { get; set; }
        [DataMember]
        public int TradeMarkID { get; set; }
        [DataMember]
        public string Comments { get; set; }

    }
}
