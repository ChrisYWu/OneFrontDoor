using System.Collections.Generic;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Account.AdHoc
{
    public class AccountResponseDetails
    {
        [DataMember]
        public IList<DPSG.Portal.BC.Types.Account.AdHoc.AccountResponse> AdhocStoreAccounts = new List<DPSG.Portal.BC.Types.Account.AdHoc.AccountResponse>();
    }
}
