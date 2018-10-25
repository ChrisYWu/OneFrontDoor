using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Config.BCMYDAY
{
    [DataContract]
    public class ConfigValuesResults
    {
        [DataMember]
        public IList<Types.Config.BCMYDAY.ConfigValuesModel> Config = new List<Types.Config.BCMYDAY.ConfigValuesModel>();
     
    }
}
