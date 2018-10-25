using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.CDE
{
    [DataContract]
    public class AssetDetails
    {
        [DataMember]
        public IList<DPSG.Portal.BC.Types.CDE.Contract.Asset> Asset = new List<DPSG.Portal.BC.Types.CDE.Contract.Asset>();
    }
}
