using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract
{
    [DataContract]
    public class LocalChain :Base
    {
        [DataMember]
        public int? SAPLocalChainID { get; set; }
        [DataMember]
        public int LocalChainID { get; set; }
        [DataMember]
        public string LocalChainName { get; set; }
        [DataMember]
        public int? RegionalChainID { get; set; }
    }
}