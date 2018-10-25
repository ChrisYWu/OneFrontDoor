using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Promotion
{
    [DataContract]
    public class PromotionCustomer
    {
        [DataMember]
        public int PromotionID {get; set;}
        [DataMember]
        //public string CustomerNumber {get; set;}
        public int CustomerNumber { get; set; }
    }
}
