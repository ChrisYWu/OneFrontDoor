/// <summary>
/*  Module Name         : One Portal Config Entry Type
 *  Purpose             : Provide the Structure of a Config Entry Type 
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

namespace DPSG.Portal.Framework.Types
{
    [Serializable]
    public class ConfigEntry
    {
        public string KeyName { get; set; }
        public string KeyValue { get; set; }
        public string Description { get; set; }
        public string Category { get; set; }

    }

    [Serializable]
    public class TabConfigList
    {
        public string TabTitle { get; set; }
        public List<string> WebpartsToInclude { get; set; }
    }
}
