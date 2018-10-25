using DPSG.DSDDeliveryService.MyDay.WebAPI.Model;
//using DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Input;
using DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Output;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.DataService
{
    public class DeliveryDataService : MerchConnectionWrapper
    {
        #region All Merch HttpGet methods
        public MasterLists GetMaster()
        {
            MasterLists output = new MasterLists();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = {};
                MerchReader reader = this.ExecuteReader(Constant.StoredProcedureName.GetMaster, pars);

                output.FarawayReasons = reader.GetResults<FarawayReason>().ToList();
                output.ResequenceReasons = reader.GetResults<ResequenceReason>().ToList();
                return output;

            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public DeliveryManifest GetDeliveryManifest(int RouteID, DateTime? DeliveryDateUTC = null)
        {
            DeliveryManifest output = new DeliveryManifest();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@RouteID", RouteID),
                                        new SqlParameter("@DeliveryDateUTC", DeliveryDateUTC),
                                        };
                MerchReader reader = this.ExecuteReader(Constant.StoredProcedureName.GetDeliveryManifest, pars);

                output.Header = reader.GetResults<ManifestHeader>().ToList()[0];
                output.Stops = reader.GetResults<DeliveryStop>().ToList();
                return output;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }


        #endregion

        #region Post
        public void InsertWebAPILog(WebAPILog objServiceLog)
        {
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@ServiceName", objServiceLog.ServiceName),
                                        new SqlParameter("@OperationName", objServiceLog.OperationName),
                                        new SqlParameter("@ModifiedDate", objServiceLog.ModifiedDate),
                                        new SqlParameter("@GSN", objServiceLog.GSN),
                                        new SqlParameter("@Type", objServiceLog.Type),
                                        new SqlParameter("@Exception", objServiceLog.Exception),
                                        new SqlParameter("@GUID", objServiceLog.GUID),
                                        new SqlParameter("@ComputerName", objServiceLog.ComputerName),
                                        new SqlParameter("@UserAgent", objServiceLog.UserAgent),
                                        new SqlParameter("@Json", objServiceLog.Json)
                                       };
                int result = this.ExecuteNonQuery(Constant.StoredProcedureName.InsertWebAPILog, pars);

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally { this.CloseSession(); }
        }

        #endregion

    }
}
