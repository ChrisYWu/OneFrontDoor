using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using Microsoft.SharePoint;
using Microsoft.SharePoint.Administration;
using DPSG.Portal.Framework.Types;

namespace DPSG.Portal.Framework.Security
{
    public class Utilities
    {
        private static string GetConnectionString()
        {
            //string connectionString = ConfigurationManager.ConnectionStrings["SDMConnectionString"].ConnectionString;
            string connectionString = ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString;
            return connectionString + ";Application Name=be0cb86d-bf57-420e-b941-a581ec2d036b";
        }

        //static IList<UserPermission> userPermissions = null;
        //static IList<RolePermission> rolePermissions = null;
        //static IList<RoleAttribute> roleAttributes = null;
        private Utilities()
        {

        }

        //public static bool CheckAccess(UserInfo UserInfo, int EntityID, int PermissionType)
        //{
        //    bool _result = false;
        //    try
        //    {
        //        if (userPermissions == null)
        //        {
        //            using (DPSG.Portal.Framework.Security.PortalSecurity db = new PortalSecurity(GetConnectionString()))
        //            {
        //                userPermissions = db.UserPermissions.ToList<UserPermission>();
        //                rolePermissions = db.RolePermissions.ToList<RolePermission>();
        //            }
        //        }
        //        if (userPermissions.Where(i => string.Compare(i.GSN, UserInfo.GSN, true) == 0 && i.EntityID == EntityID && i.PermissonTypeID == PermissionType).Count() > 0)
        //            return true;
        //        else
        //        {
        //            if (rolePermissions.Where(i => i.RoleID == UserInfo.PrimaryRoleId && i.EntityID == EntityID && i.PermissonTypeID == PermissionType).Count() > 0)
        //                return true;
        //            else
        //                return false;
        //        }



        //        //using (DPSG.Portal.Framework.Security.PortalSecurity db = new PortalSecurity(GetConnectionString()))
        //        //{
        //        //    #region Check in UserPermission
        //        //    var keys = from o in db.UserPermissions
        //        //               where o.GSN == UserInfo.GSN && o.EntityID == EntityID && o.PermissonTypeID == PermissionType
        //        //               select o;

        //        //    if (keys.Count() > 0)
        //        //    {
        //        //        _result = true;
        //        //    }
        //        //    #endregion

        //        //    #region Check Role Permission
        //        //    else
        //        //    {
        //        //        int id = db.Roles.Where(i => i.RoleName == UserInfo.PrimaryRole.ToString()).First().RoleID;

        //        //        var key = from o in db.RolePermissions
        //        //                  where o.RoleID == id && o.EntityID == EntityID && o.PermissonTypeID == PermissionType
        //        //                  select o;

        //        //        if (key.Count() > 0)
        //        //        {
        //        //            _result = true;
        //        //        }
        //        //    }
        //        //    #endregion
        //        //}
        //    }
        //    catch (Exception ex)
        //    {
        //        _result = false;
        //    }

        //    return _result;
        //}

        //public static string GetRoleAttribute(int roleID, string key)
        //{
        //    try
        //    {
        //        if (roleAttributes == null)
        //        {
        //            using (DPSG.Portal.Framework.Security.PortalSecurity db = new PortalSecurity(GetConnectionString()))
        //            {
        //                roleAttributes = db.RoleAttributes.ToList<RoleAttribute>();
        //            }
        //        }
        //        var value = roleAttributes.Where(i => i.RoleID == roleID && i.Key == key).FirstOrDefault();
        //        if (value != null)
        //        {
        //            return value.KeyValue;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        LogException(ex);
        //    }
        //    return "";
        //}

        private static void LogException(Exception ex)
        {

            SPSecurity.RunWithElevatedPrivileges(delegate()
                {
                    SPDiagnosticsService diagSvc = SPDiagnosticsService.Local;
                    diagSvc.WriteTrace(0, new SPDiagnosticsCategory("DPSG", TraceSeverity.Monitorable, EventSeverity.Error), TraceSeverity.Monitorable, ex.Message + "\n" + ex.Message + "\n" + ex.StackTrace, null);
                });


        }
        public static IList<Types.Account> GetRoleAccount(string gsn)
        {
            using (DPSG.Portal.Framework.Security.PortalSecurity db = new PortalSecurity(GetConnectionString()))
            {
                var sys = from o in db.UserNationalChains
                          join natchain in db.NationalChains on o.NationalChainID equals natchain.NationalChainID
                          where o.GSN.ToUpper() == gsn.ToUpper()
                          select new Types.Account { ChainName = natchain.NationalChainName, ChainId = o.NationalChainID };

                return sys.ToList<Types.Account>();


            }
        }

        //public static IList<DPSG.Portal.Framework.Types.ProgramSystem> GetRoleSystem(string roleShortName)
        //{
        //    using (DPSG.Portal.Framework.Security.PortalSecurity db = new PortalSecurity(GetConnectionString()))
        //    {
        //        var sys = from o in db.RoleSystems
        //                  join role in db.Roles on o.RoleID equals role.RoleID
        //                  join system in db.Systems on o.SystemID equals system.SystemID
        //                  where role.RoleShortName == roleShortName
        //                  select new Types.ProgramSystem { Disabled = o.Disabled ?? false, Name = system.SystemName, ID = o.SystemID, SequenceID = system.Sequence };

        //        return sys.ToList<Types.ProgramSystem>().OrderBy(i=> i.SequenceID).ToList();


        //    }
        //}
    }
}
