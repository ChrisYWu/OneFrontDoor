using DPSG.Portal.BC.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.BC.BAL
{
    public class Helper
    {
        public static string ReturnUTCDateTime(DateTime? DT)
        {
            return DT.HasValue ? TimeZoneInfo.ConvertTimeToUtc(DT.Value).ToString(Constants.DATE_FORMAT) : "";
        }
    }
}
