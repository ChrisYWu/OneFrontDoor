/// <summary>
/*  Module Name         : One Portal Config Entries
 *  Purpose             : Provide the Keys to Access the Config Entries 
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
    public static class Config
    {
        //Web Config Entry
        public static readonly string KeyBMConfigListURL = "SplashNetConfigListURL";
        public static readonly string KeyADUserName= "SplashNet.TimerJob.ADUserName";
        public static readonly string KeyADPassword = "SplashNet.TimerJob.ADPassword";
        public static readonly string SDMConnectingString = "SplashNet.SDM.ConnectionString";
        public static readonly string MyNewsFeedAccount = "SplashNet.MyNewsFeedAccount";
        public const string RiverbedJSFilePath = "RiverbedJSFilePath";
        public const string LogSreConsumption = "LogSREConsumption";
        

        //BM Config Entry
        public static readonly string MySplashNetSite = "MySplashNetSite";
        public static readonly string SplashNetSite = "SplashNetSite";
        public static readonly string BUSiteURL = "BUSiteUrl";
        public static readonly string DefaultLocation = "DefaultLocation";

        public static readonly string CacheDurationTimeInMinutes = "CacheDurationTimeInMinutes";
        public static readonly string UseHttpContextCache = "UseHttpContextCache";


        public static readonly string MaxKPIPreferencesAllowed = "MaxKPIPreferencesAllowed";
        
        public static readonly string TabConfiguration = "TabConfiguration";
        public static readonly int CookieExpiryInYears = 1;

        public static readonly string BMSite = "BMSite";
        public static readonly string BUSite = "BUSite";
        public static readonly string BUAlertsListName = "BUAlertsListName";
        public static readonly string BUMarketAlertsListName = "BUMarketAlertsListName";

        public static readonly string NoOfAlertToShowOnScreen = "NoOfAlertToShowOnScreen";
        public static readonly string NoOfMarketAlertsToShowOnScreen = "NoOfMarketAlertsToShowOnScreen";
        public static readonly string NoOfNewsToShowOnScreen = "NoOfNewsToShowOnScreen";
        public static readonly string NoOfCharactersToShowForNewsBody = "NoOfCharactersToShowForNewsBody";

        public static readonly string FormNameSystemAlerts = "FormNameSystemAlerts";
        public static readonly string FormNameAnnouncements = "FormNameAnnouncements";
        public static readonly string FormNameMarketingAlerts = "FormNameMarketingAlerts";
        public static readonly string FormNameOrderDeadlines = "FormNameOrderDeadlines";

        public static readonly string PageNameITUpdates = "PageNameITUpdates";

        public const string RedirectToDefaultURL = "RedirectToDefaultURL";

        //Weather Config key entries added by Himanshu, User Story: #22
        public static readonly string WeatherWebServiceURL = "WeatherWebServiceURL";
        public static readonly string WeatherWebServiceFeatures = "WeatherWebServiceFeatures";
        public static readonly string WeatherWebServiceSettings = "WeatherWebServiceSettings";
        public static readonly string WeatherAppKey = "WeatherAppKey";
        public static readonly string WeatherResponseFormat = "WeatherResponseFormat";

        public static readonly string WeatherIconSet = "WeatherIconSet";
        public static readonly string WeatherImageURL = "WeatherImageURL";
        public static readonly string WeatherWebpartIconURL = "WeatherWebpartIconURL";

        public static readonly string WeatherTimeOutErrorMessage = "WeatherTimeOutErrorMessage";
        public static readonly string WeatherCouldNotConnectErrorMessage = "WeatherCouldNotConnectErrorMessage";
        public static readonly string WeatherIncorrectResponseErrorMessage = "WeatherIncorrectResponseErrorMessage";
        public static readonly string WeatherErrorMessage = "WeatherErrorMessage";
        public static readonly string WeatherNumOfDays = "WeatherNumOfDays";

        public static readonly string FooterText = "FooterText";
        public static readonly string SitemapUrl = "SitemapUrl";
        public static readonly string HelpUrl = "HelpUrl";

        public static readonly string NoOfTrendingNowTerms = "NoOfTrendingNowTerms";
        public static readonly string PBGoal = "PBGoal";

        // PRApproval counts
        public static readonly string PRApprovalCountURL = "PRApprovalCountURL";
        public static readonly string PRApprovalsSiteURL = "PRApprovalsSiteURL";

        // Quick Links default value
        public static readonly string linksDefault = "linksDefault";

        // Promotions GEO Relevancy 
        public static readonly string GEOBUName = "GEOBUName";
        public static readonly string GEOBUText = "GEOBUText";
        
        //message list
        public static readonly string MessageListURL = "/Lists/MessageList/AllItems.aspx";

        //program page
        public static readonly string ProgramSite = "ProgramSite";
        public static readonly string ProgLibbaseUrl = "ProgLibbaseUrl";

        //SupplyChain
        public static readonly string SupplyChainInventoryOperationsURL = "SupplyChainInventoryOperationsURL";
        public static readonly string SupplyChainBingMapCredential = "SupplyChainBingMapCredential";


    }
}
