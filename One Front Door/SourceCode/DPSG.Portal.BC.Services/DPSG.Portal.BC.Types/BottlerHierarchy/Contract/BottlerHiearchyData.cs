using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.BottlerHierarchy.Contract
{
    [DataContract]
    public class BottlerHiearchyData
    {
        [DataMember]
        public IList<Types.BottlerHierarchy.Contract.BottlerHieararchy> EBH1 = new List<Types.BottlerHierarchy.Contract.BottlerHieararchy>();

        [DataMember]
        public IList<Types.BottlerHierarchy.Contract.BottlerHieararchy> EBH2 = new List<Types.BottlerHierarchy.Contract.BottlerHieararchy>();

        [DataMember]
        public IList<Types.BottlerHierarchy.Contract.BottlerHieararchy> EBH3 = new List<Types.BottlerHierarchy.Contract.BottlerHieararchy>();

        [DataMember]
        public IList<Types.BottlerHierarchy.Contract.BottlerHieararchy> EBH4 = new List<Types.BottlerHierarchy.Contract.BottlerHieararchy>();
    }
}
