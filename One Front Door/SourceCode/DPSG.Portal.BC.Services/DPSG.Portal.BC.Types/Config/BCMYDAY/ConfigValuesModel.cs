using System;
using System.Linq;
using System.Runtime.Serialization;


namespace DPSG.Portal.BC.Types.Config.BCMYDAY
{
    [DataContract]
    public class ConfigValuesModel : Base
    {
        [DataMember]
        public int ConfigID { get; set; }
        [DataMember]
        public string Key { get; set; }
        [DataMember]
        public string Value { get; set; }
        [DataMember]
        public string Description { get; set; }

    }
}
