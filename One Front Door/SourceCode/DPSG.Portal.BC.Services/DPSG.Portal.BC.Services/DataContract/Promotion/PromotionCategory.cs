using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Promotion
{
    [DataContract]
    public class PromotionCategory:Base
    {
        [DataMember]
        int CategoryID;
        [DataMember]
        string CategoryName;
    }
}