using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable,DataContract]
    public class TradeMark
    {
        [DataMember]
        public int tradeMarkId { get; set; }
        [DataMember]
        public string tradeMarkName { get; set; }
        //[DataMember]
        //public string SAPBrandId { get; set; }
    }
}
