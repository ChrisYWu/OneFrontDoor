using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types
{
    [DataContract]
    public class StoreNote
    {
        [DataMember]
        public int StoreConditionID { get; set; }

        [DataMember]
        public int StoreConditionNoteID { get; set; }

        [DataMember]
        public string Note { get; set; }

        [DataMember]
        public string ImageURL { get; set; }

        [DataMember]
        public string ImageName { get; set; }

    }
}