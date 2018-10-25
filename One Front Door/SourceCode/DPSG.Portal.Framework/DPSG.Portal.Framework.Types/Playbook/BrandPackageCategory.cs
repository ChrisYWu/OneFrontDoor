using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class BrandPackageCategory
    {
        public string CategoryName { get; set; }
        public int CategoryId { get; set; }
        public List<PromoBrand> Brands { get; set; }
        public List<PromoPackage> Packages { get; set; }

    }
}
