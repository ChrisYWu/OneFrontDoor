using DPSG.Portal.BC.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.BAL
{
    public class CDE:Base
    {
        public Types.CDE.AssetDetails GetAssetDetail(string routeNumber)
        {
            var results = new Types.CDE.AssetDetails();
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                results = oBCRepository.GetAssetDetail(routeNumber);
                //objServiceLog.Exception = "";
                //oBCRepository.InsertWebServiceLog(objServiceLog);
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
