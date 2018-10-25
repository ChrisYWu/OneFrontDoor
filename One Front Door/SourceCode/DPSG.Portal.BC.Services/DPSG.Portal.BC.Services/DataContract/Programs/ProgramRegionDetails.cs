using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Programs
{
    [DataContract]
    public class ProgramRegionDetails : ResponseBase
    {
        [DataMember]
        public IList<Types.Programs.Contract.Region.AccountPrograms> AccountPrograms = new List<Types.Programs.Contract.Region.AccountPrograms>();
        [DataMember]
        public IList<Types.Programs.Contract.Region.ProgramPackages> ProgramPackages = new List<Types.Programs.Contract.Region.ProgramPackages>();
        [DataMember]
        public IList<Types.Programs.Contract.Region.ProgramBrands> ProgramBrands = new List<Types.Programs.Contract.Region.ProgramBrands>();
        [DataMember]
        public IList<Types.Programs.Contract.Region.ProgramAccounts> ProgramAccounts = new List<Types.Programs.Contract.Region.ProgramAccounts>();
        [DataMember]
        public IList<Types.Programs.Contract.Region.ProgramAttachments> ProgramAttachments = new List<Types.Programs.Contract.Region.ProgramAttachments>();
        [DataMember]
        public IList<Types.Programs.Contract.Region.MarketingPrograms> MarketingPrograms = new List<Types.Programs.Contract.Region.MarketingPrograms>();
        [DataMember]
        public IList<Types.Programs.Contract.Region.MarketingProgramPackages> MarketingProgramPackages = new List<Types.Programs.Contract.Region.MarketingProgramPackages>();
        [DataMember]
        public IList<Types.Programs.Contract.Region.MarketingProgramBrands> MarketingProgramBrands = new List<Types.Programs.Contract.Region.MarketingProgramBrands>();
        [DataMember]
        public IList<Types.Programs.Contract.Region.MarketingProgramAccounts> MarketingProgramAccounts = new List<Types.Programs.Contract.Region.MarketingProgramAccounts>();
        [DataMember]
        public IList<Types.Programs.Contract.Region.MarketingProgramAttachments> MarketingProgramAttachments = new List<Types.Programs.Contract.Region.MarketingProgramAttachments>();

    }
}