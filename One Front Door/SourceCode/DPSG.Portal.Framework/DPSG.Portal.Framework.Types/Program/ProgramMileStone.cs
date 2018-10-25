using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class ProgramMileStone
    {
        private int _milestoneID;
        public int MilestoneID
        {
            get
            {
                return this._milestoneID;
            }
            set
            {
                this._milestoneID = value;
            }
        }
        private int? _accountId;
        public int? AccountId
        {
            get
            {
                return this._accountId;
            }
            set
            {
                this._accountId = value;
            }
        }

        private int? _dayRuleId;
        public int? DayRuleId
        {
            get
            {
                return this._dayRuleId;
            }
            set
            {
                this._dayRuleId = value;
            }
        }
        private string _daysRuleName;
        public string DayRuleName
        {
            get
            {
                return this._daysRuleName;
            }
            set
            {
                this._daysRuleName = value;
            }
        }

        private string _milestoneName;
        public string MilestoneName
        {
            get
            {
                return this._milestoneName;
            }
            set
            {
                this._milestoneName = value;
            }
        }

        private string _milestoneDesc;
        public string MilestoneDesc
        {
            get
            {
                return this._milestoneDesc;
            }
            set
            {
                this._milestoneDesc = value;
            }
        }

        public int? MilestoneOrder { get; set; }
        private string _milestoneIconUrl;
        public string MilestoneIconURL
        {
            get
            {
                return this._milestoneIconUrl;
            }
            set
            {
                this._milestoneIconUrl = value;
            }
        }

        private string _status;
        public string Status
        {
            get
            {
                return this._status;
            }
            set
            {
                this._status = value;
            }
        }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public DateTime? DueDate { get; set; }
        public int? AssociatdMilestoneID { get; set; }
        public int? DaysCalculation { get; set; }
        public int? NumberOfDays { get; set; }
        public string DayPeriod { get; set; }
        public int StatusId { get; set; }
        public string ApprovalRule { get; set; }
        public string PrecedenceRule { get; set; }
        public int? AttachmentType { get; set; }
        public int? EndPointMilestoneId { get; set; }
        private string _createdBy;
        public string CreatedBy
        {
            get
            {
                return this._createdBy;
            }
            set
            {
                this._createdBy = value;
            }
        }

        private DateTime _createdDate;
        public DateTime CreatedDate
        {
            get
            {
                return this._createdDate;
            }
            set
            {
                this._createdDate = value;
            }
        }

        private string _modifiedBy;
        public string ModifiedBy
        {
            get
            {
                return this._modifiedBy;
            }
            set
            {
                this._modifiedBy = value;
            }
        }

        private DateTime _modifedDate;
        public DateTime ModifedDate
        {
            get
            {
                return this._modifedDate;
            }
            set
            {
                this._modifedDate = value;
            }
        }
        public List<ProgramAttachment> Attachments { get; set; }
        public byte[] imageAttachment { get; set; }
        public string imageType { get; set; }
        public bool? CopyAttachment { get; set; }
    }
}
