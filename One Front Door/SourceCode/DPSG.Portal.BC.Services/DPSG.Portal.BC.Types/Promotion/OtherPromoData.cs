using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.Promotion
{
    public class OtherPromoData
    {

        public IList<DPSG.Portal.BC.Types.Promotion.PromotionCategory> PromotionCategories = new List<DPSG.Portal.BC.Types.Promotion.PromotionCategory>();
        public IList<DPSG.Portal.BC.Types.Promotion.PromotionRefusalReason> PromotionRefusalReasons = new List<DPSG.Portal.BC.Types.Promotion.PromotionRefusalReason>();
        public IList<DPSG.Portal.BC.Types.Promotion.PromotionExecutionStatus> PromotionExecutionStatus = new List<DPSG.Portal.BC.Types.Promotion.PromotionExecutionStatus>();
    }
}
