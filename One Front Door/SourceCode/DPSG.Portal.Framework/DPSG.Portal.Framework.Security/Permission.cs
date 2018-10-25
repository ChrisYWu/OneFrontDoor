using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Security
{
    public class Permission
    {
        private Permission()
        {
        }

        public string  PermissionName { get; set; }

        public static Permission GetPermissionFromString(string PermissionName)
        {
            Permission permission=new Permission();
            return permission;
        }
    }
}
