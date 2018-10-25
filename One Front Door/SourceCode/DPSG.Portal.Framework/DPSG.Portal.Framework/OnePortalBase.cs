/// <summary>
/*  Module Name         : One Portal Base
 *  Purpose             : Provide the Base Class to Access One Portal Initilization to run One Portal Components
 *  Created Date        : 04-Feb-2013
 *  Created By          : Himanshu Panwar
 *  Last Modified Date  : 04-Feb-2013
 *  Last Modified By    : 04-Feb-2013
 *  Where to use        : In All One Portal Components
 *  Dependency          : DPSG.Portal.Framework.Types; DPSG.Portal.Framework.Types.Constants; DPSG.Portal.Framework.CommonUtils
*/
/// </summary>

#region using

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.SharePoint;
using DPSG.Portal.Framework.Types;
using DPSG.Portal.Framework.Types.Constants;
using DPSG.Portal.Framework.CommonUtils;
using System.Web;
using System.Collections;
using Microsoft.SharePoint.Utilities;
using System.Runtime.Serialization;
#endregion

namespace DPSG.Portal.Framework
{
    public class OnePortalBase
    {
        private SPWeb buSiteWeb = null;


        Types.BranchInfo _currentBranch = null;
        public Types.BranchInfo CurrentBranch
        {
            get
            {
                try
                {
                    if (_currentBranch != null)
                        return _currentBranch;

                    //Current branch will only be applicable if user has DSD my location
                    if (!this.SreInstance.CheckUserBehaviorMember(Behavior.GLOBAL_CONTEXT, BehaviorMembers.DSD_MY_LOCATION))
                    {
                        _currentBranch = new Types.BranchInfo();
                        return _currentBranch;
                    }

                    string cacheKey = SPContext.Current.Web.CurrentUser.LoginName + "_" + CacheKeys.CurrentBranchCacheKey;
                    object value = CacheHelper.GetCacheValue(cacheKey);
                    if (value != null)
                    {
                        _currentBranch = (Types.BranchInfo)value;
                    }
                    else
                    {
                        _currentBranch = CurrentUser.PrimaryBranch;
                        CacheHelper.SetCacheValue(cacheKey, _currentBranch, 24);    
                    }
                    return _currentBranch;
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("ERROR: COULD NOT RETRIEVE CURRENT BRANCH FROM COOKIE", ex);

                    DPSGOnePortalException dex = new DPSGOnePortalException("ERROR: COULD NOT RETRIEVE CURRENT BRANCH FROM CACHE", ex);
                    dex.ErrorCode = ErrorInfo.ErrorCodeCacheAccessError;
                    dex.ErrorMessage = ErrorInfo.ErrorCodeCacheAccessError + "for retrieving " + CacheKeys.CurrentBranchCacheKey;
                    return new BranchInfo();
                    //throw dex;
                }
            }
            set
            {
                try
                {
                    string cacheKey = SPContext.Current.Web.CurrentUser.LoginName + "_" + CacheKeys.CurrentBranchCacheKey;
                    CacheHelper.SetCacheValue(cacheKey, value, 24);
                    _currentBranch = value;
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("ERROR: COULD NOT SET COOKIE FOR CURRENT BRANCH", ex);

                    DPSGOnePortalException dex = new DPSGOnePortalException("ERROR: COULD NOT SET COOKIE FOR CURRENT BRANCH", ex);
                    dex.ErrorCode = ErrorInfo.ErrorCodeCacheAccessError;
                    dex.ErrorMessage = ErrorInfo.ErrorCodeCacheAccessError + "for setting " + CacheKeys.CurrentBranchCacheKey;
                    throw dex;
                }
            }
        }

