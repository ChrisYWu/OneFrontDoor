using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.IPE.ResponseData
{
    [DataContract]
    public class EventResponseDataDetails
    {
        [DataMember]
        public IList<Types.IPE.ResponseData.Contract.EventResponseData> EventResponseData = new List<Types.IPE.ResponseData.Contract.EventResponseData>();
    }
}
