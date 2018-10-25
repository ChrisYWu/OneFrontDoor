/// <summary>
/*  Module Name         : One Portal User Preference Manager
 *  Purpose             : Manage the User Preference 
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
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Portal.Framework.Types;
using System.Web;
using DPSG.Portal.Framework.CommonUtils;
using Microsoft.SharePoint;
using Microsoft.SharePoint.Administration;
using Microsoft.Office.Server.UserProfiles;
using Microsoft.Office.Server;
using DPSG.Portal.Framework.Types.Constants;
using System.Collections;

using System.DirectoryServices;
using System.Web.Hosting;
using DPSG.Portal.Framework.SDM;
using DPSG.Portal.SRE.DataContracts;

#endregion

namespace DPSG.Portal.Framework
{
    public static class UserInfoManager
    {
        const int NUM_OF_MY_LINKS = 10;


        public static void PopulateAllGeos(UserInfo UserPref)
        {
            try
            {
                UserPref.UserLocations = UserProfileRepository.GetAllGeos();
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: In PopulateAllGeos", ex);
            }
        }

        /// <summary>
        /// This Method will fetch User Preference from SharePoint User Profile
        /// </summary>
        /// <returns>User Preference</returns>
        public static UserInfo GetUserPreferences(int? PersonaID)
        {
            string currentUser = string.Empty;
            string GSN = string.Empty;

            UserInfo usrPref = null;

            //Handle Claim based User loginname string as User profile not working with claim based string
            //Split as Domain\UserName
            if (SPContext.Current.Web.CurrentUser.ID == SPContext.Current.Web.Site.SystemAccount.ID)
                currentUser = HttpContext.Current.User.Identity.Name;
            else
                currentUser = SPContext.Current.Web.CurrentUser.LoginName;
            if (currentUser.Trim().Contains("|"))
                currentUser = currentUser.Split('|')[1];

            try
            {
                //Popualting the Person, if its not there in global context
                
                //Load User Profile Properties
                usrPref = UserProfileRepository.GetSPUserProfileByGSN(PersonaID, UserProfileHelper.GetGSNFromUserName(currentUser));
                usrPref.LoginName = currentUser;
                //Read the User My Links from User Profile System
                UserProfileHelper.GetUserPrefFromUserProfile(usrPref, currentUser, NUM_OF_MY_LINKS);                
                //Get User Location from AD if preferences are not set in SharePoint user profile
                if (!usrPref.IsPreferenceSaved)
                {
                    //Load Location from AD
                    string usrCity = string.Empty;
                    int? zipCode = null;

                    if (GetUserLocationFromAD(usrPref.GSN, out usrCity, out zipCode))
                    {
                        usrPref.UserCity = usrCity;
                        usrPref.ZipCode = zipCode;
                    }
                }
                 


                //load Route Information
                try
                {
                    usrPref.Routes = JSONSerelization.Deserialize<List<Types.UserRoutes>>(UserProfileRepository.GetRouteInfo(usrPref.GSN, PersonaID));
                }
                catch { }

                try
                {
                    usrPref.GoalAccount = JSONSerelization.Deserialize<List<Types.UserGoalAccount>>(UserProfileRepository.GetGoalAccountInfo(usrPref.GSN,PersonaID));
                }
                catch { }

               

                try
                {
                    usrPref.UserLocations = UserProfileRepository.GetUserLocations(usrPref.GSN, usrPref.SPUserProfileID);
                }
                catch { }
                usrPref.BCRegion = UserProfileRepository.GetBCRegions(usrPref.GSN);

                //usrPref.LocalAccounts = UserProfileRepository.GetLocalAccounInfo(usrPref.GSN, PersonaID);

                //Set User Persona
                try
                {
                    usrPref.UserPersona = UserProfileRepository.GetUserPersona(usrPref.GSN);
                }
                catch { }

                // Get MyPlants
                try
                {
                    string[] strarry = UserProfileRepository.GetPlantInfo(usrPref.GSN, PersonaID);
                    usrPref.MyPlants = strarry[0] != null ? JSONSerelization.Deserialize<List<Types.Plants>>(strarry[0]) : new List<Plants>();
                    usrPref.DefaultManufacture = strarry[1] != null ? strarry[1] : "";
                }
                catch { }
                // Inventory
                try
                {
                    usrPref.UserProductLineItems = UserProfileRepository.GetUserProductLineItems(usrPref.GSN, usrPref.SPUserProfileID);
                }
                catch { }

                try
                {
                    usrPref.DefaultInventoryPerf = UserProfileRepository.GetDefaultInvetorySetting(usrPref.GSN, PersonaID);
                }
                catch { }

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETING USER PREFERENCE IN USERINFOMANAGER FOR USER " + currentUser, ex);
            }

            return usrPref;
        }

        /// <summary>
        /// This method will set User Preference in SharePoint User Profile Properties
        /// </summary>
        /// <param name="usrPref">User Preference</param>
        internal static void SetUserPreference(UserInfo usrPref)
        {
            string currentUser = SPContext.Current.Web.CurrentUser.LoginName;

            //Handle Claim based User loginname string as User profile not working with claim based string
            //Split as Domain\UserName
            if (currentUser.Trim().Contains("|"))
                currentUser = currentUser.Split('|')[1];
            try
            {
                UserProfileHelper.SetUserPrefToUserProfile(usrPref, currentUser);
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: SETING USER PREFERENCE IN USERINFOMANAGER FOR USER " + usrPref.LoginName, ex);
            }
        }


        /// <summary>
        /// This method will retrive user city and zipcode from AD
        /// </summary>
        /// <param name="GSN"> account name of the user</param>
        /// <param name="userCity">User City as defined in "l" attribute in AD</param>
        /// <param name="zipCode">Zip Code as defined in "postalcode" attribute in AD</param>
        /// <returns></returns>
        internal static bool GetUserLocationFromAD(string GSN, out string _userCity, out int? _zipCode)
        {
            DirectoryEntry objDirectoryEntry = new DirectoryEntry("LDAP://DPSG.net");

            bool result = false;

            _userCity = null;
            _zipCode = null;

            try
            {
                using (HostingEnvironment.Impersonate())
                {
                    DirectorySearcher dSearch = new DirectorySearcher(objDirectoryEntry);
                    dSearch.Filter = "(&(objectClass=user) (SAMAccountName=" + GSN + "))";
                    SearchResult sresult = dSearch.FindOne();
                    DirectoryEntry dsresult = sresult.GetDirectoryEntry();
                    if (dsresult.Properties["l"].Value != null && dsresult.Properties["postalcode"].Value != null)
                    {
                        _userCity = dsresult.Properties["l"].Value.ToString();
                        _zipCode = Convert.ToInt32(dsresult.Properties["postalcode"].Value);
                        result = true;
                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: IN GETTING USER CITY & ZIPCODE FROM AD FOR GSN::" + GSN, ex);
            }

            return result;
        }

        /// <summary>
        /// Get the Default GoalFunctionID for User
        /// </summary>
        /// <param name="objPortalBase"></param>
        /// <returns></returns>
        public static int GetDefaultGoalFunctionID(OnePortalBase objPortalBase)
        {
            List<DataScopeValue> dataScopeValue = objPortalBase.SreInstance.GetDataScopeValues("Goal Function");
            if (dataScopeValue != null && dataScopeValue.Count > 0)
            {
                string strValue = (from val in dataScopeValue where val.IsDefault == true select val.Value).FirstOrDefault();

                return Convert.ToInt32(strValue);
            }
            else
            {
                return 1;
            }         
        }
    }
}
