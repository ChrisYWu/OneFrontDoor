using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Portal.Framework.SDM;
using DPSG.Portal.Framework.Types;

namespace Test
{
    class Program
    {
        static void Main(string[] args)
        {
            PlaybookRepository obj = new PlaybookRepository();
            List<Promotion> t = obj.DeleteEdgePromotion("data source=bsccap108;initial catalog=Portal_Data;persist security info=True;user id=OnePortal;password=OnePortal");

            EdgeRepository obj1 = new EdgeRepository();
            List<EDGERPLItem> t1 = obj1.GetDeletedItems(DateTime.UtcNow, "data source=bsccap108;initial catalog=Portal_Data;persist security info=True;user id=OnePortal;password=OnePortal");
        }
    }
}
