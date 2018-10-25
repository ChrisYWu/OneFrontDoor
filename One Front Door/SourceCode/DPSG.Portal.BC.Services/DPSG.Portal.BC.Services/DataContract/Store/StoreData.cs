using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Store
{
    [DataContract]
    public class StoreData : ResponseBase
    {
        //[DataMember]
        //public IList<Condition> StoreCondition = new List<Condition>();
        [DataMember]
        public IList<Condition> StoreConditions = new List<Condition>();

        [DataMember]
        public IList<Display> StoreDisplays = new List<Display>();

        [DataMember]
        public IList<TieInRate> StoreTieInRates = new List<TieInRate>();

        [DataMember]
        public IList<DisplayDetails> StoreDisplayDetails = new List<DisplayDetails>();

        [DataMember]
        public IList<BCPromotionExecution> PromotionExecutions = new List<BCPromotionExecution>();

        [DataMember]
        public IList<StoreNote> StoreNotes = new List<StoreNote>();

        [DataMember]
        public IList<PriorityAnswer> PriorityAnswers = new List<PriorityAnswer>();

    }
}