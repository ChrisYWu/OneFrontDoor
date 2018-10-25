using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Promotion
{
    [DataContract]
    public class PromotionAttachment
    {
        [DataMember]
        public int PromotionID { get; set; }
        [DataMember]
        public int AttachmentID { get; set; }
        [DataMember]
        public string FileURL { get; set; }
        [DataMember]
        public string FileName { get; set; }
        [DataMember]
        public int Size { get; set; }
        [DataMember]
        public string Type { get; set; }
        [DataMember]
        public string LastModifiedDate { get; set; }
    }
}
