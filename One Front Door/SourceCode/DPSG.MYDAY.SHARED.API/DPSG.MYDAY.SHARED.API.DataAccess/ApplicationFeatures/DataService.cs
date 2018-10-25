using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using DTO = DPSG.MYDAY.SHARED.API.Models.ApplicationFeatures;

namespace DPSG.MYDAY.SHARED.API.DataAccess.ApplicationFeatures
{
    public class DataService : DatabaseContextWrapper
    {
        public async Task<DTO.FeatureResults> ApplicationFeatures(string applicationName, string branchId)
        {
            var results = new DTO.FeatureResults();

            try
            {
                CreateSession();
                SqlParameter[] param = { new SqlParameter("@ApplicationName",SqlDbType.VarChar) {Value = applicationName },
                                         new SqlParameter("@BranchId",SqlDbType.VarChar) {Value = branchId }
                                       };

                var reader = await ExecuteReaderAsync("[FocusSKU].[p-websvc-GetApplicationFeatures]", param);
                results.ApplicationFeatureConfigs = reader.GetResults<DTO.FeatureResults.FeatureItemDto>().ToList();

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally { CloseSession(); }

            return results;

        }

        public async Task<DTO.ApplicationVersionResults> ApplicationVersion(string applicationName)
        {
            var results = new DTO.ApplicationVersionResults();
            try
            {
                CreateSession();
                SqlParameter[] param = { new SqlParameter("@ApplicationName",SqlDbType.VarChar) {Value = applicationName }
                    
                };

                var reader = await ExecuteReaderAsync("[Shared].[p-websvc-GetApplicationVersions]", param);
                results.ApplicationVersion = reader.GetResults<DTO.ApplicationVersionResults.AppVersion>().ToList();

            }
            catch (Exception ex)
            {

                throw ex;
            }

            return results;
        }
    }
}
