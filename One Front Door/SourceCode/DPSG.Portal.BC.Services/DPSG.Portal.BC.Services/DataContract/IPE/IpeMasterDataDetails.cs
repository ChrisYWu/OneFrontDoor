using System;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.IPE
{
    [DataContract]
    public class IpeMasterDataDetails : ResponseBase
    {
        [DataMember]
        public Types.IPE.MasterData.IpeMasterData IpeMasterData { get; set; }

    }
}
