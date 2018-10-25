using System.Collections.Generic;

namespace DPSG.MYDAY.SHARED.API.Models.ApplicationFeatures
{
   public class ApplicationVersionResults: OutputBase
    {
        public List<AppVersion> ApplicationVersion { get; set; }

        public class AppVersion 
        {
            public string ApplicationName { get; set; }
            public string MinimumVersion { get; set; }
            public string CurrentVersion { get; set; }
        }
    }
}
