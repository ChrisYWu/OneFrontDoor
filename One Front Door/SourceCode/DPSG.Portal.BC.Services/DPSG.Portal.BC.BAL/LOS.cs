using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Portal.BC.Types;
using DPSG.Portal.BC.DAL;
using DPSG.Portal.BC.Common;
using System.Collections;
using System.Reflection;

namespace DPSG.Portal.BC.BAL
{
   public class LOS : Base
    {        
        public ArrayList GetLOSMasterData(DateTime? LastModifiedDate)
        {
            ArrayList _arrLOSMastr = null;
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                _arrLOSMastr= oBCRepository.GetLosMasterDetails(LastModifiedDate);
            }
            catch(Exception ex)
            {
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }
            return _arrLOSMastr;
        }
    }
}
