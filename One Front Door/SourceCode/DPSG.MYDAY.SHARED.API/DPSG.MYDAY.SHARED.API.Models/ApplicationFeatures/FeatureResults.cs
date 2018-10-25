using System.Collections.Generic;

namespace DPSG.MYDAY.SHARED.API.Models.ApplicationFeatures
{
    public class FeatureResults : OutputBase
    {
        List<FeatureItemDto> applicationFeature;

        public List<FeatureItemDto> ApplicationFeatureConfigs
        {
            get { return applicationFeature; }
            set { applicationFeature = value; }
        }
        public class FeatureItemDto :FeatureItem
        { }
    }
}
