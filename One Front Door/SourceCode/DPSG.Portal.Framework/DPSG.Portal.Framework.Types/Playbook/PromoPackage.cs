using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class PromoPackage
    {

        [DataMember]
        public string PackageId { get; set; }
        [DataMember]
        public string PackageName { get; set; }
        [DataMember]
        public string SAPpackageId { get; set; }
        [DataMember]
        public bool Checked { get; set; }
        public string CategoryName { get; set; }
        public int CategoryId { get; set; }
    }


    //used to bind the filter on timeline
    public class PromoPackageInfo
    {
        public int PromotionID { get; set; }

        public int PackageId { get; set; }

        public string PackageName { get; set; }

    }
}
