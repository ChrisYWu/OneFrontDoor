using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
   public class MileStoneStatus
    {
        public int  Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string symbolUrl { get; set; }
        public byte[] imageAttachment { get; set; }
        public string gsnId { get; set; }
    }
}
