using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract
{
    [DataContract]
    public class LOSDisplayLocation : Base
    {
        [DataMember]
        public int LOSID { get; set; }
        [DataMember]
        public int DisplayLocationID { get; set; }
        [DataMember]
        public int DisplaySequence { get; set; }
        [DataMember]
        public int GridX { get; set; }
        [DataMember]
        public int GridY { get; set; }
        [DataMember]
        public DateTime CreatedDate { get; set; }
        [DataMember]
        public DateTime ModifiedDate { get; set; }
        [DataMember]
        public bool IsActive { get; set; }
        [DataMember]
        public string CreatedBy { get; set; }
        [DataMember]
        public string ModifiedBy { get; set; }
    }
}
