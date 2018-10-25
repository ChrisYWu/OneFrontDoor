/// <summary>
/*  Module Name         : One Portal User Profile Helper
 *  Purpose             : Provide the Helper Methods to Work with SharePoint User Profile Properties 
 *  Created Date        : 04-Feb-2013
 *  Created By          : Himanshu Panwar
 *  Last Modified Date  : 08-Apr-2013
 *  Last Modified By    : Himanshu Panwar
 *  Where to use        : In One Portal 
 *  Dependency          : 
*/
/// </summary>

#region using

using System;
using System.Linq;
using System.Text;
using System.Collections;
using Microsoft.SharePoint;
using System.Collections.Generic;
using DPSG.Portal.Framework.Types;
using DPSG.Portal.Framework.Types.Constants;
using Microsoft.Office.Server.UserProfiles;

#endregion


namespace DPSG.Portal.Framework.CommonUtils
{
    public static class UserProfileHelper
    {

        /// <summary>
        /// This method will retrive the user profile property for current user
        /// </summary>
        /// <param name="propertyName"></param>
        /// <returns>success:property value</returns>
        public static string GetUserProfileProperty(string propertyName, string userName)
        {
            string value = string.Empty;

            SPSecurity.RunWithElevatedPrivileges(delegate()
            {
                using (var site = new SPSite(SPContext.Current.Site.ID))
                {
                    try
                    {
                        SPServiceContext sc = SPServiceContext.GetContext(site);
                        UserProfileManager userProfileManager = new UserProfileManager(sc);
                        Microsoft.Office.Server.UserProfiles.UserProfile profile = userProfileManager.GetUserProfile(userName);

                        value = profile[propertyName].Value as string;
                    }
                    catch (Exception ex)
                    {
                        ExceptionHelper.LogException("ERROR: COULD NOT GET USER PROFILE PROPERTY NAME:" + propertyName + " FOR USER:" + userName, ex);
                    }
                }
            });
            return value;
        }


