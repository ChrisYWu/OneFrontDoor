using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Store
{
    [DataContract]
    public class PriorityAnswer : Base
    {
        [DataMember]
        public int ConditionID { get; set; }

        [DataMember]
        public int ManagementPriorityID { get; set; }

        [DataMember]
        public int PriorityExecutionStatusID { get; set; }

        [DataMember]
        public string ClientPriorityExecutionID { get; set; }

        [DataMember]
        public int PriorityExecutionID { get; set; }

    }
}