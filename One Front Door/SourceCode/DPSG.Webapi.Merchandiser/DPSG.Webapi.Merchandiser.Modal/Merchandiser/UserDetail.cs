using DPSG.Webapi.Merchandiser.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.Modals
{

    public class UserDetailOutput : IResponseInformation
    {
        UserDetail userInfo;        
        public UserDetail UserInfo
        {
            get { return userInfo; }
            set { userInfo = value; }
        }

        public List<MerchBranch> Branches { get; set; }
        public List<MerchGroup> Groups { get; set; }

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

   public class UserDetail 
    {
        public string GSN { get; set; } 
        public string Email { get; set; }
        public string Name { get; set; }
        public int IsValid { get; set; }
        public Boolean IsAuthorized { get; set; }
      

    }


}
