/// <summary>
/*  Module Name         : One Portal Cookie Keys
 *  Purpose             : Provide the Keys Names for Caching data in Browser Cookies 
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

#endregion

namespace DPSG.Portal.Framework.Types.Constants
{
    public static class CookieKeys
    {
        public static readonly string CookieName = "DPSGOnePortalCookie";
        public static readonly string CookieUserName = "UserName";
        public static readonly string CookieDefaultBranch = "PrimaryBranch";
        public static readonly string CookieAdditionalBranch = "AdditionalBranch";
        public static readonly string CookieCurrentBranch = "CurrentBranch";
        public static readonly string IsPreferenceSaved = "IsPreferenceSaved";        
    }

}
