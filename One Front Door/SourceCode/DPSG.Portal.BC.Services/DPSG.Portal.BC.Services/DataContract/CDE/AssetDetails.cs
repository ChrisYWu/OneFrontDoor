using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.CDE
{
    [DataContract]
    public class AssetDetails:ResponseBase
    {
        [DataMember]
        public IList<DPSG.Portal.BC.Types.CDE.Contract.Asset> Asset = new List<DPSG.Portal.BC.Types.CDE.Contract.Asset>();
    }
}