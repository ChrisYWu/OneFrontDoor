/// <summary>
/*  Module Name         : One Portal List's Field Names
 *  Purpose             : Provide the Field Names for Various Lists used within Code 
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
    public class MessageList
    {
        public static readonly string Name = "MessageList";
        public static readonly string Appname = "Appname";
        public static readonly string ScreenName = "ScreenName";
        public static readonly string Function = "Function";
        public static readonly string MessageKey = "MessageKey";
        public static readonly string MessageText = "MessageText";
        public static readonly string Type = "Type";
    }

    public class ConfigList
    {
        public static readonly string Name = "BM Config";
        public static readonly string FieldKeyName = "KeyName";
        public static readonly string FieldKeyValue = "KeyValue";
        public static readonly string FieldDescription = "Description";
        public static readonly string FieldCategory = "Category";
    }
    public class PreferencesList
    {
        public static readonly string Name = "BM Preferences";
        public static readonly string FieldBranchManager = "Branch_x0020_Manager";
        public static readonly string FieldBranch = "Branch";
        public static readonly string FieldDefaultBranch = "Default_x0020_Branch";
        public static readonly string FieldAdditionalBranches = "Additional_x0020_Branches";
        public static readonly string FieldBrand = "Brand";
        public static readonly string FieldKPI = "KPI";
        public static readonly string FieldKPIPreferences = "KPI_x0020_Preferences";
        public static readonly string FieldIsPreferenceSaved = "IsPreferenceSaved";
    }

    public class BranchList
    {

        public static readonly string Name = "Branches";
        public static readonly string FieldBranchID = "BranchID";
        public static readonly string FieldBranchName = "Branch";
        public static readonly string FieldBranch = "Branch_x0020_Name";
        public static readonly string FieldBUUrl = "BU_x0020_URL";
        public static readonly string FieldBusinesUnit = "Business_x0020_Unit";
        public static readonly string FieldRegion = "Region";
        public static readonly string FieldZipCode = "ZipCode"; 
    }

    public class BrandList
    {
        public static readonly string Name = "Brands";
        public static readonly string FieldBrandID = "Brand_x0020_ID";
        public static readonly string FieldBrandName = "Brand_x0020_Names";
        public static readonly string FieldBrandImage = "Brand_x0020_Image";
        public static readonly string FieldBrandThumbnail = "Brand_x0020_Thumbnail";
        public static readonly string FieldKPIBrandName = "KPI_x0020_BrandName";
        public static readonly string FieldScorecardMap = "Scorecard_x0020_Map";
        public static readonly string FieldTitle = "Title";

    }

    public class InTheSpotLightList
    {
        public static readonly string Name = "In the Spotlight";
        public static readonly string FieldSpotLightSubtitle = "Subtitle";
        public static readonly string FieldSpotLightImage = "Image";
        public static readonly string FieldSpotLightBody = "Body";
        public static readonly string FieldSpotlightEffectiveDate = "Effective Date";
        public static readonly string FieldSpotLightExpirationDate = "Expiration Date";
    }    

    public class SplashNetConfigList
    {
        public static readonly string Name = "SplashNetConfigList";
        public static readonly string KeyNameField = "KeyName";
        public static readonly string KeyValueField = "KeyValue";
        public static readonly string DescriptionField = "Description";
        public static readonly string CategoryField = "Category";

    }

    public class WhatsNewList
    {
        public static readonly string Name = "Whats New";
        public static readonly string FieldType = "Restriction_x0020_Type";
        public static readonly string FieldListUrl = "Title";
        public static readonly string FieldFileType = "Title";
        public static readonly string FieldIncludeExclude = "IncludeExclude";
    }

    public class ITUpdatesList
    {
        public static readonly string Name = "IT Updates";
        public static readonly string FieldID = "ID";
        public static readonly string FieldTitle = "Title";
        public static readonly string FieldCommnucationType = "Communication_x0020_Type";
        public static readonly string FieldDetails = "Details";
        public static readonly string FieldLocation = "Location";
        public static readonly string FieldExpirationDate = "Expiration_x0020_Date";
        public static readonly string FieldEffectiveDate = "Effective_x0020_Date";
        public static readonly string FieldCreatedDate = "Created";

        public static readonly string TermStoreGroup = "DPSG Enterprise Taxonomy"; //changed as per Dev/QA
        public static readonly string TermStoreCommunicationType = "Communication_x0020_Type";  //changed as per Dev/QA
        public static readonly string TermStoreLocation = "Location";
    }

    public class ITUpdateReadInfoHiddenList
    {
        public static readonly string Name = "ITUpdateReadInfoList";
        public static readonly string FieldITUpdateItemID = "ITUpdateItemID";
        public static readonly string FieldUsers = "Users";
    }

    public class PromotionList
    {
        public static readonly string Name = "Promotion";
        public static readonly string FieldPromotionHTML = "Promotional Content";
        public static readonly string FieldPromotionLocation = "Location";
        public static readonly string FieldPromotionEffectiveDate = "Effective Date";
        public static readonly string FieldPromotionExpirationDate = "Expiration Date";


        public static readonly string TermStoreGroup = "DPSG Enterprise Taxonomy"; //changed as per Dev/QA
        public static readonly string TermStoreCommunicationType = "Communication Type";  //changed as per Dev/QA
        public static readonly string TermStoreLocation = "Location";
    }

    public class TrendingNowHiddenList
    {
        public static readonly string Name = "TrendingNowHiddenList";
        public static readonly string FieldTrendingTerm = "Title";
        public static readonly string HiddenFieldCount = "OccurrenceCount";
    }

    public class TrendingNowList
    {
        public static readonly string Name = "Trending Now";
        public static readonly string FieldTrendingTerm = "Title";
    }

    // MyNews Master List for all the Feed URLs
    public class MyNewsFeedURLsList
    {
        public static readonly string Name = "MyNewsFeedURLs";
        public static readonly string FieldFeedName = "FeedName";
        public static readonly string FieldFeedURL = "FeedURL";
        public static readonly string FieldFeedStatus = "FeedStatus";
    }
    // MyNews User specific Feeds List 
    public class MyNewsFeedsList
    {
        public static readonly string Name = "MyNewsFeeds";
        public static readonly string FieldUserName = "UserName";
        //public static readonly string FieldFeedID = "FeedID";
        public static readonly string FieldFeedName = "FeedName";
        
    }

    // MySalesTarget List 
    public class MySalesTargetList
    {
        public static readonly string Name = "MySalesTarget";
        public static readonly string FieldPlanCases = "PlanCases";
        public static readonly string FieldActualCases = "ActualCases";
        public static readonly string FieldMTD = "MTD";
        public static readonly string FieldCasesPending = "CasesPending";
        public static readonly string FieldBranchName = "BranchName";
    }

    // RoleBasedURLs list
    public class RoleBasedURLs
    {
        public static readonly string Name = "RoleBasedURLs";
        public static readonly string FieldUserRole = "UserRole";
        public static readonly string FieldRedirectURL = "RedirectURL";
    }
    // Marketing Alerts 
    public class MarketingAlertsReadInfoHiddenList
    {
        public static readonly string Name = "MarketingAlertsReadInfoList";
        public static readonly string FieldMAItemID = "MAItemID";
        public static readonly string FieldMAUsers = "Users";
    }
    // Order Deadlines
    public class OrderDeadlinesReadInfoHiddenList
    {
        public static readonly string Name = "OrderDeadlinesReadInfoList";
        public static readonly string FieldODItemID = "ODItemID";
        public static readonly string FieldODUsers = "Users";
    }
    // Marketing Alerts List
    public class MarketingAlertsList
    {
        public static readonly string Name = "Marketing Alerts";
        public static readonly string FieldID = "ID";
        public static readonly string FieldTitle = "Title";
        public static readonly string FieldBrand = "Brand";
        public static readonly string FieldItemDescription = "Item Description";
        public static readonly string FieldLocations = "Locations";
        public static readonly string FieldExpirationDate = "ExpirationDate";
        public static readonly string FieldEffectiveDate = "Effective_x0020_Date";
        public static readonly string FieldCreatedDate = "Created";
    }

    // Order Deadlines  List
    public class OrderDeadlinesList
    {
        public static readonly string Name = "Order Deadlines";
        public static readonly string FieldID = "ID";
        public static readonly string FieldTitle = "Title";
        public static readonly string FieldBrand = "Brand";
        public static readonly string FieldItemDescription = "Item Description";
        public static readonly string FieldLocations = "Locations";
        public static readonly string FieldDeadlineDate = "Deadline_x0020_Date";
        public static readonly string FieldExpirationDate = "ExpirationDate";
        public static readonly string FieldEffectiveDate = "Effective_x0020_Date";
        public static readonly string FieldCreatedDate = "Created";
    }

    // News You Can Use List
    public class NewsYouCanUseList
    {
        public static readonly string Name = "News You Can Use";
        public static readonly string FieldID = "ID";
        public static readonly string FieldURL = "URL";
        public static readonly string FieldShareWidgets = "Share Widgets";
    }

}

