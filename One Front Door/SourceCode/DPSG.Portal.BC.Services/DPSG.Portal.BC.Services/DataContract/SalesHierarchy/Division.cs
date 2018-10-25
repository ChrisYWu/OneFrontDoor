using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.SalesHierarchy
{
    [DataContract]
    public class Division : Base
    {
        [DataMember]
        public int ZoneID;
        [DataMember]
        public string DivisionName;
        [DataMember]
        public int DivisionID;
        [DataMember]
        public string BCNodeID;
    }
}