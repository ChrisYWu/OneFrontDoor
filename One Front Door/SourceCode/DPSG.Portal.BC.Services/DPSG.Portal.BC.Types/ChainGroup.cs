using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types
{
    [DataContract]
    public class ChainGroup : Base
    {
        [DataMember]
        public int? LocalChainID { get; set; }
        [DataMember]
        public int? RegionalChainID { get; set; }
        [DataMember]
        public int? NationalChainID { get; set; }
        [DataMember]
        public string ChainGroupID { get; set; }
        [DataMember]
        public string ChainGroupName { get; set; }
        [DataMember]
        public string ImageName { get; set; }
        [DataMember]
        public string MobileImageURL { get; set; }
    }
}
