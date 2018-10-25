using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;


namespace DPSG.Portal.BC.Services.DataContract.SalesHierarchy
{
    [DataContract]
    public class Zone:Base
    {
        [DataMember]
        public int ZoneID;
        [DataMember]
        public string BCNodeID;
        [DataMember]
        public string ZoneName;
        [DataMember]
        public int SystemID;
    }
}