        /// <summary>
        /// This Method will fetch User Preference from User Profile Properties. Mainly the MyLinks.
        /// </summary>
        /// <param name="userName"></param>
        /// <returns></returns>
        public static void  GetUserPrefFromUserProfile(UserInfo usrPref, string userName,  int noOfQuickLinksToBeFetched)
        {
            #region TO BE DELETED
            //UserInfo usrPref = new UserInfo();
            //usrPref.LoginName = userName;
            //usrPref.GSN = GetGSNFromUserName(userName);
            //As part of SRE Integration we are reading the profiles from spuserprofile table rather than SharePoint user profile service. We will use the SharePoint user profile service only to read the My Links
            #endregion

            SPSecurity.RunWithElevatedPrivileges(delegate()
            {
                using (var site = new SPSite(SPContext.Current.Site.ID))
                {
                    try
                    {
                        SPServiceContext sc = SPServiceContext.GetContext(site);
                        UserProfileManager userProfileMangager = new UserProfileManager(sc);
                        Microsoft.Office.Server.UserProfiles.UserProfile profile = userProfileMangager.GetUserProfile(userName);

                        #region TO BE DELETED
                        //try
                        //{
                        //    if (profile[UserProfileProperties.PrimaryBranch].Value != null)
                        //        usrPref.PrimaryBranch = JSONSerelization.Deserialize<Types.BranchInfo>(Convert.ToString(profile[UserProfileProperties.PrimaryBranch].Value));
                        //}
                        //catch { }
                        ////try
                        ////{
                        ////    if (profile[UserProfileProperties.AdditionalBranches].Value != null)
                        ////    {
                        ////        // Get AdditionalBranches information from SPUserProfile Table in DB
                        ////        ///usrPref.AdditionalBranches = JSONSerelization.Deserialize<List<Types.Branch>>(Convert.ToString(profile[UserProfileProperties.AdditionalBranches].Value));
                        ////    }

                                
                        ////}
                        ////catch { }
                        //try
                        //{
                        //    if (profile[UserProfileProperties.BranchBrand].Value != null)
                        //        usrPref.TradeMarks = JSONSerelization.Deserialize<List<BranchTradeMarks>>(Convert.ToString(profile[UserProfileProperties.BranchBrand].Value));
                        //}
                        //catch { }
                        ////if (profile[UserProfileProperties.BranchKPI].Value != null)
                        ////    usrPref.BranchKPI = JSONSerelization.Deserialize<List<BranchKPI>>(Convert.ToString(profile[UserProfileProperties.BranchKPI].Value));
                        //// Branch CAN relation

                        //try
                        //{
                        //    if (profile[UserProfileProperties.BranchCAN].Value != null)
                        //        usrPref.BranchCAN = JSONSerelization.Deserialize<List<BranchCAN>>(Convert.ToString(profile[UserProfileProperties.BranchCAN].Value));
                        //    else
                        //        usrPref.BranchCAN = new List<BranchCAN>();
                        //}
                        //catch { }

                        //usrPref.Accounts = new UserAccounts();

                        //try
                        //{
                        //    if (profile[UserProfileProperties.NationalAccount].Value != null)
                        //        usrPref.Accounts.National = JSONSerelization.Deserialize<List<Account>>(Convert.ToString(profile[UserProfileProperties.NationalAccount].Value));
                        //    else
                        //        usrPref.Accounts.National = new List<Account>();
                        //}
                        //catch { }

                        //try
                        //{
                        //    if (profile[UserProfileProperties.RegionalAccount].Value != null)
                        //        usrPref.Accounts.Regional = JSONSerelization.Deserialize<List<Account>>(Convert.ToString(profile[UserProfileProperties.RegionalAccount].Value));
                        //    else
                        //        usrPref.Accounts.Regional = new List<Account>();
                        //}
                        //catch { }

                        //try
                        //{
                        //    if (profile[UserProfileProperties.LocalAccount].Value != null)
                        //        usrPref.Accounts.Local = JSONSerelization.Deserialize<List<Account>>(Convert.ToString(profile[UserProfileProperties.LocalAccount].Value));
                        //    else
                        //        usrPref.Accounts.Local = new List<Account>();
                        //}
                        //catch { }

                        //usrPref.Geo = new GeoRelevancy();

                        //try
                        //{
                        //    if (profile[UserProfileProperties.GeoBUs].Value != null)
                        //        usrPref.Geo.BU = JSONSerelization.Deserialize<List<BusinessUnit>>(Convert.ToString(profile[UserProfileProperties.GeoBUs].Value));
                        //    else
                        //        usrPref.Geo.BU = new List<BusinessUnit>();
                        //}
                        //catch { }

                        //try
                        //{
                        //    if (profile[UserProfileProperties.GeoRegions].Value != null)
                        //        usrPref.Geo.Region = JSONSerelization.Deserialize<List<Region>>(Convert.ToString(profile[UserProfileProperties.GeoRegions].Value));
                        //    else
                        //        usrPref.Geo.Region = new List<Region>();
                        //}
                        //catch (Exception ex){ }

                        ////get Area
                        //try
                        //{
                        //    if (profile[UserProfileProperties.GeoAreas].Value != null)
                        //        usrPref.Geo.Area = JSONSerelization.Deserialize<List<Area>>(Convert.ToString(profile[UserProfileProperties.GeoAreas].Value));
                        //    else
                        //        usrPref.Geo.Area = new List<Area>();
                        //}
                        //catch (Exception ex) { }
                        ////get super channels
                        //usrPref.Channels = new UserChannels();
                        //try
                        //{  
                        //    if (profile[UserProfileProperties.SuperChannel].Value != null)
                        //        usrPref.Channels.SuperChannel = JSONSerelization.Deserialize<List<ChannelJSON>>(Convert.ToString(profile[UserProfileProperties.SuperChannel].Value));
                        //    else
                        //        usrPref.Channels.SuperChannel = new List<ChannelJSON>();
                        //}
                        //catch (Exception ex) { }
                        ////get channels
                        //try
                        //{
                        //    if (profile[UserProfileProperties.Channel].Value != null)
                        //        usrPref.Channels.Channel = JSONSerelization.Deserialize<List<ChannelJSON>>(Convert.ToString(profile[UserProfileProperties.Channel].Value));
                        //    else
                        //        usrPref.Channels.Channel = new List<ChannelJSON>();
                        //}
                        //catch (Exception ex) { }

                        //try
                        //{
                        //    if (profile[UserProfileProperties.GeoBranches].Value != null)
                        //        usrPref.Geo.Branch = JSONSerelization.Deserialize<List<Branch>>(Convert.ToString(profile[UserProfileProperties.GeoBranches].Value));
                        //    else
                        //        usrPref.Geo.Branch = new List<Branch>();
                        //}
                        //catch { }

                        //try
                        //{
                        //    if (profile[UserProfileProperties.DefaultPromotion].Value != null)
                        //        usrPref.DefaultPromotion = Convert.ToString(profile[UserProfileProperties.DefaultPromotion].Value);
                        //}
                        //catch { }

                      
                        
                        //if (profile[UserProfileProperties.PrimaryRole].Value != null)
                        //    usrPref.PrimaryRole = GetUserRole(Convert.ToString(profile[UserProfileProperties.PrimaryRole].Value));
                        //else
                        //    usrPref.PrimaryRole = OnePortalRole.Others;

                        //if (profile[UserProfileProperties.IsPreferenceSaved].Value != null)
                        //    usrPref.IsPreferenceSaved = Convert.ToBoolean(profile[UserProfileProperties.IsPreferenceSaved].Value);    
                        #endregion

                        usrPref.MyLinks = GetMyLinks(profile.QuickLinks, noOfQuickLinksToBeFetched);
                    }
                    catch (Exception ex)
                    {
                        ExceptionHelper.LogException("ERROR: COULD NOT GET USER PREFERENCE PROFILE PROPERTY FOR USER:" + userName, ex);

                        DPSGOnePortalException dex = new DPSGOnePortalException("ERROR: COULD NOT GET USER PREFERENCE PROFILE PROPERTY", ex);
                        dex.ErrorCode = ErrorInfo.ErrorCodeUserProfileGetError;
                        dex.ErrorMessage = ErrorInfo.ErrorMessageUserProfileGetError;
                        //throw dex;
                    }
                }
            });
          
        }


