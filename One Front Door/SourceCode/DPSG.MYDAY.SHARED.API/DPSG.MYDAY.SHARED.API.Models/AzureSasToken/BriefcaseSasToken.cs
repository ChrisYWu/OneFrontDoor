using System;
using System.Collections.Generic;

namespace DPSG.MYDAY.SHARED.API.Models.AzureSasToken
{
    public class BriefcaseSasToken : OutputBase
    {
        public IList<SasTokenInfo> Briefcase = new List<SasTokenInfo>();

        public class SasTokenInfo
        {
            private DateTime _sasExpirationDate;
            public string SasContainerToken { get; set; }
            public string Container { get; set; }
            public string BaseUrl { get; set; }
            public string SasExpirationDate
            {
                get { return _sasExpirationDate.ToString("yyyy-MM-ddThh:mm:ss"); }
                set { _sasExpirationDate = DateTime.Parse(value); }
            }
        }
    }
}