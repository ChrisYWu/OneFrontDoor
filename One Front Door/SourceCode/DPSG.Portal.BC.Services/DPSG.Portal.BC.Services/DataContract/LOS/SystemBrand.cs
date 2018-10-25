using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.LOS
{
    [DataContract]
    public class SystemBrand :Base 
    {
        [DataMember]
        public int SystemBrandID;
        [DataMember]
        public string BrandName;
        [DataMember]
        public int? BrandID;
        
        //[DataMember]
        //public int? TradeMarkID;
        //[DataMember]
        //public string TradeMarkName;

        [DataMember]
        public char? TieInType;
        [DataMember]
        public bool IsDPSBrand
        {
            get {
                if (  this.BrandID.HasValue && this.BrandID != 0)
                    return true;
                else
                    return false;
            }
            set { }
        }
        [DataMember]
        public int? BrandLevelSort;

        [DataMember]
        public int? SystemTradeMarkID;

        [DataMember]
        public string ImageURL;

    }
}