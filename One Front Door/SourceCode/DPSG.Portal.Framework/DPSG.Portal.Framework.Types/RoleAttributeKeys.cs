using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types.RoleAttributeKeys
{
    public class MyPref
    {
        public const string GEOAPPLICABLE = "GEOApplicable";
        public const string CHANNELAPPLICABLE = "ChannelApplicable";
        public const string CHAINAPPLICABLE = "ChainApplicable";
        public const string SYSTEMAPPLICABLE = "SystemApplicable";
        public const string SALESTRGTAPPLICABLE = "SalesTrgtApplicable";
        public const string PROMOTIONACTIVITYAPPLICABLE = "PromotionActivityApplicable";
        public const string PREFACCOUNTAPPLICABLE = "PrefAccountApplicable";
        public const string ROUTEAPPLICABLE = "RouteApplicable";
    }

    public class MySplashnet
    {
        public const string HEADERBRANCHSELECTED = "HeaderBranchSelected";
        public const string PR_APPROVAL_APPLICABLE = "PRApprovalApplicable";
    }

    public class PromotionActivity
    {
        public const string HIDE_PROMOTION_TYPE = "HideAccountChannelPromotionType";
        public const string DISABLE_ACCOUNT_TYPE = "DisableAccountType";
        public const string CREATE_ISO_PROMOTION = "CreateISOPromotion";
        public const string EDIT_PRMOTION_PRIORITY = "EditPromotionPriority";
    }

    public class ProgramAttribute
    {
        public const string MYSPLASHNET_ALERTS = "MILESTONE_ALERTS";
        public const string SHOW_ALERTS_NOTIFICATION="HIDEALERTNOTIFICATION";
    }
}
