using DPSG.Webapi.Merchandiser.Modal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;

namespace DPSG.Webapi.Merchandiser.DataServices
{
    public class ReportingDS : MerchandiserConnectionWrapper
    {

        public StoreServiceOutput GetStoreServicedReportDS(StoreServiceInput storeSerInput)
        {
            try
            {

                List<StoreService> output = new List<StoreService>();
                StoreServiceOutput obj = new StoreServiceOutput();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@MerchGroupIDs", storeSerInput.MerchGroupIDs),
                                         new SqlParameter("@FromDate",storeSerInput.FromDate),
                                         new SqlParameter("@ToDate", storeSerInput.ToDate)};

                SDMReader reader = this.ExecuteReader(Constants.Reporting.StoredProcedures.GetStoreServiceReport, pars);

                if (reader != null)
                {
                    output = reader.GetResults<StoreService>().ToList();
                }
                obj.StoreServices = output;
                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public UserMerchGroupOutput GetUserMerchGroupsDS(UserMerchGroupInput userGSN)
        {
            try
            {
                List<UserMerchGroup> output = new List<UserMerchGroup>();
                UserMerchGroupOutput obj = new UserMerchGroupOutput();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@GSN", userGSN.UserGSN),
                                       };

                SDMReader reader = this.ExecuteReader(Constants.Reporting.StoredProcedures.GetUserMerchGroups, pars);

                if (reader != null)
                {
                    output = reader.GetResults<UserMerchGroup>().ToList();
                }
                obj.UserMerchGroups = output;
                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public MileageOutput GetMileageReportDS(MileageInput mileageInput)
        {
            try
            {

                List<Mileage> output = new List<Mileage>();
                MileageOutput obj = new MileageOutput();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@MerchGroupIDs", mileageInput.MerchGroupIDs),
                                         new SqlParameter("@FromDate",mileageInput.FromDate),
                                         new SqlParameter("@ToDate", mileageInput.ToDate)
                };

                SDMReader reader = this.ExecuteReader(Constants.Reporting.StoredProcedures.GetMileageReport, pars);

                if (reader != null)
                {
                    output = reader.GetResults<Mileage>().ToList();
                }
                obj.Mileages = output;
                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

    }
}
