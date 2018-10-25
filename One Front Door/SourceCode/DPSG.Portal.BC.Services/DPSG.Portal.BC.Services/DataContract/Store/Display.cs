using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Store
{
    [DataContract]
    public class Display : Base
    {
        [DataMember]
        public int? ConditionID { get; set; }

        [DataMember]
        public int DisplayID { get; set; }
        
        [DataMember]
        public int ClientDisplayID { get; set; }

        
        [DataMember]
        public int? DisplayLocationID { get; set; }

        [DataMember]
        public int? DisplayTypeID { get; set; }

        [DataMember]
        public int? PromotionID { get; set; }

        [DataMember]
        public string DisplayLocationNote { get; set; }

        [DataMember]
        public string ReasonID { get; set; }

        [DataMember]
        public string OtherNote { get; set; }


        [DataMember]
        public string ImageURL { get; set; }

        [DataMember]
        public string ImageName { get; set; }

        [DataMember]
        public string ImageBytes { get; set; }

        [DataMember]
        public int? GridX { get; set; }
        [DataMember]
        public int? GridY { get; set; }

        [DataMember]
        public IList<DisplayDetails> StoreDisplayDetails = new List<DisplayDetails>();

        [DataMember]
        public int IsFairShare;

        [DataMember]
        public int? DPTieInFlag { get; set; }

    }
}