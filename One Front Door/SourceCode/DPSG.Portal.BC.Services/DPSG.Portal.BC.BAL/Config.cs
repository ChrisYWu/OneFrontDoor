using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using DPSG.Portal.BC.Common;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.BAL
{
    public class Config : Base
    {
        public Types.Config.BCMYDAY.ConfigValuesResults GetConfigurationValues()
        {

            var results = new Types.Config.BCMYDAY.ConfigValuesResults();
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                results = oBCRepository.GetConfigurationValues();
            }
            catch (Exception ex)
            {
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }

            return results;
        }
    }
}