        Types.Persona _currentPersona = null;
        bool CurrentPersonaPopulated = false;
        public Types.Persona CurrentPersona
        {
            get
            {
                try
                {

                    if (CurrentPersonaPopulated)
                        return (_currentPersona);

                    if (_currentPersona != null)
                    {
                        if (_currentPersona.PersonaID != 0)
                        {
                            return _currentPersona;
                        }
                        else
                            return null;
                    }

                    

                    string cacheKey = SPContext.Current.Web.CurrentUser.LoginName + "_" + CacheKeys.CurrentPersonaCacheKey;
                    object value = CacheHelper.GetCacheValue(cacheKey);
                    if (value != null)
                    {
                        _currentPersona = (Types.Persona)value;

                        if (_currentPersona.PersonaID != 0)
                        {
                            return _currentPersona;
                        }
                        else
                            return null;
                    }
                    else
                    {


                        string currentUser = "";
                        if (SPContext.Current.Web.CurrentUser.ID == SPContext.Current.Web.Site.SystemAccount.ID)
                            currentUser = HttpContext.Current.User.Identity.Name;
                        else
                            currentUser = SPContext.Current.Web.CurrentUser.LoginName;
                        if (currentUser.Trim().Contains("|"))
                            currentUser = currentUser.Split('|')[1];

                        string gsn = DPSG.Portal.Framework.CommonUtils.UserProfileHelper.GetGSNFromUserName(currentUser);

                        _currentPersona = DPSG.Portal.Framework.SDM.UserProfileRepository.GetUserPersona(gsn).FirstOrDefault();
                        if (_currentPersona != null)
                            CacheHelper.SetCacheValue(cacheKey, _currentPersona);
                        else
                            CacheHelper.SetCacheValue(cacheKey, new Types.Persona());
                        CurrentPersonaPopulated = true;
                        return (_currentPersona);
                    }
                   
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("ERROR: COULD NOT RETRIEVE CURRENT Persona FROM Cache", ex);

                    DPSGOnePortalException dex = new DPSGOnePortalException("ERROR: COULD NOT RETRIEVE CURRENT BRANCH FROM CACHE", ex);
                    dex.ErrorCode = ErrorInfo.ErrorCodeCacheAccessError;
                    dex.ErrorMessage = ErrorInfo.ErrorCodeCacheAccessError + "for retrieving " + CacheKeys.CurrentPersonaCacheKey;
                    return (new Types.Persona());
                    //throw dex;
                }
            }
            set
            {
                try
                {
                    //Before Setting User Persona, we need to clear the SRE User Rules CACHE. SO that new rules will loaded to cache as related to 
                    string cacheKey = SPContext.Current.Web.CurrentUser.LoginName + "_" + CacheKeys.CurrentPersonaCacheKey;
                    CacheHelper.SetCacheValue(cacheKey, value, 24);
                    _currentPersona = value;

                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("ERROR: COULD NOT SET COOKIE FOR CURRENT BRANCH", ex);

                    DPSGOnePortalException dex = new DPSGOnePortalException("ERROR: COULD NOT SET COOKIE FOR CURRENT BRANCH", ex);
                    dex.ErrorCode = ErrorInfo.ErrorCodeCacheAccessError;
                    dex.ErrorMessage = ErrorInfo.ErrorCodeCacheAccessError + "for setting " + CacheKeys.CurrentPersonaCacheKey;
                    throw dex;
                }
            }
        }
        public Types.BCRegionInfo CurrentBCRegion
        {
            get
            {
                try
                {
                    //Current branch will only be applicable if user has DSD my location
                    if (!this.SreInstance.CheckUserBehaviorMember(Behavior.PREFERENCES, BehaviorMembers.BC_GEO))
                    {
                        return (new Types.BCRegionInfo());
                    }


                    string cacheKey = SPContext.Current.Web.CurrentUser.LoginName + "_" + CacheKeys.CurrentRegionCacheKey;
                    if (CacheHelper.GetCacheValue(cacheKey) != null)
                    {
                        return (Types.BCRegionInfo)CacheHelper.GetCacheValue(cacheKey);
                    }
                    else
                    {
                        Types.BCRegionInfo curRegion = CurrentUser.PrimaryBCRegion;

                        CacheHelper.SetCacheValue(cacheKey, curRegion, 24);     //Since every night there is app pool recycle so no need to create cache for more than 24 hrs

                        #region TO BE DELETED
                        //// Cache User Preferences for a long time, it may cause some inappropriate application behaviour pls chk
                        ////try to store in session 
                        //DateTime expirationTime = DateTime.Today.AddYears(1);
                        //HttpContext.Current.Cache.Remove(cacheKey);
                        //HttpContext.Current.Cache.Add(cacheKey, curRegion, null, expirationTime, System.Web.Caching.Cache.NoSlidingExpiration,
                        //    System.Web.Caching.CacheItemPriority.High, null);
                        #endregion

                        return curRegion;
                    }
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("ERROR: COULD NOT RETRIEVE CURRENT BC REGION FROM COOKIE", ex);

                    DPSGOnePortalException dex = new DPSGOnePortalException("ERROR: COULD NOT RETRIEVE CURRENT BRANCH FROM CACHE", ex);
                    dex.ErrorCode = ErrorInfo.ErrorCodeCacheAccessError;
                    dex.ErrorMessage = ErrorInfo.ErrorCodeCacheAccessError + "for retrieving " + CacheKeys.CurrentRegionCacheKey;
                    return new BCRegionInfo();
                    //throw dex;
                }
            }
            set
            {
                try
                {
                    string cacheKey = SPContext.Current.Web.CurrentUser.LoginName + "_" + CacheKeys.CurrentRegionCacheKey;
                    //Types.BCRegionInfo curRegion = (Types.BCRegionInfo)value;

                    CacheHelper.SetCacheValue(cacheKey, value, 24);

                    #region TO BE DELETED
                    //// Cache User Preferences for a long time, it may cause some inappropriate application behaviour pls chk
                    ////try to store in session 
                    //DateTime expirationTime = DateTime.Today.AddYears(1);
                    //HttpContext.Current.Cache.Remove(cacheKey);
                    //HttpContext.Current.Cache.Add(cacheKey, curRegion, null, expirationTime, System.Web.Caching.Cache.NoSlidingExpiration,
                    //    System.Web.Caching.CacheItemPriority.High, null);
                    #endregion
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("ERROR: COULD NOT SET COOKIE FOR CURRENT BC-REGION", ex);

                    DPSGOnePortalException dex = new DPSGOnePortalException("ERROR: COULD NOT SET COOKIE FOR CURRENT BC-REGION", ex);
                    dex.ErrorCode = ErrorInfo.ErrorCodeCacheAccessError;
                    dex.ErrorMessage = ErrorInfo.ErrorCodeCacheAccessError + "for setting " + CacheKeys.CurrentRegionCacheKey;
                    throw dex;
                }
            }
        }

