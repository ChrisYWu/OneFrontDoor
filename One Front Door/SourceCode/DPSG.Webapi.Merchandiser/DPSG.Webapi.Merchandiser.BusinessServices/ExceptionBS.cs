using DPSG.Webapi.Merchandiser.DataServices;
using DPSG.Webapi.Merchandiser.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.BusinessServices
{
   public class ExceptionBS
    {
      public MerchExceptionResponse InsertExceptionBS(MerchException merchException)
        {
            ExceptionDS ds = new ExceptionDS();
            return ds.InsertExceptionDS(merchException);
        }
    }
}
