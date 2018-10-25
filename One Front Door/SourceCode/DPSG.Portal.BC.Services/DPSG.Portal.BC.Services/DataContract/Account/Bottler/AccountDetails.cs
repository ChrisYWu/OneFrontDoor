using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Account.Bottler
{
    public class AccountDetails : ResponseBase
    {
        [DataMember]
        public IList<DPSG.Portal.BC.Types.Account.Bottler.Contract.BottlerAccount> Stores = new List<DPSG.Portal.BC.Types.Account.Bottler.Contract.BottlerAccount>();
    }
}