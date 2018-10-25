/// <summary>
/*  Module Name         : One Portal Helper Utilities
 *  Purpose             : Provide the Common Helper Methods
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
using System.Web;
using Microsoft.SharePoint;
using System.Text.RegularExpressions;
using System.Xml;
using Microsoft.SharePoint.Utilities;
using Microsoft.SharePoint.Client;
using System.Web.UI.WebControls;
using System.Collections;
using System.Web.Configuration;
using System.Diagnostics;
using System.Reflection;
using Microsoft.SharePoint.Taxonomy;
using System.Web.Script.Serialization;
using DPSG.Portal.Framework.Types.Constants;
using DPSG.Portal.Framework.Types;
using System.Data;
using System.IO;
#endregion


namespace DPSG.Portal.Framework.CommonUtils
{
    public static class HelperUtils
    {
        /// <summary>
        /// Trims and formats the description after stripping the HTML based on noOfChars
        /// </summary>
        /// <param name="checkValue"></param>
        /// <param name="noOfChars"></param>
        /// <returns></returns>
        public static string TrimAndFormat(string checkValue, int noOfChars)
        {
            string retValue = string.Empty;
            retValue = StripHTML(checkValue);
            if (retValue.Length > noOfChars)
                retValue = retValue.Substring(0, noOfChars) + "...";

            return retValue;
        }
        public static String BuildViewFieldsXML(params String[] FieldNames)
        {
            const string TEMPLATE = @"<FieldRef Name='{0:S}'/>";
            StringBuilder strbViewFields = new StringBuilder();
            foreach (string FieldName in FieldNames)
            {
                strbViewFields.AppendFormat(TEMPLATE, FieldName);
            }
            return strbViewFields.ToString();
        }

        /// <summary>
        /// Strips HTML from inputstring
        /// </summary>
        /// <param name="inputString"></param>
        /// <returns></returns>
        public static string StripHTML(string inputString)
        {
            const string HTML_TAG_PATTERN = "<.*?>";
            return Regex.Replace(inputString, HTML_TAG_PATTERN, string.Empty);
        }
        /// <summary>
        /// Checks for null string
        /// </summary>
        /// <param name="checkValue"></param>
        /// <returns></returns>
        public static string CheckNullString(object checkValue)
        {
            string retValue = string.Empty;
            try
            {
                //try to convert to string
                if (checkValue != null)
                    retValue = checkValue.ToString().Trim();
            }
            catch
            {
                retValue = string.Empty;
            }
            return retValue;
        }

        #region Branch Helper Methods

        public static List<Branch> DeserializeBranches(this string value)
        {
            List<Branch> retVal = new List<Branch>();

            var arr = new string[1];

            if (value.Contains(';'))
                arr = value.Split(';');
            else
                arr[0] = value;

            foreach (string item in arr)
            {
                retVal.Add(new Branch { branchName = item });
            }

            return retVal;
        }

        public static string SerializeBranches(this List<Branch> value)
        {
            StringBuilder sbBranches = new StringBuilder();

            if (value != null)
            {
                foreach (Branch branch in value)
                {
                    sbBranches.Append(branch.branchName + ";");
                }
                if (sbBranches.ToString().EndsWith(";"))
                    sbBranches.Remove(sbBranches.Length - 1, 1);
            }
            return sbBranches.ToString();
        }

        public static string SerializeBranches(this List<Branch> value, char delimiter)
        {
            StringBuilder sbBranches = new StringBuilder();

            if (value != null)
            {
                foreach (Branch branch in value)
                {
                    sbBranches.Append(branch.branchName + delimiter);
                }
                if (sbBranches.ToString().EndsWith(delimiter.ToString()))
                    sbBranches.Remove(sbBranches.Length - 1, 1);
            }
            return sbBranches.ToString();
        }

        public static List<Branch> DeserializeBranches(this string value, char delimiter)
        {
            List<Branch> retVal = new List<Branch>();

            var arr = new string[1];

            if (value.Contains(delimiter))
                arr = value.Split(delimiter);
            else
                arr[0] = value;

            foreach (string item in arr)
            {
                retVal.Add(new Branch { branchName = item });
            }

            return retVal;
        }

        #endregion

        #region Config Helper Methods
        /// <summary>
        /// This method is used to get the ConfigEntry by KeyName
        /// </summary>
        /// <param name="keyName">KeyName</param>
        /// <returns>Value</returns>
        public static string GetConfigEntrybyKey(string keyName)
        {
            return GetConfigEntrybyKeyCategory(keyName, string.Empty);
        }

        /// <summary>
        /// This method is used to get the ConfigEntry by KeyName and Category
        /// </summary>
        /// <param name="keyName">KeyName</param>
        /// <returns>Value</returns>
        public static string GetConfigEntrybyKeyCategory(string keyName, string Category)
        {
            string ConfigListCacheKey = "SplashNetConfigListCacheKey";
            string listQuery = string.Empty;
            string keyValue = string.Empty;
            
            DataTable dtConfigList = null;
            if (string.IsNullOrEmpty(Category))
            {
                listQuery = "KeyName = '" + keyName + "'";
            }
            else
            {
                listQuery = "KeyName = '" + keyName + "' AND Category = '" + Category + "'";
            }


            if (HttpContext.Current.Cache[ConfigListCacheKey] != null)
            {
                dtConfigList = (DataTable)HttpContext.Current.Cache[ConfigListCacheKey];
                if (dtConfigList != null && dtConfigList.Rows.Count > 0)
                {
                    DataRow[] drKeyValue = dtConfigList.Select(listQuery);
                    if (drKeyValue != null && drKeyValue.Length > 0)
                    {
                        keyValue = Convert.ToString(drKeyValue[0][SplashNetConfigList.KeyValueField]);
                    }
                }
            }
            else
            {
                string configListUrl = GetWebConfigEntrybyKey(Config.KeyBMConfigListURL);
                try
                {
                    SPQuery oQuery = new SPQuery();
                    oQuery.RowLimit = 500;
                    oQuery.ViewFields = BuildViewFieldsXML(SplashNetConfigList.KeyNameField, SplashNetConfigList.KeyValueField, SplashNetConfigList.CategoryField, SplashNetConfigList.DescriptionField);

                    SPSecurity.RunWithElevatedPrivileges(delegate()
                    {
                        using (SPSite elevatedSite = new SPSite(configListUrl))
                        {
                            SPList list = elevatedSite.RootWeb.Lists.TryGetList(SplashNetConfigList.Name);
                            if (list != null)
                            {
                                SPListItemCollection collListItems = list.GetItems(oQuery);
                                dtConfigList = collListItems.GetDataTable();

                                if (dtConfigList != null && dtConfigList.Rows.Count > 0)
                                {
                                    DataRow[] drKeyValue = dtConfigList.Select(listQuery);
                                    if (drKeyValue != null && drKeyValue.Length > 0)
                                    {
                                        keyValue = Convert.ToString(drKeyValue[0][SplashNetConfigList.KeyValueField]);
                                    }
                                }
                                DateTime ExpirationTime = DateTime.Today.AddDays(1);
                                HttpContext.Current.Cache.Remove(ConfigListCacheKey);
                                HttpContext.Current.Cache.Add(ConfigListCacheKey, dtConfigList, null, ExpirationTime, System.Web.Caching.Cache.NoSlidingExpiration,
                                    System.Web.Caching.CacheItemPriority.High, null);
                            }
                        }
                    });
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("THERE IS ERROR WHILE RETRIEVING THE VALUE OF " + keyName + " And Category " + Category + " FROM BM_CONFIG LIST", ex);
                }
            }
            return keyValue;
        }

        public static void writeLog(string id,string e)
        {
            //using (StreamWriter w = File.AppendText("C:" + "\\" + "log.txt"))
            //{
            //    w.WriteLine(id + "-" + e + "-" + System.DateTime.Now.ToString());
            //}
        }


        /// <summary>
        /// Gets MySplashNet URL
        /// </summary>
        /// <returns></returns>
        public static string GetMySplashNetSiteUrl()
        {
            string Url = string.Empty;
            string keyName = Config.MySplashNetSite;
            try
            {
                Url = GetConfigEntrybyKey(keyName);
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("THERE IS ERROR WHILE RETRIEVING THE VALUE OF " + keyName + " FROM BM_CONFIG LIST", ex);
            }
            return Url;
        }

        /// <summary>
        /// Gets SplashNet URL
        /// </summary>
        /// <returns></returns>
        public static string GetSplashNetSiteUrl()
        {
            string Url = string.Empty;
            string keyName = Config.SplashNetSite;
            try
            {
                Url = GetConfigEntrybyKey(keyName);
                // Url = @"http://minint-e5m32ri:81";
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("THERE IS AN ERROR WHILE RETRIEVING THE VALUE OF " + keyName + " FROM BM_CONFIG LIST", ex);
            }
            return Url;
        }

        /// <summary>
        /// Gets BU URL
        /// </summary>
        /// <returns></returns>
        public static string GetBUSiteUrl()
        {
            string Url = string.Empty;
            string keyName = Config.BUSiteURL;
            try
            {
                Url = GetConfigEntrybyKey(keyName);
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("THERE IS ERROR WHILE RETRIEVING THE VALUE OF " + keyName + " FROM BM_CONFIG LIST", ex);
            }
            return Url;
        }

        public static string GetDefaultLocation()
        {
            string location = string.Empty;
            string currentUser = SPContext.Current.Web.CurrentUser.LoginName;
            try
            {
                location = UserProfileHelper.GetUserProfileProperty(UserProfileProperties.DefaultLocation, currentUser);
                if (string.IsNullOrEmpty(location))
                    location = GetDefaultLocationFromConfig();
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("THERE IS ERROR WHILE RETRIEVING THE VALUE OF DEFAULTLOCATION FROM BM_CONFIG LIST", ex);
            }
            return location;
        }

        private static string GetDefaultLocationFromConfig()
        {
            string location = string.Empty;
            string keyName = Config.DefaultLocation;
            try
            {
                location = GetConfigEntrybyKey(keyName);
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("THERE IS ERROR WHILE RETRIEVING THE VALUE OF " + keyName + " FROM BM_CONFIG LIST", ex);
            }
            return location;
        }

        public static OnePortalContext GetOnePortalContext(string siteUrl)
        {
            OnePortalContext context;

            string splashNetUrl = HelperUtils.GetSplashNetSiteUrl();
            string mySplashNetUrl = HelperUtils.GetMySplashNetSiteUrl();
            string buUrl = HelperUtils.GetBUSiteUrl();

            if (siteUrl.Equals(splashNetUrl))
                context = OnePortalContext.SplashNet;
            else if (siteUrl.Equals(mySplashNetUrl))
                context = OnePortalContext.MySplashNet;
            else if (siteUrl.Equals(buUrl))
                context = OnePortalContext.BU;
            else
                context = OnePortalContext.None;

            return context;
        }

        public static string GetMyNewsFeedAccount()
        {
            string account = string.Empty;
            try
            {
                account = GetWebConfigEntrybyKey(Config.MyNewsFeedAccount);
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("THERE IS ERROR WHILE RETRIEVING THE VALUE OF " + account + " FROM WEB CONFIG LIST IN HELPER UTILS", ex);
            }
            return account;
        }

        /// <summary>
        /// Gets web.config appsettings value by key
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        private static string GetWebConfigEntrybyKey(string key)
        {
            string retVal = string.Empty;
            try
            {
                retVal = HelperUtils.CheckNullString(WebConfigurationManager.AppSettings[key]);

                if (string.IsNullOrEmpty(retVal))
                    throw new Exception();
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: COULD NOT RETRIEVE VALUE FOR KEY \"" + key + "\" FROM WEB.CONFIG. CHECK WEB.CONFIG ENTRIES", ex);

                DPSGOnePortalException dex = new DPSGOnePortalException("ERROR: COULD NOT RETRIEVE VALUE FOR KEY \"" + key + "\" FROM WEB.CONFIG. CHECK WEB.CONFIG ENTRIES", ex);
                dex.ErrorCode = ErrorInfo.ErrorCodeWebConfigEntryMissing;
                dex.ErrorMessage = ErrorInfo.ErrorMessageWebConfigEntryMissing + " for key: \"" + key + "\".";
                throw dex;
            }
            return retVal;
        }

        #endregion

        public static IEnumerable<TSource> DistinctBy<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector)
        {
            HashSet<TKey> knownKeys = new HashSet<TKey>();
            foreach (TSource element in source)
            {
                if (knownKeys.Add(keySelector(element)))
                {
                    yield return element;
                }
            }
        }

        #region Weather Helper Methods

        public static string GetWeatherWebServiceRequestURL(string locationZipCode)
        {
            string webServiceURL = GetConfigEntrybyKey(Config.WeatherWebServiceURL);
            string AppKey = GetConfigEntrybyKey(Config.WeatherAppKey);
            string features = GetConfigEntrybyKey(Config.WeatherWebServiceFeatures).ToLower();
            string settings = GetConfigEntrybyKey(Config.WeatherWebServiceSettings).ToLower();
            string query = locationZipCode;
            string format = GetConfigEntrybyKey(Config.WeatherResponseFormat).ToLower();

            StringBuilder url = new StringBuilder();
            url.Append(webServiceURL);
            url.Append("/api/");
            url.Append(AppKey);
            url.Append('/');
            url.Append(features);
            url.Append('/');
            url.Append(settings);
            url.Append("/q/");
            url.Append(query);
            url.Append('.');
            url.Append(format);

            return url.ToString();
        }
        #endregion


        public static string GetMessageByKey(string MessageKey)
        {
            string MessageListCacheKey = CommonConstants.CACHE_MESSAGE_KEY;
            string listQuery = string.Empty;
            string keyValue = string.Empty;
            DataTable dtMessageList = null;

            listQuery = CommonConstants.MessageKey + "= " + "'" + MessageKey + "'";

            if (HttpContext.Current.Cache[MessageListCacheKey] != null)
            {
                dtMessageList = (DataTable)HttpContext.Current.Cache[MessageListCacheKey];
                if (dtMessageList != null && dtMessageList.Rows.Count > 0)
                {
                    DataRow[] drKeyValue = dtMessageList.Select(listQuery);
                    if (drKeyValue != null && drKeyValue.Length > 0)
                    {
                        keyValue = Convert.ToString(drKeyValue[0][MessageList.MessageText]);
                    }
                }
            }
            else
            {
                // string messageListUrl = "http://win-brdc2uegf52:9999/Lists/MessageList/AllItems.aspx";
                string messageListUrl = SPContext.Current.Site.RootWeb.Url + Config.MessageListURL;

                try
                {
                    SPQuery oQuery = new SPQuery();
                    oQuery.RowLimit = 500;
                    oQuery.ViewFields = BuildViewFieldsXML(MessageList.Appname, MessageList.Function, MessageList.MessageKey, MessageList.MessageText, MessageList.ScreenName, MessageList.Type);

                    SPSecurity.RunWithElevatedPrivileges(delegate()
                    {
                        using (SPSite elevatedSite = new SPSite(messageListUrl))
                        {
                            SPList list = elevatedSite.RootWeb.Lists.TryGetList(MessageList.Name);
                            if (list != null)
                            {
                                SPListItemCollection collListItems = list.GetItems(oQuery);
                                dtMessageList = collListItems.GetDataTable();

                                if (dtMessageList != null && dtMessageList.Rows.Count > 0)
                                {
                                    DataRow[] drKeyValue = dtMessageList.Select(listQuery);
                                    if (drKeyValue != null && drKeyValue.Length > 0)
                                    {
                                        keyValue = Convert.ToString(drKeyValue[0][MessageList.MessageText]);
                                    }
                                }
                                DateTime ExpirationTime = DateTime.Today.AddDays(1);
                                HttpContext.Current.Cache.Remove(MessageListCacheKey);

                                if (dtMessageList != null)
                                    HttpContext.Current.Cache.Add(MessageListCacheKey, dtMessageList, null, ExpirationTime, System.Web.Caching.Cache.NoSlidingExpiration,
                                        System.Web.Caching.CacheItemPriority.High, null);
                            }
                        }
                    });
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("THERE IS ERROR WHILE RETRIEVING THE VALUE " + MessageKey + "  FROM MessageList", ex);
                }
            }
            return keyValue;
        }
        /*
                public static int cacheTime = GetCacheDuration();
                public static bool useCache = GetCacheUseSetting();

                /// <summary>
                /// Gets Cache duration in minutes
                /// </summary>
                /// <returns></returns>
                private static int GetCacheDuration()
                {
                    //Default time in minutes
                    int cacheTime = 15;
                    try
                    {
                        string cacheDuration = GetConfigValue(Config.CacheDurationTimeInMinutes);
                        int result;
                        if (int.TryParse(cacheDuration, out result))
                            cacheTime = result;
                    }
                    catch
                    {
                        //Default time in minutes
                        cacheTime = 15;
                    }

                    return cacheTime;
                }


                private static bool GetCacheUseSetting()
                {
                    //Default useCache value
                    bool useCache = false;
                    try
                    {
                        string useCacheSetting = GetConfigValue(Config.UseHttpContextCache);
                        bool result;
                        if (bool.TryParse(useCacheSetting, out result))
                            useCache = result;
                    }
                    catch
                    {
                        //Default useCache value
                        useCache = false;
                    }

                    return useCache;
                }

                /// <summary>
                /// Gets the web app URL
                /// </summary>
                /// <returns></returns>
                public static string GetWebApplicationURL()
                {
                    HttpContext context = HttpContext.Current;
                    string webAppPath = string.Empty;
                    if (context != null)
                    {
                        //Formatting the fully qualified website url/name
                        webAppPath = string.Format("{0}://{1}",
                                                context.Request.Url.Scheme,
                                                context.Request.Url.Authority);
                    }
                    return webAppPath;
                }

                /// <summary>
                /// Retrieves Site collection URL
                /// </summary>
                /// <returns></returns>
                public static string GetSiteCollectionURL()
                {
                    string siteCollPath = string.Empty;
                    if (SPContext.Current != null)
                    {
                        siteCollPath = SPContext.Current.Site.RootWeb.Url;
                    }
                    return siteCollPath;
                }


                /// <summary>
                /// Strips HTML from inputstring
                /// </summary>
                /// <param name="inputString"></param>
                /// <returns></returns>
                public static string StripHTML(this string inputString)
                {
                    const string HTML_TAG_PATTERN = "<.*?>";
                    return Regex.Replace(inputString, HTML_TAG_PATTERN, string.Empty);
                }


                /// <summary>
                /// Trims and formats the description after stripping the HTML based on noOfChars
                /// </summary>
                /// <param name="checkValue"></param>
                /// <param name="noOfChars"></param>
                /// <returns></returns>
                public static string TrimAndFormat(string checkValue, int noOfChars)
                {
                    string retValue = string.Empty;
                    retValue = checkValue.StripHTML();
                    if (retValue.Length > noOfChars)
                        retValue = retValue.Substring(0, noOfChars) + "...";

                    return retValue;
                }

                /// <summary>
                /// Retrieve Look up value for a field name
                /// </summary>
                /// <param name="item"></param>
                /// <param name="fieldName"></param>
                /// <returns></returns>
                public static string GetFieldValueLookup(SPListItem item, string fieldName)
                {
                    if (item != null)
                    {
                        SPFieldLookupValue lookupValue =
                            new SPFieldLookupValue(item[fieldName] as string);
                        return lookupValue.LookupValue;
                    }
                    else
                    {
                        return string.Empty;
                    }
                }


                public static bool IsNewListItem(DateTime Created)
                {
                    TimeSpan ts = System.DateTime.Now - Created;
                    if (ts.TotalHours < 48)
                    {
                        return true;
                    }
                    else
                        return false;
                }


                /// <summary>
                /// Parse taxonomy field with multiple selection
                /// </summary>
                /// <param name="taxnomyString"></param>
                /// <returns></returns>
                public static List<MetadataValue> ExtractMultipleValuesFromMeteDataField(object fieldValue)
                {
                    List<MetadataValue> retVal = new List<MetadataValue>();

                    string taxonomyString = CheckNullString(fieldValue);

                    if (!string.IsNullOrEmpty(taxonomyString) && taxonomyString.Contains(';'))
                    {
                        var arr = taxonomyString.Split(';');
                        foreach (string item in arr)
                        {
                            retVal.Add(ExtractValueFromMeteDataField(item));
                        }
                    }
                    else if (!string.IsNullOrEmpty(taxonomyString))
                    {
                        var arr = taxonomyString.Split(';');
                        foreach (string item in arr)
                        {
                            retVal.Add(ExtractValueFromMeteDataField(item));
                        }
                    }
                    return retVal;
                }

                /// <summary>
                /// Parses Taxnomy field 
                /// </summary>
                /// <param name="taxnomyString"></param>
                /// <returns></returns>
                public static MetadataValue ExtractValueFromMeteDataField(object taxnomyStringObj)
                {
                    MetadataValue retVal = new MetadataValue();

                    var taxnomyString = CheckNullString(taxnomyStringObj);
                    if (!string.IsNullOrEmpty(taxnomyString) && taxnomyString.Contains('|'))
                    {
                        string Label = taxnomyString.Substring(0, taxnomyString.IndexOf('|'));
                        string Guid = taxnomyString.Substring(taxnomyString.IndexOf('|') + 1);

                        retVal.Label = Label;
                        retVal.Guid = Guid;
                    }
                    return retVal;
                }

                /// <summary>
                /// Returns today's date in ISO format to be used in CAML Queries
                /// </summary>
                /// <returns></returns>
                public static string Today()
                {
                    return Microsoft.SharePoint.Utilities.SPUtility.CreateISO8601DateTimeFromSystemDateTime(System.DateTime.Now.Date).ToString();
                }


                /// <summary>
                /// Converts a string item to URLField type with URL and Description
                /// </summary>
                /// <param name="field"></param>
                /// <returns></returns>
                public static URLField GetURLFieldFromString(this string field)
                {
                    URLField urlfield = new URLField();

                    if (string.IsNullOrEmpty(field))
                    {
                        urlfield.URL = string.Empty;
                        urlfield.Description = string.Empty;
                    }
                    else
                    {
                        if (field.Contains(','))
                        {
                            urlfield.Description = field.Substring(field.IndexOf(',') + 1);
                            urlfield.URL = field.Substring(0, field.IndexOf(','));
                        }
                        else
                        {
                            urlfield.Description = field;
                            urlfield.URL = field;
                        }

                        //if URL equals URL Description then make URL Description empty as it contains the URL
                        if (urlfield.URL.Trim() == urlfield.Description.Trim())
                            urlfield.Description = string.Empty;
                    }


                    return urlfield;
                }

               

                /// <summary>
                /// Get AssemblyFileVersion from AssemblyInfo.cs
                /// </summary>
                /// <returns></returns>
                public static string GetAssemblyFileVersion()
                {
                    string assFileVersion = string.Empty;

                    try
                    {
                        assFileVersion = FileVersionInfo.GetVersionInfo(Assembly.GetExecutingAssembly().Location).FileVersion;
                    }
                    catch (Exception ex)
                    {
                        ExceptionHelper.LogException("ERROR: COULD NOT RETRIEVE AssemblyFileVersion VALUE", ex);

                        DPSGException dex = new DPSGException("ERROR: COULD NOT RETRIEVE AssemblyFileVersion VALUE ", ex);
                        dex.ErrorCode = ErrorInfo.ErrorCodeAssemblyInfoError;
                        dex.ErrorMessage = ErrorInfo.ErrorMessageAssemblyInfoError;
                        throw dex;
                    }

                    return assFileVersion;
                }

                public static void SortListItem(ListBox listtoSort)
                {
                    SortedList sortedList = new SortedList();
                    foreach (ListItem item in listtoSort.Items)
                    {
                        sortedList.Add(item.Text, item.Value);
                    }

                    listtoSort.Items.Clear();
                    listtoSort.DataSource = sortedList.GetKeyList();
                    listtoSort.DataBind();
                }


                public static IEnumerable<TSource> DistinctBy<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector)
                {
                    HashSet<TKey> knownKeys = new HashSet<TKey>();
                    foreach (TSource element in source)
                    {
                        if (knownKeys.Add(keySelector(element)))
                        {
                            yield return element;
                        }
                    }
                }

                public static string GetItemURL(SPListItem item, string displayFormname)
                {
                    string itemURL = string.Empty;
                    try
                    {
                        itemURL = HelperUtils.CheckNullString(item["EncodedAbsUrl"]);

                        if (itemURL.Contains("/"))
                            itemURL = itemURL.Substring(0, itemURL.LastIndexOf("/"));

                        itemURL = itemURL + "/" + displayFormname + "?ID=" + item.ID.ToString();
                    }
                    catch (Exception ex)
                    {
                        ExceptionHelper.LogException("ERROR: COULD NOT RETRIEVE ITEM URL", ex);
                    }
                    return itemURL;
                }

               

                #region "BRAND Utility methods

                public static List<BranchBrandRelation> DeserializeBrands(this string value)
                {
                    List<BranchBrandRelation> retVal = new List<BranchBrandRelation>();
                    try
                    {
                        JavaScriptSerializer js = new JavaScriptSerializer();
                        retVal = js.Deserialize<List<BranchBrandRelation>>(value);
                    }
                    catch (Exception ex)
                    {
                        ExceptionHelper.LogException("ERROR: COULD NOT DESERIALIZE BRANDS FROM JSON STRING", ex);

                        //DPSGException dex = new DPSGException("ERROR: COULD NOT DESERIALIZE BRANDS FROM JSON STRING", ex);
                        //dex.ErrorCode = ErrorInfo.ErrorCodeGeneric;
                        //dex.ErrorMessage = ErrorInfo.ErrorMessageGeneric;
                        //throw dex;

                    }
                    return retVal;
                }

                public static string SerializeBrands(this List<BranchBrandRelation> value)
                {
                    StringBuilder sbBrands = new StringBuilder();

                    try
                    {
                        JavaScriptSerializer js = new JavaScriptSerializer();
                        sbBrands.Append(js.Serialize(value));
                    }
                    catch (Exception ex)
                    {
                        ExceptionHelper.LogException("ERROR: COULD NOT SERIALIZE BRANDS TO JSON STRING", ex);

                        //DPSGException dex = new DPSGException("ERROR: COULD NOT SERIALIZE BRANDS TO JSON STRING", ex);
                        //dex.ErrorCode = ErrorInfo.ErrorCodeGeneric;
                        //dex.ErrorMessage = ErrorInfo.ErrorMessageGeneric;
                        //throw dex;

                    }

                    return sbBrands.ToString();
                }


                public static List<MetadataField> DeserializeMetaDataFromString(this string value)
                {
                    List<MetadataField> retVal = new List<MetadataField>();

                    var arr = value.Split(';');
                    foreach (string item in arr)
                    {
                        retVal.Add(item.GetMetadata());
                    }
                    return retVal;
                }

                public static string SerializeMetaDataToString(this List<MetadataField> value)
                {
                    StringBuilder sbMetadata = new StringBuilder();

                    foreach (MetadataField brand in value)
                    {
                        sbMetadata.Append(brand.Label + ";");
                    }
                    if (sbMetadata.ToString().EndsWith(";"))
                        sbMetadata.Remove(sbMetadata.Length - 1, 1);

                    return sbMetadata.ToString();
                }

                public static MetadataField GetMetadata(this string value)
                {
                    MetadataField retVal = new MetadataField();
                    if (!string.IsNullOrEmpty(value))
                    {
                        var arr = value.Split('|');
                        retVal = new MetadataField { Label = arr[0], Guid = arr[1] };
                    }
                    return retVal;
                }

                #endregion

                #region Branch-KPI Utility methods added by Ajay

                public static List<BranchKpiRelation> DeserializeKPIs(this string value)
                {
                    List<BranchKpiRelation> retVal = new List<BranchKpiRelation>();
                    try
                    {
                        JavaScriptSerializer js = new JavaScriptSerializer();
                        retVal = js.Deserialize<List<BranchKpiRelation>>(value);
                    }
                    catch (Exception ex)
                    {
                        ExceptionHelper.LogException("ERROR: COULD NOT DESERIALIZE KPIS FROM JSON STRING", ex);
                    }
                    return retVal;
                }

                public static string SerializeKPIs(this List<BranchKpiRelation> value)
                {
                    StringBuilder sbKPIs = new StringBuilder();

                    try
                    {
                        JavaScriptSerializer js = new JavaScriptSerializer();
                        sbKPIs.Append(js.Serialize(value));
                    }
                    catch (Exception ex)
                    {
                        ExceptionHelper.LogException("ERROR: COULD NOT SERIALIZE KPIS TO JSON STRING", ex);
                    }

                    return sbKPIs.ToString();
                }

                #endregion

                #region KPI Utility Methods

                public static List<string> GetKPISortedListFromFieldItem(string kpis)
                {
                    List<string> kpiPrefs = new List<string>();
                    List<KPI> sortedKPIs = new List<KPI>();

                    if (!string.IsNullOrEmpty(kpis))
                    {
                        if (kpis.Contains(';'))
                        {
                            string[] tempKPIs = kpis.Split(';');
                            foreach (string tempStr in tempKPIs)
                            {
                                if (!string.IsNullOrEmpty(tempStr))
                                {
                                    sortedKPIs.Add(GetKPIfromString(tempStr));
                                }
                            }
                        }
                    }

                    if (sortedKPIs.Count > 1)
                    {
                        sortedKPIs = sortedKPIs.OrderBy(a => a.DispOrder).ToList();
                    }

                    foreach (KPI kpiItem in sortedKPIs)
                    {
                        kpiPrefs.Add(kpiItem.MetricName);
                    }

                    return kpiPrefs;
                }

                private static Types.KPI GetKPIfromString(string kpiString)
                {
                    Types.KPI kpiT = new KPI(string.Empty, 0);

                    var dispOrder = "0";
                    var KPI = string.Empty;
                    if (kpiString.Contains(","))
                    {
                        dispOrder = kpiString.Substring(kpiString.IndexOf(',') + 1);
                        KPI = kpiString.Substring(0, kpiString.IndexOf(','));
                    }
                    else
                    {
                        KPI = kpiString;
                    }

                    int iDispOrder = 0;
                    if (int.TryParse(dispOrder, out iDispOrder))
                        kpiT = new KPI(KPI, iDispOrder);
                    else
                        kpiT = new KPI(KPI, 0);

                    return kpiT;
                }

                #endregion


                /*
                public static string GetBUByDefaultBranch(string defaultBranch)
                {
                    string businessUnit = string.Empty;

                    try
                    {
                        var branch = BranchHelper.GetBranchList().Where(a => a.BranchName == defaultBranch).FirstOrDefault();
                        if (branch != null)
                        {
                            businessUnit = branch.BusinesUnit;
                        }
                    }
                    catch (Exception ex)
                    {
                        ExceptionHelper.LogException("ERROR: COULD NOT RETRIEVE BUSINESS UNIT FOR BRANCH \"" + defaultBranch + "\".", ex);

                        DPSGException dex = new DPSGException("ERROR: COULD NOT RETRIEVE BUSINESS UNIT FOR BRANCH \"" + defaultBranch + "\".", ex);
                        dex.ErrorCode = ErrorInfo.ErrorCodeDefaultBranchNotFound;
                        dex.ErrorMessage = ErrorInfo.ErrorMessageDefaultBranchNotFound;
                        dex.ErrorDescription = "COULD NOT RETRIEVE BUSINESS UNIT FOR BRANCH \"" + defaultBranch + "\".";

                        throw dex;
                    }

                    return businessUnit;
                }
                public static string GetRegionByDefaultBranch(string defaultBranch)
                {
                    string region = string.Empty;

                    try
                    {
                        var branch = BranchHelper.GetBranchList().Where(a => a.BranchName == defaultBranch).FirstOrDefault();
                        if (branch != null)
                        {
                            region = branch.Region;
                        }
                    }
                    catch (Exception ex)
                    {
                        ExceptionHelper.LogException("ERROR: COULD NOT RETRIEVE REGION FOR BRANCH \"" + defaultBranch + "\".", ex);

                        DPSGException dex = new DPSGException("ERROR: COULD NOT RETRIEVE REGION FOR BRANCH \"" + defaultBranch + "\".", ex);
                        dex.ErrorCode = ErrorInfo.ErrorCodeDefaultBranchNotFound;
                        dex.ErrorMessage = ErrorInfo.ErrorMessageDefaultBranchNotFound;
                        dex.ErrorDescription = "COULD NOT RETRIEVE REGION FOR BRANCH \"" + defaultBranch + "\".";

                        throw dex;
                    }

                    return region;
                }

                */

        /*
        public static bool FindMetadataTermByValue(string termSetName, string termValue)
        {
            bool isFound = false;

            TaxonomySession session = new TaxonomySession(SPContext.Current.Site);
            TermStore termStore = session.DefaultKeywordsTermStore;
            foreach (Microsoft.SharePoint.Taxonomy.Group group in termStore.Groups)
            {
                if (group.Name.Contains("DPSG"))
                {
                    TermSet termSet = group.TermSets[termSetName]; //Replace with term set name

                    TermCollection termCol = termSet.GetAllTerms();
                    Term term = termCol.Where(a => a.Name == termValue).FirstOrDefault();
                    if (term != null)
                        isFound = true;

                    break;
                }
            }
            return isFound;
        }

        /*
        public static bool IsBranchAvailable(string Branch)
        {
            bool isBranchAvailable = false;
            foreach (Branch branch in BranchHelper.GetBranchList())
            {
                if (branch.BranchName.Equals(Branch, StringComparison.InvariantCultureIgnoreCase))
                {
                    isBranchAvailable = true;
                    break;
                }
            }
            return isBranchAvailable;
        }

        
        public static bool IsBrandAvailable(string Brand)
        {
            bool isBrandAvailable = false;
            foreach (Brand brand in BrandHelper.GetBrandList())
            {
                if (brand.BrandName.Equals(Brand, StringComparison.InvariantCultureIgnoreCase))
                {
                    isBrandAvailable = true;
                    break;
                }
            }
            return isBrandAvailable;
        }

        */
        /*
        public static bool IsKPIAvailable(string Kpi)
        {
            bool isKpiAvailable = false;
            foreach (Types.KPI kpi in KPIHelper.GetAllKPIs())
            {
                if (kpi.MetricName.Equals(Kpi, StringComparison.InvariantCultureIgnoreCase))
                {
                    isKpiAvailable = true;
                    break;
                }
            }
            return isKpiAvailable;
        }
        */

        /*
        public static void DeleteUnavailableItemFromPreferences(string MetaDataType, string Value)
        {

            ListPreferenceManager prefMgr = new ListPreferenceManager();
            switch (MetaDataType.ToLower())
            {
                case "branch":
                    if (!IsBranchAvailable(Value))
                    {
                        //Update Branch and Brands Preferences for All Users
                        prefMgr.UpdateBranchPreferences(Value);
                    }
                    break;
                case "brand":
                    if (!IsBrandAvailable(Value))
                    {
                        //Update Brand Preferences for All Users
                        prefMgr.UpdateBrandPreferences(Value);
                    }
                    break;
                case "kpi":
                    if (!IsKPIAvailable(Value))
                    {
                        //Update KPI Preferences for All Users
                        prefMgr.UpdateKPIPreferences(Value);
                    }
                    break;
                default: break;
            }
        }
        */

    }
}
