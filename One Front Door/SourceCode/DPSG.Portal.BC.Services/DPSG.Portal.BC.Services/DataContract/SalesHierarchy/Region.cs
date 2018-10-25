using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.SalesHierarchy
{
    [DataContract]
    public class Region :Base
    {
        [DataMember]
        public int RegionID;
        [DataMember]
        public string BCNodeID;
        [DataMember]
        public string RegionName;
        [DataMember]
        public int DivisionID;
    }
}