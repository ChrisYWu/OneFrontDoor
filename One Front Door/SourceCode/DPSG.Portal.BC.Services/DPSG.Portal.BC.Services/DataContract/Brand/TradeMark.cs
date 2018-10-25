using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Brand
{
    [DataContract]
    public class TradeMark :Base
    {
        [DataMember]
        public int TradeMarkID;
        [DataMember]
        public string TradeMarkName;
        [DataMember]
        public string SAPTradeMarkID;
    }

}