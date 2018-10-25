using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.IPE.MasterData.Contract
{
    [DataContract]
    public class QuestionsEntity : Base
    {
        [DataMember]
        public int QuestionID { get; set; }
        [DataMember]
        public string Question { get; set; }
        [DataMember]
        public int ResponseTypeID { get; set; }
        [DataMember]
        public string HelpText { get; set; }
        [DataMember]
        public int KeyQuestionID { get; set; }
        [DataMember]
        public byte SortOrder { get; set; }


    }
}
