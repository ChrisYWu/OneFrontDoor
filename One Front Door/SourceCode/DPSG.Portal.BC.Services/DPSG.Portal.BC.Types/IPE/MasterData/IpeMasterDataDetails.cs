using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.IPE.MasterData
{
    [DataContract]
    public class IpeMasterDataDetails
    {
        [DataMember]
        public Types.IPE.MasterData.IpeMasterData IpeMasterData { get; set; }

    }
}
