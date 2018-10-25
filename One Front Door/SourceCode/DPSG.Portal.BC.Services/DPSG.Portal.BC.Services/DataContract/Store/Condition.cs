using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Store
{
    [DataContract]
    public class Condition : Base
    {
        [DataMember]
        public int ConditionID { get; set; }
        [DataMember]
        public int AccountId { get; set; }
        [DataMember]
        public int? StoreID { get; set; }
        [DataMember]
        public int? BottlerID { get; set; }
        [DataMember]
        public int BCNodeID { get; set; }
        [DataMember]
        public string ConditionDate { get; set; }
        [DataMember]
        public string GSN { get; set; }
        
        [DataMember]
        public int? SDMNodeID { get; set; }
        [DataMember]
        public double? Longitude { get; set; }
        [DataMember]
        public double? Latitude { get; set; }
        [DataMember]
        public string StoreNote { get; set; }

        [DataMember]
        public IList<Display> StoreDisplays = new List<Display>();

        [DataMember]
        public IList<TieInRate> StoreTieInRates = new List<TieInRate>();

        [DataMember]
        public IList<PriorityAnswer> PriorityAnswers = new List<PriorityAnswer>();

        [DataMember]
        public IList<BCPromotionExecution> PromotionExecutions = new List<BCPromotionExecution>();

        [DataMember]
        public IList<StoreNote> StoreNotes = new List<StoreNote>();

        [DataMember]
        public string Name;
     
    }
}