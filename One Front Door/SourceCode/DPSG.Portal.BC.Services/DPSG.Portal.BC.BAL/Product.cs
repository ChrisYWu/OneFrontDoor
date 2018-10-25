using DPSG.Portal.BC.Common;
using System;
using System.Reflection;

namespace DPSG.Portal.BC.BAL
{
    public class Product:Base
    {
        public Types.Product.ProductHierarchyDetails GetProductHierarchyDetails(DateTime? lastModifiedDate)
        {
            var results = new Types.Product.ProductHierarchyDetails();
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                results = oBCRepository.GetProductHeirarchyDetails(lastModifiedDate);
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
