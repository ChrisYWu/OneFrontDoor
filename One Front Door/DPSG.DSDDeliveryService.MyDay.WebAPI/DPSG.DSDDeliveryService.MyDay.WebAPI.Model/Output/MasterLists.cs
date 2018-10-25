using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Output
{
    public class MasterLists: OutputBase
    {
        public List<FarawayReason> FarawayReasons { get; set; }
        public List<ResequenceReason> ResequenceReasons { get; set; }
    }

    public class FarawayReason
    {
        public int FarawayReasonID { get; set; }
        public string ReasonDesc { get; set; }
    }

    public class ResequenceReason
    {
        public int ResequenceReasonID { get; set; }
        public string ReasonDesc { get; set; }

    }
}
