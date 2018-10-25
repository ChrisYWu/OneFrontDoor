using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.IPE
{
    [DataContract]
    public class EventResponseDataDetails : ResponseBase
    {
        [DataMember]
        public IList<Types.IPE.ResponseData.Contract.EventResponseData> EventResponseData = new List<Types.IPE.ResponseData.Contract.EventResponseData>();
    }
}
