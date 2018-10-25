using System;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.SalesMaster.Contract
{
    [DataContract]
    public class BottlerTrademarks : Base
    {
        [DataMember]
        public int BottlerID { get; set; }
        [DataMember]
        public int TradeMarkID { get; set; }
    }
}
