/// <summary>
/*  Module Name         : One Portal Cache Keys
 *  Purpose             : Provide the Keys Names for Caching data in ASP.NET Cache 
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
    public static class CacheKeys
    {
        public static readonly string BMConfigList = "BMConfigList";
        public static readonly string BranchCollectionList = "BranchCollectionList";

        public static readonly string WeatherCacheKey = "WeatherHTML";
        public static readonly string WeatherCacheDependencyKey = "LocationZipCode";
        public static readonly string QuickLinksCacheKey = "QuickLinks";
        public static readonly string MyLinksCacheKey = "MyLinks";

        public static readonly string WhatsNewCacheKey = "WhatsNewHTML";
        public static readonly string TrendingNowCacheKey = "TrendingNowHTML";

        public static readonly string CurrentBranchCacheKey = "CurrentBranch";

        public const string CurrentRegionCacheKey = "CurrentBCRegion";


        public static readonly string AllAccountTreeViewCacheKey = "AllAccountsTreeView";

        public static readonly string AllAccountAutoCompCacheKey = "AllAccountsAutoComp";

        public static readonly string AllLocationTreeViewCacheKey = "AllLocationTreeView";
        public static readonly string AllLocationAutoCompCacheKey = "AllLocationAutoComp";

        public static readonly string AllLocationAccountsCacheKey = "AllLocationAccounts";
        public static readonly string AllChannelsCacheKey = "AllChannelsCacheKey";
        public static readonly string AllUserPrefChannelsCacheKey = "AllUserPrefChannelsCacheKey";

        public const string GET_RELATIONSHIP_FROM_LOCATION_CHAIN = "Relationship_MView.LocationChain";
        public static readonly string CurrentPersonaCacheKey = "CurrentPersona";
        public const string CACHE_KEY_ALLLOCALACCOUNTS = "OFDPortalAllLocalAccounts";

    }
}
