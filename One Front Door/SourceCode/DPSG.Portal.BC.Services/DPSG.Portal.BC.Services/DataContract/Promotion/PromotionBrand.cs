using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Promotion
{
    [DataContract]
    public class PromotionBrand
    {
        [DataMember]
        public int PromotionID;
        [DataMember]
        public int BrandID;
        [DataMember]
        public int TrademarkID;
    }
}