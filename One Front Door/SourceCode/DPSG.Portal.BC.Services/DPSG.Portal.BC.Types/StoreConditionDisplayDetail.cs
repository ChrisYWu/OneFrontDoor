using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.BC.Types
{
    public class StoreConditionDisplayDetail
    {
        public int StoreConditionDisplayID { get; set; }
        public int? SystemPackageID { get; set; }
        public int? SystemBrandID { get; set; }
        public int ClientDisplayId { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public bool IsActive { get; set; }
    }
}