        public static void UpdateCurrentUserCache()
        {
            try
            {
                string cacheKey = SPContext.Current.Web.CurrentUser.LoginName + "_UserPreference";
                string PersonaCacheKey = SPContext.Current.Web.CurrentUser.LoginName + "_" + CacheKeys.CurrentPersonaCacheKey;
                Types.Persona persona = null;
                if (CacheHelper.GetCacheValue(PersonaCacheKey) != null)
                {
                    persona=(Types.Persona)CacheHelper.GetCacheValue(cacheKey);
                }

                UserInfo UserPref = null;
                if (persona != null)
                    UserPref = UserInfoManager.GetUserPreferences(persona.PersonaID);
                else
                    UserPref = UserInfoManager.GetUserPreferences(null);

                DateTime ExpirationTime = DateTime.Today.AddYears(1); // Cache User Preferences for a long time
                HttpContext.Current.Cache.Remove(cacheKey);
                HttpContext.Current.Cache.Add(cacheKey, UserPref, null, ExpirationTime, System.Web.Caching.Cache.NoSlidingExpiration,
                    System.Web.Caching.CacheItemPriority.High, null);

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: COULD NOT RETRIEVE USER PREFERENCES", ex);

                DPSGOnePortalException dex = new DPSGOnePortalException("ERROR: COULD NOT RETRIEVE USER PREFERENCES", ex);
                dex.ErrorCode = ErrorInfo.ErrorCodeGeneric;
                dex.ErrorMessage = ErrorInfo.ErrorMessageGeneric;
                throw dex;
            }
        }

