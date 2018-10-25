using System;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Priority.Contract
{
    [DataContract]
    public class PriorityCustomer :Base 
    {
        [DataMember]
        public int PriorityID { get; set; }

        [DataMember]
        public int? NationalChainID { get; set; }

        [DataMember]
        public int? RegionalChainID { get; set; }

        [DataMember]
        public int? LocalChainID { get; set; }
    }
}