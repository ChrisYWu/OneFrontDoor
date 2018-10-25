using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class PromoBrand
    {

        public int PromotionID { get; set; }
        public int? TradeMarkID { get; set; }
        [DataMember]
        public int? BrandId { get; set; }
        [DataMember]
        public string BrandName { get; set; }
        [DataMember]
        public string SAPBrandId { get; set; }
        [DataMember]
        public bool Checked { get; set; }
        [DataMember]
        public bool IsTradeMark { get; set; }

        private string _tbrandID;
        public string TBrandID
        {
            get
            {
                if (BrandId != null && BrandId != 0)
                {
                    _tbrandID = BrandId + "§brand";
                }

                else if (TradeMarkID != null && TradeMarkID != 0)
                {
                    _tbrandID = TradeMarkID + "§trademark";
                }

                return this._tbrandID;
            }
            
        }

        public string ImageUrl { get; set; }

        [DataMember]
        public string SAPTrademarkID { get; set; }
    }
}
