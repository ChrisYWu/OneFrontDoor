using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Input
{
    public class DisplayBuild
    {
        public Int64 SAPAccountNumber { get; set; }
        public string GSN { get; set; }
        public int PromotionID { get; set; }
        public bool RequiresDisplay { get; set; }
        public int PromotionExecutionStatusID { get; set; }
        public int? DisplayLocationID { get; set; }
        public int? DisplayTypeID { get; set; }
        public DateTime? ProposedStartDate { get; set; }
        public DateTime? ProposedEndDate { get; set; }
        public string BuildInstruction { get; set; }
        public string InstructionImageName { get; set; }
        public string RelativeURL { get; set; }
        public string AbsoluteURL { get; set; }
        public string StorageAccount { get; set; }
        public string Container { get; set; }
    }
}
