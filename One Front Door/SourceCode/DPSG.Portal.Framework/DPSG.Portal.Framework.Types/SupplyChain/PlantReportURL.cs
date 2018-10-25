using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
namespace DPSG.Portal.Framework.Types.SupplyChain
{
    [DataContract, Serializable]
    public class PlantReportURL
    {
        [DataMember]
        public string ReportType { get; set; }
        [DataMember]
        public string ReportURL { get; set; }
    }
}
