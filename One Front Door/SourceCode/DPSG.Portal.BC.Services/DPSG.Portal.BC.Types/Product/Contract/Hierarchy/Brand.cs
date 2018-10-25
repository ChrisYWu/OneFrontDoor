using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Product.Contract.Hierarchy
{
    [DataContract]
    public class Brand:Base
    {
        [DataMember]
        public int BrandID { get; set; }
        [DataMember]
        public string SAPBrandID { get; set; }
        [DataMember]
        public string BrandName { get; set; }
        [DataMember]
        public int TradeMarkID { get; set; }

    }
}
