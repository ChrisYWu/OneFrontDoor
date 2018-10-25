using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract
{
    [DataContract]
    public class SalesAccount:Base
    {
        [DataMember]
        public int BCSalesAccountabilityID;
        [DataMember]
        public string GSN;
        [DataMember]        
        public int? TotalCompanyID;
        [DataMember]
        public int? CountryID;
        [DataMember]
        public int? SystemID;
        [DataMember]
        public int? ZoneID;
        [DataMember]
        public int? DivisionID;
        [DataMember]
        public int? RegionID;
        [DataMember]
        public bool IsPrimary;
        [DataMember]
        public bool IsSystemLoad;
        
    }
}