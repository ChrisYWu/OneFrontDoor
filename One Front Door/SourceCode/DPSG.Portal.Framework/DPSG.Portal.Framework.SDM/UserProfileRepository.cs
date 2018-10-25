using System;
using System.Web;
using System.Linq;
using System.Configuration;
using System.Collections.Generic;
using DPSG.Portal.Framework.CommonUtils;
using DPSG.Portal.Framework.Types;
using System.Reflection;
using DPSG.Portal.Framework.Types.Constants;
using Telerik.OpenAccess.Data.Common;
using System.Data.Common;
using Microsoft.SharePoint;

namespace DPSG.Portal.Framework.SDM
{
    public static class UserProfileRepository
    {
        private static string GetConnectionString()
        {
            //string connectionString = ConfigurationManager.ConnectionStrings["SDMConnectionString"].ConnectionString;
            string connectionString = ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString;
            return connectionString + ";Application Name=19F4DE33-5DC8-4BEE-BE13-D8CBC15938DF";

        }

        public static void UpdateLastAccessDatetime(string gsn, string key, DateTime updatedDate)
        {

            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {

                    var lastAccessDates = from o in db.AlertNotificationLastAccessDatetimes
                                          where o.GSN == gsn && o.Key == key
                                          select o;

                    if (lastAccessDates.Count() > 0)
                    {
                        AlertNotificationLastAccessDatetime lastAccessDate = lastAccessDates.FirstOrDefault();
                        lastAccessDate.LastAccessDateTime = updatedDate;

                    }
                    else
                    {
                        AlertNotificationLastAccessDatetime lastAccessDate = new AlertNotificationLastAccessDatetime();
                        lastAccessDate.GSN = gsn;
                        lastAccessDate.Key = key;
                        lastAccessDate.LastAccessDateTime = updatedDate;
                        db.Add(lastAccessDate);

                    }
                    db.SaveChanges();
                    //if(allBranchs.Count>0)
                    //    return allBranchs[0].
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING GetLastAccessDatetime FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }
        }

        public static DateTime GetLastAccessDatetime(string gsn, string key)
        {

            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {

                    var lastAccessDate = from o in db.AlertNotificationLastAccessDatetimes
                                         where o.GSN == gsn && o.Key == key
                                         select o;

                    if (lastAccessDate.Count() > 0)
                        return (DateTime)lastAccessDate.FirstOrDefault().LastAccessDateTime;
                    else
                        return DateTime.Now;
                    //if(allBranchs.Count>0)
                    //    return allBranchs[0].
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING GetLastAccessDatetime FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }
            return DateTime.Now;
        }

        public static IEnumerable<Types.Branch> GetAllBranches()
        {
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {

                    var allBranchs = from o in db.Branches
                                     where o.SPBranchName != null
                                     select new DPSG.Portal.Framework.Types.Branch { branchName = o.SPBranchName, branchId = o.BranchID, SAPBranchId = o.SAPBranchID }
                                     ;
                    return allBranchs.ToList();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING BRANCHES FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }


        /// <summary>
        /// This method will fetch a branch inforamtion like BU Id, Name & Area Id, Name
        /// </summary>
        /// <param name="branchName">branchName</param>
        /// <returns></returns>
        //public static Types.BranchInfo GetBranchInfo(string branchName)
        //{
        //    try
        //    {
        //        if (!string.IsNullOrEmpty(branchName))
        //        {
        //            using (UserProfileModel objdb = new UserProfileModel(GetConnectionString()))
        //            {

        //                var branchInfo = from b in objdb.Branches
        //                                 join r in objdb.Regions on b.RegionID equals r.RegionID
        //                                 join bu in objdb.BusinessUnits on r.BUID equals bu.BUID
        //                                 where b.BranchName == branchName
        //                                 select new Types.BranchInfo { BranchName = b.BranchName, SAPBranchId = b.SAPBranchID , BranchId = b.BranchID, AreaId = r.RegionID, AreaName = r.RegionName, BUId = bu.BUID, BUName = bu.BUName };

        //                return branchInfo.ToList()[0];
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        ExceptionHelper.LogException("ERROR: GETTING BRANCH INFO FROM SDM IN USERPROFILEREPOSITORY CLASS FOR BRANCH:" + branchName, ex);
        //    }

        //    return null;
        //}

        public static Types.BranchInfo GetBranchInfo(int branchId)
        {
            try
            {
                //if (!string.IsNullOrEmpty(branchName))
                {
                    using (UserProfileModel objdb = new UserProfileModel(GetConnectionString()))
                    {

                        var branchInfo = from b in objdb.Branches
                                         join ar in objdb.Areas on b.AreaID equals ar.AreaID
                                         join r in objdb.Regions on ar.RegionID equals r.RegionID
                                         join bu in objdb.BusinessUnits on r.BUID equals bu.BUID
                                         where b.BranchID == branchId
                                         select new Types.BranchInfo { BranchName = b.BranchName, SAPBranchId = b.SAPBranchID, BranchId = b.BranchID, AreaId = ar.AreaID, AreaName = ar.AreaName, RegionId = r.RegionID, RegionName = r.RegionName, BUId = bu.BUID, BUName = bu.BUName };

                        return branchInfo.ToList()[0];
                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING BRANCH INFO FROM SDM IN USERPROFILEREPOSITORY CLASS FOR BRANCH:" + branchId, ex);
            }

            return new Types.BranchInfo();
        }




        /// <summary>
        /// This method is used to get the Goal Account information from DB
        /// </summary>
        /// <param name="GSN"></param>
        /// <returns></returns>
        public static string GetGoalAccountInfo(string GSN, int? PersonaID)
        {
            string strGoalAccount = string.Empty;
            try
            {
                using (UserProfileModel objdb = new UserProfileModel(GetConnectionString()))
                {
                    var goalAccount = (from usrprf in objdb.SPUserProfiles
                                       where usrprf.GSN == GSN && usrprf.PersonaID == PersonaID
                                       select usrprf).FirstOrDefault();

                    if (goalAccount != null)
                    {
                        strGoalAccount = goalAccount.GoalAccount;
                    }
                }

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING AdditionalBranch INFO FROM SDM IN USERPROFILEREPOSITORY CLASS FOR User:" + GSN, ex);
            }

            return strGoalAccount;

        }

        /// <summary>
        /// This method is used to get the Route information from DB
        /// </summary>
        /// <param name="GSN"></param>
        /// <returns></returns>
        public static string GetRouteInfo(string GSN, int? PersonaID)
        {

            string strroute = string.Empty;
            try
            {
                using (UserProfileModel objdb = new UserProfileModel(GetConnectionString()))
                {
                    var route = (from usrprf in objdb.SPUserProfiles
                                 where usrprf.GSN == GSN && usrprf.PersonaID == PersonaID
                                 select usrprf).FirstOrDefault();

                    if (route != null)
                    {
                        strroute = route.Route;
                    }
                }

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING AdditionalBranch INFO FROM SDM IN USERPROFILEREPOSITORY CLASS FOR User:" + GSN, ex);
            }

            return strroute;
        }


        /// <summary>
        /// This method is used to get the Plants information from DB
        /// </summary>
        /// <param name="GSN"></param>
        /// <returns></returns>
        public static string[] GetPlantInfo(string GSN, int? PersonaID)
        {

            //string[] strPlants = string.Empty;
            string[] strPlants = new string[2];
            try
            {
                using (UserProfileModel objdb = new UserProfileModel(GetConnectionString()))
                {
                    var plants = (from usrprf in objdb.SPUserProfiles
                                 where usrprf.GSN == GSN && usrprf.PersonaID == PersonaID
                                 select usrprf).FirstOrDefault();

                    if (plants != null)
                    {
                        strPlants[0] = plants.Plants;
                        strPlants[1] = plants.DefaultManufacture;
                        //strPlants[1] = null;
                    }
                }

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING Plants INFO FROM SDM IN USERPROFILEREPOSITORY CLASS FOR User:" + GSN, ex);
            }

            return strPlants;
        }

        public static List<DPSG.Portal.Framework.Types.Branch> GetUserBranches(UserProfileModel cntxt, string GSN)
        {
            try
            {
                DbParameter[] parm = { (new OAParameter { ParameterName = "@GSN", Value = GSN }) };
                return cntxt.ExecuteQuery<DPSG.Portal.Framework.Types.Branch>("person.pGerUserBranches", System.Data.CommandType.StoredProcedure, parm).ToList<DPSG.Portal.Framework.Types.Branch>();
            }
            catch { }
            return new List<DPSG.Portal.Framework.Types.Branch>();
        }

        public static List<BCRegion> GetUserBCRegions(UserProfileModel cntxt, string GSN)
        {
            try
            {
                DbParameter[] parm = { (new OAParameter { ParameterName = "@GSN", Value = GSN }) };
                return cntxt.ExecuteQuery<BCRegion>("[Person].[pGerUserBCRegions]", System.Data.CommandType.StoredProcedure, parm).ToList<BCRegion>();
            }
            catch { }
            return new List<BCRegion>();
        }

        /// <summary>
        /// This method is used to get the Additional branch information from DB
        /// </summary>
        /// <param name="GSN"></param>
        /// <returns></returns>
        public static string GetAdditionalBranchInfo(string GSN, int? PersonaID)
        {

            string addBranch = string.Empty;
            try
            {
                using (UserProfileModel objdb = new UserProfileModel(GetConnectionString()))
                {
                    var AdditionalBranch = (from usrprf in objdb.SPUserProfiles
                                            where usrprf.GSN == GSN && usrprf.PersonaID == PersonaID
                                            select usrprf).FirstOrDefault();

                    if (AdditionalBranch != null)
                    {
                        addBranch = AdditionalBranch.AdditionalBranch;
                    }
                }

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING AdditionalBranch INFO FROM SDM IN USERPROFILEREPOSITORY CLASS FOR User:" + GSN, ex);
            }

            return addBranch;
        }




        public static string GetLocalAccounInfo(string GSN, int? PersonaID)
        {
            string laccount = string.Empty;
            try
            {
                using (UserProfileModel objdb = new UserProfileModel(GetConnectionString()))
                {
                    var localaccount = (from usrprf in objdb.SPUserProfiles
                                        where usrprf.GSN == GSN && usrprf.PersonaID == PersonaID
                                        select usrprf).FirstOrDefault();

                    if (localaccount != null)
                    {
                        laccount = localaccount.LocalAccount;
                    }
                }

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING LOCAL ACCOUNT INFO FROM SDM IN USERPROFILEREPOSITORY CLASS FOR User:" + GSN, ex);
            }

            return laccount;
        }

        /// <summary>
        /// This Method will fetch Role scope of the User from SDM
        /// </summary>
        /// <param name="GSN">User GSN ID</param>
        /// <returns>RoleScope</returns>
        //public static OnePortalRoleScope GetUserRoleScope(string GSN)
        //{
        //    string rolescope = string.Empty;

        //    try
        //    {
        //        using (UserProfileModel objdb = new UserProfileModel(GetConnectionString()))
        //        {

        //            var branchInfo = from usrprf in objdb.SPUserProfiles
        //                             join r in objdb.Roles on usrprf.RoleID equals r.RoleID
        //                             where usrprf.GSN == GSN
        //                             select r.RoleScope;

        //            rolescope = Convert.ToString(branchInfo.ToList()[0]);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        ExceptionHelper.LogException("ERROR: GETTING ROLESCOPE INFO FROM SDM IN USERPROFILEREPOSITORY CLASS FOR USER:" + GSN, ex);
        //    }

        //    return GetRoleScopeFromString(rolescope);
        //}

        //public static int GetUserRoleID(string GSN)
        //{
        //    int iRoleID = 0;

        //    try
        //    {
        //        using (UserProfileModel objdb = new UserProfileModel(GetConnectionString()))
        //        {

        //            var roleID = from usrprf in objdb.SPUserProfiles
        //                             where usrprf.GSN == GSN
        //                             select usrprf.RoleID;

        //            iRoleID = Convert.ToInt32(roleID.ToList()[0]);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        ExceptionHelper.LogException("ERROR: GETTING ROLESCOPE INFO FROM SDM IN USERPROFILEREPOSITORY CLASS FOR USER:" + GSN, ex);
        //    }

        //    return iRoleID;
        //}

        ///// <summary>
        ///// This method will fetch Default systems of the user from SDM
        ///// </summary>
        ///// <param name="systemId"></param>
        ///// <returns>defaultSystem</returns>
        //public static string GetUserDefaultSystem(int roleId)
        //{
        //    string defaultSystem = string.Empty;

        //    try
        //    {
        //        using (UserProfileModel objdb = new UserProfileModel(GetConnectionString()))
        //        {
        //           string[] systemId = (from usrprf in objdb.RoleSystems
        //                                        where usrprf.RoleID == roleId && usrprf.DefaultValue==true
        //                                        select Convert.ToString(usrprf.SystemID)).ToArray();
        //           if (systemId != null && systemId.Length > 0)
        //           {
        //               defaultSystem = string.Join(",", systemId);
        //           }
        //        }

        //    }
        //    catch (Exception ex)
        //    {
        //        ExceptionHelper.LogException("ERROR: GETTING ROLESCOPE INFO FROM SDM IN USERPROFILEREPOSITORY CLASS FOR USER(Role ID):" + roleId, ex);
        //    }

        //    return defaultSystem;
        //}

        #region "Save TradeMark"

        public static bool ClearUserBranchTradeMark(int userInBranchId)
        {
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    List<UserBranchTradeMark> branchtrademarks = db.UserBranchTradeMarks.Where(i => i.UserInBranchID == userInBranchId).ToList();

                    foreach (UserBranchTradeMark branchtrademark in branchtrademarks)
                    {
                        db.Delete(branchtrademark);
                    }

                    db.SaveChanges();
                }

                return true;
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: CLEARING USER BRANCH TRADEMARKS IN SDM IN USERPROFILEREPOSITORY CLASS FOR USERBRANCHID:" + userInBranchId, ex);
            }

            return false;
        }

        public static bool AddUserBranchTradeMark(List<BranchTradeMarks> branchtrademarks, string GSN)
        {
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    foreach (BranchTradeMarks _branchtrademark in branchtrademarks)
                    {
                        int userInBranchId = db.UserInBranches.Where(i => i.BranchID == _branchtrademark.Branch.branchId && i.GSN == GSN).Select(i => i.UserInBranchID).ToList()[0];
                        //ClearUserBranchTradeMark(userInBranchId);
                        foreach (Types.TradeMark trademark in _branchtrademark.TradeMarks)
                        {
                            UserBranchTradeMark branchbrand = new UserBranchTradeMark();
                            branchbrand.TradeMarkID = trademark.tradeMarkId;
                            branchbrand.UserInBranchID = userInBranchId;

                            db.Add(branchbrand);
                        }
                    }
                    db.SaveChanges();
                }

                return true;
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: ADDING UPDATING USER BRANCH TRADEMARKS IN SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return false;
        }

        #endregion

        #region "Save User Branches"

        public static bool ClearUserInBranch(string GSN)
        {
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    List<UserInBranch> branches = db.UserInBranches.Where(i => i.GSN.ToUpper() == GSN.ToUpper()).ToList();

                    foreach (UserInBranch branch in branches)
                    {
                        ClearUserBranchTradeMark(branch.UserInBranchID);
                        db.Delete(branch);
                    }

                    db.SaveChanges();
                }

                return true;
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: CLEARING USER BRANCHES IN SDM IN USERPROFILEREPOSITORY CLASS FOR USER:" + GSN, ex);
            }

