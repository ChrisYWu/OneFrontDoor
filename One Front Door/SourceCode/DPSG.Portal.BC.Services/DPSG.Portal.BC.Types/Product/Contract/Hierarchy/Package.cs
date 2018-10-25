using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Product.Contract.Hierarchy
{
    [DataContract]
    public class Package:Base
    {
        [DataMember]
        public int PackageID { get; set; }
        [DataMember]
        public string PackageName { get; set; }
        [DataMember]
        public string SAPPackageID { get; set; }

    }
}
