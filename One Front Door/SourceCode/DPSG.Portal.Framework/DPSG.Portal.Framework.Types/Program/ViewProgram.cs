using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using DPSG.Portal.Framework.Types.Constants;
using Microsoft.SharePoint.Utilities;

namespace DPSG.Portal.Framework.Types
{
    public class ViewProgram
    {
        //Program
        public string ProgramName { get; set; }
        public int ProgramID { get; set; }
        public string ProgramComments { get; set; }
        public int ProgramStatusID { get; set; }
        public int ParentProgramID { get; set; }
        public string ProgramModifiedBy { get; set; }
        public DateTime ProgramModifiedDate { get; set; }
        public DateTime ProgramCreatedDate { get; set; }
        public DateTime DisplayStartDate { get; set; }
        public DateTime DisplayEndDate { get; set; }
        public string ProgramAccount { get; set; }
        public string ProgramPackage { get; set; }
        public string ProgramTrademark { get; set; }
        public string ProgramGeoRelevancy { get; set; }
        public string ProgramStatus { get; set; }
        public int IsMyAccount { get; set; }

        // Latest Program Update Properties
        public string LatestProgramStatusType { get; set; }
        public string MilestoneInfo { get; set; }
        public DateTime LastLoginTime { get; set; }
        public string UpdatedInfo { get; set; }
        public string DisplayInfo { get; set; }
        public int TextCount { get; set; }
        public string ToolTip { get; set; }

        //Milestone
        public int MilestoneID { get; set; }
        public DateTime? MilestoneStartDate { get; set; }
        public DateTime? MilestoneEndDate { get; set; }
        public string MilestoneStatus { get; set; }
        public int MilestoneStatusID { get; set; }
        public string MilestoneName { get; set; }
        public string MilestoneComments { get; set; }
        public int MilstoneAccountID { get; set; }
        public DateTime MilestoneModifiedDate { get; set; }
        public string MilestoneModifiedBy { get; set; }
        public string MilestoneAccountName { get; set; }
        public int MilestoneOrder { get; set; }
        public string MilestoneDayPeriod { get; set; }
        public string MilestoneApprovalRule { get; set; }
        public int MilestoneNumberOfDays { get; set; }
        public int MilestoneProgressID { get; set; }
        public string MilestoneProgressStatus { get; set; }
        public byte[] MilestoneIconImage { get; set; }

        // Property for getting the Milestone Name for the corresponding attachment
        public string AssociatedMSAttachName { get; set; }
        public string AttachmentUrl { get; set; }
        public string AttachmentName { get; set; }
        public int MilestoneAttachmentStatusID { get; set; }
        public string MilestoneAttachmentStatus { get; set; }
        public string MilestoneAttachmentSystemId { get; set; }
        public string MilestoneAttachmentSystemName { get; set; }
        public int MilestoneAttachmentId { get; set; }

        //Others
        public string SystemName { get; set; }        

        //Geters Only
        /// <summary>
        /// Returns the status sort order value i.e.. Draft =1, Approved =2, Cancelled =3
        /// </summary>
        public int ProgramStatusSortValue
        {
            get
            {
                int value = 0;
                Types.ProgramStatus _status = (Types.ProgramStatus)Enum.Parse(typeof(Types.ProgramStatus), this.ProgramStatus.Replace(" ",""));
                switch (_status)
                {
                    case Types.ProgramStatus.Draft:
                        value = 3;
                        break;
                    case Types.ProgramStatus.ReadyforApproval:
                        value=2;
                        break;
                    case Types.ProgramStatus.Approved:
                        value = 1;
                        break;
                    case Types.ProgramStatus.Cancelled:
                        value = 4;
                        break;
                }

                return value;
            }
        }

        /// <summary>
        /// Returns the Image Url based on the status of the program
        /// </summary>
        public string ProgramStatusImageUrl
        {
            get
            {
                Types.ProgramStatus _status = (Types.ProgramStatus)Enum.Parse(typeof(Types.ProgramStatus), this.ProgramStatus.Replace(" ", ""));
                string uri = string.Empty;

                switch (_status)
                {
                    case Types.ProgramStatus.Approved:
                        uri = CommonConstants.IMAGE_PLAYBOOK_PATH + CommonConstants.IMG_APPROVED;
                        break;
                    case Types.ProgramStatus.Cancelled:
                        uri = CommonConstants.IMAGE_PLAYBOOK_PATH + CommonConstants.IMG_REJECTED;
                        break;
                    case Types.ProgramStatus.Draft:
                        uri = CommonConstants.IMAGE_PLAYBOOK_PATH + CommonConstants.IMG_DRAFT;
                        break;
                    case Types.ProgramStatus.ReadyforApproval:
                        uri = CommonConstants.IMAGE_PLAYBOOK_PATH + CommonConstants.IMG_READY_FOR_APPROVAL;
                        break;
                }
                return uri;
            }
        }

        /// <summary>
        /// Returns the Account image url if the image is present in the physical file system else returns emty string
        /// </summary>
        public string ProgramAccountImageUrl
        {
            get
            {
                string _accountUri = string.Empty;

                try
                {
                    //Regular expression to remove special characters from milestone account name
                    Regex r = new Regex("(?:[^a-z0-9 ]|(?<=['\"]))", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant | RegexOptions.Compiled);
                    string _name = r.Replace(this.MilestoneAccountName, String.Empty).Replace(" ", String.Empty);

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
        public string MarketingProgramName { get; set; }
        public string MarketingProgramImageURL { get; set; }
    }
}
