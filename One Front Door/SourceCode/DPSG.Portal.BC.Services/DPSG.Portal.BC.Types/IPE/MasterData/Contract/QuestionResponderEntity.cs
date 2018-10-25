using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.IPE.MasterData.Contract
{
    [DataContract]
    public class QuestionResponderEntity : Base
    {
        [DataMember]
        public int QuestionResponderID { get; set; }
        [DataMember]
        public int EventTypeID { get; set; }
        [DataMember]
        public int QuestionID { get; set; }
        [DataMember]
        public int ResponderID { get; set; }
        [DataMember]
        public int PhaseID { get; set; }
        [DataMember]
        public int GroupID { get; set; }


    }
}
