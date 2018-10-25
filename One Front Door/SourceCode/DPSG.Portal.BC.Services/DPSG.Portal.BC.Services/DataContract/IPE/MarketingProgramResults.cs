using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.IPE
{
    [DataContract]
    public class MarketingProgramResults : ResponseBase
    {
        [DataMember]
        public IList<Types.IPE.Programs.Contract.MarketingPrograms> MarketingPrograms = new List<Types.IPE.Programs.Contract.MarketingPrograms>();
        [DataMember]
        public IList<Types.IPE.Programs.Contract.MarketingProgramPackages> MarketingProgramPackages = new List<Types.IPE.Programs.Contract.MarketingProgramPackages>();
        [DataMember]
        public IList<Types.IPE.Programs.Contract.MarketingProgramBrands> MarketingProgramBrands = new List<Types.IPE.Programs.Contract.MarketingProgramBrands>();
        [DataMember]
        public IList<Types.IPE.Programs.Contract.MarketingProgramAttachments> MarketingProgramAttachments = new List<Types.IPE.Programs.Contract.MarketingProgramAttachments>();

    }
}
