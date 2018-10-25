using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework
{
    public interface IMySplashnetNotification
    {
        string Title { get; set; }
        string URL { get; set; }
        IList<DPSG.Portal.Framework.Types.MySplashnetNotification> GetMySplashnetNotifications(string GSN, int roleId, DateTime lastAccessDatetime, int branchID = 0, int regionID=0,int? currentPersona=0);
    }
}
