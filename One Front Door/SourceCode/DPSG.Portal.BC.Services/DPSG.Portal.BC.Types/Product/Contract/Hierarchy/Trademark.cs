using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Product.Contract.Hierarchy
{
    [DataContract]
    public class Trademark:Base
    {
        [DataMember]
        public int TradeMarkID { get; set; }
        [DataMember]
        public string TradeMarkName { get; set; }
        [DataMember]
        public string SAPTradeMarkID { get; set; }

    }
}
