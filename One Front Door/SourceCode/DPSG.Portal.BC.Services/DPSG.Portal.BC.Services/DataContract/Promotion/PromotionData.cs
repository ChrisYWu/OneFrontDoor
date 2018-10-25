using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Promotion
{
    [DataContract]
    public class PromotionData : ResponseBase
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
        public List<DPSG.Portal.BC.Types.Promotion.PromotionAttachment> PromotionAttachments = new List<DPSG.Portal.BC.Types.Promotion.PromotionAttachment>();
        [DataMember]
        public List<PromotionBottler> PromotionBottlers = new List<PromotionBottler>();
        [DataMember]
        public List<DPSG.Portal.BC.Types.Promotion.PromotionWeekPriority> PromotionPriority = new List<DPSG.Portal.BC.Types.Promotion.PromotionWeekPriority>();
        [DataMember]
        public List<DPSG.Portal.BC.Types.Promotion.PromotionStatus> PromotionStatus = new List<DPSG.Portal.BC.Types.Promotion.PromotionStatus>();
        [DataMember]
        public List<DPSG.Portal.BC.Types.Promotion.PromotionCustomer> PromotionCustomers = new List<DPSG.Portal.BC.Types.Promotion.PromotionCustomer>();
        [DataMember]
        public List<DPSG.Portal.BC.Types.Promotion.PromotionState> PromotionStates = new List<DPSG.Portal.BC.Types.Promotion.PromotionState>();

    }
}