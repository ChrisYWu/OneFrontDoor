using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Brand
{
    [DataContract]
    public class Package :Base
    {
        [DataMember]
        public int PackageID;
        [DataMember]
        public string PackageName;
        [DataMember]
        public string SAPPackageID;
       
       
    }
}