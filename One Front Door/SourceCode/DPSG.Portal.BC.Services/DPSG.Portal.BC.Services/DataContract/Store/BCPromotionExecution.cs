using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Store
{
    [DataContract]
    public class BCPromotionExecution : Base
    {
        [DataMember]
        public int ConditionID { get; set; }

        [DataMember]
        public int PromotionID { get; set; }

        [DataMember]
        public string ClientDisplayID { get; set; }

        [DataMember]
        public int? StoreConditionDisplayID { get; set; }

        [DataMember]
        public int PromotionExecutionStatusID { get; set; }

        [DataMember]
        public string ClientPromotionExecutionID { get; set; } //Need DB column otherwise don't know how to associate

        [DataMember]
        public int PromotionExecutionID { get; set; } //Need DB column otherwise don't know how to associate

        [DataMember]
        public string Comments { get; set; }

    }
}