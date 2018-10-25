using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Account.AdHoc
{
    public class AccountResponse
    {
        [DataMember]
        public int ClientStoreID { get; set; }
        [DataMember]
        public int AccountID { get; set; }
        
    }
}
