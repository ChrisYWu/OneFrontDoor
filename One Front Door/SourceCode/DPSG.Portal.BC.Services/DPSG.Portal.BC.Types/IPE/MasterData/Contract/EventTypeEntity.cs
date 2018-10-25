using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.IPE.MasterData.Contract
{
    [DataContract]
    public class EventTypeEntity : Base
    {
        [DataMember]
        public int EventTypeID { get; set; }
        [DataMember]
        public string Description { get; set; }
    }
}
