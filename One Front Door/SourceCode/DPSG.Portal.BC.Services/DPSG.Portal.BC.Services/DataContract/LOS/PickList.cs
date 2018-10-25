using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.LOS
{
    [DataContract]
    public class PickList : Base 
    {
        [DataMember]
        public int PickListID;
        [DataMember]
        public string PickListName;
    }
}