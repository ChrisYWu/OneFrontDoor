using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.IPE.SurveyData
{
    [DataContract]
    public class SurveyDataResults
    {
        [DataMember]
        public IList<Types.IPE.SurveyData.Contract.EventBottlerPhaseModel> EventBottlerPhase = new List<Types.IPE.SurveyData.Contract.EventBottlerPhaseModel>();
        [DataMember]
        public IList<Types.IPE.SurveyData.Contract.EventQuestionDatesModel> EventQuestionDates = new List<Types.IPE.SurveyData.Contract.EventQuestionDatesModel>();
    }
}
