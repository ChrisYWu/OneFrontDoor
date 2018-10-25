using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.IPE.SurveyData.Contract
{
    [DataContract]
    public class SurveyHistoryModel : Base
    {
        private DateTime _created;
        [DataMember]
        public string EventResponseKey { get; set; }
        [DataMember]
        public int EbhLevelSelected { get; set; }
        [DataMember]
        public int ResponseTypeValueID { get; set; }
        [DataMember]
        public string ChainGroupID { get; set; }
        [DataMember]
        public int EventID { get; set; }
        [DataMember]
        public int BottlerID { get; set; }
        [DataMember]
        public int PhaseID { get; set; }
        [DataMember]
        public int QuestionResponderID { get; set; }
        [DataMember]
        public string Gsn { get; set; }
        [DataMember]
        public string Created
        {
            get { return _created.ToString("MM/dd/yyyy"); }
            set { _created = DateTime.Parse(value); }
        }
        [DataMember]
        public string Comments { get; set; }
    }
}
