using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.IPE.SurveyData.Contract
{
    [DataContract]
    public class EventBottlerPhaseModel : Base
    {
        [DataMember]
        public int EventID { get; set; }
        [DataMember]
        public int PhaseID { get; set; }
        [DataMember]
        public int BottlerID { get; set; }
    }
}
