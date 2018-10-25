using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.SalesHierarchy
{
    [DataContract]
    public class TotalCompany:Base
    {
        [DataMember]
        public int TotalCompanyID;
        [DataMember]
        public string BCNodeID;
        [DataMember]
        public string TotalCompanyName;
    }
}