        /// <summary>
        /// This method will get GSN from user name (domain\\username)
        /// </summary>
        /// <param name="userName"><User Name/param>
        /// <returns>user GSN</returns>
        public static string GetGSNFromUserName(string userName)
        {
            string GSN = string.Empty;

            if (userName.Trim().Contains("\\"))
                GSN = userName.Split('\\')[1];

            return GSN;
        }


        /// <summary>
        /// This  method will update the current user profile property
        /// </summary>
        /// <param name="propertyName"></param>
        /// <param name="value"></param>
        /// <returns>return the updated value</returns>
        public static string SetUserProfileProperty(string propertyName, string value, string userName)
        {
            SPSecurity.RunWithElevatedPrivileges(delegate()
            {
                using (var site = new SPSite(SPContext.Current.Site.ID))
                {
                    try
                    {
                        SPServiceContext sc = SPServiceContext.GetContext(site);
                        UserProfileManager userProfileMangager = new UserProfileManager(sc);
                        SPUser user = site.RootWeb.EnsureUser(userName);
                        Microsoft.Office.Server.UserProfiles.UserProfile profile = userProfileMangager.GetUserProfile(userName);

                        profile[propertyName].Value = value;
                        profile.Commit();
                    }
                    catch (Exception ex)
                    {
                        ExceptionHelper.LogException("ERROR: COULD NOT UPDATE USER PROFILE PROPERTY NAME:" + propertyName + " FOR USER:" + userName + " TO VALUE:" + value, ex);

                        DPSGOnePortalException dex = new DPSGOnePortalException("ERROR: COULD NOT UPDATE USER PROFILE PROPERTY", ex);
                        dex.ErrorCode = ErrorInfo.ErrorCodeUserProfileSetError;
                        dex.ErrorMessage = ErrorInfo.ErrorMessageUserProfileSetError;
                        throw dex;
                    }
                }
            });
            return value;
        }


