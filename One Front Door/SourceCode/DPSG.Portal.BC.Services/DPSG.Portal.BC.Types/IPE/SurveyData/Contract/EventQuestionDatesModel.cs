using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.IPE.SurveyData.Contract
{
    [DataContract]
    public class EventQuestionDatesModel : Base
    {
        private DateTime _phaseStartDate;
        private DateTime _phaseEndDate;
        private DateTime _questionStartDate;
        private DateTime _questionEndDate;

        [DataMember]
        public int EventID { get; set; }

        [DataMember]
        public int PhaseID { get; set; }

        [DataMember]
        public string PhaseStartDate
        {
            get { return _phaseStartDate.ToString("MM/dd/yyyy");}
            set {_phaseStartDate = DateTime.Parse(value); }
        }

        [DataMember]
        public string PhaseEndDate
        {
            get { return _phaseEndDate.ToString("MM/dd/yyyy"); }
            set { _phaseEndDate = DateTime.Parse(value); }
        }

        [DataMember]
        public string QuestionStartDate 
        { 
            get { return _questionStartDate.ToString("MM/dd/yyyy"); } 
            set { _questionStartDate = DateTime.Parse(value); } 
        }

        [DataMember]
        public string QuestionEndDate
        {
            get { return _questionEndDate.ToString("MM/dd/yyyy"); }
            set { _questionEndDate = DateTime.Parse(value); } 
        }

        [DataMember]
        public int KeyQuestionID { get; set; }

        [DataMember]
        public int QuestionResponderID { get; set; }
    }
}
