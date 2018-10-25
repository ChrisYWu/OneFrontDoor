using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract
{
    [DataContract]
    public class RegionalChain : Base
    {
        [DataMember]
        public int? SAPRegionalChainID { get; set; }
        [DataMember]
        public int RegionalChainID { get; set; }
        [DataMember]
        public string RegionalChainName { get; set; }
        [DataMember]
        public int? NationalChainID { get; set; }
    }
}