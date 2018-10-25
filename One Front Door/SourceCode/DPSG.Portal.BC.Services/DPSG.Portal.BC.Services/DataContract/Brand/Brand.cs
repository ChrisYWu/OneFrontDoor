using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Brand
{
    [DataContract]
    public class Brand : Base 
    {
        [DataMember]
        public int BrandID;
        [DataMember]
        public string  SAPBrandID;
        [DataMember]
        public string BrandName;
        [DataMember]
        public int TradeMarkID;
    }
}