        private UserInfo _currentUser = null;
        public UserInfo CurrentUser
        {
            get
            {
                try
                {
                    if (_currentUser != null)
                        return _currentUser;

                    string cacheKey = SPContext.Current.Web.CurrentUser.LoginName + "_UserPreference";
                    object value = CacheHelper.GetCacheValue(cacheKey);
                    if (value != null)
                    {
                        _currentUser = (UserInfo)value;
                        return _currentUser;
                    }
                    else
                    {

                        if (CurrentPersona != null)
                            _currentUser = UserInfoManager.GetUserPreferences(CurrentPersona.PersonaID);
                        else
                            _currentUser = UserInfoManager.GetUserPreferences(null);

                        CacheHelper.SetCacheValue(cacheKey, _currentUser, 24);
                        if (_currentUser != null)
                        {
                            //Checking the user aligned to some hierarchy or not
                            if (!this.SreInstance.CheckUserBehavior(Types.Behavior.GLOBAL_CONTEXT)
                                && !this.SreInstance.CheckUserBehaviorMember(Behavior.PREFERENCES, BehaviorMembers.SC_PRODUCTLINE))
                            {
                                PopulateAllGeos(_currentUser);
                                CacheHelper.SetCacheValue(cacheKey, _currentUser, 24);
                            }


                            // Remove cache for GetUserPreferredAccounts
                            CacheHelper.SetCacheValue(_currentUser.GSN + "_PrefferredUserAccount", null);
                        }
                        return _currentUser;
                    }
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("ERROR: COULD NOT RETRIEVE USER PREFERENCES", ex);

                    DPSGOnePortalException dex = new DPSGOnePortalException("ERROR: COULD NOT RETRIEVE USER PREFERENCES", ex);
                    dex.ErrorCode = ErrorInfo.ErrorCodeGeneric;
                    dex.ErrorMessage = ErrorInfo.ErrorMessageGeneric;
                    throw dex;
                }
            }
        }

        public void PopulateAllGeos(UserInfo UserPref)
        {
            try
            {
                //Populating all BUs for this user
                UserInfoManager.PopulateAllGeos(UserPref);
                //Addding all Systems
                List<ProgramSystem> systems = this.SreInstance.GetCreateApplicableSystems();
                UserPref.Geo.Area.Clear();
                UserPref.Geo.Branch.Clear();
                UserPref.Geo.Region.Clear();
                UserPref.Geo.BU.Clear();
                UserPref.Geo.System.Clear();
                UserPref.Geo.Zone.Clear();
                UserPref.Geo.Division.Clear();
                UserPref.Geo.Region.Clear();

                UserPref.Geo.System.AddRange(systems.Where(i=>i.Name!=CommonConstants.SYSTEM_NAME_DSD && i.Name != CommonConstants.SYSTEM_NAME_WD).Select(i=>new Systems(){ SystemID=i.BCSystemID, SystemName=i.Name}));
                //add all BU for DSD system
                UserPref.Geo.BU = new DPSG.Portal.Framework.SDM.PlaybookRepository().GetLocationHier().DistinctBy(i=>i.BUID).Select(i => new BusinessUnit() { buId = i.BUID, buName = i.BUName, SAPBUId = i.SAPBUID }).ToList();
                   
               
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: PopulateAllGeos", ex);
            }
        }

        public SPWeb SplashNetWeb
        {
            get
            {
                return SPContext.Current.Site.RootWeb;
            }
        }

        public SPWeb MySplashNetWeb
        {
            get
            {
                SPWeb retVal = null;
                try
                {
                    string currentSiteUrl = SPContext.Current.Site.Url;

                    OnePortalContext current = HelperUtils.GetOnePortalContext(currentSiteUrl);
                    switch (current)
                    {
                        case OnePortalContext.MySplashNet:
                            retVal = SPContext.Current.Site.RootWeb;
                            break;
                        default:
                            {
                                try
                                {
                                    using (SPSite site = new SPSite(HelperUtils.GetMySplashNetSiteUrl()))
                                    {
                                        retVal = site.OpenWeb();
                                    }
                                }
                                catch { }
                            }
                            break;
                    }

                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("FATEL ERROR: COULD NOT INITIALIZE MYSPLASHNETWEB ONEPORTALBASE PROPERTY", ex);
                }
                return retVal;
            }
        }

