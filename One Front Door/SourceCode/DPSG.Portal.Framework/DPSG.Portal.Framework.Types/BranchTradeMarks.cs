using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class BranchTradeMarks
    {
        private Branch branch;
        private List<TradeMark> tradeMarks;
        [DataMember]
        public Branch Branch
        {
            get { return branch; }
            set { branch = value; }
        }
        [DataMember]
        public List<TradeMark> TradeMarks
        {
            get { return tradeMarks; }
            set { tradeMarks = value; }
        }
    }
}
