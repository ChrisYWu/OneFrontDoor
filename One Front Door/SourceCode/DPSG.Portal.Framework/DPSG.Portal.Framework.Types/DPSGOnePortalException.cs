/// <summary>
/*  Module Name         : One Portal Exception Types
 *  Purpose             : Provide the One Portal Exception Types 
 *  Created Date        : 04-Feb-2013
 *  Created By          : Himanshu Panwar
 *  Last Modified Date  : 04-Feb-2013
 *  Last Modified By    : 04-Feb-2013
 *  Where to use        : In One Portal 
 *  Dependency          : 
*/
/// </summary>

#region using

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

#endregion

namespace DPSG.Portal.Framework.Types
{
    public class DPSGOnePortalException : Exception
    {
        public DPSGOnePortalException():base()
        { }

        public DPSGOnePortalException(string message)
            : base(message)
        { }
        public DPSGOnePortalException(string message, Exception InnerException)
            : base(message,InnerException)
        { }


        private string _errorCode;
        private string _errorDescription;
        private string _errorMessage;

        public string ErrorCode
        {
            get { return _errorCode; }
            set { _errorCode = value; }
        }
        public string ErrorDescription
        {
            get { return _errorDescription; }
            set { _errorDescription = value; }
        }
        public string ErrorMessage
        {
            get { return _errorMessage; }
            set { _errorMessage = value; }
        }
    }
}