        public SPWeb BUSiteWeb
        {
            get
            {
                if (buSiteWeb != null)
                {
                    return buSiteWeb;
                }
                using (SPSite MarketingWeb = new SPSite(DPSG.Portal.Framework.CommonUtils.HelperUtils.GetConfigEntrybyKey(DPSG.Portal.Framework.Types.Constants.Config.BUSiteURL)))
                {
                    if (buSiteWeb == null)
                        buSiteWeb = MarketingWeb.OpenWeb();
                }
                return buSiteWeb;
            }
        }

       

        public void Dispose()
        {
            try
            {
                if (this.MySplashNetWeb != null)
                    MySplashNetWeb.Dispose();
                if (buSiteWeb != null)
                    buSiteWeb.Dispose();
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("FATEL ERROR: COULD NOT DISPOSE ONEPORTALBASE PROPERTIES", ex);

                DPSGOnePortalException dex = new DPSGOnePortalException("FATEL ERROR: COULD NOT DISPOSE ONEPORTALBASE PROPERTIES", ex);
                dex.ErrorCode = ErrorInfo.ErrorCodeGeneric;
                dex.ErrorMessage = ErrorInfo.ErrorMessageGeneric;
                //throw dex;
            }
        }

        string _version = "";
        public string ScriptVersion
        {
            get
            {
                if (_version == "")
                {
                    object value = CacheHelper.GetCacheValue("SplashNetScriptVersion");
                    if (value == null)
                    {
                        _version = HelperUtils.GetConfigEntrybyKey(CommonConstants.CSS_VERSION).Trim();
                        CacheHelper.SetCacheValue("SplashNetScriptVersion", _version);
                    }
                    else
                    {
                        _version = (string)value;
                    }
                    _version = HelperUtils.GetConfigEntrybyKey(CommonConstants.CSS_VERSION).Trim();
                }
                return _version;
            }
        }

        #region Security Code

        //public bool CheckUserAccess(int EntityID, int PermissionType)
        //{
        //    return DPSG.Portal.Framework.Security.Utilities.CheckAccess(this.CurrentUser, EntityID, PermissionType);
        //}

        //public string GetRoleAttribute(string Key)
        //{
        //    return DPSG.Portal.Framework.Security.Utilities.GetRoleAttribute(this.CurrentUser.PrimaryRoleId,Key);
        //    //return "1";// DPSG.Portal.Framework.Security.Utilities.GetRoleAttribute(DPSG.Portal.Framework.Security.Utilities.GetRoleFromString(this.CurrentUser.PrimaryRole.ToString()), Key);
        //}

        //public IList<DPSG.Portal.Framework.Types.ProgramSystem> GetRoleSystem()
        //{
        //    //return DPSG.Portal.Framework.Security.Utilities.GetRoleSystem(CurrentUser.PrimaryRole.ToString());
        //    return new List<ProgramSystem>();
        //}

        public IList<Account> GetRoleAccount()
        {
            return null;// DPSG.Portal.Framework.Security.Utilities.GetRoleAccount(CurrentUser.GSN.ToString());

        }

        #endregion

        public SREBase SreInstance
        {
            get
            {

                SREBase.Instance.GSN = this.CurrentUser.GSN.ToUpper();
                string fileURL = string.Empty;
                //No need to handle the Null Reference Exception. As this code fails only if specific scenarios and we can not handle the is null with this. So we are using the try and finally
                try { fileURL = SPContext.Current.File.Url; }
                catch { }
                if (this.CurrentPersona != null)
                {
                    SREBase.Instance.CurrentUserPersona = this.CurrentPersona.PersonaID;
                }
                SREBase.Instance.RequestURL = SPUtility.ConcatUrls(SPContext.Current.Web.Url, fileURL);
                return SREBase.Instance;
            }
        }

        private bool? _isUserInRole = null;
        public bool IsUserInRole()
        {
            if (_isUserInRole == null)
            {
                string login = SPContext.Current.Web.CurrentUser.LoginName;
                object value = CacheHelper.GetCacheValue("SplashNetIsUserInRole_" + login);
                if (value == null)
                {
                    _isUserInRole = this.SreInstance.IsUserAssignedToRole();
                    CacheHelper.SetCacheValue("SplashNetIsUserInRole_" + login, _isUserInRole);
                }
                else
                {
                    _isUserInRole = (bool)value;
                }
            }
            return Convert.ToBoolean(_isUserInRole);
        }

