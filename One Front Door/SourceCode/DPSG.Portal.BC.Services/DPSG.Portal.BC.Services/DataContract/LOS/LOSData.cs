using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.LOS
{
    [DataContract]
    public class LOSData : ResponseBase 
    {
        [DataMember]
        public IList<LOS> LOS=new List<LOS>();        
        [DataMember]
        public IList<DisplayLocation> DisplayLocations = new List<DisplayLocation>();
        [DataMember]
        public IList<LOSDisplayLocation> LOSDisplayLocations = new List<LOSDisplayLocation>();
        [DataMember]
        public IList<TieInReasonMaster> TieInReasons = new List<TieInReasonMaster>();
        [DataMember]
        public IList<DisplayTypeMaster> DisplayTypes = new List<DisplayTypeMaster>();
        [DataMember]
        public IList<SystemBrand> SystemBrands = new List<SystemBrand>();
        [DataMember]
        public IList<SystemPackage> SystemPackages = new List<SystemPackage>();
        [DataMember]
        public IList<SystemPackageBrand> SystemPackageBrands = new List<SystemPackageBrand>();
        [DataMember]
        public IList<SystemTrademarkMaster> SystemTrademark= new List<SystemTrademarkMaster>();
        [DataMember]
        public IList<Config> Config = new List<Config>();
        [DataMember]
        public IList<SystemCompetitionBrand> SystemCompetitionBrands = new List<SystemCompetitionBrand>();
        [DataMember]
        public IList<BCPromotionExecutionStatus> PromotionExecutionStatusMaster = new List<BCPromotionExecutionStatus>();
                
    }
}