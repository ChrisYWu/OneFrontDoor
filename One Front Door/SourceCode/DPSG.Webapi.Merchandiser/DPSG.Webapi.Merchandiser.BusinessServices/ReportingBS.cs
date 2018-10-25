using DPSG.Webapi.Merchandiser.DataServices;
using DPSG.Webapi.Merchandiser.Modal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.BusinessServices
{
   public class ReportingBS
    {

        public StoreServiceOutput GetStoreServicedReportBS(StoreServiceInput storeSerInput)
        {
            // Data service Inststance
            ReportingDS ds = new ReportingDS();
            return ds.GetStoreServicedReportDS(storeSerInput);
        }

        public UserMerchGroupOutput GetUserMerchGroupsBS(UserMerchGroupInput userGSN)
        {
            // Data service Inststance
            ReportingDS ds = new ReportingDS();
            return ds.GetUserMerchGroupsDS(userGSN);
        }

        public MileageOutput GetMileageReportBS(MileageInput mileageInput)
        {
            // Data service Inststance
            ReportingDS ds = new ReportingDS();
            return ds.GetMileageReportDS(mileageInput);
        }

    }
}
