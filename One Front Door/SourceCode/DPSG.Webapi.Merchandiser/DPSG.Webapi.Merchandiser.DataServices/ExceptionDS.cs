using DPSG.Webapi.Merchandiser.Model;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.DataServices
{
   public class ExceptionDS : MerchandiserConnectionWrapper
    {
        public MerchExceptionResponse InsertExceptionDS(MerchException merchException)
        {
            MerchExceptionResponse output = new MerchExceptionResponse();

            int statusVal;
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@AppliationID", merchException.AppliationID),
                                        new SqlParameter("@SeverityID", merchException.SeverityID),
                                        new SqlParameter("@Source", merchException.Source),
                                        new SqlParameter("@UserName", merchException.UserName),
                                        new SqlParameter("@Detail", merchException.Detail),
                                        new SqlParameter("@StackTrace", merchException.StackTrace)};

                statusVal = this.ExecuteNonQuery(Constants.Exception.StoredProcedures.InsertExceptions, pars);
                output.SqlReturnCode = statusVal;
            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }

            return output;
        }
    }
}
