using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Promotion
{
    [DataContract]
    public class PromotionAttachment
    {
        [DataMember]
        public int PromotionID;
        [DataMember]
        public int FileURL;
        [DataMember]
        public int FileName;
        [DataMember]
        public int Size;
        [DataMember]
        public string Type;
    }
}