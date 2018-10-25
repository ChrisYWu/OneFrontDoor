using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class ProgrameCalander_MSDetails
    {
        public int ProgramID { get; set; }
        public int MilestoneOrder { get; set; }
        public int MilestoneID { get; set; }
        public string MilestoneName { get; set; }
        public byte[] MilestoneIconImage { get; set; }
        public DateTime? MilestoneStartDate { get; set; }
        public DateTime? MilestoneEndDate { get; set; }
        public int MilestoneStatusID { get; set; }
        public int MilestoneProgressID { get; set; }
        public string AttachmentName { get; set; }
        public string AttachmentUrl { get; set; }
        public string MilestoneAttachmentStatus { get; set; }
        public string AssociatedMSAttachName { get; set; }
        public string MilestoneStatus { get; set; }
        public string MilestoneProgressStatus { get; set; }
        public string LNKAttachmentsName { get; set; }
        public string DisplaySystemNames { get; set; }
        public string UserSystems { get; set; }

    }
}
