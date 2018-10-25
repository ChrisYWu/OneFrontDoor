using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.LOS
{
    [DataContract]
    public class LOSDisplayLocation : Base 
    {
        [DataMember]
        public int LOSID;
        [DataMember]
        public int DisplayLocationID;
        [DataMember]
        public int? DisplaySequence;
        [DataMember]
        public int? GridX;
        [DataMember]
        public int? GridY;
    }
}