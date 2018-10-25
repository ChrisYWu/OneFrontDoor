using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace DPSG.Portal.Framework
{
    public static class ConnectionStrings
    {
        public static string PlaybookConnectionString 
        { 
            get {
                string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString + ";App=Playbook";
                return connectionString; 
            } 
        }
        public static string NationalAccountConnectionString
        {
            get
            {
                string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString + ";App=NA";
                return connectionString;
            }
        }

        public static string SecurityConnectionString
        {
            get
            {
                string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString + ";App=Security";
                return connectionString;
            }
        }

        public static string BCConnectionString
        {
            get
            {
                string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString + ";App=A058ACA8-1DC1-47BF-8B52-6E96DDC0E9F6";
                return connectionString;
            }
        }

    }
}
