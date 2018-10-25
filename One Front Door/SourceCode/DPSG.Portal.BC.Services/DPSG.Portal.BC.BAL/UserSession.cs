using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Reflection;
using DPSG.Portal.BC.DAL;

namespace DPSG.Portal.BC.BAL
{
    public class UserSession
    {
        private BCRepository _bcrepository;
        public BCRepository oBCRepository
        {
            get
            {
                if (_bcrepository == null)
                    _bcrepository = new BCRepository();

                return _bcrepository;
            }
        }

        public void InsertUserSessionInfo(string GSN, string SessionID, DateTime ExpiryDate)
        {
            try
            {
                oBCRepository.InsertUserSession(GSN, SessionID, ExpiryDate);
            }
            catch (Exception ex)
            {
            }
        }

        public bool ValidateUserSession(string GSN, string SessionID)
        {
            string _returnSDMId = string.Empty;
            try
            {
                _returnSDMId = oBCRepository.GetUserSession(GSN, SessionID);
                if (_returnSDMId != null && _returnSDMId != "")
                    return true;
            }
            catch (Exception ex)
            {
                return false;
            }
            return false;
        }
    }
}