        string _TopNavigationHeader = "-1";
        public string TopNavigationHeader()
        {
            if (_TopNavigationHeader == "-1")
            {
                string login = SPContext.Current.Web.CurrentUser.LoginName;

                object value = CacheHelper.GetCacheValue("SplashNetTopNavigationHeader_" + login);
                if (value == null)
                {
                    _TopNavigationHeader = string.Empty;
                    List<string> lstBehaviorMembers = this.SreInstance.GetUserBehaviorMember(Behavior.TOP_NAVIGATION_HEADER);
                    if (lstBehaviorMembers.Count > 0)
                        _TopNavigationHeader = lstBehaviorMembers.First();
                    CacheHelper.SetCacheValue("SplashNetTopNavigationHeader_" + login, _TopNavigationHeader);
                }
                else
                {
                    _TopNavigationHeader = (string)value;
                }
            }
            return _TopNavigationHeader;
        }

        bool? _TopHeaderNotifications = null;
        public bool TopHeaderNotifications()
        {
            if (_TopHeaderNotifications == null)
            {
                string login = SPContext.Current.Web.CurrentUser.LoginName;

                object value = CacheHelper.GetCacheValue("TopHeaderNotifications_" + login);
                if (value == null)
                {
                    _TopHeaderNotifications = this.SreInstance.CheckUserBehaviorMember(Behavior.TOP_HEADER_NOTIFICATIONS, BehaviorMembers.ALERTS);
                    CacheHelper.SetCacheValue("TopHeaderNotifications_" + login, _TopHeaderNotifications);
                }
                else
                {
                    _TopHeaderNotifications = (bool)value;
                }
            }
            return Convert.ToBoolean(_TopHeaderNotifications);
        }

        int _GetMSNNotification = -1;
        public int GetMSNNotification()
        {
            if (_GetMSNNotification == -1)
            {
                string login = SPContext.Current.Web.CurrentUser.LoginName;

                object value = CacheHelper.GetCacheValue("GetMSNNotification_" + login);
                if (value == null)
                {
                    _GetMSNNotification = 0;
                    if (this.CurrentUser.IsPreferenceSaved)
                    {
                        _GetMSNNotification = this.SreInstance.GetUserBehaviorMember(Behavior.TOP_HEADER_ALERTS).Count() > 0 ? 1 : 0;
                    }
                    CacheHelper.SetCacheValue("GetMSNNotification_" + login, _GetMSNNotification);
                }
                else
                {
                    _GetMSNNotification = (int)value;
                }
            }
            return _GetMSNNotification;
        }

        bool? _PRApproval=null;
        public bool PRApproval()
        {
            if (_PRApproval == null)
            {
                string login = SPContext.Current.Web.CurrentUser.LoginName;

                object value = CacheHelper.GetCacheValue("PRApproval_" + login);
                if (value == null)
                {
                    _PRApproval = false;
                    _PRApproval=(this.SreInstance.CheckUserBehaviorMember(Behavior.TOP_HEADER_NOTIFICATIONS, BehaviorMembers.Approvals)) && (this.SreInstance.CheckUserBehaviorMember(Behavior.TOP_HEADER_APPROVAL_CONTENT, BehaviorMembers.PR_APPROVALS));
                    CacheHelper.SetCacheValue("PRApproval_" + login, _PRApproval);
                }
                else
                {
                    _PRApproval = (bool)value;
                }
            }
            return (bool)_PRApproval;
        }

        string _GetUserSystems = null;
        public string GetUserSystems()
        {
            if (_GetUserSystems == null)
            {
                string login = SPContext.Current.Web.CurrentUser.LoginName;

                object value = CacheHelper.GetCacheValue("GetUserSystems_" + login);
                if (value == null)
                {
                    _GetUserSystems=string.Join(",", this.SreInstance.GetUserSystems().Select(i => i.Name).ToArray());
                    CacheHelper.SetCacheValue("GetUserSystems_" + login, _GetUserSystems);
                }
                else
                {
                    _GetUserSystems= (string)value;
                }
            }
            return _GetUserSystems;
        }

