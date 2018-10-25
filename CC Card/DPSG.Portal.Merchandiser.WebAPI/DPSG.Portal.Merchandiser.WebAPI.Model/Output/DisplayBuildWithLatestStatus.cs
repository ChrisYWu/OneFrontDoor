using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Output
{
    public class DisplayBuildWithLatestStatus : OutputBase
    {
        public List<DisplayBuildOutputTranslated> DisplayBuilds { get; set; }
    }

    public class DisplayBuildWithLatestStatusRaw
    {
        public List<DisplayBuildOutputRaw> DisplayBuilds { get; set; }
    }

    public class DisplayBuildOutputBase 
    {
        public Int32 DisplayBuildID { get; set; }
        public Int64 SAPAccountNumber { get; set; }
        public Int32 PromotionID { get; set; }
        public String PromotionName { get; set; }
        public String PromotionDescription { get; set; }
        public Int32? DisplayLocationID { get; set; }
        public Int32? DisplayTypeID { get; set; }
        public String ProposedStartDate { get; set; }
        public String ProposedEndDate { get; set; }
        public String BuildInstruction { get; set; }
        public String InstructionImageName { get; set; }
        public DateTime? ClientTime { get; set; }
        public String ClientTimeZone { get; set; }
        public String ClientAppSource { get; set; }
        public String ExecutionGSN { get; set; }
        public Int32? BuildStatusID { get; set; }
        public Int32? ExecutionDisplayLocationID { get; set; }
        public Int32? ExecutionDisplayTypeID { get; set; }
        public Int32? BuildRefusalReasonID { get; set; }
        public String BuildNote { get; set; }
        public String ImageName { get; set; }
        public bool? RequiresDisplay { get; set; }
        public String DisplayBuildLastModifiedBy { get; set; }
        public String ExecutionFirstName { get; set; }
        public String ExecutionLastName { get; set; }
    }

    public class DisplayBuildOutputRaw : DisplayBuildOutputBase
    {
        //---------------------
        public string ConnectionString { get; set; }
        public string RelativeURL { get; set; }
        public string AbsoluteURL { get; set; }
        public string StorageAccount { get; set; }
        public string Container { get; set; }
        public string AccessLevel { get; set; }

        //Exec---------------------
        public string ExecConnectionString { get; set; }
        public string ExecRelativeURL { get; set; }
        public string ExecAbsoluteURL { get; set; }
        public string ExecStorageAccount { get; set; }
        public string ExecContainer { get; set; }
        public string ExecAccessLevel { get; set; }
    }

    public class DisplayBuildOutputTranslated : DisplayBuildOutputBase
    {
        public DisplayBuildOutputTranslated(DisplayBuildOutputBase b)
        {
            this.BuildInstruction = b.BuildInstruction;
            this.BuildNote = b.BuildNote;
            this.BuildRefusalReasonID = b.BuildRefusalReasonID;
            this.BuildStatusID = b.BuildStatusID;
            this.ClientAppSource = b.ClientAppSource;
            this.ClientTime = b.ClientTime;
            this.ClientTimeZone = b.ClientTimeZone;
            this.DisplayBuildID = b.DisplayBuildID;
            this.DisplayLocationID = b.DisplayLocationID;
            this.DisplayTypeID = b.DisplayTypeID;
            this.ExecutionDisplayLocationID = b.ExecutionDisplayLocationID;
            this.ExecutionDisplayTypeID = b.ExecutionDisplayTypeID;
            this.ExecutionGSN = b.ExecutionGSN;
            this.ImageName = b.ImageName;
            this.InstructionImageName = b.InstructionImageName;
            this.PromotionDescription = b.PromotionDescription;
            this.PromotionID = b.PromotionID;
            this.PromotionName = b.PromotionName;
            this.ProposedEndDate = b.ProposedEndDate;
            this.ProposedStartDate = b.ProposedStartDate;
            this.SAPAccountNumber = b.SAPAccountNumber;
            this.RequiresDisplay = b.RequiresDisplay;
            this.DisplayBuildLastModifiedBy = b.DisplayBuildLastModifiedBy;
            this.ExecutionFirstName = b.ExecutionFirstName;
            this.ExecutionLastName = b.ExecutionLastName;
        }
        public String ImageURL { get; set; }
        public String ImageSAS { get; set; }
        public String InstructionImageURL { get; set; }
        public String InstructionImageSAS { get; set; }
    }
}
