using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Programs.Contract.Milestones
{
    [DataContract]
    public class ProgramMilestones
    {
        [DataMember]
        public int MilestoneID { get; set; }
        [DataMember]
        public string MilestoneName { get; set; }
        [DataMember]
        public string MilestoneDesc { get; set; }
        [DataMember]
        public int IsActive { get; set; }
        [DataMember]
        public int IsDeleted { get; set; }
    }
}
