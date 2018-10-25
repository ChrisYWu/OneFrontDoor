using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Promotion
{
    [DataContract]
    public class Document
    {
        [DataMember]
        public string URL;
        [DataMember]
        public string Name;
        [DataMember]
        public int Size;
        [DataMember]
        public string StartDate;
        [DataMember]
        public string EndDate;
        [DataMember]
        public string AttachmentType;
        [DataMember]
        public string ChainName;
        [DataMember]
        public string AttachmentID;
        [DataMember]
        public string ModifiedDate;

        
        public int MetaDataID;
    }
}
