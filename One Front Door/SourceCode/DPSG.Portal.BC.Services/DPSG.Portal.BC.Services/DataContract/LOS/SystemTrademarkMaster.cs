using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.LOS
{
    [DataContract]
    public class SystemTrademarkMaster : Base
    {
        [DataMember]
        public int SysTrademarkId;
        [DataMember]
        public string TrademarkName;
        [DataMember]
        public string TrademarkImagePath;
        //[DataMember]
        //public int SapTrademarkId;
        [DataMember]
        public int TrademarkLvlSort;

        [DataMember]
        public int? TrademarkID;

        [DataMember]
        public string ImageURL;

    }
}