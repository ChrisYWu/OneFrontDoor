using System;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
   [Serializable, DataContract]
   public class UserGoalAccount
    {
        [DataMember]
        public string AccountID { get; set; }
        [DataMember]
        public string AccountName { get; set; }
          
    }
}
