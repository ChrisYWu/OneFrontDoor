using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.IPE
{
    [DataContract]
    public class IpeBottlerDataResults : ResponseBase
    {
        [DataMember]
        public IList<Types.IPE.Bottler.Contract.IpeBottlerModel> IpeBottlers = new List<Types.IPE.Bottler.Contract.IpeBottlerModel>();
    }
}
