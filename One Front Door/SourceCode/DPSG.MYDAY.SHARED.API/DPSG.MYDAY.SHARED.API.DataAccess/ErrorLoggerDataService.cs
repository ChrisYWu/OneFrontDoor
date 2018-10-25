using DPSG.MYDAY.SHARED.API.Models;
using System;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace DPSG.MYDAY.SHARED.API.DataAccess
{
    public class ErrorLoggerDataService : DatabaseContextWrapper
    {
        public async Task LogErrorsAsync(ServiceLog objServiceLog, string json = null)
        {
            try
            {
                CreateSession();
                SqlParameter[] pars = { new SqlParameter("@ServiceName", objServiceLog.ServiceName),
                                        new SqlParameter("@OperationName", objServiceLog.OperationName),
                                        new SqlParameter("@ModifiedDate", objServiceLog.ModifiedDate),
                                        new SqlParameter("@GSN", objServiceLog.GSN),
                                        new SqlParameter("@Type", objServiceLog.Type),
                                        new SqlParameter("@Exception", objServiceLog.Exception),
                                        new SqlParameter("@GUID", objServiceLog.GUID),
                                        new SqlParameter("@ComputerName", objServiceLog.ComputerName),
                                        new SqlParameter("@UserAgent", objServiceLog.UserAgent),
                                        new SqlParameter("@Json", string.IsNullOrEmpty(json) ? objServiceLog.Json : json)
                                       };
                await ExecuteNonQueryAsync("[BCMYDAY].pSaveServiceLog", pars);

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally { CloseSession(); }
        }
    }
}
