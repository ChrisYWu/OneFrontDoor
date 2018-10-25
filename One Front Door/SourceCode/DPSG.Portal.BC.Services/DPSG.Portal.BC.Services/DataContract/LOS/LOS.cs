using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.LOS
{
    [DataContract]
    public class LOS : Base
    {
        [DataMember]
        public int LOSID;

        [DataMember]
        public int ChannelID;
        [DataMember]
        public int SAPChannelID;

        [DataMember]
        public int? LocalChainID;
        [DataMember]
        public int? SAPLocalChainID;

        [DataMember]
        public int? StoreID;
        
        [DataMember]
        public int? SAPStoreID;

        [DataMember]
        public string ImageURL;

    }
}