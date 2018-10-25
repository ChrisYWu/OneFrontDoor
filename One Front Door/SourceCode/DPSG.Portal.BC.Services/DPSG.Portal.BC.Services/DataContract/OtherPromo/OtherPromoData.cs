using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.OtherPromo
{
    [DataContract]
    public class OtherPromoData : ResponseBase
    {
        [DataMember]
        public IList<DPSG.Portal.BC.Types.Promotion.PromotionCategory> PromotionCategories = new List<DPSG.Portal.BC.Types.Promotion.PromotionCategory>();

        [DataMember]
        public IList<DPSG.Portal.BC.Types.Promotion.PromotionRefusalReason> PromotionRefusalReasons = new List<DPSG.Portal.BC.Types.Promotion.PromotionRefusalReason>();

        [DataMember]
        public IList<DPSG.Portal.BC.Types.Promotion.PromotionExecutionStatus> PromotionExecutionStatus = new List<DPSG.Portal.BC.Types.Promotion.PromotionExecutionStatus>();

    }
}