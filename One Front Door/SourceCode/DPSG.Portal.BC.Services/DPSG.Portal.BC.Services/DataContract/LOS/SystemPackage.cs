using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.LOS
{
    [DataContract]
    public class SystemPackage : Base
    {
        [DataMember]
        public int SystemPackageID;
        [DataMember]
        public string SAPContainerType;
        [DataMember]
        public string SAPPackageConfig;
        [DataMember]
        public int? BCNodeID;
        [DataMember]
        public int? SDMNodeID;
        [DataMember]
        public int? PackageLevelSort;
        [DataMember]
        public int? PackageConfigID;

        [DataMember]
        public string PackageName;



    }
}