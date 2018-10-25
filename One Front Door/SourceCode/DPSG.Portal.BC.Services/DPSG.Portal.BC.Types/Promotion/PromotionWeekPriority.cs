using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;


namespace DPSG.Portal.BC.Types.Promotion
{
    [DataContract]
    public class PromotionWeekPriority
    {
        [DataMember]
        public int PromotionID {get; set;}
        [DataMember]
        public string WeekStartDate {get; set;}
        [DataMember]
        public string WeekEndDate {get; set;}
        [DataMember]
        public int Priority {get; set;}

        [DataMember]
        public string ChainGroupID{ get; set; }
    }
}
