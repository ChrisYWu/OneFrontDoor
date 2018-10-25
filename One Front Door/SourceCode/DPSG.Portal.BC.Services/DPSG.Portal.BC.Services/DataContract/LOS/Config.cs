using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.LOS
{
    [DataContract]
    public class Config : Base
    {
        [DataMember]
        public int ConfigID;
        [DataMember]
        public string Key;
        [DataMember]
        public string Value;
        [DataMember]
        public string Description;        
    }
}