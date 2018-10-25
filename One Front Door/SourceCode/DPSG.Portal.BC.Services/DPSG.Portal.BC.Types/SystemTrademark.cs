using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types
{
   public class SystemTradeMark
    {
       public int SystemTradeMarkID { get; set; }
        public string ExternalTradeMarkName { get; set; }
        public string TrademarkImagePath { get; set; }
        public int TradeMarkLevelSort { get; set; }
        public int? TradeMarkID { get; set; }
        public string ImageURL { get; set; }
        public bool IsActive { get; set; }       
    }
}
