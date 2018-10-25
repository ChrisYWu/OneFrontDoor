using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.IPE.MasterData.Contract
{
    [DataContract]
    public class ResponseTypeValuesEntity : Base
    {
        [DataMember]
        public int ResponseTypeValueID { get; set; }
        [DataMember]
        public int ResponseTypeID { get; set; }
        [DataMember]
        public string Description { get; set; }
        [DataMember]
        public int Value { get; set; }
        [DataMember]
        public byte SortOrder { get; set; }
    }
}
