/// <summary>
/*  Module Name         : One Portal Behavior Member
 *  Purpose             : Provide the Stucture of a Behavior Member
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
    public class BehaviorMemberList
    {
      
        [DataMember]
        public string BehaviorMemberName { get; set; }
        [DataMember]
        public string BehaviorMemberValue { get; set; }
        [DataMember]
        public int BehaviorMemberPrecedence { get; set; }
        [DataMember]
        public string BehaviorName { get; set; }
    }
}