using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Programs
{
    [DataContract]
    public class ProgramMilestoneDetails
    {
        [DataMember]
        public IList<Types.Programs.Contract.Milestones.ProgramMilestones> MilestoneMaster = new List<Types.Programs.Contract.Milestones.ProgramMilestones>();
    }
}
