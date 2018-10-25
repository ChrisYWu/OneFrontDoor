using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Portal.Framework.Types.Constants;

namespace DPSG.Portal.Framework.Types
{
    public class AccountMilestone
    {
        public int AccountMilestoneID { get; set; }
        public int? AccountId { get; set; }
        public int MilestoneId { get; set; }
        public string MilestoneName { get; set; }
        public int? AssociateMilestoneId { get; set; }
        public string AssociateMilestone { get; set; }
        public int? DayCalculation { get; set; }
        public int? NoOfDays { get; set; }
        public string PrecedenceRule { get; set; }
        public string ApprovalRule { get; set; }
        public int isActive { get; set; }
        public string DayPeriod { get; set; }
        public bool CopyAttachment { get; set; }
        public byte[] imageIcone { get; set; }
        public string imageIconeType { get; set; }
        public int? MilestoneOrder { get; set; }
        public string gsnId { get; set; }
        public int? AttachmentType { get; set; }
        public string AttachmentName { get; set; }
        public string CalculationType { get; set; }
        public string DayCalculationType { get; set; }
        public string DayManualCalculation { get; set; }
        public int? EndPointMilestoneId { get; set; }
        public string DateRuleContent {
            get
            {
                string dateRuleContent = string.Empty;

                if (this.CalculationType == "Calculation")
                {
                    dateRuleContent = "Starts: <b>" + this.NoOfDays +" "+ this.DayPeriod +" "+ this.PrecedenceRule +" "+ this.AssociateMilestone+"</b>";
                }
                else if (this.CalculationType == "Manual")
                {
                    dateRuleContent = "<b>Manual" + " " + this.DayPeriod+"</b>";
                }

                return dateRuleContent;
            }
        }
        public string AttachmentContent
        {
            get
            {
            string attachmentBindContent=string.Empty;
           
                if (!string.IsNullOrEmpty(AttachmentName))
                {
                    attachmentBindContent = "Copy Attachments of  <b>" + this.AttachmentName+"</b>";
                }
                else
                {
                    attachmentBindContent = "Copy Rules Not Applicable";
                }
                return attachmentBindContent;
            }
            
        }
        public string CompletionRuleText
        {
            get
            {
                string _completionRuleText = string.Empty;
                if (!string.IsNullOrEmpty(this.ApprovalRule))
                {
                    switch (this.ApprovalRule.ToLower())
                    {
                        case CommonConstants.APPROVAL_DOCUMENT_UPLOAD:
                            _completionRuleText = CommonConstants.DOCUMENT_UPLOAD_TEXT;
                            break;
                        case CommonConstants.APPROVAL_AUTOMATIC_SINGLE_DATE:
                            _completionRuleText = CommonConstants.AUTOMATIC_DATE_TEXT;
                            break;
                        case CommonConstants.APPROVAL_AUTOMATIC_DATE:
                            _completionRuleText = CommonConstants.AUTOMATIC_DATE_TEXT;
                            break;
                        case CommonConstants.APPROVAL_MANUAL_SELECTION:
                            _completionRuleText = CommonConstants.MANUAL_SELECTION_TEXT;
                            break;
                        default:
                            _completionRuleText = CommonConstants.MANUAL_SELECTION_TEXT;
                            break;


                    }
                }

                return _completionRuleText;
            }
        }

        public AccountMilestone()
        {
            this.AccountId = 0;
            this.AccountMilestoneID = 0;
            this.ApprovalRule = string.Empty;
            this.AssociateMilestone = string.Empty;
            this.AssociateMilestoneId = 0;
            this.AttachmentName = string.Empty;
            this.AttachmentType = 0;
            this.CalculationType = string.Empty;
            this.CopyAttachment = false;
            this.DayCalculation = 0;
            this.DayCalculationType = string.Empty;
            this.DayManualCalculation = string.Empty;
            this.DayPeriod = string.Empty;
            this.EndPointMilestoneId = 0;
            this.imageIcone=new byte[]{};
            this.MilestoneId = 0;
            this.MilestoneName = string.Empty;
            this.NoOfDays = 0;

        }
    }
}
