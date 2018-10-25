using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class AppointmentInfo
    {
    
        public string ID
        {
            get;
            set;
        }

        public string Subject
        {
            get;
            set;
        }

        public DateTime StartDate
        {
            get;
            set;
        }

        public DateTime EndDate
        {
            get;
            set;
        }
        
    }
}
