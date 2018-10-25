using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Store
{
    [DataContract]
    public class ConditionResponse : ResponseBase
    {
        [DataMember]
        public int? StoreConditionID { get; set; }

        [DataMember]
        public List<StoreConditionDisplay> StoreConditionDisplays = new List<StoreConditionDisplay>();

        [DataMember]
        public List<StoreConditionNote> StoreConditionNotes = new List<StoreConditionNote>();

        [DataMember]
        public List<PriorityExecution> PriorityExecutions = new List<PriorityExecution>();

        [DataMember]
        public List<PromotionExecution> PromotionExecutions = new List<PromotionExecution>();

    }

    [DataContract]
    public class StoreConditionDisplay
    {
        [DataMember]
        public int? ClientStoreConditionDisplayID { get; set; }

        [DataMember]
        public string DisplayImageURL { get; set; }

        [DataMember]
        public string ImageName { get; set; }

        [DataMember]
        public int StoreConditionDisplayID { get; set; }
    }

    [DataContract]
    public class StoreConditionNote
    {
        [DataMember]
        public string ClientStoreConditionNoteID { get; set; }

        [DataMember]
        public string NoteImageURL { get; set; }

        [DataMember]
        public string ImageName { get; set; }

        [DataMember]
        public int StoreConditionNoteID { get; set; }
    }

    [DataContract]
    public class PriorityExecution
    {
        [DataMember]
        public string ClientPriorityExecutionID { get; set; }

        [DataMember]
        public int PriorityExecutionID { get; set; }
    }

    [DataContract]
    public class PromotionExecution
    {
        [DataMember]
        public string ClientPromotionExecutionID { get; set; }

        [DataMember]
        public int PromotionExecutionID { get; set; }

        [DataMember]
        public string ClientStoreConditionDisplayID { get; set; }

        [DataMember]
        public int? StoreConditionDisplayID { get; set; }
    }

}