        /// <summary>
        /// This Method will store User Preference to SharePoint User Profile Properties
        /// </summary>
        /// <param name="usrPref">User Preferences</param>
        public static void SetUserPrefToUserProfile(UserInfo usrPref, string userName)
        {
            SPSecurity.RunWithElevatedPrivileges(delegate()
            {
                using (var site = new SPSite(SPContext.Current.Site.ID))
                {
                    try
                    {
                        SPServiceContext sc = SPServiceContext.GetContext(site);
                        UserProfileManager userProfileMangager = new UserProfileManager(sc);
                        Microsoft.Office.Server.UserProfiles.UserProfile profile = userProfileMangager.GetUserProfile(userName);

                        //set user profile values from the user preferences object;
                        if (usrPref.PrimaryBranch != null)
                        {
                            profile[UserProfileProperties.PrimaryBranch].Value = JSONSerelization.Serialize(usrPref.PrimaryBranch);
                        }
                        // DO not need to save the additional branch in User Profile property
                        //if (usrPref.AdditionalBranches != null)
                        //{
                        //    profile[UserProfileProperties.AdditionalBranches].Value = JSONSerelization.Serialize(usrPref.AdditionalBranches);
                        //}
                        //profile[UserProfileProperties.BranchKPI].Value = JSONSerelization.Serialize(usrPref.BranchKPI);
                        if (usrPref.TradeMarks != null)
                        {
                            profile[UserProfileProperties.BranchBrand].Value = JSONSerelization.Serialize(usrPref.TradeMarks);
                        }
                        if (usrPref.BranchCAN != null)
                        {
                            profile[UserProfileProperties.BranchCAN].Value = JSONSerelization.Serialize(usrPref.BranchCAN);
                        }

                        profile[UserProfileProperties.IsPreferenceSaved].Value = Convert.ToBoolean(usrPref.IsPreferenceSaved);

                        if (usrPref.Accounts != null)
                        {
                            if (usrPref.Accounts.National != null)
                                profile[UserProfileProperties.NationalAccount].Value = JSONSerelization.Serialize(usrPref.Accounts.National);
                            if (usrPref.Accounts.Regional != null)
                                profile[UserProfileProperties.RegionalAccount].Value = JSONSerelization.Serialize(usrPref.Accounts.Regional);
                            if (usrPref.Accounts.Local != null)
                                profile[UserProfileProperties.LocalAccount].Value = JSONSerelization.Serialize(usrPref.Accounts.Local);
                        }

                        if (usrPref.Geo != null)
                        {
                            if (usrPref.Geo.BU != null)
                                profile[UserProfileProperties.GeoBUs].Value = JSONSerelization.Serialize(usrPref.Geo.BU);
                            if (usrPref.Geo.Region != null)
                                profile[UserProfileProperties.GeoRegions].Value = JSONSerelization.Serialize(usrPref.Geo.Region);
                            if (usrPref.Geo.Branch != null)
                                profile[UserProfileProperties.GeoBranches].Value = JSONSerelization.Serialize(usrPref.Geo.Branch);
                            if (usrPref.Geo.Area != null)
                                profile[UserProfileProperties.GeoAreas].Value = JSONSerelization.Serialize(usrPref.Geo.Area);
                        }
                        if (usrPref.Channels != null)
                        {
                            if (usrPref.Channels.SuperChannel != null)
                                profile[UserProfileProperties.SuperChannel].Value = JSONSerelization.Serialize(usrPref.Channels.SuperChannel);
                            if (usrPref.Channels.Channel != null)
                                profile[UserProfileProperties.Channel].Value = JSONSerelization.Serialize(usrPref.Channels.Channel);
                        }

                        if (usrPref.DefaultPromotion != null)
                        {
                            profile[UserProfileProperties.DefaultPromotion].Value = usrPref.DefaultPromotion;
                        }

                        profile.Commit();
                    }
                    catch (Exception ex)
                    {
                        ExceptionHelper.LogException("ERROR: COULD NOT UPDATE USER PREFERENCE PROFILE PROPERTY FOR USER:" + userName, ex);

                        DPSGOnePortalException dex = new DPSGOnePortalException("ERROR: COULD NOT UPDATE USER PREFERENCE PROFILE PROPERTY", ex);
                        dex.ErrorCode = ErrorInfo.ErrorCodeUserProfileSetError;
                        dex.ErrorMessage = ErrorInfo.ErrorMessageUserProfileSetError;
                        throw dex;
                    }
                }
            });
        }


        /// <summary>
        /// This Method will fetch quick links for current user
        /// </summary>
        /// <param name="quickLinks">User Profile Quick Links</param>
        /// <param name="limit">Number of Quick Links to be Fetched</param>
        /// <returns></returns>
        private static ArrayList GetMyLinks(QuickLinkManager quickLinks, int limit)
        {
            ArrayList links = new ArrayList();
            try
            {
                SPContext.Current.Web.AllowUnsafeUpdates = true;
                // variable to store data of default links from splashnet config list 
                string linksValue = Framework.CommonUtils.HelperUtils.GetConfigEntrybyKey(Config.linksDefault);
                string[] linkFeed = linksValue.Split('|');
                int checkCounter = 0;
                //check whether the values from list exixts for the current current user
                foreach (string linkFeedName in linkFeed)
                {
                    string[] linkName = linkFeedName.Split(',');
                    foreach (QuickLink quickLink in quickLinks.GetItems())
                    {
                        if (linkName[0] == quickLink.Title.ToString())
                        {
                            checkCounter = 1;
                            break;
                        }
                    }
                    if (checkCounter == 1)
                        break;
                }
                //if the dafault values are not present then create the values in quickLinks
                if (checkCounter == 0)
                {
                    foreach (string linkFeedName in linkFeed)
                    {
                        string[] linkName = linkFeedName.Split(',');
                        quickLinks.Create(linkName[0], linkName[1], QuickLinkGroupType.General, null, Privacy.Private);
                    }
                }


                SPContext.Current.Web.AllowUnsafeUpdates = false;
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: COULD NOT UPDATE DEFAULT QUICK LINKS", ex);
            }

            int counter = 0;
            string editMyLink = string.Empty;
            foreach (QuickLink quickLink in quickLinks.GetItems())
            {
                if (counter == limit)
                    break;

                if (quickLink.Title == "Edit My Links")
                {
                    editMyLink = quickLink.Url + ";" + quickLink.Title;
                }
                links.Add(quickLink.Url + ";" + quickLink.Title);
                counter++;
            }
            //insert Edit My Links on the top of the List
            if (links.Contains(editMyLink))
            {
                links.Remove(editMyLink);
                editMyLink = "/_layouts/DPSG.Portal.SplashNet/MyQuickLinks.aspx" + ";" + "Edit My Links";
                links.Insert(0, editMyLink);
            }

            return links;
        }
    }
}
