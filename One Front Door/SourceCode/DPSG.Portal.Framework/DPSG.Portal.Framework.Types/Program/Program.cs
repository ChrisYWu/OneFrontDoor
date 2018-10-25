using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using Microsoft.SharePoint.Utilities;
using DPSG.Portal.Framework.Types.Constants;
using System.IO;

namespace DPSG.Portal.Framework.Types
{
    public class Program
    {
        public string ProcMode { get; set; }
        public int? ProgramID
        {
            get;
            set;
        }
        public string ProgramName
        {
            get;
            set;
        }

        public string Comments
        {
            get;
            set;
        }

        public string ProgramStatus
        {
            get;
            set;
        }
        public int RootAccountID { get; set; }
        public List<SelectedTreeItem> SelectedAccounts { get; set; }
        public bool IsDuplicate { get; set; }
        public int? ParentProgramID
        {
            get;
            set;
        }
        public string CreatedBy
        {
            get;
            set;
        }
        public DateTime CreatedDate
        {
            get;
            set;
        }
        public string ModifiedBy
        {
            get;
            set;
        }
        public DateTime ModifiedDate
        {
            get;
            set;
        }
        public string AccountDisplayView
        {
            get;
            set;
        }
        public string PackageDisplayView
        {
            get;
            set;
        }
        public string TrademarkDisplayView
        {
            get;
            set;
        }
        public DateTime StartDate
        {
            get;
            set;
        }
        public DateTime EndDate
        {
            get;
            set;
        }
        public string ProgramTrademarkIds
        {
            get;
            set;
        }
        public string ProgramBrandIds
        {
            get;
            set;
        }

        public List<PromoBrand> ProgramTrademarks
        {
            get;
            set;
        }

        public string ProgramPackagesId
        {
            get;
            set;
        }
        public List<PromoPackage> ProgramPackages
        {
            get;
            set;
        }
        public string ProgramAccountXML
        {
            get;
            set;
        }
        public int ProcStatus
        {
            get;
            set;
        }
        public string MileStoneXML { get; set; }
        public string ProcMessage
        {
            get;
            set;
        }
        public bool SubmitAndCreateDuplicate { get; set; }
        public string AttachmentJSON { get; set; }
        public string AttachmentsSystem { get; set; }
        public string SystemId { get; set; }
        public List<ProgramAttachment> Attachments { get; set; }
        public string AttachmentsName { get; set; }
        public string ProgramTradeMarkID { get; set; }
        public string strProgramPackages { get; set; }
        public string ProgramMSAccountName { get; set; }
        public string SystemName { get; set; }
        public string ProgramAccountImageUrl
        {
            get
            {
                string _accountUri = string.Empty;

                try
                {
                    //Regular expression to remove special characters from milestone account name
                    Regex r = new Regex("(?:[^a-z0-9 ]|(?<=['\"]))", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant | RegexOptions.Compiled);
                    string _name = r.Replace(this.ProgramMSAccountName, String.Empty).Replace(" ", String.Empty);

                    // Check if the image exists in the physical folder -- > 14 hive
                    if (File.Exists(SPUtility.GetGenericSetupPath(CommonConstants.IMAGE_PB_ACCOUNT_PHYSICAL_PATH + _name.ToLower() + ".png")))
                    {
                        _accountUri = CommonConstants.IMAGE_ACCOUNT_PATH + _name.ToLower() + ".png";
                    }
                }
                catch (Exception ex)
                {
                    //ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
                return _accountUri;
            }
        }
        public int PromotionID { get; set; }
        public int MarketingProgramID { get; set; }
        public List<GEOListItem> GEORelavencies { get; set; }
        public string ProgramBrandJSON { get; set; }
        public string ProgramGeoRelevancy { get; set; }
        public string MarketingProgramName { get; set; }
        public string MarketingProgramImageURL { get; set; }
        public string MarketingProgramImageURLLarge { get; set; }
        public string MarketingProgramImageName { get; set; }
    }
}
