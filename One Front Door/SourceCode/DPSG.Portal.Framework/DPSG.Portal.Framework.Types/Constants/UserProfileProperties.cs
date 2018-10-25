/// <summary>
/*  Module Name         : One Portal User Profile Properties
 *  Purpose             : Provide the Keys Names for Accessing SharePoint User Profile Properties 
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
    public class UserProfileProperties
    {
        public static readonly string DefaultLocation = "Office"; //"SPS-Location";

        public static readonly string AccountName = "AccountName";
        public static readonly string PrimaryBranch = "PrimaryBranch";
        public static readonly string AdditionalBranches = "AdditionalBranches";
        public static readonly string BranchBrand = "BranchBrand";
        //public static readonly string BranchKPI = "BranchKPI";
        public static readonly string BranchCAN = "BranchCAN";
        public static readonly string IsPreferenceSaved = "IsPreferenceSaved";
        public static readonly string IsBranchManager = "IsBranchManager";
        public static readonly string PrimaryRole = "PrimaryRole";

        //Properties added for Account
        public static readonly string NationalAccount = "NationalAccount";
        public static readonly string RegionalAccount = "RegionalAccount";
        public static readonly string LocalAccount = "LocalAccount";

        public static readonly string GeoBUs = "BUs";
        public static readonly string GeoRegions = "Regions";
        public static readonly string GeoBranches = "Branches";
        public static readonly string GeoAreas = "Areas";

        public static readonly string Channel = "Channel";
        public static readonly string SuperChannel = "SuperChannel";
        public static readonly string DefaultPromotion = "DefaultPromotion";
    }
}
