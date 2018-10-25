

/// <summary>
/*  Module Name         : One Portal Branch Type
 *  Purpose             : Provide the Stucture of a Branch Type
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
using System.Runtime.Serialization;
#endregion

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class Persona
    {
        [DataMember]
        public int PortalRoleID { get; set; }
        [DataMember]
        public string PersonaName { get; set; }
        [DataMember]
        public int? PersonaID { get; set; }
        [DataMember]
        public string PortalRoleName { get; set; }
        [DataMember]
        public int PortalRolePrecedence { get; set; }
        [DataMember]
        public string PortalRoleShortName { get; set; }
    }
}