using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.IPE
{
    [DataContract]
    public class SurveyHistoryResults : ResponseBase
    {
        [DataMember]
        public IList<Types.IPE.SurveyData.Contract.SurveyHistoryModel> EventResponseHistory = new List<Types.IPE.SurveyData.Contract.SurveyHistoryModel>();

    }
}
