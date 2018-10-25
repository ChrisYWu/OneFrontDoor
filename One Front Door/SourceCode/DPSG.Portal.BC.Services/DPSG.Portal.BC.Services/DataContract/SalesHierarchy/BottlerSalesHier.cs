using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.SalesHierarchy
{
    [DataContract]
    public class BottlerSalesHier :Base
    {
        [DataMember]
        public string TotalCompanyName;
        [DataMember]
        public int TotalCompanyID;
        [DataMember]
        public string HierType;
        [DataMember]
        public string CountryName;
        [DataMember]
        public int CountryID;
        [DataMember]
        public string SystemName;
        [DataMember]
        public string ZoneName;
        [DataMember]
        public int ZoneID;
        [DataMember]
        public string DivisionName;
        [DataMember]
        public int DivisionID;
        [DataMember]
        public string RegionName;
        [DataMember]
        public int RegionID;
        [DataMember]
        public string RegionBCNodeID;
    }
}