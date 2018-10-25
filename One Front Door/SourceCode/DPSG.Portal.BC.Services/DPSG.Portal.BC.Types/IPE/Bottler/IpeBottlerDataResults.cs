using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.IPE.Bottler
{
    [DataContract]
    public class IpeBottlerDataResults
    {
        [DataMember]
        public IList<Types.IPE.Bottler.Contract.IpeBottlerModel> IpeBottlers = new List<Types.IPE.Bottler.Contract.IpeBottlerModel>();
    }
}
