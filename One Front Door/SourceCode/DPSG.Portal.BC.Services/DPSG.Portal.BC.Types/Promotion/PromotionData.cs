using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;


namespace DPSG.Portal.BC.Types.Promotion
{
    [DataContract]
    public class PromotionData
    {
        [DataMember]
        public List<DPSG.Portal.BC.Types.Promotion.Promotion> Promotions = new List<DPSG.Portal.BC.Types.Promotion.Promotion>();
        [DataMember]
        public List<DPSG.Portal.BC.Types.Promotion.PromotionBrand> PromotionBrands = new List<DPSG.Portal.BC.Types.Promotion.PromotionBrand>();
        [DataMember]
        public List<DPSG.Portal.BC.Types.Promotion.PromotionAccount> PromotionAccounts = new List<DPSG.Portal.BC.Types.Promotion.PromotionAccount>();
        [DataMember]
        public List<DPSG.Portal.BC.Types.Promotion.PromotionPackage> PromotionPackages = new List<DPSG.Portal.BC.Types.Promotion.PromotionPackage>();
        [DataMember]
        public List<DPSG.Portal.BC.Types.Promotion.PromotionState> PromotionStates = new List<DPSG.Portal.BC.Types.Promotion.PromotionState>();
        [DataMember]
        public List<DPSG.Portal.BC.Types.Promotion.PromotionAttachment> PromotionAttachments = new List<DPSG.Portal.BC.Types.Promotion.PromotionAttachment>();
        [DataMember]
        public List<DPSG.Portal.BC.Types.Promotion.PromotionStatus> PromotionStatus = new List<DPSG.Portal.BC.Types.Promotion.PromotionStatus>();
        [DataMember]
        public List<DPSG.Portal.BC.Types.Promotion.PromotionWeekPriority> PromotionsWeekPriority = new List<DPSG.Portal.BC.Types.Promotion.PromotionWeekPriority>();
        [DataMember]
        public List<DPSG.Portal.BC.Types.Promotion.PromotionCustomer> PromotionCustomers = new List<DPSG.Portal.BC.Types.Promotion.PromotionCustomer>();
 
 
    }
}
