using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.SalesHierarchy
{
    [DataContract]
    public class Country : Base
    {
        [DataMember]
        public int CountryID;
        [DataMember]
        public string BCNodeID;
        [DataMember]
        public string CountryName;
        [DataMember]
        public int TotalCompanyID;
    }
}