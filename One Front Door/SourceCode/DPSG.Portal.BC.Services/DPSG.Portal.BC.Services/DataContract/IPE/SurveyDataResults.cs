using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.IPE
{
    [DataContract]
    public class SurveyDataResults : ResponseBase
    {
        [DataMember]
        public IList<Types.IPE.SurveyData.Contract.EventBottlerPhaseModel> EventBottlerPhase = new List<Types.IPE.SurveyData.Contract.EventBottlerPhaseModel>();
        [DataMember]
        public IList<Types.IPE.SurveyData.Contract.EventQuestionDatesModel> EventQuestionDates = new List<Types.IPE.SurveyData.Contract.EventQuestionDatesModel>();
    }
}
