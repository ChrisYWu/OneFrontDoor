using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Output
{
    public class MerchBuildMaster : OutputBase
    {
        public List<BuildRefusalReason> BuildRefusalReasons { get; set; }
        public List<DisplayBuildStatus> DisplayBuildStatuses { get; set; }
        public List<DNSReason> DNSReasons { get; set; }
    }

    public class BuildRefusalReason
    {
        public int BuildRefusalReasonID { get; set; }
        public string BuildResusalReasonName { get; set; }
        public bool IsActive { get; set; }
    }

    public class DisplayBuildStatus
    {
        public int BuildStatusID { get; set; }
        public string BuildStatusName { get; set; }
        public bool IsActive { get; set; }
    }

    public class DNSReason
    {
        public int DNSReasonID { get; set; }
        public string DNSReasonName { get; set; }
        public bool IsActive { get; set; }
    }
}
