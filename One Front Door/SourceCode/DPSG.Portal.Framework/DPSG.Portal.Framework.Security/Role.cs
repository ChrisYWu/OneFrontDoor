using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Security
{
    public class UserRole
    {
        private UserRole()
        {
        }

        public string RoleName { get; set; }

        public static Role GetRoleFromString(string RoleName)
        {
            Role role=new Role();
            return role;
        }
    }
}
