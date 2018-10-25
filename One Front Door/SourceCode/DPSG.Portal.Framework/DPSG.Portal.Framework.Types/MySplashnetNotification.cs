using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class MySplashnetNotification
    {
        public string Status { get; set; }
        public string Description{get;set;}
        public int Count{get;set;}
        public string URL{get;set;}
        public bool read { get; set; }
    }
}
