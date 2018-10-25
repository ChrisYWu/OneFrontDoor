using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Numerics;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.CDE.Contract
{
    [DataContract]
    public class Asset
    {
        [DataMember]
        public string AccountID { get; set; }
        [DataMember]
        public int AssetCount { get; set; }
        [DataMember]
        public bool SurveyNeededFlag { get; set; }
        [DataMember]
        public int Status { get; set; }


       
    }
}
