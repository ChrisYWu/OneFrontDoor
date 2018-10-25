using System;
using System.Linq;
using System.Runtime.Serialization;
using DPSG.Portal.BC.Services.DataContract;

namespace DPSG.Portal.BC.Services.DataContract.BottlerHierarchy
{
    [DataContract]
    public class BotttlerHierarchyDataDetails : ResponseBase
    {
        [DataMember]
        public Types.BottlerHierarchy.Contract.BottlerHiearchyData BottlerHierarchyMaster { get; set; }
    }
}