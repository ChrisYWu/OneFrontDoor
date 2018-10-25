using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.BC.Common
{
    public static class ServiceContext
    {
        private static string callId;
        static ServiceContext()
        {            
            callId = (Guid.NewGuid()).ToString();
        }

        public static string CallID
        {
            get
            {
                return callId;
            }
        }

        public static string RequestInputBody;
    }
}
