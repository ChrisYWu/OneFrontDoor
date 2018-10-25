using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;


namespace DPSG.Portal.BC.Types.Promotion
{
    [DataContract]
    public class PromotionPackage
    {
        [DataMember]
        public int PromotionID { get; set; }
        [DataMember]
        public int PackageID { get; set; }
    }
}
