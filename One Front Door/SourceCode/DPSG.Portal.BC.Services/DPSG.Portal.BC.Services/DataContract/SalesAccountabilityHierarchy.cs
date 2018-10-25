using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract
{
    [DataContract]
    public class SalesAccountabilityHierarchy : ResponseBase
    {
        [DataMember]
        public List<SalesAccount> SalesAccount = new List<SalesAccount>();
    }
}