using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Portal.BC.Types;
using DPSG.Portal.BC.DAL;
using DPSG.Portal.BC.Common;
using System.Collections;
using System.Reflection;

namespace DPSG.Portal.BC.BAL
{
    public class Sales : Base
    {

        public Types.SalesMaster.SalesMasterDataDetails GetSalesMaster (DateTime? lastModified)
        {
            var results = new Types.SalesMaster.SalesMasterDataDetails();
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                results = oBCRepository.GetSalesMaster(lastModified);
            }
            catch (Exception ex)
            {
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }

            return results;
         }

        public ArrayList GetSalesHierarchyMaster(DateTime? LastModified)
        {
            ArrayList _arrSalesHierarchy = null;
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                _arrSalesHierarchy = oBCRepository.GetSalesHierarchyMaster(LastModified);
                //objServiceLog.Exception = "";
                //oBCRepository.InsertWebServiceLog(objServiceLog);           
            }
            catch(Exception ex)
            {
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }
            return _arrSalesHierarchy;
        }

        public List<Model.BCSalesAccountability> GetSalesAccountability(DateTime? LastModified)
        {
            List<Model.BCSalesAccountability> _lstAccountability = null;

            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                _lstAccountability= oBCRepository.GetSalesAccountablitymaster(LastModified);
                //objServiceLog.Exception = "";
                //oBCRepository.InsertWebServiceLog(objServiceLog);
            }
            catch(Exception ex)
            {
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }
            return _lstAccountability;
        }

    }
}
