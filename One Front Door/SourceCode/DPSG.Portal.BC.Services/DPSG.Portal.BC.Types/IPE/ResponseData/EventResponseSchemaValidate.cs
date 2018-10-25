using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.IPE.ResponseData
{
    [DataContract]
    public class EventResponseSchemaValidate
    {
        [DataMember]
        public List<Types.IPE.ResponseData.Contract.EventResponseData> EventResponseData { get; set; }
    }
}
