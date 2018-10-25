using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Brand
{
    [DataContract]
    public class BrandData :ResponseBase
    {
        [DataMember]
        public List<Brand> Brands = new List<Brand>();
        [DataMember]
        public List<Package> Packages = new List<Package>();
        [DataMember]
        public List<TradeMark> TradeMarks = new List<TradeMark>();
    }
}