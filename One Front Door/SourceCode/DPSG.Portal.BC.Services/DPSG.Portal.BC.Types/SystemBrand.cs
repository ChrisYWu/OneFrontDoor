using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types
{
    public class SystemBrand
    {
        public int SystemBrandID { get; set; }
        public string ExternalBrandName { get; set; }
        public int? BrandID { get; set; }
        public char? TieInType { get; set; }
        public bool IsDPSBrand { get; set; }
        public int? BrandLevelSort { get; set; }
        public int? SystemTradeMarkID { get; set; }
        public string ImageURL { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
    }
}
