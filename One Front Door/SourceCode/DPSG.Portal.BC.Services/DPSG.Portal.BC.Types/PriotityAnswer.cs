using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types
{
    [DataContract]
    public class PriorityAnswer
    {
        [DataMember]
        public int StoreConditionID { get; set; }

        [DataMember]
        public int ManagementPriorityID { get; set; }

        [DataMember]
        public int PriorityExecutionID { get; set; }

        [DataMember]
        public int PriorityExecutionStatusID { get; set; }
    }
}