            return false;
        }

        public static bool AddUserInBranch(Types.BranchInfo primaryBranch, List<Types.Branch> branches, string GSN)
        {
            try
            {
                ClearUserInBranch(GSN);

                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    UserInBranch pribranch = new UserInBranch();
                    pribranch.GSN = GSN.ToUpper();
                    pribranch.BranchID = primaryBranch.BranchId;
                    pribranch.IsPrimary = true;

                    db.Add(pribranch);

                    foreach (Types.Branch _branch in branches)
                    {
                        UserInBranch branch = new UserInBranch();
                        branch.GSN = GSN.ToUpper();
                        branch.BranchID = _branch.branchId;
                        branch.IsPrimary = false;

                        db.Add(branch);
                    }
                    db.SaveChanges();
                }

                return true;
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: ADDING USER BRANCH BRANDS IN SDM IN USERPROFILEREPOSITORY CLASS FOR USER:" + GSN, ex);
            }

            return false;
        }

        #endregion

        #region "User Location"


        public static bool AddUserLocations(GeoRelevancy location, int spProfileID, UserProfileModel db, string _gsnID)
        {
            List<UserLocation> lstuserlocation = null;
            try
            {
                try
                {
                    //remove existing account detail of user
                    var itemsToDelete = db.UserLocations.Where(i => i.SPUserProfileID == spProfileID);
                    if (itemsToDelete != null)
                        db.Delete(itemsToDelete);
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("ERROR: DELETING USER LOCATION IN SDM IN USERPROFILEREPOSITORY CLASS FOR spProfileID:" + spProfileID, ex);
                }

                lstuserlocation = new List<UserLocation>();

                List<UserGeoLocations> lstLoactionReadonly = GetUserLocations(string.Empty, (int)spProfileID).Where(i => i.IsReadOnly == true).ToList();
                //For DSD Users
                if (location.BU != null)
                    lstuserlocation.AddRange(location.BU.Where(i => lstLoactionReadonly.Where(j => j.BUID == i.buId).Count() > 0 ? false : true).Select(i => new UserLocation() { SPUserProfileID = spProfileID, BUID = i.buId, GSN = _gsnID }).ToList());
                if (location.Region != null)
                    lstuserlocation.AddRange(location.Region.Where(i => lstLoactionReadonly.Where(j => j.RegionID == i.regionId).Count() > 0 ? false : true).Select(i => new UserLocation() { SPUserProfileID = spProfileID, RegionID = i.regionId, GSN = _gsnID }).ToList());
                if (location.Area != null)
                    lstuserlocation.AddRange(location.Area.Where(i => lstLoactionReadonly.Where(j => j.AreaID == i.AreaId).Count() > 0 ? false : true).Select(i => new UserLocation() { SPUserProfileID = spProfileID, AreaID = i.AreaId, GSN = _gsnID }).ToList());
                if (location.Branch != null)
                    lstuserlocation.AddRange(location.Branch.Where(i => lstLoactionReadonly.Where(j => j.BranchID == i.branchId).Count() > 0 ? false : true).Select(i => new UserLocation() { SPUserProfileID = spProfileID, BranchID = i.branchId, GSN = _gsnID }).ToList());

                //For BC Users
                if (location.System != null)
                    lstuserlocation.AddRange(location.System.Where(i => lstLoactionReadonly.Where(j => j.SystemID == i.SystemID).Count() > 0 ? false : true).Select(i => new UserLocation() { SPUserProfileID = spProfileID, SystemID = i.SystemID, GSN = _gsnID }).ToList());
                if (location.Zone != null)
                    lstuserlocation.AddRange(location.Zone.Where(i => lstLoactionReadonly.Where(j => j.ZoneID == i.ZoneID).Count() > 0 ? false : true).Select(i => new UserLocation() { SPUserProfileID = spProfileID, ZoneID = i.ZoneID, GSN = _gsnID }).ToList());
                if (location.Division != null)
                    lstuserlocation.AddRange(location.Division.Where(i => lstLoactionReadonly.Where(j => j.DivisionID == i.DivisionID).Count() > 0 ? false : true).Select(i => new UserLocation() { SPUserProfileID = spProfileID, DivisionID = i.DivisionID, GSN = _gsnID }).ToList());
                if (location.BCRegion != null)
                    lstuserlocation.AddRange(location.BCRegion.Where(i => lstLoactionReadonly.Where(j => j.BCRegionID == i.RegionID).Count() > 0 ? false : true).Select(i => new UserLocation() { SPUserProfileID = spProfileID, BCRegionID = i.RegionID, GSN = _gsnID }).ToList());


                db.Add(lstuserlocation);
                db.SaveChanges();



            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: ADDING USER Locations IN SDM IN USERPROFILEREPOSITORY CLASS FOR SPProfileID:" + spProfileID, ex);
            }
            return true;
        }
        #endregion
        #region User Channel


        public static bool AddUserChannels(UserChannels channels, int spProfileID, UserProfileModel db, string _gsnId)
        {
            try
            {
                List<UserChannel> lstuserChannels = null;
                try
                {
                    //remove existing account detail of user
                    var itemsToDelete = db.UserChannels.Where(i => i.SPUserProfileID == spProfileID);
                    if (itemsToDelete != null)
                        db.Delete(itemsToDelete);
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("ERROR: DELETING USER CHANNEL IN SDM IN USERPROFILEREPOSITORY CLASS FOR SPProfileID:" + spProfileID, ex);
                }

                lstuserChannels = new List<UserChannel>();
                if (channels.SuperChannel != null)
                    lstuserChannels.AddRange(channels.SuperChannel.Select(i => new UserChannel() { SPUserProfileID = spProfileID, SuperChannelID = i.ChannelId,GSN = _gsnId }).ToList());
                if (channels.Channel != null)
                    lstuserChannels.AddRange(channels.Channel.Select(i => new UserChannel() { SPUserProfileID = spProfileID, ChannelID = i.ChannelId, GSN = _gsnId }).ToList());
                db.Add(lstuserChannels);
                db.SaveChanges();

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: ADDING USER CHANNELS IN SDM IN USERPROFILEREPOSITORY CLASS FOR SPProfileID:" + spProfileID, ex);
            }
            return true;
        }
        #endregion

        #region User Goal Account

        public static bool AddUserGoalAccount(List<UserGoalAccount> goalAccount, string GSN, int spProfileID, UserProfileModel db, int DefaultGoalFunctionID)
        {
            try
            {
                List<UserAccountMapping> lstusrGoalAccount = null;
                try
                {
                    var itemsToDelete = db.UserAccountMappings.Where(i => i.SPUserProfileID == spProfileID);
                    if (itemsToDelete != null)
                        db.Delete(itemsToDelete);
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("ERROR: DELETING USER Goal Account IN SDM IN USERPROFILEREPOSITORY CLASS FOR USER:" + GSN, ex);
                }

                lstusrGoalAccount = new List<UserAccountMapping>();
                int AccountID = 0;
                if (goalAccount != null)
                {
                    foreach (UserGoalAccount GA in goalAccount)
                    {
                        if (GA.AccountID.EndsWith("M"))
                        {
                            AccountID = Convert.ToInt32(GA.AccountID.TrimEnd('M'));
                            lstusrGoalAccount.Add(new UserAccountMapping { GSN = GSN, SPUserProfileID = spProfileID, MarketID = AccountID, GoalFunctionID = DefaultGoalFunctionID, IsActive = true, CreatedBy = GSN, CreatedDate = DateTime.Now, ModifiedBy = GSN, ModifiedDate = DateTime.Now });
                        }
                        else if (GA.AccountID.EndsWith("G"))
                        {
                            AccountID = Convert.ToInt32(GA.AccountID.TrimEnd('G'));
                            lstusrGoalAccount.Add(new UserAccountMapping { GSN = GSN, SPUserProfileID = spProfileID, AccountGroupMasterID = AccountID, GoalFunctionID = DefaultGoalFunctionID, IsActive = true, CreatedBy = GSN, CreatedDate = DateTime.Now, ModifiedBy = GSN, ModifiedDate = DateTime.Now });
                        }

                    }
                }
                db.Add(lstusrGoalAccount);
                db.SaveChanges();
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: ADDING USER Goal Account IN SDM IN USERPROFILEREPOSITORY CLASS FOR USER:" + GSN, ex);
            }
            return true;
        }

        #endregion

        #region User Routes
        public static bool AddUserRoutes(List<UserRoutes> routes, int spProfileID, UserProfileModel db, string _gsnId)
        {
            try
            {
                List<UserRoute> lstuserRoutes = null;
                try
                {
                    //remove existing route detail of user
                    var itemsToDelete = db.UserRoutes.Where(i => i.SPUserProfileID == spProfileID);
                    if (itemsToDelete != null)
                        db.Delete(itemsToDelete);
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("ERROR: DELETING USER ROUTES IN SDM IN USERPROFILEREPOSITORY CLASS FOR spProfileID:" + spProfileID, ex);
                }

                lstuserRoutes = new List<UserRoute>();
                if (routes != null)
                    lstuserRoutes.AddRange(routes.Select(i => new UserRoute() { SPUserProfileID = spProfileID, RouteID = i.RouteId, GSN = _gsnId }).ToList());
                db.Add(lstuserRoutes);
                db.SaveChanges();

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: ADDING USER CHANNELS IN SDM IN USERPROFILEREPOSITORY CLASS FOR SPProfileID:" + spProfileID, ex);
            }
            return true;
        }
        #endregion

        #region "Save Accounts"

        public static bool ClearUserAccounts(string GSN)
        {
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    List<UserAccount> branches = db.UserAccounts.Where(i => i.GSN.ToUpper() == GSN.ToUpper()).ToList();

                    foreach (UserAccount branch in branches)
                    {
                        db.Delete(branch);
                    }

                    db.SaveChanges();
                }

                return true;
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: CLEARING USER ACCOUNTS IN SDM IN USERPROFILEREPOSITORY CLASS FOR USER:" + GSN, ex);
            }

            return false;
        }

        public static bool AddUserAccounts(Types.UserAccounts accounts, int spProfileID, UserProfileModel db, string _gsnId)
        {
            try
            {

                List<UserAccount> lstuserAccount = null;
                try
                {
                    //remove existing account detail of user
                    var itemsToDelete = db.UserAccounts.Where(i => i.SPUserProfileID == spProfileID);
                    if (itemsToDelete != null)
                        db.Delete(itemsToDelete);
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("ERROR: DELETING USER ACCOUNTS IN SDM IN USERPROFILEREPOSITORY CLASS FOR SPProfileID:" + spProfileID, ex);
                }

                lstuserAccount = new List<UserAccount>();
                if (accounts.National != null)
                    lstuserAccount.AddRange(accounts.National.Select(i => new UserAccount() { SPUserProfileID = spProfileID, NationalChainID = i.ChainId, GSN = _gsnId }).ToList());
                if (accounts.Regional != null)
                    lstuserAccount.AddRange(accounts.Regional.Select(i => new UserAccount() { SPUserProfileID = spProfileID, RegionalChainID = i.ChainId, GSN = _gsnId }).ToList());
                if (accounts.Local != null)
                    lstuserAccount.AddRange(accounts.Local.Select(i => new UserAccount() { SPUserProfileID = spProfileID, LocalChainID = i.ChainId, GSN = _gsnId }).ToList());
                db.Add(lstuserAccount);
                db.SaveChanges();


                return true;
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: ADDING USER ACCOUNTS IN SDM IN USERPROFILEREPOSITORY CLASS FOR SPProfileID:" + spProfileID, ex);
            }

            return false;
        }

        #endregion

        #region Save Plant IDs into MyPlants Table
        public static bool AddUserPlants(List<Plants> plants, int spProfileID, UserProfileModel db, string _gsnId)
        {
            try
            {
                List<MyPlant> lstuserPlant = null;
                try
                {
                    //remove existing route detail of user
                    var itemsToDelete = db.MyPlants.Where(i => i.SPUserProfileID == spProfileID);
                    if (itemsToDelete != null)
                        db.Delete(itemsToDelete);
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("ERROR: DELETING USER ROUTES IN SDM IN USERPROFILEREPOSITORY CLASS FOR spProfileID:" + spProfileID, ex);
                }

                lstuserPlant = new List<MyPlant>();
                if (plants != null)
                    lstuserPlant.AddRange(plants.Select(i => new MyPlant() { SPUserProfileID = spProfileID, PlantID = i.PlantID }).ToList());
                db.Add(lstuserPlant);
                db.SaveChanges();

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: ADDING USER CHANNELS IN SDM IN USERPROFILEREPOSITORY CLASS FOR SPProfileID:" + spProfileID, ex);
            }
            return true;
        }
        #endregion

        #region Save User Product Line and Trademark into UserProductLine table
        public static bool AddUserProductLine(ProductLine productLineItem, int spProfileID, UserProfileModel db, string _gsnID)
        {
            List<UserProductLine> lstuserProductLine = null;
            try
            {
                try
                {
                    //remove existing account detail of user
                    var itemsToDelete = db.UserProductLines.Where(i => i.SPUserProfileID == spProfileID);
                    if (itemsToDelete != null)
                        db.Delete(itemsToDelete);
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException("ERROR: DELETING USER Product Line IN SDM IN USERPROFILEREPOSITORY CLASS FOR spProfileID:" + spProfileID, ex);
                }

                lstuserProductLine = new List<UserProductLine>();

                List<UserProductLinesItem> lstLoactionReadonly = GetUserProductLineItems(string.Empty, (int)spProfileID).ToList();
                //For DSD Users
                if (productLineItem.Products != null)
                    lstuserProductLine.AddRange(productLineItem.Products.Select(i => new UserProductLine() { SPUserProfileID = spProfileID, ProductLineID = i.ProductLineID, GSN = _gsnID }).ToList());
                if (productLineItem.Trademarks != null)
                    lstuserProductLine.AddRange(productLineItem.Trademarks.Select(i => new UserProductLine() { SPUserProfileID = spProfileID, TradeMarkID = i.TradeMarkID, GSN = _gsnID }).ToList());

                db.Add(lstuserProductLine);
                db.SaveChanges();
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: ADDING USER Locations IN SDM IN USERPROFILEREPOSITORY CLASS FOR SPProfileID:" + spProfileID, ex);
            }
            return true;
        }
        #endregion
        public static IEnumerable<Types.TradeMark> GetAllBrands()
        {
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    var allBrands = from t in db.Brands
                                    select new Types.TradeMark { tradeMarkName = t.BrandName, tradeMarkId = t.BrandID }
                                    ;
                    return allBrands.ToList();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING BRANDS FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }

        public static IEnumerable<Types.TradeMark> GetAllTradeMarks()
        {
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    var allTradeMarks = from t in db.TradeMarks
                                        select new Types.TradeMark { tradeMarkName = t.TradeMarkName, tradeMarkId = t.TradeMarkID };
                    return allTradeMarks.ToList();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING BRANDS FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }

        /// <summary>
        /// This method will update the user preferences in SPUserProfile table. Also If user not exists it will Insert the user.
        /// </summary>
        /// <param name="profileInfo"></param>
        /// <returns></returns>
        public static bool UpdateUserProfile(Types.UserInfo profileInfo, int? PersonaID, Dictionary<string, bool> DictPermissions)
        {
            bool _updateSuccess = false;
            try
            {
                bool isAddUser = false;
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    SPUserProfile spUser = db.SPUserProfiles.FirstOrDefault(i => i.GSN == profileInfo.GSN && i.PersonaID == PersonaID);
                    if (spUser == null)
                    {
                        spUser = new SPUserProfile();
                        spUser.GSN = profileInfo.GSN;
                        spUser.PersonaID = PersonaID;
                        isAddUser = true;
                    }
                    //Add all the properties that needs to be updated.

                    #region Updating Primary Branch
                    if (profileInfo.PrimaryBranch != null)
                    {
                        // Set the valus if the user has the permission to view the geography tab else set the value as empty
                        if (DictPermissions != null && DictPermissions["Geography"])
                        {
                            spUser.PrimaryBranch = JSONSerelization.Serialize(profileInfo.PrimaryBranch);
                            spUser.PrimaryBranchId = profileInfo.PrimaryBranch.BranchId;
                        }
                        else
                        {
                            spUser.PrimaryBranch = "[]";
                            spUser.PrimaryBranchId = 0;
                        }
                    }
                    #endregion

                    #region Updating Primary BC Region
                    if (profileInfo.PrimaryBCRegion != null)
                    {
                        if (DictPermissions != null && DictPermissions["BCGeography"])
                        {
                            spUser.PrimaryBCRegion = JSONSerelization.Serialize(profileInfo.PrimaryBCRegion);
                            spUser.PrimaryBCRegionID = profileInfo.PrimaryBCRegion.RegionID;
                        }
                        else
                        {
                            spUser.PrimaryBCRegion = "[]";
                            spUser.PrimaryBCRegionID = 0;
                        }
                    }
                    #endregion

                    #region Updating Additional Branch
                    if (profileInfo.AdditionalBranches != null)
                        spUser.AdditionalBranch = (DictPermissions != null && DictPermissions["Geography"]) ? JSONSerelization.Serialize(profileInfo.AdditionalBranches) : "[]";
                    #endregion

                    #region Updating addtional BC region
                    if (profileInfo.AdditionalBCRegion != null)
                    {
                        spUser.AdditionalBCRegion = (DictPermissions != null && DictPermissions["BCGeography"]) ? JSONSerelization.Serialize(profileInfo.AdditionalBCRegion) : "[]";
                    }
                    #endregion

                    //spUser.KPI = JSONSerelization.Serialize(profileInfo.BranchKPI);
                    if (profileInfo.TradeMarks != null)
                        spUser.BranchTradeMark = JSONSerelization.Serialize(profileInfo.TradeMarks);

                    if (profileInfo.BranchCAN != null)
                        spUser.BranchCAN = JSONSerelization.Serialize(profileInfo.BranchCAN);

                    #region Updating Account Information
                    if (profileInfo.Accounts != null)
                    {
                        if (DictPermissions != null && DictPermissions["Account"])
                        {
                            if (profileInfo.Accounts.National != null)
                                spUser.NationalAccount = JSONSerelization.Serialize(profileInfo.Accounts.National);
                            if (profileInfo.Accounts.Regional != null)
                                spUser.RegionalAccount = JSONSerelization.Serialize(profileInfo.Accounts.Regional);
                            if (profileInfo.Accounts.Local != null)
                                spUser.LocalAccount = JSONSerelization.Serialize(profileInfo.Accounts.Local);


                        }
                        else
                        {
                            spUser.NationalAccount = "[]";
                            spUser.RegionalAccount = "[]";
                            spUser.LocalAccount = "[]";
                        }
                    }
                    #endregion

                    #region Updating Geography Information
                    if (profileInfo.Geo != null)
                    {
                        if (DictPermissions != null && DictPermissions["Geography"])
                        {
                            if (profileInfo.Geo.BU != null)
                                spUser.BU = JSONSerelization.Serialize(profileInfo.Geo.BU);
                            if (profileInfo.Geo.Region != null)
                                spUser.Region = JSONSerelization.Serialize(profileInfo.Geo.Region);
                            if (profileInfo.Geo.Branch != null)
                                spUser.Branch = JSONSerelization.Serialize(profileInfo.Geo.Branch);
                            if (profileInfo.Geo.Area != null)
                                spUser.Area = JSONSerelization.Serialize(profileInfo.Geo.Area);
                        }
                        else
                        {
                            spUser.BU = "[]";
                            spUser.Region = "[]";
                            spUser.Branch = "[]";
                            spUser.Area = "[]";
                        }

                        //For BC Users
                        if (DictPermissions != null && DictPermissions["BCGeography"])
                        {
                            if (profileInfo.Geo.System != null)
                                spUser.System = JSONSerelization.Serialize(profileInfo.Geo.System);
                            if (profileInfo.Geo.Zone != null)
                                spUser.Zone = JSONSerelization.Serialize(profileInfo.Geo.Zone);
                            if (profileInfo.Geo.Division != null)
                                spUser.Division = JSONSerelization.Serialize(profileInfo.Geo.Division);
                            if (profileInfo.Geo.BCRegion != null)
                                spUser.BCRegion = JSONSerelization.Serialize(profileInfo.Geo.BCRegion);
                        }
                        else
                        {
                            spUser.System = "[]";
                            spUser.Zone = "[]";
                            spUser.Division = "[]";
                            spUser.BCRegion = "[]";
                        }

                    }
                    #endregion

                    #region Updating Channel Information
                    if (profileInfo.Channels != null)
                    {
                        if (DictPermissions != null && DictPermissions["Channel"])
                        {
                            if (profileInfo.Channels.SuperChannel != null)
                                spUser.SuperChannel = JSONSerelization.Serialize(profileInfo.Channels.SuperChannel);
                            if (profileInfo.Channels.Channel != null)
                                spUser.Channel = JSONSerelization.Serialize(profileInfo.Channels.Channel);
                        }
                        else
                        {
                            spUser.SuperChannel = "[]";
                            spUser.Channel = "[]";
                        }

                    }
                    #endregion

                    #region Updating Goal Account Information

                    if (profileInfo.GoalAccount != null)
                        spUser.GoalAccount = (DictPermissions != null && DictPermissions["GOALAccount"]) ? JSONSerelization.Serialize(profileInfo.GoalAccount) : "[]";

                    #endregion

                    #region Updating route information
                    if (profileInfo.Routes != null)
                        spUser.Route = (DictPermissions != null && DictPermissions["Route"]) ? JSONSerelization.Serialize(profileInfo.Routes) : "[]";
                    #endregion

                    ////Save local account in JSON Format
                    //if (profileInfo.LocalAccounts != null)
                    //    spUser.LocalAccount = profileInfo.LocalAccounts;

                    #region Updating Plants information
                    if (profileInfo.MyPlants != null)
                    {
                        spUser.Plants = JSONSerelization.Serialize(profileInfo.MyPlants);
                        //spUser.DefaultManufacture = profileInfo.DefaultManufacture;
                    }
                    else
                    {
                        spUser.Plants = "[]";
                        //spUser.DefaultManufacture = "";
                    }
                    #endregion

                    #region Update Product Line and Trademarks
                    if (profileInfo.ProductLines != null)
                    {
                        if (profileInfo.ProductLines.Products != null)
                            spUser.ProductLineName = JSONSerelization.Serialize(profileInfo.ProductLines.Products);
                        if (profileInfo.ProductLines.Trademarks != null)
                            spUser.TradeMarkName = JSONSerelization.Serialize(profileInfo.ProductLines.Trademarks);
                    }
                    #endregion

                    #region Updating My Setting for Manufacturing & Inventory

                    if (profileInfo.DefaultManufacture != "0")
                        spUser.DefaultManufacture = profileInfo.DefaultManufacture;
                    else
                        spUser.DefaultManufacture = "";

                    if (profileInfo.DefaultInventoryPerf != "0")
                        spUser.DefaultInventoryPref = profileInfo.DefaultInventoryPerf;
                    else
                        spUser.DefaultInventoryPref = "";

                    #endregion
                    spUser.IsPreferenceSaved = profileInfo.IsPreferenceSaved;

                    //Save the Primary Branch ID get it from UserProfile Properties..
                    //UserProfile uProfile = db.UserProfiles.First(i => i.GSN == profileInfo.GSN);
                    // uProfile.PrimaryBranchID = profileInfo.PrimaryBranch;
                    if (isAddUser)
                    {
                        db.Add(spUser);
                    }
                    db.SaveChanges();
                    AddUserAccounts(profileInfo.Accounts, spUser.SPUserProfileID, db, profileInfo.GSN);
                    AddUserLocations(profileInfo.Geo, spUser.SPUserProfileID, db, profileInfo.GSN);
                    AddUserChannels(profileInfo.Channels, spUser.SPUserProfileID, db, profileInfo.GSN);
                    AddUserRoutes(profileInfo.Routes, spUser.SPUserProfileID, db, profileInfo.GSN);
                    AddUserGoalAccount(profileInfo.GoalAccount, profileInfo.GSN, spUser.SPUserProfileID, db, profileInfo.DefaultGoalFunctionID);
                    AddUserPlants(profileInfo.MyPlants, spUser.SPUserProfileID, db, profileInfo.GSN);
                    AddUserProductLine(profileInfo.ProductLines, spUser.SPUserProfileID, db, profileInfo.GSN);
                }

                _updateSuccess = true;
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: UPDATING USER PROFILE PROPERTIES IN SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }
            finally
            {
                string cacheKey = SPContext.Current.Web.CurrentUser.LoginName + "_UserPreference";
                CacheHelper.SetCacheValue(cacheKey, null);

                string currBranchcacheKey = SPContext.Current.Web.CurrentUser.LoginName + "_" + CacheKeys.CurrentBranchCacheKey;
                string currRegionKey = SPContext.Current.Web.CurrentUser.LoginName + "_" + CacheKeys.CurrentRegionCacheKey;
                string currentUserCacheKey = SPContext.Current.Web.CurrentUser.LoginName + "_UserPreference";

                CacheHelper.SetCacheValue(currBranchcacheKey, null);
                CacheHelper.SetCacheValue(currRegionKey, null);
                CacheHelper.SetCacheValue(currentUserCacheKey, null);
                
                
            }

            return _updateSuccess;
        }

        
        public static IEnumerable<Types.CAN> GetAllCANs()
        {
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    var allCANs = from t in db.UserCans
                                  select new Types.CAN { canId = t.CANID, canName = t.CANName }
                                    ;
                    return allCANs.ToList();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING CANS FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }

        public static string GetBranchZipCodeFromSDM(string branchName)
        {
            try
            {
                if (!string.IsNullOrEmpty(branchName))
                {
                    using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                    {
                        string zipCode = Convert.ToString(db.Branches.First(i => i.BranchName.ToLower() == branchName.ToLower()).ZipCode);


                        return zipCode;
                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ZIPCODE FROM SDM IN USERPROFILEREPOSITORY CLASS FOR BRANCH:" + branchName, ex);
            }

            return null;
        }

        public static int GetBranchIdFromSDM(string sapBranchId)
        {
            int branchID = 0;
            try
            {
                //if (!string.IsNullOrEmpty(branchId))
                {
                    using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                    {
                        branchID = db.Branches.First(i => i.SAPBranchID == sapBranchId).BranchID;

                        return branchID;
                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING SAPBRANCHID FROM SDM IN USERPROFILEREPOSITORY CLASS FOR BRANCH:" + branchID, ex);
            }

            return branchID;
        }

        public static string GetBranchNameFromSDM(int branchId)
        {
            try
            {
                //if (!string.IsNullOrEmpty(branchId))
                {
                    using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                    {
                        string branchName = db.Branches.First(i => i.BranchID == branchId).BranchName;

                        return branchName;
                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING SAPBRANCHID FROM SDM IN USERPROFILEREPOSITORY CLASS FOR BRANCH:" + branchId, ex);
            }

            return null;
        }


        /// <summary>
        /// This method will map a string value to a OnePortalRoleScope enum
        /// </summary>
        /// <param name="rolescope">rolescope</param>
        /// <returns>OnePortalRoleScope enum value</returns>
        //private static OnePortalRoleScope GetRoleScopeFromString(string rolescope)
        //{
        //    OnePortalRoleScope ret = OnePortalRoleScope.None;

        //    rolescope = rolescope.ToLower();

        //    if (!string.IsNullOrEmpty(rolescope))
        //    {
        //        switch (rolescope)
        //        {
        //            case "national":
        //                ret = OnePortalRoleScope.National;
        //                break;
        //            case "bu":
        //                ret = OnePortalRoleScope.BU;
        //                break;
        //            case "region":
        //                ret = OnePortalRoleScope.Region;
        //                break;
        //            case "branch":
        //                ret = OnePortalRoleScope.Branch;
        //                break;
        //            case "district":
        //                ret = OnePortalRoleScope.District;
        //                break;
        //            default:
        //                ret = OnePortalRoleScope.None;
        //                break;
        //        }
        //    }

        //    return ret;
        //}

        /// <summary>
        /// Get the user Program last login time for Program Module
        /// </summary>
        /// <param name="GSN"></param>
        /// <returns></returns>
        public static DateTime GetUserProgramLastLoginTime(string GSN)
        {
            DateTime _lastLogin = DateTime.Now;

            using (UserProfileModel cntxt = new UserProfileModel(GetConnectionString()))
            {
                try
                {
                    _lastLogin = cntxt.SPUserProfiles.First(i => i.GSN == GSN).ProgramLastLoginTime.Value;
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
            }

            return _lastLogin;
        }

        /// <summary>
        /// Sets the current time as the user last login  time for playbook module
        /// </summary>
        /// <param name="GSN"></param>
        /// <returns></returns>
        public static void SetUserProgramLastLoginTime(string GSN, DateTime dtProgramLastLoginTime)
        {
            using (UserProfileModel cntxt = new UserProfileModel(GetConnectionString()))
            {
                try
                {
                    SPUserProfile _userProfile = cntxt.SPUserProfiles.First(i => i.GSN == GSN);
                    _userProfile.LastLoginTime = dtProgramLastLoginTime;

                    cntxt.SaveChanges();
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
            }
        }

        /// <summary>
        /// Get the user last login time for PlayBook Module
        /// </summary>
        /// <param name="GSN"></param>
        /// <returns></returns>
        public static DateTime GetUserLastLoginTime(string GSN)
        {
            DateTime _lastLogin = DateTime.Now;

            using (UserProfileModel cntxt = new UserProfileModel(GetConnectionString()))
            {
                try
                {
                    _lastLogin = cntxt.SPUserProfiles.First(i => i.GSN == GSN).LastLoginTime.Value;
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
            }

            return _lastLogin;
        }

        /// <summary>
        /// Get the user last login time for PlayBook Module
        /// </summary>
        /// <param name="GSN"></param>
        /// <returns></returns>
        public static UserInfo GetSPUserProfileByGSN(int? PersonaID, string GSN)
        {

            UserInfo usrPref = new UserInfo();
            usrPref.GSN = GSN;

            using (UserProfileModel cntxt = new UserProfileModel(GetConnectionString()))
            {
                try
                {
                    SPUserProfile spUserProfile = cntxt.SPUserProfiles.FirstOrDefault(i => i.GSN == GSN && i.PersonaID == PersonaID);

                    if (spUserProfile != null)
                    {
                        ////Primary Branch
                       
                        ////Trade Marks
                        try
                        {
                            if (spUserProfile.BranchTradeMark != null)
                            {
                                usrPref.TradeMarks = JSONSerelization.Deserialize<List<BranchTradeMarks>>(Convert.ToString(spUserProfile.BranchTradeMark));
                            }
                            else
                            {
                                usrPref.TradeMarks = new List<BranchTradeMarks>();
                            }
                        }
                        catch { }
                        //// Branch CAN relation
                        try
                        {
                            if (spUserProfile.BranchCAN != null)
                                usrPref.BranchCAN = JSONSerelization.Deserialize<List<BranchCAN>>(Convert.ToString(spUserProfile.BranchCAN));
                            else
                                usrPref.BranchCAN = new List<BranchCAN>();
                        }
                        catch { }
                        usrPref.Accounts = new UserAccounts();
                        try
                        {
                            if (spUserProfile.NationalAccount != null)
                                usrPref.Accounts.National = JSONSerelization.Deserialize<List<Account>>(Convert.ToString(spUserProfile.NationalAccount));
                            else
                                usrPref.Accounts.National = new List<Account>();
                        }
                        catch { }
                        try
                        {
                            if (spUserProfile.RegionalAccount != null)
                                usrPref.Accounts.Regional = JSONSerelization.Deserialize<List<Account>>(Convert.ToString(spUserProfile.RegionalAccount));
                            else
                                usrPref.Accounts.Regional = new List<Account>();
                        }
                        catch { }
                        try
                        {
                            if (spUserProfile.LocalAccount != null)
                                usrPref.Accounts.Local = JSONSerelization.Deserialize<List<Account>>(Convert.ToString(spUserProfile.LocalAccount));
                            else
                                usrPref.Accounts.Local = new List<Account>();
                        }
                        catch { }
                        PopulateSAPIds(cntxt,usrPref);
                        usrPref.Geo = new GeoRelevancy();

                        try
                        {
                            if (spUserProfile.BU != null)
                                usrPref.Geo.BU = JSONSerelization.Deserialize<List<Types.BusinessUnit>>(Convert.ToString(spUserProfile.BU));
                            else
                                usrPref.Geo.BU = new List<Types.BusinessUnit>();
                        }
                        catch { }

                        try
                        {
                            if (spUserProfile.Region != null)
                                usrPref.Geo.Region = JSONSerelization.Deserialize<List<Types.Region>>(Convert.ToString(spUserProfile.Region));
                            else
                                usrPref.Geo.Region = new List<Types.Region>();
                        }
                        catch { }

                        try
                        {
                            if (spUserProfile.Area != null)
                                usrPref.Geo.Area = JSONSerelization.Deserialize<List<Types.Area>>(Convert.ToString(spUserProfile.Area));
                            else
                                usrPref.Geo.Area = new List<Types.Area>();
                        }
                        catch { }

                        //Set BC Locations details

                        try
                        {
                            if (spUserProfile.System != null)
                                usrPref.Geo.System = JSONSerelization.Deserialize<List<Types.Systems>>(Convert.ToString(spUserProfile.System));
                            else
                                usrPref.Geo.System = new List<Types.Systems>();
                        }
                        catch { }

                        try
                        {
                            if (spUserProfile.Zone != null)
                                usrPref.Geo.Zone = JSONSerelization.Deserialize<List<Types.Zone>>(Convert.ToString(spUserProfile.Zone));
                            else
                                usrPref.Geo.Zone = new List<Types.Zone>();
                        }
                        catch { }

                        try
                        {
                            if (spUserProfile.Division != null)
                                usrPref.Geo.Division = JSONSerelization.Deserialize<List<Types.Division>>(Convert.ToString(spUserProfile.Division));
                            else
                                usrPref.Geo.Division = new List<Types.Division>();
                        }
                        catch { }

                        try
                        {
                            if (spUserProfile.BCRegion != null)
                                usrPref.Geo.BCRegion = JSONSerelization.Deserialize<List<Types.BCRegion>>(Convert.ToString(spUserProfile.BCRegion));
                            else
                                usrPref.Geo.BCRegion = new List<Types.BCRegion>();
                        }
                        catch { }

                        //get super channels
                        usrPref.Channels = new UserChannels();
                        try
                        {
                            if (spUserProfile.SuperChannel != null)
                                usrPref.Channels.SuperChannel = JSONSerelization.Deserialize<List<ChannelJSON>>(Convert.ToString(spUserProfile.SuperChannel));
                            else
                                usrPref.Channels.SuperChannel = new List<ChannelJSON>();
                        }
                        catch (Exception ex) { }
                        //get channels
                        try
                        {
                            if (spUserProfile.Channel != null)
                                usrPref.Channels.Channel = JSONSerelization.Deserialize<List<ChannelJSON>>(Convert.ToString(spUserProfile.Channel));
                            else
                                usrPref.Channels.Channel = new List<ChannelJSON>();
                        }
                        catch (Exception ex) { }

                        try
                        {
                            if (spUserProfile.Branch != null)
                                usrPref.Geo.Branch = JSONSerelization.Deserialize<List<Types.Branch>>(Convert.ToString(spUserProfile.Branch));
                            else
                                usrPref.Geo.Branch = new List<Types.Branch>();
                        }
                        catch { }

                        try
                        {
                            if (spUserProfile.DefaultPromotion != null)
                                usrPref.DefaultPromotion = Convert.ToString(spUserProfile.DefaultPromotion);
                        }
                        catch { }
                        try
                        {
                            if (spUserProfile.IsPreferenceSaved != null)
                                usrPref.IsPreferenceSaved = Convert.ToBoolean(spUserProfile.IsPreferenceSaved);
                        }
                        catch { }

                        usrPref.SPUserProfileID = spUserProfile.SPUserProfileID;
                        usrPref.MyAccounts = GetUserMyAccount(spUserProfile.SPUserProfileID);
                        usrPref.MyChannels = GetUserMyChannels(spUserProfile.SPUserProfileID);
                        usrPref.AdditionalBranches = GetUserBranches(cntxt, GSN);
                        usrPref.AdditionalBCRegion = GetUserBCRegions(cntxt, GSN);


                        if (usrPref.AdditionalBranches.Count > 0)
                            usrPref.PrimaryBranch = new BranchInfo() { BranchId = usrPref.AdditionalBranches[0].branchId, BranchName = usrPref.AdditionalBranches[0].branchName, SAPBranchId = usrPref.AdditionalBranches[0].SAPBranchId, BUId = usrPref.AdditionalBranches[0].BUID, BUName = usrPref.AdditionalBranches[0].BUName, RegionId = usrPref.AdditionalBranches[0].RegionID, RegionName = usrPref.AdditionalBranches[0].RegionName, AreaId = usrPref.AdditionalBranches[0].AreaID, AreaName = usrPref.AdditionalBranches[0].AreaName };

                        if (usrPref.AdditionalBCRegion.Count > 0)
                            usrPref.PrimaryBCRegion = new BCRegionInfo() { RegionID = usrPref.AdditionalBCRegion[0].RegionID, RegionName = usrPref.AdditionalBCRegion[0].RegionName };



                        usrPref.ProductLines = new ProductLine();
                        try
                        {
                            if (spUserProfile.ProductLineName != null)
                                usrPref.ProductLines.Products = JSONSerelization.Deserialize<List<Types.Products>>(Convert.ToString(spUserProfile.ProductLineName));
                            else
                                usrPref.ProductLines.Products = new List<Types.Products>();
                        }
                        catch { }

                        try
                        {
                            if (spUserProfile.TradeMarkName != null)
                                usrPref.ProductLines.Trademarks = JSONSerelization.Deserialize<List<Types.TradeMarks>>(Convert.ToString(spUserProfile.TradeMarkName));
                            else
                                usrPref.ProductLines.Trademarks = new List<Types.TradeMarks>();
                        }
                        catch { }
                    }
                    else
                    {
                        usrPref.PrimaryBranch = new BranchInfo();
                        usrPref.TradeMarks = new List<BranchTradeMarks>();
                        usrPref.BranchCAN = new List<BranchCAN>();
                        usrPref.Accounts = new UserAccounts();
                        usrPref.Accounts.National = new List<Account>();
                        usrPref.Accounts.Regional = new List<Account>();
                        usrPref.Accounts.Local = new List<Account>();
                        usrPref.Geo = new GeoRelevancy();

                        usrPref.Geo.BU = new List<Types.BusinessUnit>();
                        usrPref.Geo.Region = new List<Types.Region>();
                        usrPref.Geo.Area = new List<Types.Area>();

                        usrPref.Geo.System = new List<Types.Systems>();
                        usrPref.Geo.Zone = new List<Types.Zone>();
                        usrPref.Geo.Division = new List<Types.Division>();
                        usrPref.Geo.BCRegion = new List<Types.BCRegion>();

                        usrPref.Channels = new UserChannels();
                        usrPref.Channels.SuperChannel = new List<ChannelJSON>();
                        usrPref.Channels.Channel = new List<ChannelJSON>();
                        usrPref.Geo.Branch = new List<Types.Branch>();
                        usrPref.MyAccounts = new List<AccountInfo>();
                        usrPref.ProductLines = new ProductLine();
                        usrPref.ProductLines.Products = new List<Products>();
                        usrPref.ProductLines.Trademarks = new List<TradeMarks>();

                    }






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

                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
                return usrPref;
            }


        }

        private static void PopulateSAPIds(UserProfileModel cntxt, UserInfo usrPref)
        {
            try
            {
                foreach (Account account in usrPref.Accounts.National)
                {
                    if (account.SAPChainId == null || account.SAPChainId == "")
                    {
                        try
                        {
                            account.SAPChainId = cntxt.NationalChains.Where(i => i.NationalChainID == account.ChainId).FirstOrDefault().SAPNationalChainID.ToString();
                        }
                        catch { }
                    }
                }
                foreach (Account account in usrPref.Accounts.Regional)
                {
                    if (account.SAPChainId == null || account.SAPChainId == "")
                    {
                        try
                        {
                            account.SAPChainId = cntxt.RegionalChains.Where(i => i.RegionalChainID == account.ChainId).FirstOrDefault().SAPRegionalChainID.ToString();
                        }
                        catch { }
                    }
                }
                foreach (Account account in usrPref.Accounts.Local)
                {
                    if (account.SAPChainId == null || account.SAPChainId == "")
                    {
                        try
                        {
                            account.SAPChainId = cntxt.LocalChains.Where(i => i.LocalChainID == account.ChainId).FirstOrDefault().SAPLocalChainID.ToString();
                        }
                        catch { }
                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
        }

        public static List<AccountInfo>  GetUserMyAccount(int spUserProfileId)
        {
            List<AccountInfo> objlstAccountInfo = new List<AccountInfo>();
            using (UserProfileModel entity = new UserProfileModel(GetConnectionString()))
            {
                try
                {
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@SPUserProfileId", Value = spUserProfileId }) };
                    objlstAccountInfo = entity.ExecuteQuery<AccountInfo>("Person.pGetMyAccounts", System.Data.CommandType.StoredProcedure, parm).ToList<AccountInfo>();
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
            }
            return objlstAccountInfo;

        }

        public static List<AccountInfo> GetUserMyChannels(int spUserProfileId)
        {
            List<AccountInfo> objlstAccountInfo = new List<AccountInfo>();
            using (UserProfileModel entity = new UserProfileModel(GetConnectionString()))
            {
                try
                {
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@SPUserProfileId", Value = spUserProfileId }) };
                    objlstAccountInfo = entity.ExecuteQuery<AccountInfo>("[Person].[pGetMyChannels]", System.Data.CommandType.StoredProcedure, parm).ToList<AccountInfo>();
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
            }
            return objlstAccountInfo;

        }

        /// <summary>
        /// Sets the current time as the user last login  time for playbook module
        /// </summary>
        /// <param name="GSN"></param>
        /// <returns></returns>
        public static void SetUserLastLoginTime(string GSN)
        {
            using (UserProfileModel cntxt = new UserProfileModel(GetConnectionString()))
            {
                try
                {
                    SPUserProfile _userProfile = cntxt.SPUserProfiles.First(i => i.GSN == GSN);
                    _userProfile.LastLoginTime = DateTime.Now;

                    cntxt.SaveChanges();
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
            }
        }

        // Get data from SDM for MySalesTarget MetrixID= "M103"
        /* SELECT  sum(metric) as MetricValue
       FROM [Portal_Data].[MSTR].[FactOFDDailyMetrics] a
       inner join   MSTR.TransMTDDay    b on a.MetricDate = b.MTDDayDate
       where MetricID = 'M103'
       and b.DayDate = '2013-05-28'      
       and BranchID =120   */
        public static decimal GetLoadOutHB(int branch, DateTime dt)
        {
            decimal actualValue = 0;
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    var actualData = db.ExecuteScalar<decimal>("SELECT "
                        + "((sum([LoadOutHB]) - sum([SalesQty]))/sum([LoadOutHB]))*100.0"
                        + "FROM [Portal_Data].[MSTR].[ViewOFDDailyMetrics] m "
                        + "inner join [MSTR].[TransMTDDay] d on m.metricdate=d.MTDDaydate and convert(date,daydate,104)='" + dt.ToString("MM/dd/yyyy") + "'"
                        + "where branchid=" + branch
                        + "group by [BranchID]");
                    actualValue = Convert.ToDecimal(actualData);

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GetLoadOutHB Matrix value FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return actualValue;
        }
        public static decimal GetActualValue(string matxID, int brncID, DateTime dt)
        {
            decimal actualValue = 0;
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {

                    var actData = from t in db.FactOFDDailyMetrics
                                  join r in db.TransMTDDays on t.MetricDate equals r.MTDDayDate
                                  where t.MetricID == matxID && r.DayDate == dt && t.BranchID == brncID
                                  select new Types.MatrixData { matrixValue = t.Metric };

                    var actualData = actData.AsEnumerable().Sum(o => o.matrixValue);
                    actualValue = Convert.ToDecimal(actualData);

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING Matrix value FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return actualValue;
        }

        // Get value for DOS
        public static List<MatrixData> GetActualValueDos(string matxID, int brncID)
        {
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {

                    var actData = from t in db.FactOFDDailyMetrics.Where(i => i.MetricID == matxID && i.BranchID == brncID)
                                  orderby t.MetricDate descending
                                  select new Types.MatrixData { matrixValue = t.Metric };

                    return actData.ToList();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING Matrix value FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }

        // Get data from SDM for MySalesTarget 
        public static List<MatrixData> GetTargetValue(int monthID, int brncID)
        {
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    var targetData = from t in db.DimBranchPlans.Where(i => i.BranchID == brncID && i.Monthid == monthID)
                                     select new Types.MatrixData { planValue = t.PlanVolume }
                                    ;

                    return targetData.ToList();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING Target Value FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }

        public static IEnumerable<Types.TradeMark> GetDefaultTradeMarks(int branchID)
        {
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    var defaultTradeMarks = from a in db.BranchMaterials
                                            join b in db.Materials on a.MaterialID equals b.MaterialID
                                            join c in db.Brands on b.BrandID equals c.BrandID
                                            join d in db.TradeMarks on c.TrademarkID equals d.TradeMarkID
                                            where a.BranchID == branchID
                                            select new Types.TradeMark { tradeMarkName = d.TradeMarkName, tradeMarkId = d.TradeMarkID };
                    return defaultTradeMarks.Distinct().ToList();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING DEFAULT BRANDS FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }

        public static List<BehaviorMemberList> GetBehavoirMembers(string BehavoirName)
        {
            using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
            {
                //Get all the local regional and national chain associated with the account id (parm)
                DbParameter[] parm = { (new OAParameter { ParameterName = "@BehavoirName", Value =BehavoirName})};
                var allAccounts = db.ExecuteQuery<DPSG.Portal.Framework.Types.BehaviorMemberList>("Settings.BehavoirMembers", System.Data.CommandType.StoredProcedure, parm).ToList<BehaviorMemberList>();

                return allAccounts;
            }
        }

        /// <summary>
        /// This method is used in MyPreference page
        /// </summary>
        /// <returns></returns>
        public static List<TreeViewItem> GetAllGeoTreeViewDetails()
        {
            List<TreeViewItem> objGEOTreeViewlst = null;
            try
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    List<PBLocationHier> objlstLocationHier = objPlaybookEntities.PBLocationHiers.ToList();
                    if (objlstLocationHier != null)
                    {

                        objGEOTreeViewlst = new List<TreeViewItem>();
                        var nationLocations = objlstLocationHier.DistinctBy(i => i.BUID).ToList();
                        objGEOTreeViewlst.AddRange(nationLocations.Select(i => new TreeViewItem() { Id = i.BUID, ParentId = 0, Text = i.BUName, Value = string.Concat(i.BUID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BU, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPBUID) }));
                        var regionalLocations = (from item in objlstLocationHier
                                                 join nationlocation in nationLocations
                                                 on item.BUID equals nationlocation.BUID
                                                 select new { item.RegionID, item.RegionName, item.BUID, item.SAPBUID, item.SAPRegionID }).Distinct().ToList();

                        objGEOTreeViewlst.AddRange(regionalLocations.Select(i => new TreeViewItem() { Id = GetID(i.BUID, i.RegionID), ParentId = i.BUID, Text = i.RegionName, Value = string.Concat(i.RegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_REGIONAL, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPRegionID) }));

                        var localLocations = (from item in objlstLocationHier
                                              join regionalLocation in regionalLocations
                                               on item.RegionID equals regionalLocation.RegionID
                                              select new { item.BranchID, item.BranchName, item.RegionID, item.BUID, item.SAPBranchID }).Distinct().ToList();

                        objGEOTreeViewlst.AddRange(localLocations.Select(i => new TreeViewItem() { Id = GetID(i.RegionID, i.BranchID), ParentId = GetID(i.BUID, i.RegionID), Text = i.BranchName, Value = string.Concat(i.BranchID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BRANCH, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPBranchID) }));
                    }

                }

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }


            return objGEOTreeViewlst;
        }

        public static List<TreeViewItem> GetAccountsForTreeView()
        {
            List<TreeViewItem> lstAccountsTreeView = null;
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {

                    lstAccountsTreeView = new List<TreeViewItem>();

                    //Get all the local regional and national chain associated with the account id (parm)
                    var allAccounts = db.LocationChains.Where(i => i.NationalChainName != CommonConstants.PROMOTION_NATIONAL_ALL_OTHER || i.RegionalChainName != CommonConstants.PROMOTION_REGIONAL_ALL_OTHER).Select(i => new { i.LocalChainID, i.LocalChainName, i.RegionalChainName, i.RegionalChainID, i.NationalChainName, i.NationalChainID, i.SAPNationalChainID, i.SAPRegionalChainID, i.SAPLocalChainID }).ToList();

                    //Get all the unique National Account
                    var nationalAccounts = allAccounts.Select(i => new { i.NationalChainID, i.NationalChainName, i.SAPNationalChainID }).Distinct();

                    //Add all the National Accounts with ParentID = 0
                    lstAccountsTreeView.AddRange(nationalAccounts.Select(i => new TreeViewItem() { Id = i.NationalChainID, ParentId = 0, Text = i.NationalChainName, Value = i.NationalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + AccountType.National.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPNationalChainID }));

                    //Get all the regional accounts
                    var regionalAccounts = (from allAccount in allAccounts
                                            join nationalaccount in nationalAccounts
                                            on allAccount.NationalChainID equals nationalaccount.NationalChainID
                                            select new { allAccount.RegionalChainID, allAccount.RegionalChainName, allAccount.NationalChainID, allAccount.NationalChainName, allAccount.SAPRegionalChainID }).Distinct();
                    lstAccountsTreeView.AddRange(regionalAccounts.Select(i => new TreeViewItem() { Id = GetID(i.NationalChainID, i.RegionalChainID), ParentId = i.NationalChainID, Text = i.RegionalChainName, Value = i.RegionalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + AccountType.Regional.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPRegionalChainID }));

                    //Get all the local account
                    var localAccounts = (from allAccount in allAccounts
                                         join regionalaccount in regionalAccounts
                                         on allAccount.RegionalChainID equals regionalaccount.RegionalChainID
                                         select new { allAccount.LocalChainID, allAccount.LocalChainName, allAccount.RegionalChainID, allAccount.SAPLocalChainID, allAccount.NationalChainID }).Distinct();

                    lstAccountsTreeView.AddRange(localAccounts.Select(i => new TreeViewItem() { Id = GetID(GetID(i.NationalChainID, i.RegionalChainID), i.LocalChainID), ParentId = GetID(i.NationalChainID, i.RegionalChainID), Text = i.LocalChainName, Value = i.LocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + AccountType.Local.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPLocalChainID }));

                    return lstAccountsTreeView;

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }

        public static List<LocationChain> GetLocationAccountsForTreeView()
        {
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    //Get all the local regional and national chain associated with the account id (parm)
                    var allAccounts = db.LocationChains.Where(i => i.NationalChainName != CommonConstants.PROMOTION_NATIONAL_ALL_OTHER && i.RegionalChainName != CommonConstants.PROMOTION_REGIONAL_ALL_OTHER).ToList();

                    string sql = db.LocationChains.Where(i => i.NationalChainName != CommonConstants.PROMOTION_NATIONAL_ALL_OTHER && i.RegionalChainName != CommonConstants.PROMOTION_REGIONAL_ALL_OTHER).Distinct().ToString();
                    return allAccounts;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }

        public static List<TreeViewItem> GetAllAccount()
        {
            List<TreeViewItem> allGeoBasedAccounts = null;

            try
            {
                string cacheKey = "OFDAllGeoBasedAccounts";


                if (CacheHelper.GetCacheValue(cacheKey) != null)
                {
                    allGeoBasedAccounts = CacheHelper.GetCacheValue(cacheKey) as List<TreeViewItem>;
                }
                else
                {
                    List<CustomLocationChain> allLocAccounts = UserProfileRepository.GetAllAccountsForTreeView();

                    allGeoBasedAccounts = new List<TreeViewItem>();

                    var nationalAccounts = allLocAccounts.Select(i => new { i.NationalChainID, i.NationalChainName, i.SAPNationalChainID, i.BranchID }).DistinctBy(i => i.NationalChainID).ToList();

                    //Add all the National Accounts with ParentID = 0
                    allGeoBasedAccounts.AddRange(nationalAccounts.Select(i => new TreeViewItem() { Id = i.NationalChainID + 10000, Text = i.NationalChainName, Value = DPSG.Portal.Framework.Types.AccountType.National.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.NationalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPNationalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.NationalChainName, ParentId = 0 }));
                    foreach (TreeViewItem item in allGeoBasedAccounts.Where(i => i.Text == "All Other"))
                        item.Text = "Regional Accounts";
                    //Get all the regional accounts
                    var regionalAccounts = (from allAccount in allLocAccounts
                                            join nationalaccount in nationalAccounts
                                            on allAccount.NationalChainID equals nationalaccount.NationalChainID
                                            select new { allAccount.RegionalChainID, allAccount.RegionalChainName, allAccount.BranchID, allAccount.SAPRegionalChainID, allAccount.NationalChainID }).DistinctBy(i => i.RegionalChainID).ToList();
                    allGeoBasedAccounts.AddRange(regionalAccounts.Select(i => new TreeViewItem() { Id = i.RegionalChainID + 20000, Text = i.RegionalChainName, Value = DPSG.Portal.Framework.Types.AccountType.Regional.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.RegionalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPRegionalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.RegionalChainName, ParentId = i.NationalChainID + 10000 }));

                    //Get all the local account

                    var localAccounts = (from allAccount in allLocAccounts
                                         join regionalaccount in regionalAccounts
                                         on allAccount.RegionalChainID equals regionalaccount.RegionalChainID
                                         select new { allAccount.LocalChainID, allAccount.LocalChainName, allAccount.SAPLocalChainID, allAccount.BranchID, allAccount.RegionalChainID, allAccount.NationalChainID }).DistinctBy(i => i.LocalChainID).ToList();

                    allGeoBasedAccounts.AddRange(localAccounts.Select(i => new TreeViewItem() { Id = i.LocalChainID + 30000, Text = i.LocalChainName, Value = DPSG.Portal.Framework.Types.AccountType.Local.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.LocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPLocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.LocalChainName, ParentId = i.RegionalChainID + 20000 }));

                    CacheHelper.SetCacheValue(cacheKey, allGeoBasedAccounts, 4320);
                }


            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }
            return allGeoBasedAccounts.OrderBy(i => i.Text).ToList();
        }


        public static List<TreeViewItem> GetLocalAccount()
        {
            List<TreeViewItem> allGeoBasedAccounts = null;

            try
            {
                string cacheKey = "OFDAllGeoBasedLocalAccounts";


                if (CacheHelper.GetCacheValue(cacheKey) != null)
                {
                    allGeoBasedAccounts = CacheHelper.GetCacheValue(cacheKey) as List<TreeViewItem>;
                }
                else
                {
                                     

                    allGeoBasedAccounts = new List<TreeViewItem>();

                    using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                    {
                        //Get all the local regional and national chain associated with the account id (parm)
                        var allAccounts = db.ExecuteQuery<CustomLocationChain>("[Playbook].[GetAllLocalAccounts]", System.Data.CommandType.StoredProcedure, null).Distinct().ToList();

                        allGeoBasedAccounts.AddRange(allAccounts.Select(i => new TreeViewItem() { Id = i.LocalChainID + 30000, Text = i.LocalChainName, Value = DPSG.Portal.Framework.Types.AccountType.Local.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.LocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPLocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.LocalChainName, ParentId = i.RegionalChainID + 20000 }));
                        //allGeoBasedAccounts = (List<TreeViewItem>)allAccounts;
                    }


                    CacheHelper.SetCacheValue(cacheKey, allGeoBasedAccounts, 4320);
                }


            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }
            return allGeoBasedAccounts.OrderBy(i => i.Text).ToList();
        }

        public static List<TreeViewItem> GetAllLocationAccount(string branchjson, List<SelectedTreeItem> lstChannels)
        {
            List<TreeViewItem> allGeoBasedAccounts = null;

            try
            {
                if (!string.IsNullOrEmpty(branchjson) || lstChannels != null)
                {

                    List<DPSG.Portal.Framework.Types.Branch> objlstBranch = JSONSerelization.Deserialize<List<DPSG.Portal.Framework.Types.Branch>>(branchjson);
                    List<SelectedTreeItem> objlstChannels = lstChannels;
                    if (objlstBranch != null || objlstChannels != null)
                    {
                        string cacheKey = string.Join("", objlstBranch.OrderBy(i => i.branchId).Select(i => Convert.ToString(i.branchId)).ToArray());
                        cacheKey = string.Concat("Account", cacheKey, string.Join("", objlstChannels.OrderBy(i => i.Value).Select(i => Convert.ToString(i.Value)).ToArray()));

                        if (CacheHelper.GetCacheValue(cacheKey) != null)
                        {
                            allGeoBasedAccounts = CacheHelper.GetCacheValue(cacheKey) as List<TreeViewItem>;
                        }
                        else
                        {
                            List<CustomLocationChain> allLocAccounts = UserProfileRepository.GetLocationAccountsForTreeView(objlstBranch, objlstChannels);

                            allGeoBasedAccounts = new List<TreeViewItem>();

                            var nationalAccounts = allLocAccounts.Select(i => new { i.NationalChainID, i.NationalChainName, i.SAPNationalChainID, i.BranchID }).DistinctBy(i => i.NationalChainID).ToList();

                            //Add all the National Accounts with ParentID = 0
                            allGeoBasedAccounts.AddRange(nationalAccounts.Select(i => new TreeViewItem() { Id = i.NationalChainID + 10000, Text = i.NationalChainName, Value = DPSG.Portal.Framework.Types.AccountType.National.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.NationalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPNationalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.NationalChainName, ParentId = 0 }));
                            foreach (TreeViewItem item in allGeoBasedAccounts.Where(i => i.Text == "All Other"))
                                item.Text = "Regional Accounts";
                            //Get all the regional accounts
                            var regionalAccounts = (from allAccount in allLocAccounts
                                                    join nationalaccount in nationalAccounts
                                                    on allAccount.NationalChainID equals nationalaccount.NationalChainID
                                                    select new { allAccount.RegionalChainID, allAccount.RegionalChainName, allAccount.BranchID, allAccount.SAPRegionalChainID, allAccount.NationalChainID }).DistinctBy(i => i.RegionalChainID).ToList();
                            allGeoBasedAccounts.AddRange(regionalAccounts.Select(i => new TreeViewItem() { Id = i.RegionalChainID + 20000, Text = i.RegionalChainName, Value = DPSG.Portal.Framework.Types.AccountType.Regional.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.RegionalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPRegionalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.RegionalChainName, ParentId = i.NationalChainID + 10000 }));

                            //Get all the local account

                            var localAccounts = (from allAccount in allLocAccounts
                                                 join regionalaccount in regionalAccounts
                                                 on allAccount.RegionalChainID equals regionalaccount.RegionalChainID
                                                 select new { allAccount.LocalChainID, allAccount.LocalChainName, allAccount.SAPLocalChainID, allAccount.BranchID, allAccount.RegionalChainID, allAccount.NationalChainID }).DistinctBy(i => i.LocalChainID).ToList();

                            allGeoBasedAccounts.AddRange(localAccounts.Select(i => new TreeViewItem() { Id = i.LocalChainID + 30000, Text = i.LocalChainName, Value = DPSG.Portal.Framework.Types.AccountType.Local.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.LocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPLocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.LocalChainName, ParentId = i.RegionalChainID + 20000 }));

                            CacheHelper.SetCacheValue(cacheKey, allGeoBasedAccounts, 4320);
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }
            return allGeoBasedAccounts.OrderBy(i => i.Text).ToList();
        }

        // Supply Chain
        public static List<TreeViewItem> GetAllLocalAccount(string branchjson, List<SelectedTreeItem> lstChannels)
        {
            List<TreeViewItem> allLocalAccounts = null;

            try
            {
                if (!string.IsNullOrEmpty(branchjson) || lstChannels != null)
                {

                    List<DPSG.Portal.Framework.Types.Branch> objlstBranch = JSONSerelization.Deserialize<List<DPSG.Portal.Framework.Types.Branch>>(branchjson);
                    List<SelectedTreeItem> objlstChannels = lstChannels;

                    if (objlstBranch != null || objlstChannels != null)
                    {
                        string cacheKey = string.Join("", objlstBranch.OrderBy(i => i.branchId).Select(i => Convert.ToString(i.branchId)).ToArray());
                        cacheKey = string.Concat("LocalAccount", cacheKey, string.Join("", objlstChannels.OrderBy(i => i.Value).Select(i => Convert.ToString(i.Value)).ToArray()));

                        if (CacheHelper.GetCacheValue(cacheKey) != null)
                        {
                            allLocalAccounts = CacheHelper.GetCacheValue(cacheKey) as List<TreeViewItem>;
                        }
                        else
                        {
                            List<CustomLocationChain> allLocallocationAccounts = UserProfileRepository.GetLocalLocationAccounts(objlstBranch, objlstChannels);

                            allLocalAccounts = new List<TreeViewItem>();

                            allLocalAccounts.AddRange(allLocallocationAccounts.Select(i => new TreeViewItem() { Id = i.LocalChainID, Text = i.LocalChainName, Value = DPSG.Portal.Framework.Types.AccountType.Local.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.LocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPLocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.LocalChainName, ParentId = i.RegionalChainID }));

                            CacheHelper.SetCacheValue(cacheKey, allLocalAccounts, 4320);
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }
            return allLocalAccounts.OrderBy(i => i.Text).ToList();
        }

        public static List<TreeViewItem> GetAllChannelByLocation(string json)
        {
            List<TreeViewItem> allGeoBasedChannels = null;

            try
            {
                if (!string.IsNullOrEmpty(json))
                {

                    List<DPSG.Portal.Framework.Types.Branch> objlstBranch = JSONSerelization.Deserialize<List<DPSG.Portal.Framework.Types.Branch>>(json);

                    if (objlstBranch != null)
                    {
                        string cacheKey = string.Concat("Channel", string.Join("", objlstBranch.Select(i => Convert.ToString(i.branchId)).ToArray()));
                        if (CacheHelper.GetCacheValue(cacheKey) != null)
                        {
                            allGeoBasedChannels = CacheHelper.GetCacheValue(cacheKey) as List<TreeViewItem>;
                        }
                        else
                        {
                            List<Channels> allChannels = UserProfileRepository.GetChannelByLocationForTreeView(objlstBranch);

                            allGeoBasedChannels = new List<TreeViewItem>();

                            var superChannel = allChannels.Select(i => new { i.SuperChannelID, i.SuperChannelName, i.SAPSuperChannelID }).DistinctBy(i => i.SuperChannelID).ToList();

                            //Add all the Super channel with ParentID = 0
                            allGeoBasedChannels.AddRange(superChannel.Select(i => new TreeViewItem() { Id = (i.SuperChannelID + 10000), Text = i.SuperChannelName, Value = i.SuperChannelID + CommonConstants.PROMOTION_CHANNEL_TREE_VIEW_SEPERATOR + Enum.GetName(typeof(ChannelType), ChannelType.SuperChannel) + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPSuperChannelID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SuperChannelName, ParentId = 0 }));

                            //Get all the channels
                            var channels = (from allChannel in allChannels
                                            join channel in superChannel
                                            on allChannel.SuperChannelID equals channel.SuperChannelID
                                            select new { allChannel.ChannelID, allChannel.ChannelName, allChannel.SAPChannelID, allChannel.SuperChannelID }).DistinctBy(i => i.ChannelID).ToList();
                            allGeoBasedChannels.AddRange(channels.Select(i => new TreeViewItem() { Id = i.ChannelID + 20000, Text = i.ChannelName, Value = i.ChannelID + CommonConstants.PROMOTION_CHANNEL_TREE_VIEW_SEPERATOR + Enum.GetName(typeof(ChannelType), ChannelType.Channel) + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPChannelID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.ChannelName, ParentId = i.SuperChannelID + 10000 }));

                            //Get all the local account

                            CacheHelper.SetCacheValue(cacheKey, allGeoBasedChannels, 4320);
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL CHANNEL FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }
            return allGeoBasedChannels.OrderBy(i => i.Text).ToList();
        }

        public static List<CustomLocationChain> GetAllAccountsForTreeView()
        {
            try
            {

                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    //Get all the local regional and national chain associated with the account id (parm)
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@BranchIds", Value ="0" }),
                                            (new OAParameter { ParameterName = "@ChannelIds", Value ="0" }),
                                            (new OAParameter { ParameterName = "@SuperChannelIds", Value ="0" })};
                    var allAccounts = db.ExecuteQuery<CustomLocationChain>("[Playbook].[GetAccountsForLocation]", System.Data.CommandType.StoredProcedure, parm).Distinct().ToList();

                    return allAccounts;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }

        public static List<CustomLocationChain> GetLocationAccountsForTreeView(List<DPSG.Portal.Framework.Types.Branch> objlstBranch, List<SelectedTreeItem> lstChannels)
        {
            try
            {
                string brancIds = string.Empty, channelIds = string.Empty, superChannelIds = string.Empty;
                brancIds = string.Join(",", objlstBranch.Select(i => Convert.ToString(i.branchId)).ToArray());
                channelIds = string.Join(",", lstChannels.Where(i => i.Type == Enum.GetName(typeof(ChannelType), ChannelType.Channel)).Select(i => Convert.ToString(i.Value)).ToArray());
                superChannelIds = string.Join(",", lstChannels.Where(i => i.Type == Enum.GetName(typeof(ChannelType), ChannelType.SuperChannel)).Select(i => Convert.ToString(i.Value)).ToArray());
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    //Get all the local regional and national chain associated with the account id (parm)
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@BranchIds", Value =!string.IsNullOrEmpty(brancIds)?brancIds:"0" }),
                                            (new OAParameter { ParameterName = "@ChannelIds", Value =!string.IsNullOrEmpty(channelIds)?channelIds:"0" }),
                                            (new OAParameter { ParameterName = "@SuperChannelIds", Value =!string.IsNullOrEmpty(superChannelIds)?superChannelIds:"0" })};
                    var allAccounts = db.ExecuteQuery<CustomLocationChain>("[Playbook].[GetAccountsForLocation]", System.Data.CommandType.StoredProcedure, parm).Distinct().ToList();

                    return allAccounts;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }

        public static List<AccountInfo> GetAllLocalAccounts()
        {
            List<AccountInfo> retval = null; ;
            try
            {
                retval = (List<AccountInfo>)CacheHelper.GetCacheValue(DPSG.Portal.Framework.Types.Constants.CacheKeys.CACHE_KEY_ALLLOCALACCOUNTS);
                if (retval == null)
                {
                    using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                    {
                        //Get all the local regional and national chain associated with the account id (parm)
                        var allAccounts = db.ExecuteQuery<AccountInfo>("[Playbook].[GetAllLocalAccounts]", System.Data.CommandType.StoredProcedure,null).Distinct().ToList();

                        retval = (List<AccountInfo>)allAccounts;
                    }
                    CacheHelper.SetCacheValue(DPSG.Portal.Framework.Types.Constants.CacheKeys.CACHE_KEY_ALLLOCALACCOUNTS, retval, 168);
                }
                return retval;
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GetAllLocalAccounts GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }

        public static List<CustomLocationChain> GetLocalLocationAccounts(List<DPSG.Portal.Framework.Types.Branch> objlstBranch, List<SelectedTreeItem> lstChannels)
        {
            try
            {
                string brancIds = string.Empty, channelIds = string.Empty, superChannelIds = string.Empty;
                brancIds = string.Join(",", objlstBranch.Select(i => Convert.ToString(i.branchId)).ToArray());
                channelIds = string.Join(",", lstChannels.Where(i => i.Type == Enum.GetName(typeof(ChannelType), ChannelType.Channel)).Select(i => Convert.ToString(i.Value)).ToArray());
                superChannelIds = string.Join(",", lstChannels.Where(i => i.Type == Enum.GetName(typeof(ChannelType), ChannelType.SuperChannel)).Select(i => Convert.ToString(i.Value)).ToArray());

                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    //Get all the local regional and national chain associated with the account id (parm)
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@BranchIds", Value =!string.IsNullOrEmpty(brancIds)?brancIds:"0" }),
                                            (new OAParameter { ParameterName = "@ChannelIds", Value =!string.IsNullOrEmpty(channelIds)?channelIds:"0" }),
                                            (new OAParameter { ParameterName = "@SuperChannelIds", Value =!string.IsNullOrEmpty(superChannelIds)?superChannelIds:"0" })};

                    var allAccounts = db.ExecuteQuery<CustomLocationChain>("[Playbook].[GetLocalAccountsForLocation]", System.Data.CommandType.StoredProcedure, parm).Distinct().ToList();

                    return allAccounts;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }

        public static List<Channels> GetChannelByLocationForTreeView(List<DPSG.Portal.Framework.Types.Branch> objlstBranch)
        {
            try
            {
                string branchIds = string.Empty;
                branchIds = string.Join(",", objlstBranch.Select(i => Convert.ToString(i.branchId)).ToArray());

                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    //Get all the channel associated with the account id (parm)
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@branchIds", Value = branchIds }) };
                    var allAccounts = db.ExecuteQuery<Channels>(DBConstants.DB_PROC_TO_CHANNEL_BY_LOCATION, System.Data.CommandType.StoredProcedure, parm).Distinct().ToList();

                    return allAccounts;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL CHANNEL FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }
        private static int GetID(int p, int p_2)
        {
            for (int i = 0; i < p_2.ToString().Length; i++)
                p *= 10;
            return p_2 + p;
        }

        #region System

        ///// <summary>
        ///// Returns the comma seperated system id for the roles
        ///// </summary>
        ///// <param name="Role"></param>
        ///// <returns></returns>
        //public static string GetSystemIdByRole(string Role)
        //{
        //    string _systems = string.Empty;

        //    try
        //    {
        //        using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
        //        {
        //            //Get the Id of the User role
        //            Role _role = db.Roles.Where(i => i.RoleName == Role).FirstOrDefault();

        //            string[] _roleSystems = db.RoleSystems.Where(i => i.RoleID == _role.RoleID).Select(i => i.SystemID.ToString()).ToArray();

        //            _systems = string.Join(",", _roleSystems);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
        //    }
        //    return _systems;
        //}

        #endregion

        ///// <summary>
        ///// Checks if the user is admin or not
        ///// </summary>
        ///// <param name="GSN"></param>
        ///// <returns></returns>
        //public static bool CheckIsUserAdmin(string GSN)
        //{
        //    bool _isAdmin = false;

        //    try
        //    {
        //        using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
        //        {
        //            //Get the Id of the User role
        //            _isAdmin = db.UserNationalChains.Where(i => i.GSN == GSN).FirstOrDefault().IsAdmin.Value;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
        //        _isAdmin = false;
        //    }
        //    return _isAdmin;
        //}

        ///// <summary>
        ///// 
        ///// </summary>
        ///// <returns></returns>
        //public static bool CheckIsUserAdminForAccount(string GSN, int NationalAccId)
        //{
        //    bool _isAdmin = false;

        //    try
        //    {
        //        using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
        //        {
        //            //Get the Id of the User role
        //            _isAdmin = db.UserNationalChains.Where(i => i.GSN == GSN && i.NationalChainID == NationalAccId).FirstOrDefault().IsAdmin.Value;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
        //        _isAdmin = false;
        //    }
        //    return _isAdmin;
        //}

        /// <summary>
        /// Get all the accounts (including hierarchy) for the GSN
        /// </summary>
        /// <param name="GSN"></param>
        /// <returns></returns>
        public static List<AccountInfo> GetAllAccountsByGSN(string GSN)
        {
            List<AccountInfo> _lstAcc = new List<AccountInfo>();
            PlaybookRepository _pbRepository = new PlaybookRepository();

            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    List<UserNationalChain> _userAccount = db.UserNationalChains.Where(i => i.GSN.ToLower().Equals(GSN.ToLower())).ToList();

                    _userAccount.ForEach(i => _lstAcc.AddRange(_pbRepository.GetAccountsInfoById(i.NationalChainID.Value, AccountType.National)));
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return _lstAcc;
        }

        #region Goal Account Tab Method
        public static List<UserGoalAccount> GetAllGoalAccount()
        {
            List<UserGoalAccount> allGoalAccount = null;
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    DbParameter[] parm = null;
                    return db.ExecuteQuery<UserGoalAccount>("[GOAL].[pGetAllDistinctAccounts]", System.Data.CommandType.StoredProcedure, parm).ToList();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL GOAL Account FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }
            return allGoalAccount;
        }

        #endregion

        #region Route TAB Method
        public static List<UserRoutes> GetRoutes(List<DPSG.Portal.Framework.Types.Branch> objlstBranch)
        {
            try
            {
                string branchIds = string.Empty;
                branchIds = string.Join(",", objlstBranch.Select(i => Convert.ToString(i.branchId)).ToArray());

                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    //Get all the channel associated with the account id (parm)
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@branchIds", Value = branchIds }) };
                    var allRoutes = db.ExecuteQuery<UserRoutes>(DBConstants.DB_PROC_TO_ROUTE_BY_BRANCH, System.Data.CommandType.StoredProcedure, parm).Distinct().ToList();

                    return allRoutes;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ROUTE FOR BRANCHES FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }
        public static List<UserRoutes> GetAllRoutesByBranch(string json)
        {
            List<UserRoutes> allGeoBasedRoutes = null;

            try
            {
                if (!string.IsNullOrEmpty(json))
                {

                    List<DPSG.Portal.Framework.Types.Branch> objlstBranch = JSONSerelization.Deserialize<List<DPSG.Portal.Framework.Types.Branch>>(json);

                    if (objlstBranch != null)
                    {
                        string cacheKey = string.Concat("Route", string.Join("", objlstBranch.Select(i => Convert.ToString(i.branchId)).ToArray()));
                        if (CacheHelper.GetCacheValue(cacheKey) != null)
                        {
                            allGeoBasedRoutes = CacheHelper.GetCacheValue(cacheKey) as List<UserRoutes>;
                        }
                        else
                        {
                            allGeoBasedRoutes = UserProfileRepository.GetRoutes(objlstBranch);

                            CacheHelper.SetCacheValue(cacheKey, allGeoBasedRoutes, 4320);
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL CHANNEL FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }
            return allGeoBasedRoutes.ToList();
        }
        #endregion

        /// <summary>
        /// get branch info for BU
        /// </summary>
        /// <param name="branchId"></param>
        /// <returns></returns>

        public static Types.BranchInfoBU GetBranchInfoBU(int branchId)
        {
            try
            {
                //if (!string.IsNullOrEmpty(branchName))
                {
                    using (UserProfileModel objdb = new UserProfileModel(GetConnectionString()))
                    {

                        var branchInfoBU = from b in objdb.Branches
                                           join ar in objdb.Areas on b.AreaID equals ar.AreaID
                                           join r in objdb.Regions on ar.RegionID equals r.RegionID
                                           join bu in objdb.BusinessUnits on r.BUID equals bu.BUID
                                           where b.BranchID == branchId
                                           select new Types.BranchInfoBU { BranchName = b.BranchName, SAPBranchID = b.SAPBranchID, BranchId = b.BranchID, AreaId = ar.AreaID, SAPAreaID = ar.SAPAreaID, AreaName = ar.AreaName, RegionId = r.RegionID, SAPRegionID = r.SAPRegionID, RegionName = r.RegionName, BUId = bu.BUID, SAPBUID = bu.SAPBUID, BUName = bu.BUName };

                        return branchInfoBU.ToList()[0];
                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING BRANCH INFO FROM SDM IN USERPROFILEREPOSITORY CLASS FOR BRANCH:" + branchId, ex);
            }

            return null;
        }

        /// <summary>
        /// Method to get All National Accounts to display on My Prefrence page.
        /// </summary>
        /// <returns></returns>
        public static List<Types.Account> GetNAAccounts()
        {
            List<Types.Account> returnObj = new List<Account>();
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    var sys = from o in db.NationalChainMasters
                              join natchain in db.NationalChains on o.NationalChainID equals natchain.NationalChainID
                              select new Types.Account { ChainName = natchain.NationalChainName, ChainId = o.NationalChainID };


                    returnObj = sys.Distinct().ToList<Types.Account>();

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING NATIONAL ACCOUNTS USING METHOD GetNAAccounts() FROM SDM IN USERPROFILEREPOSITORY CLASS FOR MY PREF", ex);
            }
            return returnObj;
        }

        /// <summary>
        /// Method to update user prefrences in DB.
        /// </summary>
        /// <param name="_accounts"></param>
        /// <param name="gsn"></param>
        /// <returns></returns>
        public static bool SetNAPrefAccount(List<Types.Account> _accounts, string gsn)
        {
            bool returnObj = false;
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    List<UserNationalChain> lstuserAccount = null;
                    try
                    {
                        //remove existing account detail of user
                        var itemsToDelete = db.UserNationalChains.Where(i => string.Compare(i.GSN, gsn, true) == 0);
                        if (itemsToDelete != null)
                            db.Delete(itemsToDelete);
                    }
                    catch (Exception ex)
                    {
                        ExceptionHelper.LogException("ERROR: DELETING USER ACCOUNTS IN SDM IN USERPROFILEREPOSITORY CLASS FOR USER:", ex);
                    }

                    lstuserAccount = new List<UserNationalChain>();
                    if (_accounts.Count > 0)
                        lstuserAccount.AddRange(_accounts.Select(i => new UserNationalChain() { GSN = gsn, NationalChainID = i.ChainId, IsAdmin = false }).ToList());
                    db.Add(lstuserAccount);
                    db.SaveChanges();


                    returnObj = true;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: ADDING USER ACCOUNTS IN SDM IN USERPROFILEREPOSITORY CLASS FOR USER:", ex);
            }

            return returnObj;

        }



        public static void TraceConsumptionInfo(string GSN, long Duration, string pageURL, DateTime requestedDate)
        {
            DateTime _lastLogin = DateTime.Now;

            using (UserProfileModel cntxt = new UserProfileModel(GetConnectionString()))
            {
                try
                {

                    ConsumptionLog_OFD logTraceInfo = new ConsumptionLog_OFD()
                    {
                        Duration = Duration,
                        PageURL = pageURL,
                        RequestTime = requestedDate,
                        GSN = GSN
                    };

                    cntxt.Add(logTraceInfo);
                    cntxt.SaveChanges();

                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
            }


        }

        public static int? GetPrimaryBCRegionID(string GSN)
        {
            int? bcregionID = 0;
            try
            {
                {
                    using (UserProfileModel objdb = new UserProfileModel(GetConnectionString()))
                    {
                        bcregionID = objdb.Bcsalesaccountabilities.Where(i => i.GSN == GSN && i.IsPrimary == true).FirstOrDefault().RegionID;
                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING BC REGIONID INFO FROM SDM IN USERPROFILEREPOSITORY CLASS FOR GSN:" + GSN, ex);
            }

            return bcregionID;
        }


        public static List<UserGeoLocations> GetAllGeos()
        {
            List<UserGeoLocations> lstUserLocations = null;
            UserGeoLocations geoloc = null;
            lstUserLocations = new List<UserGeoLocations>();

            using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
            {
                //Adding all BUs
                var BUs = db.BusinessUnits;
                foreach (BusinessUnit bu in BUs)
                {
                    geoloc = new UserGeoLocations();
                    geoloc.BUID = bu.BUID;
                    lstUserLocations.Add(geoloc);
                }
            }
            return lstUserLocations;
        }


        public static List<UserGeoLocations> GetUserLocations(string GSN, int SPUserProfileID)
        {
            List<UserGeoLocations> lstUserLocations = null;
            UserGeoLocations geoloc = null;
            List<UserLocation> lstLocations = null;

            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    if (SPUserProfileID > 0)
                        lstLocations = db.UserLocations.Where(i => i.SPUserProfileID == SPUserProfileID).ToList();
                    else
                        lstLocations = db.UserLocations.Where(i => i.GSN == GSN).ToList();

                    if (lstLocations != null && lstLocations.Count > 0)
                    {
                        lstUserLocations = new List<UserGeoLocations>();
                        foreach (UserLocation loc in lstLocations)
                        {
                            geoloc = new UserGeoLocations();
                            geoloc.AreaID = loc.AreaID;
                            geoloc.RegionID = loc.RegionID;
                            geoloc.BCRegionID = loc.BCRegionID;
                            geoloc.BranchID = loc.BranchID;
                            geoloc.BUID = loc.BUID;
                            geoloc.DivisionID = loc.DivisionID;
                            geoloc.GSN = loc.GSN;
                            geoloc.SystemID = loc.SystemID;
                            geoloc.ZoneID = loc.ZoneID;
                            geoloc.DivisionID = loc.DivisionID;
                            geoloc.IsReadOnly = loc.IsReadOnly;
                            lstUserLocations.Add(geoloc);

                        }
                    }

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING BC REGIONS USING METHOD GetBCRegions() FROM SDM IN USERPROFILEREPOSITORY CLASS FOR MY PREF", ex);
            }

            return (lstUserLocations!=null)?lstUserLocations:new List<UserGeoLocations>();

        }


        

        #region BC Geo/Account

        public static string GetAdditionalBCRegionInfo(string GSN, int? PersonaID)
        {

            string addBcRegion = string.Empty;
            try
            {
                using (UserProfileModel objdb = new UserProfileModel(GetConnectionString()))
                {
                    var AdditionalBCRegion = (from usrprf in objdb.SPUserProfiles
                                              where usrprf.GSN == GSN && usrprf.PersonaID == PersonaID
                                              select usrprf).FirstOrDefault();

                    if (AdditionalBCRegion != null)
                    {
                        addBcRegion = AdditionalBCRegion.AdditionalBCRegion;
                    }
                }

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING AdditionalBranch INFO FROM SDM IN USERPROFILEREPOSITORY CLASS FOR User:" + GSN, ex);
            }

            return addBcRegion;
        }

        public static Types.BCRegionInfo GetBCRegionInfo(int regionID)
        {
            try
            {
                {
                    using (UserProfileModel objdb = new UserProfileModel(GetConnectionString()))
                    {

                        var bcregionInfo = from botl in objdb.VBottlerSalesHiers
                                           where botl.RegionID == regionID
                                           select new Types.BCRegionInfo { SystemID = botl.SystemID, SystemName = botl.SystemName, ZoneID = botl.ZoneID, ZoneName = botl.ZoneName, DivisionID = botl.DivisionID, DivisionName = botl.DivisionName, RegionID = botl.RegionID, RegionName = botl.RegionName };

                        return bcregionInfo.ToList()[0];
                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING BRANCH INFO FROM SDM IN USERPROFILEREPOSITORY CLASS FOR BRANCH:" + regionID, ex);
            }

            return null;
        }

        public static Types.BCRegionInfo GetBCRegionInfo(int? regionID)
        {
            try
            {
                {
                    using (UserProfileModel objdb = new UserProfileModel(GetConnectionString()))
                    {

                        var regionInfo = from bottlersales in objdb.VBottlerSalesHiers
                                         where bottlersales.RegionID == regionID
                                         select
                                         new Types.BCRegionInfo
                                         {
                                             SystemID = bottlersales.SystemID,
                                             SystemName = bottlersales.SystemName,
                                             ZoneID = bottlersales.ZoneID,
                                             ZoneName = bottlersales.ZoneName,
                                             DivisionID = bottlersales.DivisionID,
                                             DivisionName = bottlersales.DivisionName,
                                             RegionID = bottlersales.RegionID,
                                             RegionName = bottlersales.RegionName
                                         };

                        return regionInfo.ToList()[0];
                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING BC REGION INFO FROM SDM IN USERPROFILEREPOSITORY CLASS FOR REGION:" + regionID, ex);
            }

            return null;
        }

        public static List<Types.BCRegion> GetBCRegions(string GSN)
        {
            List<Types.BCRegion> _lstRegion = new List<BCRegion>();

            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    var regions = (from bcsales in db.Bcsalesaccountabilities
                                   join reg in db.Region1 on bcsales.RegionID equals reg.RegionID
                                   where
                                       bcsales.GSN == GSN
                                   select new Types.BCRegion { RegionID = reg.RegionID, RegionName = reg.RegionName }).ToList<Types.BCRegion>();


                    _lstRegion = regions.Distinct().ToList<Types.BCRegion>();

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING BC REGIONS USING METHOD GetBCRegions() FROM SDM IN USERPROFILEREPOSITORY CLASS FOR MY PREF", ex);
            }

            return _lstRegion;

        }

        public static string GetBCRegion(string GSN, int? PersonaID)
        {
            string bcregion = string.Empty;
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    bcregion = db.SPUserProfiles.Where(botl => botl.GSN == GSN && botl.PersonaID == PersonaID).FirstOrDefault().PrimaryBCRegion;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING BC REGIONS USING METHOD GetBCRegions() FROM SDM IN USERPROFILEREPOSITORY CLASS FOR MY PREF", ex);
            }

            return bcregion;

        }

        public static List<CustomLocationChain> GetBCLocationAccountsForTreeView()
        {
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {

                    var allAccounts = db.ExecuteQuery<CustomLocationChain>("[PlayBook].[GetBCAccountsForLocation]", System.Data.CommandType.StoredProcedure).Distinct().ToList();

                    return allAccounts;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }

        public static List<CustomLocationChain> GetAllBCAccounts()
        {
            List<CustomLocationChain> lstcustomchain = null;

            if (CacheHelper.GetCacheValue(CommonConstants.PREFERENCEBCACCOUNTKEY) != null)
                lstcustomchain = CacheHelper.GetCacheValue(CommonConstants.PREFERENCEBCACCOUNTKEY) as List<CustomLocationChain>;
            else
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    lstcustomchain = GetBCLocationAccountsForTreeView();

                    CacheHelper.SetCacheValue(CommonConstants.PREFERENCEBCACCOUNTKEY, lstcustomchain, 24);
                }
            }

            return lstcustomchain;
        }

        public static List<TreeViewItem> GetAllLocationBCAccount(string bcregionJSON)
        {
            List<TreeViewItem> allGeoBasedAccounts = null;

            try
            {
                if (!string.IsNullOrEmpty(bcregionJSON))
                {

                    List<DPSG.Portal.Framework.Types.BCRegion> lstbcregion = JSONSerelization.Deserialize<List<DPSG.Portal.Framework.Types.BCRegion>>(bcregionJSON);

                    if (lstbcregion != null)
                    {
                        string[] bcregionids = lstbcregion.Select(i => Convert.ToString(i.RegionID)).ToArray();

                        List<CustomLocationChain> allLocAccounts = UserProfileRepository.GetAllBCAccounts().Where(i => bcregionids.Contains(i.BCRegionID.ToString()) && i.RegionalChainName != CommonConstants.ALL_OTHER).ToList();

                        allGeoBasedAccounts = new List<TreeViewItem>();

                        var nationalAccounts = allLocAccounts.Select(i => new { i.NationalChainID, i.NationalChainName, i.SAPNationalChainID, i.RegionID }).DistinctBy(i => i.NationalChainID).ToList();

                        //Add all the National Accounts with ParentID = 0
                        allGeoBasedAccounts.AddRange(nationalAccounts.Select(i => new TreeViewItem() { Id = i.NationalChainID + 10000, Text = i.NationalChainName, Value = DPSG.Portal.Framework.Types.AccountType.National.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.NationalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPNationalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.NationalChainName, ParentId = 0 }));

                        foreach (TreeViewItem item in allGeoBasedAccounts.Where(i => i.Text == "All Other"))
                            item.Text = "Regional Accounts";

                        //Get all the regional accounts
                        var regionalAccounts = (from allAccount in allLocAccounts
                                                join nationalaccount in nationalAccounts
                                                on allAccount.NationalChainID equals nationalaccount.NationalChainID
                                                select new { allAccount.RegionalChainID, allAccount.RegionalChainName, allAccount.RegionID, allAccount.SAPRegionalChainID, allAccount.NationalChainID }).DistinctBy(i => i.RegionalChainID).ToList();

                        allGeoBasedAccounts.AddRange(regionalAccounts.Select(i => new TreeViewItem() { Id = i.RegionalChainID + 20000, Text = i.RegionalChainName, Value = DPSG.Portal.Framework.Types.AccountType.Regional.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.RegionalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPRegionalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.RegionalChainName, ParentId = i.NationalChainID + 10000 }));

                        //Get all the local account

                        var localAccounts = (from allAccount in allLocAccounts
                                             join regionalaccount in regionalAccounts
                                             on allAccount.RegionalChainID equals regionalaccount.RegionalChainID
                                             select new { allAccount.LocalChainID, allAccount.LocalChainName, allAccount.SAPLocalChainID, allAccount.RegionID, allAccount.RegionalChainID, allAccount.NationalChainID }).DistinctBy(i => i.LocalChainID).ToList();

                        allGeoBasedAccounts.AddRange(localAccounts.Select(i => new TreeViewItem() { Id = i.LocalChainID + 30000, Text = i.LocalChainName, Value = DPSG.Portal.Framework.Types.AccountType.Local.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.LocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPLocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.LocalChainName, ParentId = i.RegionalChainID + 20000 }));



                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }
            return allGeoBasedAccounts.OrderBy(i => i.Text).ToList();
        }


        public static List<TreeViewItem> GetAllLocalBCAccount(string bcregionJSON)
        {
            List<TreeViewItem> allLocalAccounts = null;

            try
            {
                if (!string.IsNullOrEmpty(bcregionJSON))
                {

                    List<DPSG.Portal.Framework.Types.BCRegion> lstbcregion = JSONSerelization.Deserialize<List<DPSG.Portal.Framework.Types.BCRegion>>(bcregionJSON);

                    if (lstbcregion != null)
                    {
                        string[] bcregionids = lstbcregion.Select(i => Convert.ToString(i.RegionID)).ToArray();

                        List<CustomLocationChain> allLocallocationAccounts = UserProfileRepository.GetAllBCAccounts().Where(i => bcregionids.Contains(i.BCRegionID.ToString()) && i.NationalChainName == CommonConstants.ALL_OTHER && i.RegionalChainName == CommonConstants.ALL_OTHER).ToList();

                        allLocalAccounts = new List<TreeViewItem>();

                        allLocalAccounts.AddRange(allLocallocationAccounts.Select(i => new TreeViewItem() { Id = i.LocalChainID, Text = i.LocalChainName, Value = DPSG.Portal.Framework.Types.AccountType.Local.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.LocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPLocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.LocalChainName, ParentId = i.RegionalChainID }));

                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }
            return allLocalAccounts.OrderBy(i => i.Text).ToList();
        }

        

        #endregion

        public static List<Persona> GetUserPersona(string GSN)
        {

            List<Persona> lstUserPersona = null;
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {

                    lstUserPersona = db.GetUserPersonaByGSN(GSN).Select(c => new Persona()
                        {
                            PersonaID = c.PersonaID,
                            PersonaName = c.PersonaName,
                            PortalRoleID = (int)c.PortalRoleID,
                            PortalRoleName = c.PortalRoleName,
                            PortalRolePrecedence = (int)c.Precedence,
                            PortalRoleShortName=c.PortalShortName
                            
                        })
                        .ToList();

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING User Persona USING METHOD GetUserPersona() FROM SDM IN USERPROFILEREPOSITORY CLASS FOR MY PREF", ex);
            }

            return lstUserPersona;

        }
        public static Persona GetPersonaInfoByID(string GSN, int personaID)
        {

            Persona currentPersona = null;
            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {

                    currentPersona = db.GetUserPersonaByGSN(GSN).Where(i => i.PersonaID == personaID).Select(c => new Persona()
                       {
                           PersonaID = c.PersonaID,
                           PersonaName = c.PersonaName,
                           PortalRoleID = (int)c.PortalRoleID,
                           PortalRoleName = c.PortalRoleName,
                           PortalRolePrecedence = (int)c.Precedence,
                           PortalRoleShortName=c.PortalShortName
                       })
                       .ToList().FirstOrDefault();

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING BC REGIONS USING METHOD GetUserPersona() FROM SDM IN USERPROFILEREPOSITORY CLASS FOR MY PREF", ex);
            }

            return currentPersona;

        }

        #region Supply Chain
       
        public static List<Plants> GetAllPlantsName()
        {
            List<Plants> objPlantsName = new List<Plants>();
            try
            {
                if (CacheHelper.GetCacheValue(CommonConstants.SUPPLY_CHAIN_PLANT_KEY) != null)
                    objPlantsName = CacheHelper.GetCacheValue(CommonConstants.SUPPLY_CHAIN_PLANT_KEY) as List<Plants>;
                else
                {
                    using (UserProfileModel objDB = new UserProfileModel(GetConnectionString()))
                    {
                        objPlantsName = objDB.Plants.Where(i=>i.Active==true).Select(i => new Plants() { PlantID = i.PlantID, PlantName = i.PlantDesc }).ToList();
                    }
                    CacheHelper.SetCacheValue(CommonConstants.SUPPLY_CHAIN_PLANT_KEY, objPlantsName, 24);
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(ex.Message, ex);
            }
            return objPlantsName;
        }

        public static List<Measurs> GetMeasursType(int DepartmentID)
        {
            List<Measurs> objMeasurs = new List<Measurs>();
            try
            {
                if (CacheHelper.GetCacheValue(CommonConstants.SUPPLY_CHAIN_MANUFACTURE_MYSETTING_KEY) != null)
                    objMeasurs = CacheHelper.GetCacheValue(CommonConstants.SUPPLY_CHAIN_MANUFACTURE_MYSETTING_KEY) as List<Measurs>;
                else
                {
                    using (UserProfileModel objDB = new UserProfileModel(GetConnectionString()))
                    {
                        objMeasurs = objDB.MeasursTypes.Select(i => new Measurs() { MeasursID = i.MeasursID, DeptID = i.DeptID, MeasursType = i.MeasursType1 }).Where(i => i.DeptID == DepartmentID).ToList();
                    }
                    CacheHelper.SetCacheValue(CommonConstants.SUPPLY_CHAIN_MANUFACTURE_MYSETTING_KEY, objMeasurs, 24);
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(ex.Message, ex);
            }
            return objMeasurs;
        }

        public static List<Measurs> GetInventoryMeasursType(int DepartmentID)
        {
            List<Measurs> objMeasurs = new List<Measurs>();
            try
            {
                if (CacheHelper.GetCacheValue(CommonConstants.SUPPLY_CHAIN_INVENTORY_MYSETTING_KEY) != null)
                    objMeasurs = CacheHelper.GetCacheValue(CommonConstants.SUPPLY_CHAIN_INVENTORY_MYSETTING_KEY) as List<Measurs>;
                else
                {
                    using (UserProfileModel objDB = new UserProfileModel(GetConnectionString()))
                    {
                        objMeasurs = objDB.MeasursTypes.Select(i => new Measurs() { MeasursID = i.MeasursID, DeptID = i.DeptID, MeasursType = i.MeasursType1 }).Where(i => i.DeptID == DepartmentID).ToList();
                    }
                    CacheHelper.SetCacheValue(CommonConstants.SUPPLY_CHAIN_INVENTORY_MYSETTING_KEY, objMeasurs, 24);
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(ex.Message, ex);
            }
            return objMeasurs;
        }

        public static List<CustomLocationChain> GetLocationAccountsForSupplyChainTreeView(List<DPSG.Portal.Framework.Types.Branch> objlstBranch)
        {
            try
            {
                string brancIds = string.Empty, channelIds = string.Empty, superChannelIds = string.Empty;
                brancIds = string.Join(",", objlstBranch.Select(i => Convert.ToString(i.branchId)).ToArray());
                
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    //Get all the local regional and national chain associated with the account id (parm)
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@BranchIds", Value =!string.IsNullOrEmpty(brancIds)?brancIds:"0" })};
                    var allAccounts = db.ExecuteQuery<CustomLocationChain>("[Playbook].[GetAccountsForLocationSupplyChain]", System.Data.CommandType.StoredProcedure, parm).Distinct().ToList();

                    return allAccounts;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }

        public static List<TreeViewItem> GetAllLocationAccountSupplyChain(string SupplyChainbranchjson)
        {
            List<TreeViewItem> allLocationBasedAccounts = null;

            try
            {
                if (!string.IsNullOrEmpty(SupplyChainbranchjson))
                {

                    List<DPSG.Portal.Framework.Types.Branch> objlstBranch = JSONSerelization.Deserialize<List<DPSG.Portal.Framework.Types.Branch>>(SupplyChainbranchjson);
                    //List<SelectedTreeItem> objlstChannels = lstChannels;
                    if (objlstBranch != null)
                    {
                        string cacheKey = string.Join("", objlstBranch.OrderBy(i => i.branchId).Select(i => Convert.ToString(i.branchId)).ToArray());
                        cacheKey = string.Concat("Account", cacheKey);

                        if (CacheHelper.GetCacheValue(cacheKey) != null)
                        {
                            allLocationBasedAccounts = CacheHelper.GetCacheValue(cacheKey) as List<TreeViewItem>;
                        }
                        else
                        {
                            List<CustomLocationChain> allLocAccounts = UserProfileRepository.GetLocationAccountsForSupplyChainTreeView(objlstBranch);

                            allLocationBasedAccounts = new List<TreeViewItem>();

                            var nationalAccounts = allLocAccounts.Select(i => new { i.NationalChainID, i.NationalChainName, i.SAPNationalChainID, i.BranchID }).DistinctBy(i => i.NationalChainID).ToList();

                            //Add all the National Accounts with ParentID = 0
                            allLocationBasedAccounts.AddRange(nationalAccounts.Select(i => new TreeViewItem() { Id = i.NationalChainID + 10000, Text = i.NationalChainName, Value = DPSG.Portal.Framework.Types.AccountType.National.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.NationalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPNationalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.NationalChainName, ParentId = 0 }));
                            foreach (TreeViewItem item in allLocationBasedAccounts.Where(i => i.Text == "All Other"))
                                item.Text = "Regional Accounts";
                            //Get all the regional accounts
                            var regionalAccounts = (from allAccount in allLocAccounts
                                                    join nationalaccount in nationalAccounts
                                                    on allAccount.NationalChainID equals nationalaccount.NationalChainID
                                                    select new { allAccount.RegionalChainID, allAccount.RegionalChainName, allAccount.BranchID, allAccount.SAPRegionalChainID, allAccount.NationalChainID }).DistinctBy(i => i.RegionalChainID).ToList();
                            allLocationBasedAccounts.AddRange(regionalAccounts.Select(i => new TreeViewItem() { Id = i.RegionalChainID + 20000, Text = i.RegionalChainName, Value = DPSG.Portal.Framework.Types.AccountType.Regional.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.RegionalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPRegionalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.RegionalChainName, ParentId = i.NationalChainID + 10000 }));

                            //Get all the local account

                            var localAccounts = (from allAccount in allLocAccounts
                                                 join regionalaccount in regionalAccounts
                                                 on allAccount.RegionalChainID equals regionalaccount.RegionalChainID
                                                 select new { allAccount.LocalChainID, allAccount.LocalChainName, allAccount.SAPLocalChainID, allAccount.BranchID, allAccount.RegionalChainID, allAccount.NationalChainID }).DistinctBy(i => i.LocalChainID).ToList();

                            allLocationBasedAccounts.AddRange(localAccounts.Select(i => new TreeViewItem() { Id = i.LocalChainID + 30000, Text = i.LocalChainName, Value = DPSG.Portal.Framework.Types.AccountType.Local.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.LocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPLocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.LocalChainName, ParentId = i.RegionalChainID + 20000 }));

                            CacheHelper.SetCacheValue(cacheKey, allLocationBasedAccounts, 4320);
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }
            return allLocationBasedAccounts.OrderBy(i => i.Text).ToList();
        }

        //public static List<TreeViewItem> GetProductLineTreeView(string branchJson)
        //{
        //    List<TreeViewItem> objProductLineTreeViewlst = null;
        //    try
        //    {
        //        if (!string.IsNullOrEmpty(branchJson))
        //        {

        //            List<DPSG.Portal.Framework.Types.Branch> _objlstBranch = JSONSerelization.Deserialize<List<DPSG.Portal.Framework.Types.Branch>>(branchJson);

        //            if (_objlstBranch != null && _objlstBranch.Count > 0)
        //            {
        //                string cacheKey = string.Concat("Product Line", string.Join("", _objlstBranch.Select(i => Convert.ToString(i.branchId)).ToArray()));
        //                if (CacheHelper.GetCacheValue(cacheKey) != null)
        //                {
        //                    objProductLineTreeViewlst = CacheHelper.GetCacheValue(cacheKey) as List<TreeViewItem>;
        //                }
        //                else
        //                {
        //                    List<ProductLineHier> objlstProductLineHier = GetProductLineWithTradmark(_objlstBranch);
        //                    if (objlstProductLineHier != null)
        //                    {
        //                        objProductLineTreeViewlst = new List<TreeViewItem>();

        //                        var ProductLineItems = objlstProductLineHier.DistinctBy(i => i.ProductLineID).ToList();

        //                        objProductLineTreeViewlst.AddRange(ProductLineItems.Select(i => new TreeViewItem() { Id = i.ProductLineID, Text = i.ProductLineName, Value = string.Concat(i.ProductLineID, CommonConstants.SUPPLY_CHAIN_TREE_VIEW_SEPERATOR, CommonConstants.SUPPLY_CHAIN_PRODUCTLINE), SAPValue = string.Concat(i.ProductLineID, CommonConstants.SUPPLY_CHAIN_TREE_VIEW_SEPERATOR, CommonConstants.SUPPLY_CHAIN_PRODUCTLINE, CommonConstants.SUPPLY_CHAIN_TREE_VIEW_SEPERATOR, i.ProductLineID, CommonConstants.SUPPLY_CHAIN_TREE_VIEW_SEPERATOR, i.ProductLineName), ParentId = 0 }));
                                
        //                        var trademarks = (from item in objlstProductLineHier
        //                                          join ProductLineItem in ProductLineItems
        //                                          on item.ProductLineID equals ProductLineItem.ProductLineID
        //                                          select new { item.TradeMarkID, item.SAPTradeMarkID, item.TradeMarkName, item.ProductLineID }).Distinct().ToList();

        //                        objProductLineTreeViewlst.AddRange(trademarks.Select(i => new TreeViewItem() { Id = (i.TradeMarkID + 10000), Value = string.Concat(i.TradeMarkID, CommonConstants.SUPPLY_CHAIN_TREE_VIEW_SEPERATOR, CommonConstants.SUPPLY_CHAIN_TRADEMARK), SAPValue = string.Concat(i.TradeMarkID, CommonConstants.SUPPLY_CHAIN_TREE_VIEW_SEPERATOR, CommonConstants.SUPPLY_CHAIN_TRADEMARK, CommonConstants.SUPPLY_CHAIN_TREE_VIEW_SEPERATOR, i.SAPTradeMarkID, CommonConstants.SUPPLY_CHAIN_TREE_VIEW_SEPERATOR, i.TradeMarkName), Text = i.TradeMarkName, ParentId = i.ProductLineID }));

        //                    }
        //                }
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
        //    }
        //    if (objProductLineTreeViewlst != null)
        //    {
        //        objProductLineTreeViewlst.OrderBy(i => i.Text).ToList();
        //    }
        //    return objProductLineTreeViewlst;
        //}
        public static List<TreeViewItem> GetProductLineTreeView()
        {
            List<TreeViewItem> objProductLineTreeViewlst = null;
            try
            {
               

               
                        string cacheKey = "Supply Chain Product Line TradeMark";
                        if (CacheHelper.GetCacheValue(cacheKey) != null)
                        {
                            objProductLineTreeViewlst = CacheHelper.GetCacheValue(cacheKey) as List<TreeViewItem>;
                        }
                        else
                        {
                            List<ProductLineHier> objlstProductLineHier = GetProductLineWithTradmark();
                            if (objlstProductLineHier != null)
                            {
                                objProductLineTreeViewlst = new List<TreeViewItem>();

                                var ProductLineItems = objlstProductLineHier.DistinctBy(i => i.ProductLineID).ToList();

                                objProductLineTreeViewlst.AddRange(ProductLineItems.Select(i => new TreeViewItem() { Id = i.ProductLineID, Text = i.ProductLineName, Value = string.Concat(i.ProductLineID, CommonConstants.SUPPLY_CHAIN_TREE_VIEW_SEPERATOR, CommonConstants.SUPPLY_CHAIN_PRODUCTLINE), SAPValue = string.Concat(i.ProductLineID, CommonConstants.SUPPLY_CHAIN_TREE_VIEW_SEPERATOR, CommonConstants.SUPPLY_CHAIN_PRODUCTLINE, CommonConstants.SUPPLY_CHAIN_TREE_VIEW_SEPERATOR, i.ProductLineID, CommonConstants.SUPPLY_CHAIN_TREE_VIEW_SEPERATOR, i.ProductLineName), ParentId = 0 }));

                                var trademarks = (from item in objlstProductLineHier
                                                  join ProductLineItem in ProductLineItems
                                                  on item.ProductLineID equals ProductLineItem.ProductLineID
                                                  select new { item.TradeMarkID, item.SAPTradeMarkID, item.TradeMarkName, item.ProductLineID }).Distinct().ToList();

                                objProductLineTreeViewlst.AddRange(trademarks.Select(i => new TreeViewItem() { Id = (i.TradeMarkID + 10000), Value = string.Concat(i.TradeMarkID, CommonConstants.SUPPLY_CHAIN_TREE_VIEW_SEPERATOR, CommonConstants.SUPPLY_CHAIN_TRADEMARK), SAPValue = string.Concat(i.TradeMarkID, CommonConstants.SUPPLY_CHAIN_TREE_VIEW_SEPERATOR, CommonConstants.SUPPLY_CHAIN_TRADEMARK, CommonConstants.SUPPLY_CHAIN_TREE_VIEW_SEPERATOR, i.SAPTradeMarkID, CommonConstants.SUPPLY_CHAIN_TREE_VIEW_SEPERATOR, i.TradeMarkName), Text = i.TradeMarkName, ParentId = i.ProductLineID }));

                            }
                        }
               
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            if (objProductLineTreeViewlst != null)
            {
                objProductLineTreeViewlst.OrderBy(i => i.Text).ToList();
            }
            return objProductLineTreeViewlst;
        }
        //public static List<ProductLineHier> GetProductLineWithTradmark(List<DPSG.Portal.Framework.Types.Branch> objlstBranch)
        //{
        //    List<ProductLineHier> objlstSupplyProductLineHier = null;
        //    try
        //    {
        //        string branchIds = string.Empty;
        //        branchIds = string.Join(",", objlstBranch.Select(i => Convert.ToString(i.branchId)).ToArray());

        //        using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
        //        {
        //            DbParameter[] parm = { (new OAParameter { ParameterName = "@BranchIds", Value = branchIds }) };
        //            objlstSupplyProductLineHier = db.ExecuteQuery<ProductLineHier>("[SupplyChain].[GetProductLineWithTradeMark]", System.Data.CommandType.StoredProcedure, parm).Distinct().ToList();
        //            return objlstSupplyProductLineHier;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        ExceptionHelper.LogException("ERROR: GETTING ALL PRPDUCT LINE FOR TREE VIEW FROM SDM IN PLAYBOOKREPOSITORY CLASS", ex);
        //    }
        //    return objlstSupplyProductLineHier;
        //}
        public static List<ProductLineHier> GetProductLineWithTradmark()
        {
            List<ProductLineHier> objlstSupplyProductLineHier = null;
            try
            {
               
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    objlstSupplyProductLineHier = db.ExecuteQuery<ProductLineHier>("[SupplyChain].[GetProductLineWithTradeMark]", System.Data.CommandType.StoredProcedure, null).Distinct().ToList();
                    return objlstSupplyProductLineHier;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL PRPDUCT LINE FOR TREE VIEW FROM SDM IN PLAYBOOKREPOSITORY CLASS", ex);
            }
            return objlstSupplyProductLineHier;
        }
        // Supply Chain Product Line
        public static List<UserProductLinesItem> GetUserProductLineItems(string GSN, int SPUserProfileID)
        {
            List<UserProductLinesItem> lstUserProductLine = null;
            UserProductLinesItem Productline = null;
            List<UserProductLine> lstproducts = null;

            try
            {
                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    if (SPUserProfileID > 0)
                        lstproducts = db.UserProductLines.Where(i => i.SPUserProfileID == SPUserProfileID).ToList();
                    else
                        lstproducts = db.UserProductLines.Where(i => i.GSN == GSN).ToList();

                    if (lstproducts != null && lstproducts.Count > 0)
                    {
                        lstUserProductLine = new List<UserProductLinesItem>();
                        foreach (UserProductLine productlin in lstproducts)
                        {
                            Productline = new UserProductLinesItem();
                            Productline.ProductLineID = productlin.ProductLineID;
                            Productline.TradeMarkID = productlin.TradeMarkID;
                            Productline.GSN = productlin.GSN;
                            lstUserProductLine.Add(Productline);
                        }
                    }

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING PRODUCT LINE", ex);
            }
            return (lstUserProductLine != null) ? lstUserProductLine : new List<UserProductLinesItem>();
        }

        public static string GetDefaultInvetorySetting(string GSN, int? PersonaID)
        {

            string strDefaultInvSetting = string.Empty;

            try
            {
                using (UserProfileModel objdb = new UserProfileModel(GetConnectionString()))
                {
                    var defaultInventory = (from usrprf in objdb.SPUserProfiles
                                            where usrprf.GSN == GSN && usrprf.PersonaID == PersonaID
                                            select usrprf).FirstOrDefault();

                    if (defaultInventory != null)
                    {
                        strDefaultInvSetting = defaultInventory.DefaultInventoryPref;
                    }
                }

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING Plants INFO FROM SDM IN USERPROFILEREPOSITORY CLASS FOR User:" + GSN, ex);
            }

            return strDefaultInvSetting;
        }

        public static List<TreeViewItem> GetAllLocalAccountSupplyChain(string branchjson)
        {
            List<TreeViewItem> allLocalAccounts = null;

            try
            {
                if (!string.IsNullOrEmpty(branchjson))
                {

                    List<DPSG.Portal.Framework.Types.Branch> objlstBranch = JSONSerelization.Deserialize<List<DPSG.Portal.Framework.Types.Branch>>(branchjson);

                    if (objlstBranch != null)
                    {
                        string cacheKey = string.Join("", objlstBranch.OrderBy(i => i.branchId).Select(i => Convert.ToString(i.branchId)).ToArray());

                        if (CacheHelper.GetCacheValue(cacheKey) != null)
                        {
                            allLocalAccounts = CacheHelper.GetCacheValue(cacheKey) as List<TreeViewItem>;
                        }
                        else
                        {
                            List<CustomLocationChain> allLocallocationAccounts = UserProfileRepository.GetLocalLocationAccountsSupplyChain(objlstBranch);

                            allLocalAccounts = new List<TreeViewItem>();

                            allLocalAccounts.AddRange(allLocallocationAccounts.Select(i => new TreeViewItem() { Id = i.LocalChainID, Text = i.LocalChainName, Value = DPSG.Portal.Framework.Types.AccountType.Local.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.LocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPLocalChainID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.LocalChainName, ParentId = i.RegionalChainID }));

                            CacheHelper.SetCacheValue(cacheKey, allLocalAccounts, 4320);
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }
            return allLocalAccounts.OrderBy(i => i.Text).ToList();
        }

        public static List<CustomLocationChain> GetLocalLocationAccountsSupplyChain(List<DPSG.Portal.Framework.Types.Branch> objlstBranch)
        {
            try
            {
                string brancIds = string.Empty, channelIds = string.Empty, superChannelIds = string.Empty;
                brancIds = string.Join(",", objlstBranch.Select(i => Convert.ToString(i.branchId)).ToArray());

                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    //Get all the local regional and national chain associated with the account id (parm)
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@BranchIds", Value =!string.IsNullOrEmpty(brancIds)?brancIds:"0" })};
                    var allAccounts = db.ExecuteQuery<CustomLocationChain>("[Playbook].[GetLocalAccountsForLocationSupplyChain]", System.Data.CommandType.StoredProcedure, parm).Distinct().ToList();

                    return allAccounts;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ALL ACCOUNTS FOR TREE VIEW FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return null;
        }
        #endregion

        public static List<string> GetAccountsForPromos(string loggedInUser)
        {
            List<string> lstAccounts = new List<string>();
            try
            {

                using (UserProfileModel db = new UserProfileModel(GetConnectionString()))
                {
                    DbParameter[] parm = {(new OAParameter { ParameterName ="@GSN",Value =loggedInUser})};
                    string query = "SELECT ChainTypeID FROM [MSTR].[vREVUserAccountChain] WHERE GSN='"+loggedInUser +"'";
                    lstAccounts = db.ExecuteQuery<string>(query, System.Data.CommandType.Text, parm).ToList();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: GETTING ACCOUNTS FOR PROMOS FROM SDM IN USERPROFILEREPOSITORY CLASS", ex);
            }

            return lstAccounts;
        }
    }
}
