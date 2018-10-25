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
    public class Bottler : Base
    {
        public Types.BottlerHierarchy.BotttlerHierarchyDataDetails GetBottlerHierarchyDetails(DateTime? lastModifiedDate)
        {
            var results = new Types.BottlerHierarchy.BotttlerHierarchyDataDetails();
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                results = oBCRepository.GetBottlerHierarchy(lastModifiedDate);
            }
            catch (Exception ex)
            {
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }

            return results;
        }
        
        public List<Model.Bottler> GetBottler(DateTime? LastModified)
        {
            List<Model.Bottler> _lstbottler = null;

            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                _lstbottler = oBCRepository.GetBottler(LastModified);
                //objServiceLog.Exception = "";
                //oBCRepository.InsertWebServiceLog(objServiceLog);
            }
            catch (Exception ex)
            {
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }

            return _lstbottler;
        }
             
    }
}
