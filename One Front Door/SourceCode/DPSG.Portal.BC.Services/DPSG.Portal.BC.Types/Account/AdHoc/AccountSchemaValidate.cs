using System.Collections.Generic;
using System.Runtime.Serialization;
using DPSG.Portal.BC.Types.Account.AdHoc;

namespace DPSG.Portal.BC.Types.Account.AdHoc
{
    [DataContract]
    public class AccountSchemaValidate
    {
        [DataMember]
        public List<Account> AdhocStoreAccounts { get; set; }

    }
}
