using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;
using DPSG.Portal.BC.Services.DataContract;

namespace DPSG.Portal.BC.Services.DataContract.Account.AdHoc
{
    public class AdHocResponseDetails : ResponseBase
    {
        [DataMember]
        public IList<DPSG.Portal.BC.Types.Account.AdHoc.AccountResponse> AdhocStoreAccounts = new List<DPSG.Portal.BC.Types.Account.AdHoc.AccountResponse>();
    }
}
