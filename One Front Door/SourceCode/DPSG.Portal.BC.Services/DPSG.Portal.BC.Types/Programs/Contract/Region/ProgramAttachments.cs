using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Programs.Contract.Region
{
    [DataContract]
    public class ProgramAttachments
    {
        [DataMember]
        public int ProgramID { get; set; }
        [DataMember]
        public int  MilestoneID {get; set;}
        [DataMember]
        public int  AttachmentID {get; set;}
        [DataMember]
        public string FileURL {get; set;}
        [DataMember]
        public string FileName {get; set;}
        [DataMember]
        public string  Size {get; set;}
        [DataMember]
        public string Type {get; set;}
        [DataMember]
        public string LastModifiedDate { get; set; }
        [DataMember]
        public string StartDate { get; set; }
        [DataMember]
        public string EndDate { get; set; }

    }
}
