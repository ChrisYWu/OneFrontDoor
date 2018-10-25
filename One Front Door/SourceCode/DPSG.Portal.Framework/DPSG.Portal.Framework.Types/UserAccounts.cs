using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class UserAccounts
    {
        private List<Account> nationalAcc;
        private List<Account> regionalAcc;
        private List<Account> localAcc;

        [DataMember]
        public List<Account> National
        {
            get { return nationalAcc; }
            set { nationalAcc = value; }
        }

        [DataMember]
        public List<Account> Regional
        {
            get { return regionalAcc; }
            set { regionalAcc = value; }
        }

        [DataMember]
        public List<Account> Local
        {
            get { return localAcc; }
            set { localAcc = value; }
        }
    }
}
