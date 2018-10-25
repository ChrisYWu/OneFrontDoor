using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DPSG.Portal.BC.Types.RetailExecution;
using System.Reflection;
using DPSG.Portal.BC.Common;

namespace DPSG.Portal.BC.BAL
{
    public class RetailExecution : Base
    {
        public static StoreExecutionData GetStoreExecutionDetailsByRouteNumber(string RouteNumebr, DateTime? ModifiedDate)
        {
            return DPSG.Portal.BC.DAL.BCRepository.GetStoreExecutionDetailsByRouteNumber(RouteNumebr, ModifiedDate);

        }

        //public static int UploadStoreExecutionDetails(StoreExecution input)
        //{
        //    return DPSG.Portal.BC.DAL.BCRepository.UploadStoreExecutionDetails(input);
        //}

        public int UploadStoreExecutionDetails(StoreExecution input)
        {
            int results;
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                results = oBCRepository.UploadStoreExecutionDetails(input);
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
