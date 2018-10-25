using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Store
{
    [DataContract]
    public class StoreNote : Base
    {
        [DataMember]
        public int ConditionID { get; set; }

        [DataMember]
        public string ClientNoteID { get; set; }

        [DataMember]
        public int NoteID { get; set; }

        [DataMember]
        public string NoteDescription { get; set; }

        [DataMember]
        public string ImageURL { get; set; }

        [DataMember]
        public string ImageName { get; set; }

        [DataMember]
        public string ImageBytes { get; set; }
    }
}