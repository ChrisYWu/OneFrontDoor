/// <summary>
/*  Module Name         : One Portal Error Types
 *  Purpose             : Provide the Error Messages and Codes for One Portal 
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

namespace DPSG.Portal.Framework.Types.Constants
{
    public static class ErrorInfo
    {
        public static readonly string ErrorCodeGeneric = "50001";
        public static readonly string ErrorMessageGeneric = "An unknown error has occured. Please review ULS logs.";

        public static readonly string ErrorCodeDefaultBranchNotFound = "50002";
        public static readonly string ErrorMessageDefaultBranchNotFound = "Please select a default branch.";

        public static readonly string ErrorCodeMalformedURL = "50003";
        public static readonly string ErrorMessageMalformedURL = "Please correct the URL";

        public static readonly string ErrorCodeBMConfigEntryMissing = "50004";
        public static readonly string ErrorMessageBMConfigEntryMissing = "Config Entry Missing. Please check BM Config entries";

        public static readonly string ErrorCodeWebConfigEntryMissing = "50005";
        public static readonly string ErrorMessageWebConfigEntryMissing = "Web.Config Entry Missing. Please check Web.Config entries";

        public static readonly string ErrorCodeSoapFault = "50006";
        public static readonly string ErrorMessageSoapFault = "An unknown error has ocuured while consuming remote service. Please review ULS logs.";

        public static readonly string ErrorCodeListAccessError = "50008";
        public static readonly string ErrorMessageListAccessError = "Unable to access the list ";

        public static readonly string ErrorCodeCacheAccessError = "50009";
        public static readonly string ErrorMessageCacheAccessError = "Unable to access the cache ";

        public static readonly string ErrorCodeAssemblyInfoError = "50010";
        public static readonly string ErrorMessageAssemblyInfoError = "Unable to access AssemblyFileVersion ";

        public static readonly string ErrorCodeBranchUnavailable = "50011";
        public static readonly string ErrorMessageBranchUnavailable = "The selected branch is unavailable. Please select a different branch.";

        public static readonly string ErrorCodeUserProfileGetError = "50012";
        public static readonly string ErrorMessageUserProfileGetError = "There is an error in getting user profile property. Please try again later.";

        public static readonly string ErrorCodeUserProfileSetError = "50013";
        public static readonly string ErrorMessageUserProfileSetError = "There is an error in updating user profile property. Please try again later.";
    }
}
