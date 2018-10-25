using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.IPE.SurveyData
{
    [DataContract]
    public class SurveyHistoryResults : Base
    {
        [DataMember]
        public IList<Types.IPE.SurveyData.Contract.SurveyHistoryModel> EventResponseHistory = new List<Types.IPE.SurveyData.Contract.SurveyHistoryModel>();

    }
}
