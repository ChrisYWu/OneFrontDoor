using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract
{
    [DataContract]
    public class StoreCondition1
    {
        [DataMember]
        public int StoreConditionId { get; set; }
        [DataMember]
        public int AccountID { get; set; }
        [DataMember]
        public int BottlerID { get; set; }
        [DataMember]
        public int SystemId { get; set; }
        [DataMember]
        public DateTime ConditionDate { get; set; }
        [DataMember]
        public string GSN { get; set; }
        [DataMember]
        public decimal Longitude { get; set; }
        [DataMember]
        public decimal Latitude { get; set; }
        [DataMember]
        public string StoreNote { get; set; }
        [DataMember]
        public string CreatedBy { get; set; }
        [DataMember]
        public string ModifiedBy { get; set; }
        [DataMember]
        public DateTime CreatedDate { get; set; }
        [DataMember]
        public DateTime ModifiedDate { get; set; }
    }
}