        bool? _DSDGeo = null;
        public bool DSDGeo()
        {
            if (_DSDGeo == null)
            {
                string login = SPContext.Current.Web.CurrentUser.LoginName;
                object value = CacheHelper.GetCacheValue("DSDGeo_" + login);
                if (value == null)
                {
                    _DSDGeo = false;
                    _DSDGeo = this.SreInstance.CheckUserBehaviorMember(Behavior.PREFERENCES, BehaviorMembers.DSD_GEOGRAPHY);
                    CacheHelper.SetCacheValue("DSDGeo_" + login, _DSDGeo);
                }
                else
                {
                    _DSDGeo = (bool)value;
                }
            }
            return (bool)_DSDGeo;
        }

        bool? _BCGeo = null;
        public bool BCGeo()
        {
            if (_BCGeo == null)
            {
                string login = SPContext.Current.Web.CurrentUser.LoginName;
                object value = CacheHelper.GetCacheValue("BCGeo_" + login);
                if (value == null)
                {
                    _BCGeo = false;
                    _BCGeo = this.SreInstance.CheckUserBehaviorMember(Behavior.PREFERENCES, BehaviorMembers.BC_GEO);
                    CacheHelper.SetCacheValue("BCGeo_" + login, _BCGeo);
                }
                else
                {
                    _BCGeo = (bool)value;
                }
            }
            return (bool)_BCGeo;
        }

        string _GlobalContextText = null;
        public string GlobalContextText()
        {
            if (_GlobalContextText == null)
            {
                string login = SPContext.Current.Web.CurrentUser.LoginName;
                object value = CacheHelper.GetCacheValue("GlobalContextText_" + login);
                if (value == null)
                {
                    _GlobalContextText = "";

                    List<string> _globalContextText = this.SreInstance.GetUserBehaviorMember(Behavior.GLOBAL_CONTEXT_TEXT);
                    if (_globalContextText != null && _globalContextText.Count > 0)
                    {
                        _GlobalContextText = _globalContextText.First();
                    }

                    CacheHelper.SetCacheValue("GlobalContextText_" + login, _GlobalContextText);
                }
                else
                {
                    _GlobalContextText = (string)value;
                }
            }
            return _GlobalContextText;
        }

        string _DefaultURL = null;
        public string DefaultURL()
        {
            if (_DefaultURL == null)
            {
                string login = SPContext.Current.Web.CurrentUser.LoginName;
                object value = CacheHelper.GetCacheValue("DefaultURL_" + login);
                if (value == null)
                {
                    _DefaultURL = "";
                    string keyValue = this.SreInstance.DefaultURL();
                    if (!string.IsNullOrEmpty(keyValue))
                    {
                        _DefaultURL = keyValue.ToLower();
                    }

                    CacheHelper.SetCacheValue("DefaultURL_" + login, _DefaultURL);
                }
                else
                {
                    _DefaultURL = (string)value;
                }
            }
            return _DefaultURL;
        }

        public List<BehaviorMemberList> GetMyScoresURLs()
        {
            return DPSG.Portal.Framework.SDM.UserProfileRepository.GetBehavoirMembers("My Scores URL");
        }

        public List<BehaviorMemberList> GetMyScoresCANLevel()
        {
            return DPSG.Portal.Framework.SDM.UserProfileRepository.GetBehavoirMembers("My Scores Can Level");
        }

        public List<BehaviorMemberList> GetMyPromoURLs()
        {
            return DPSG.Portal.Framework.SDM.UserProfileRepository.GetBehavoirMembers("My Promos URL");
        }
        public bool IsGlobalContextRequired()
        {
            string currentPageURL = HttpContext.Current.Request.Url.AbsolutePath.ToLower();
            return DPSG.Portal.Framework.SDM.UserProfileRepository.GetBehavoirMembers("ShowGlobalContext").Where(i=>i.BehaviorMemberValue.ToLower() == currentPageURL).Count()==0?false:true;
        }

