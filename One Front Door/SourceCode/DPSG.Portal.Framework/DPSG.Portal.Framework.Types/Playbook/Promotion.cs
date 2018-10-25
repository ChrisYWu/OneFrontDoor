/// <summary>
/*  
    * Module Name         :DPSG.Portal.Framework.Types.Promotion.cs
    * Purpose             :To store promotion details.
    * Created Date        :4/15/2013
    * Created By          :Ranjeet Tiwari
    * Last Modified Date  :6/24/2014
    * Last Modified By    :Sunil Kumar
    * Where To Use        :PlayBook
    * Dependancy          :
*/
/// </summary>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class Promotion
    {

        public int? PromotionId { get; set; }
        public string PromotionName { get; set; }
        public int? PromotionRank { get; set; }
        public string ProcMode { get; set; }
        public int? PromotionTypeID { get; set; }
        public int? AccountId { get; set; }
        public string AccountName { get; set; }
        public AccountType AccountType { get; set; }
        public int AccountParentId { get; set; }
        public int? LocalNationalId { get; set; }
        //used for core ten brands
       public string PromotionBrandID { get; set; }
        public string PromotionBrandsJSON { get; set; }
       public string PromotionPackageID { get; set; }

        public string PromotionPrice { get; set; }
        public bool IsDuplicate { get; set; }
        public int? ParentPromotionId { get; set; }
        public int? PromotionCategoryId { get; set; }
        public int? PromotionDisplayLocationId { get; set; }
        public int? PromotionDisplayTypeId { get; set; }  // New Fields
        public string DisplayRequirement { get; set; }
        public string DisplaylocationName { get; set; }
        public string PromotionDisplayLocationOther { get; set; }
        public DateTime? PromotionStartDate { get; set; }
        public DateTime? PromotionEndDate { get; set; }
        /* New Date Fields "Display and Pricing date" (start)*/
        public DateTime? PromotionDisplayStartDate { get; set; }
        public DateTime? PromotionDisplayEndDate { get; set; }
        public DateTime? PromotionPricingStartDate { get; set; }
        public DateTime? PromotionPricingEndDate { get; set; }
        /* (End)*/
        public string PromotionStatus { get; set; }
        public string ForecastVolume { get; set; }
        public string AttachmentsName { get; set; }
        public string AttachmentURL { get; set; }
        public string CreatedBy { get; set; }
        public string ModifiedBy { get; set; }
        public bool IsPRankChanged { get; set; }
        public string AccountInfo { get; set; }
        public string PromotionCategory { get; set; }
        public string PromotionCategoryFullName { get; set; }
        public string PromotionPackages { get; set; }
        public string PromotionBrands { get; set; }
        public int PromotionStatusID { get; set; }
        public string ManageAttachmentJSON { get; set; }
        public string PromotionType { get; set; }
        public DateTime PromotionCreatedDate { get; set; }
        public DateTime PromotionModifiedDate { get; set; }
        public string PromotionActivity { get; set; }
        public int PromotionActivityID { get; set; }

        public string PromotionDescription { get; set; }
        public int? BUID { get; set; }
        public int? RegionId { get; set; }
        public int? BranchId { get; set; }
        public bool? IsLocalized { get; set; }
        public int? EDGEItemID { get; set; }
        public string GEORelavency { get; set; }
        public string GEOState { get; set; }
        public string ChannelXML { get; set; }
        public string ChannelInfo { get; set; }
        public List<GEOListItem> GEORelavencies { get; set; }
        public string AccountImageName { get; set; }
        //added by sangram for trademark
        public string PromotionTradeMarkID { get; set; }
        public string InformationCategory { get; set; }
        public bool ParentEdgePromotionCancelled { get; set; }
        public string NationalDisplayTarget { get; set; }
        public string BottlerCommitment { get; set; }
        public List<SelectedTreeItem> SelectedAccounts { get; set; }
        public bool IsNewVersion { get; set; }

        public string PromotionChannel { get; set; }

        public int? PromotionGroupID { get; set; }

        public string PromotionGroupName { get; set; }
        public bool IsFiltered { get; set; }
        public List<SelectedTreeItem> SelectedChannels { get; set; }

        private string _promotionIdWithChainId;
        public string PromotionIdWithChainId
        {
            get
            {
                _promotionIdWithChainId = PromotionId + "§" + (string.IsNullOrEmpty(PromotionType) ? "Channel" : PromotionType);

                return this._promotionIdWithChainId;
            }
        }

        public string SystemName { get; set; }
        public int DisplayOrder { get; set; }
        public string UpdatedInfo { get; set; }

        private string _timelineOrderBy;
        public string TimelineOrderBy
        {
            get
            {
                if (PromotionType == AccountType.National.ToString())
                {
                    _timelineOrderBy = "AA";
                }

                else if (PromotionType == AccountType.Regional.ToString())
                {
                    _timelineOrderBy = "BB";
                }
                else if (PromotionType == AccountType.Local.ToString())
                {
                    _timelineOrderBy = "CC";
                }
                else
                {
                    _timelineOrderBy = "DD";
                }

                return this._timelineOrderBy;
            }
        }

        //program information
        public int? ProgramId { get; set; }
        public string ProgramName { get; set; }
        public bool? IsNationalAccountPromotion { get; set; }
        public List<AccountInfo>  UserRootAssignedAccount{ get; set; }
        public bool IsUserAdmin { get; set; }
        public DateTime? ProgramLastUpdated { get; set; }
         //best bets
        public string BestBets { get; set; }
        //edge comments
        public string EdgeComments { get; set; }
        public int? ProgramStatusID { get; set; }

        /* SMA & Cost Per Store */
        public bool? IsSMA { get; set; }
        public bool? IsCostPerStore { get; set; }
        public string TPMNumberCASO { get; set; }
        public string TPMNumberPASO { get; set; }
        public string TPMNumberISO { get; set; }
        public string TPMNumberPB { get; set; }
        public string COSTPerStore { get; set; }
        /* New string value  "TPM Promotion Number that generated from TPMNumberCASO,TPMNumberPASO,TPMNumberISO" */
        public string TPMPromotionNumber { get; set; }

        public bool IsMyAccount { get; set; }
        public bool IsMyChannel { get; set; }

        // For filter Persona
        public int PersonaID { get; set; }
        public string UserGroupName { get; set; }
        public string RoleName { get; set; }
      //  public string PromotionBrandSAPID { get; set; }
       // public string PromotionTradeMarkSAPID { get; set; }
     //   public string PromotionTradeMarks { get; set; }
        public string DisplayType { get; set; }
        public string VariableRPC { get; set; }
        public int? Redemption { get; set; }
        public string FixedCost { get; set; }
        public string AccrualComments { get; set; }
        public string Unit { get; set; }
        public string Accounting { get; set; }
        public bool SendBottlerAnnouncements { get; set; }
        public string OtherBrandPrice { get; set; }
       
    }
}
