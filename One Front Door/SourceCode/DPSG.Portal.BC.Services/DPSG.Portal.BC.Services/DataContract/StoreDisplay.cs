using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract
{
    [DataContract]
    public class StoreDisplay1
    {
        [DataMember]
        public int StoreDisplayID { get; set; }
        [DataMember]
        public int StoreConditionId { get; set; }
        [DataMember]
        public int DisplayLocationID { get; set; }
        [DataMember]
        public int DisplayTypeID { get; set; }
        [DataMember]
        public int PromotionID { get; set; }
        [DataMember]
        public string DisplayLocationNote { get; set; }
        [DataMember]
        public int NoTieInListID { get; set; }
        [DataMember]
        public string OtherNote { get; set; }
        [DataMember]
        public string DisplayImage { get; set; }
        [DataMember]
        public string ImageName { get; set; }
        [DataMember]
        public int GridX { get; set; }
        [DataMember]
        public int GridY { get; set; }
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
