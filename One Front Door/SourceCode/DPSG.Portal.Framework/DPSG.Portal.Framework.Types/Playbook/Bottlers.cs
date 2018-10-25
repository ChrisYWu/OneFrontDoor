using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class Bottlers
    {
        public int RowSeqNumber { get; set; }
        public int PromotionID { get; set; }
        public int BottlersID { get; set; }
        public string BottlerName { get; set; }
        public int RegionID { get; set; }
    }
}