        public string GetUserMyScoresURL()
        {
            if (CurrentUser.Geo.BU.Count == 3)
                return GetMyScoresURLs().Where(i => i.BehaviorMemberName == "President Level").FirstOrDefault().BehaviorMemberValue + "0";
            else if (CurrentUser.Geo.BU.Count > 0)
                return GetMyScoresURLs().Where(i => i.BehaviorMemberName == "BU Level").FirstOrDefault().BehaviorMemberValue + "0^0^0^" + CurrentBranch.BUName;
            else if (CurrentUser.Geo.Region.Count > 0)
                return GetMyScoresURLs().Where(i => i.BehaviorMemberName == "Region Level").FirstOrDefault().BehaviorMemberValue + "0^0^" + CurrentBranch.RegionName + "^0";
            else if (CurrentUser.Geo.Area.Count > 0)
                return GetMyScoresURLs().Where(i => i.BehaviorMemberName == "Area Level").FirstOrDefault().BehaviorMemberValue + "0^" + CurrentBranch.AreaName + "^0^0";
            else if (CurrentUser.Geo.Branch.Count > 0)
                return GetMyScoresURLs().Where(i => i.BehaviorMemberName == "Branch Level").FirstOrDefault().BehaviorMemberValue + CurrentBranch.BranchName + "^0^0^0";
            return "";
        }

        /// <summary>
        /// This method is used to give the User MyScore CAN level
        /// </summary>
        /// <returns></returns>
        public string GetUserMyScoreCANLevel()
        {
            if (CurrentUser.Geo.BU.Count == 3)
                return GetMyScoresCANLevel().Where(i => i.BehaviorMemberName == "PresidentLevel").FirstOrDefault().BehaviorMemberValue;
            else if (CurrentUser.Geo.BU.Count > 0)
                return GetMyScoresCANLevel().Where(i => i.BehaviorMemberName == "BULevel").FirstOrDefault().BehaviorMemberValue;
            else if (CurrentUser.Geo.Region.Count > 0)
                return GetMyScoresCANLevel().Where(i => i.BehaviorMemberName == "RegionLevel").FirstOrDefault().BehaviorMemberValue;
            else if (CurrentUser.Geo.Area.Count > 0)
                return GetMyScoresCANLevel().Where(i => i.BehaviorMemberName == "AreaLevel").FirstOrDefault().BehaviorMemberValue;
            else if (CurrentUser.Geo.Branch.Count > 0)
                return GetMyScoresCANLevel().Where(i => i.BehaviorMemberName == "BranchLevel").FirstOrDefault().BehaviorMemberValue;
            return "";
        }

        public string GetUserMyPromoURL()
        {
            if (CurrentUser.Geo.BU.Count == 3)
                return GetMyPromoURLs().Where(i => i.BehaviorMemberName == "President Level").FirstOrDefault().BehaviorMemberValue;
            else if (CurrentUser.Geo.BU.Count > 0)
                return GetMyPromoURLs().Where(i => i.BehaviorMemberName == "BU Level").FirstOrDefault().BehaviorMemberValue;
            else if (CurrentUser.Geo.Region.Count > 0)
                return GetMyPromoURLs().Where(i => i.BehaviorMemberName == "Region Level").FirstOrDefault().BehaviorMemberValue;
            else if (CurrentUser.Geo.Area.Count > 0)
                return GetMyPromoURLs().Where(i => i.BehaviorMemberName == "Area Level").FirstOrDefault().BehaviorMemberValue;
            else if (CurrentUser.Geo.Branch.Count > 0)
                return GetMyPromoURLs().Where(i => i.BehaviorMemberName == "Branch Level").FirstOrDefault().BehaviorMemberValue;
            return "";
        }
        public string GetAccountLevelMyPromo()
        {
            return GetMyPromoURLs().Where(i => i.BehaviorMemberName == "Account Level").FirstOrDefault().BehaviorMemberValue;
        }
    }






}

//namespace DPSG.Portal.Framework.Types
//{

//    public class Persona
//    {
//        public int PortalRoleID { get; set; }
//        public string PersonaName { get; set; }
//        public int? PersonaID { get; set; }
//        public string PortalRoleName { get; set; }
//        public int PortalRolePrecedence { get; set; }
//    }
//}
