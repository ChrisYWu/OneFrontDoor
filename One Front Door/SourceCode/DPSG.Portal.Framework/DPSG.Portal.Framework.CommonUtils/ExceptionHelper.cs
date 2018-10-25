/// <summary>
/*  Module Name         : One Portal Exception Helper
 *  Purpose             : Provide the Helper Methods to Log Exceptions 
 *  Created Date        : 04-Feb-2013
 *  Created By          : Himanshu Panwar
 *  Last Modified Date  : 04-Feb-2013
 *  Last Modified By    : 04-Feb-2013
 *  Where to use        : In One Portal 
 *  Dependency          : 
*/
/// </summary>

#region using

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.SharePoint;
using Microsoft.SharePoint.Administration;

#endregion

namespace DPSG.Portal.Framework.CommonUtils
{
    public static class ExceptionHelper
    {

        public static void LogException(string message, Exception ex)
        {

            SPSecurity.RunWithElevatedPrivileges(delegate()
            {
                SPDiagnosticsService diagSvc = SPDiagnosticsService.Local;
                diagSvc.WriteTrace(0, new SPDiagnosticsCategory("DPSG", TraceSeverity.Monitorable, EventSeverity.Error), TraceSeverity.Monitorable, message + "\n" + ex.Message + "\n" + ex.StackTrace, null);
            });

        }

        public static void LogMessage(string message)
        {
            
            SPSecurity.RunWithElevatedPrivileges(delegate()
            {
                SPDiagnosticsService diagSvc = SPDiagnosticsService.Local;
                diagSvc.WriteTrace(0, new SPDiagnosticsCategory("DPSG -> Info", TraceSeverity.Monitorable, EventSeverity.Information), TraceSeverity.Monitorable, message + "\n");
            });

        }
    }
}
