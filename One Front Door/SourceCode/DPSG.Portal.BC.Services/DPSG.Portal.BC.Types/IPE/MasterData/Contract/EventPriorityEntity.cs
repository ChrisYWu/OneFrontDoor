using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.IPE.MasterData.Contract
{
    [DataContract]
    public class EventPriorityEntity : Base
    {
        [DataMember]
        public int PriorityID { get; set; }
        [DataMember]
        public string Description { get; set; }
        [DataMember]
        public byte SortOrder { get; set; }
    }
}
