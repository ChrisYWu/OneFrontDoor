using System;
using System.Linq;
using System.Runtime.Serialization;
using Newtonsoft.Json;

namespace DPSG.Portal.BC.Types.IPE.ResponseData.Contract
{
    [DataContract]
    public class EventResponseData
    {

        [DataMember]
        [JsonProperty("EventResponseKey", Required = Required.Always)]
        public string EventResponseKey { get; set; }

        [DataMember]
        [JsonProperty("EventID", Required = Required.Always)]
        public int EventID { get; set; }

        [DataMember]
        [JsonProperty("PhaseID", Required = Required.Always)]
        public int PhaseID { get; set; }

        [DataMember]
        [JsonProperty("QuestionResponderID", Required = Required.Always)]
        public int QuestionResponderID { get; set; }

        [DataMember]
        [JsonProperty("BottlerID", Required = Required.AllowNull)]
        public int BottlerID { get; set; }

        [DataMember]
        [JsonProperty("ChainGroupID", Required = Required.AllowNull)]
        public string ChainGroupID { get; set; }

        [DataMember]
        [JsonProperty("GSN", Required = Required.Always)]
        public string GSN { get; set; }

        [DataMember]
        [JsonProperty("ResponseTypeValueID", Required = Required.Always)]
        public int ResponseTypeValueID { get; set; }

        [DataMember]
        [JsonProperty("Comments", Required = Required.AllowNull)]
        public string Comments { get; set; }

        [DataMember]
        [JsonProperty("EBHLevelSelected", Required = Required.AllowNull)]
        public int? EBHLevelSelected { get; set; }

        [DataMember]
        [JsonProperty("EventResponseCreatedDate", Required = Required.Always)]
        public DateTime EventReponseCreatedDate { get; set; }

    }
}
