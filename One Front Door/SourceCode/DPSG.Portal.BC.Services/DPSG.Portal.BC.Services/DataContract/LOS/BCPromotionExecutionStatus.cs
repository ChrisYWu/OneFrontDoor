using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.LOS
{
    [DataContract]
    public class BCPromotionExecutionStatus :Base 
    {
        [DataMember]
        public int StatusID;
        [DataMember]
        public string StatusDesc;
        //[DataMember]
        //public bool Active;

    }
}