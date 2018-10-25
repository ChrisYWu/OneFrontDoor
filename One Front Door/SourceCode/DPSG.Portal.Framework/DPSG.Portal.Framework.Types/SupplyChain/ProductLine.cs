using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class ProductLine
    {
        private List<Products> product;
        private List<TradeMarks> trademark;

        [DataMember]
        public List<Products> Products
        {
            get { return product; }
            set { product = value; }
        }
        [DataMember]
        public List<TradeMarks> Trademarks
        {
            get { return trademark; }
            set { trademark = value; }
        }
    }
}
