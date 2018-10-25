using System;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.BottlerHierarchy
{
    [DataContract]
    public class BotttlerHierarchyDataDetails
    {
        [DataMember]
        public Types.BottlerHierarchy.Contract.BottlerHiearchyData BottlerHierarchyMaster { get; set; }
    }
}
