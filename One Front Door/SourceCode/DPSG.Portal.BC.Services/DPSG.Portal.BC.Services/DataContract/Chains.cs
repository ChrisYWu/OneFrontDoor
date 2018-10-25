using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;


namespace DPSG.Portal.BC.Services.DataContract
{
    [DataContract]
    public class Chains : ResponseBase
    {
        [DataMember]
        public IList<NationalChain> NationalChains=new List<NationalChain>();
        [DataMember]
        public IList<RegionalChain> RegionalChains = new List<RegionalChain>();
        [DataMember]
        public IList<LocalChain> LocalChains = new List<LocalChain>();
        [DataMember]
        public IList<Channel> Channels = new List<Channel>();
        [DataMember]
        public IList<SuperChannel> SuperChannels = new List<SuperChannel>();
        [DataMember]
        public IList<Types.ChainGroup> ChainGroups = new List<Types.ChainGroup>();
         
    }
}