using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract
{
    [DataContract]
    public class NationalChain : Base
    {
        [DataMember]
        public int SAPNationalChainID { get; set; }
        [DataMember]
        public int NationalChainID { get; set; }
        [DataMember]
        public string NationalChainName { get; set; }
    }
}