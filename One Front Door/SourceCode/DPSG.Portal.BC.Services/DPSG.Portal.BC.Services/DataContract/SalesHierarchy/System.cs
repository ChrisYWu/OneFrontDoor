using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.SalesHierarchy
{
    [DataContract]
    public class System : Base
    {
        [DataMember]
        public int SystemID;
        [DataMember]
        public string BCNodeID;
        [DataMember]
        public string SystemName;
        [DataMember]
        public int CountryID;
    }
}