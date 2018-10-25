﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types
{
    [DataContract]
    public class BCPromotionExecution
    {
        [DataMember]
        public int StoreConditionID { get; set; }

        [DataMember]
        public int PromotionExecutionID { get; set; }

        [DataMember]
        public int PromotionID { get; set; }

        [DataMember]
        public int? StoreConditionDisplayID { get; set; }

        [DataMember]
        public int PromotionExecutionStatusID { get; set; }

        [DataMember]
        public string Comments { get; set; }

    }
}