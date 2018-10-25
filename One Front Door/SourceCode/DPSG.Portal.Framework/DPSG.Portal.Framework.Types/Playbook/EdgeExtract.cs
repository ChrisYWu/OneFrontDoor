using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types.Playbook
{
   public class EdgeExtract
    {
        public string Status { get; set; }
        public string Type { get; set; }
        public int PromotionId { get; set; }
        public string PromotionName { get; set; }
        public string Program { get; set; }
        public string ProgramName { get; set; }
        public string PromotionStartDate { get; set; }
        public string PromotionEndDate { get; set; }
        public string LocalAccount { get; set; }
        public string RegionAccount { get; set; }
        public string NationalAccount { get; set; }
        public string Brand { get; set; }
        public string Trademark { get; set; }
        public string SuperChannel { get; set; }
        public string Package { get; set; }
        public string Attachment { get; set; }
    }
}
