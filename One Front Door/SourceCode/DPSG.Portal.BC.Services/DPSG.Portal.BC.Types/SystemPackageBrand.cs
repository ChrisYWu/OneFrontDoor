using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.BC.Types
{
    public class SystemPackageBrand
    {
        public int SystemPackageID { get; set; }
        public int SystemBrandID { get; set; }
        public bool IsActive { get; set; }        
        public bool IsDeleted { get; set; }
    }
}
