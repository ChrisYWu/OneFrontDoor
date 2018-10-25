using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types
{
    public class SystemCompetitionBrand
    {
        // SDM BC.System -> SystemID
        public int NodeID { get; set; }

        // SDM BCMyday.SystemBrand -> SystemBrandID
        public int SystemBrandID { get; set; }

        // SDM BCMyday.SystemTradeMark -> SystemTradeMarkID
        public int SystemDPSTrademarkID { get; set; }

        // SDM BCMyday.SystemCompetitionBrand -> Active
        public bool Active { get; set; }
    }
}
