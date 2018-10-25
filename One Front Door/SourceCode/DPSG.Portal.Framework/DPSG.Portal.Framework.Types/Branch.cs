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
    public class Branch
    {
        [DataMember]
        public int branchId { get; set; }
        [DataMember]
        public string branchName { get; set; }
        [DataMember]
        public string SAPBranchId { get; set; }

        [DataMember]
        public int AreaID { get; set; }
        [DataMember]
        public string AreaName { get; set; }

        [DataMember]
        public int RegionID { get; set; }
        [DataMember]
        public string RegionName { get; set; }

        [DataMember]
        public int BUID { get; set; }
        [DataMember]
        public string BUName { get; set; }
    }
}
