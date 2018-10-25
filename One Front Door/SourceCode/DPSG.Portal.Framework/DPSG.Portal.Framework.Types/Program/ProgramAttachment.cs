using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class ProgramAttachment
    {
        [DataMember]
        public int ID { get; set; }

        public int MilestoneAttachmentId { get; set; }
        [DataMember]
        public string AttachmentName { get; set; }
        
        [DataMember]
        public string MilestoneName { get; set; }
        
        [DataMember]
        public int MilestoneId { get; set; }

        [DataMember]
        public string SystemName { get; set; }

        [DataMember]
        public int? SystemId { get; set; }

         [DataMember]
        public string SystemDisplayName { get; set; }

        [DataMember]
        public string Url { get; set; }
        
        [DataMember]
        public string Type { get; set; }

        [DataMember]
        public int TypeId { get; set; }
        
        [DataMember]
        public byte[] Content { get; set; }

        [DataMember]
        public bool IsDeleted { get; set; }
        
        [DataMember]
        public bool IsNew { get; set; }
        
        [DataMember]
        public string AttachmentDocumentID { get; set; }
        
        [DataMember]
        public int AttachmentSize { get; set; }
        
        [DataMember]
        public string Status { get; set; }

        [DataMember]
        public int StatusId { get; set; }
    }
}
