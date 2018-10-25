using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.LOS
{
    [DataContract]
    public class SystemCompetitionBrand : Base
    {
        // SDM BC.System -> SystemID
        [DataMember]
        public int NodeID { get; set; }

        // SDM BCMyday.SystemBrand -> SystemBrandID
        [DataMember]
        public int SystemBrandID { get; set; }

        // SDM BCMyday.SystemTradeMark -> SystemTradeMarkID
        [DataMember]
        public int SystemDPSTrademarkID { get; set; }

        // SDM BCMyday.SystemCompetitionBrand -> Active
        //[DataMember]
        //public bool Active { get; set; }

    }
}