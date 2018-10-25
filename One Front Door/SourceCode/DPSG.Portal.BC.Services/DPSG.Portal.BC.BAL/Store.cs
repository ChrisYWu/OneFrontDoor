using DPSG.Portal.BC.Common;
using DPSG.Portal.BC.DAL;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using DPSG.Portal.BC.Model;
using Microsoft.SharePoint.Client;
using DPSG.Portal.BC.BAL.DwsSoapClientRef;
using System.Security.Principal;
using System.Diagnostics;
using System.ServiceModel;
using DPSG.Portal.BC.BAL.CopyFileServiceRef;
using System.Configuration;
using System.Web.Configuration;
using DPSG.Portal.BC.BAL.ImageClientRef;

namespace DPSG.Portal.BC.BAL
{
    public class Store : Base
    {

        public ArrayList ReturnStoreTieInsHistoryByRegionID(int RegionID, DateTime? LastModifiedDate)
        {
            
            ArrayList _arrStoreTie = null;
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;
            try
            {
                _arrStoreTie = oBCRepository.GetStoreTieInsHistoryByRegionID(RegionID, LastModifiedDate);
            }
            catch (Exception ex)
            {
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }
            return _arrStoreTie;
        }
        
        public Types.Account.Bottler.AccountDetails GetStoresByBottlerID(int bottlerID, DateTime? lastModifiedDate)
        {
            var results = new Types.Account.Bottler.AccountDetails();

            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                results = oBCRepository.GetStoresByBottlerID(bottlerID, lastModifiedDate);
            }
            catch (Exception ex)
            {
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }
            //return _lstAccount;
            return results;
        }

        public Types.Account.Bottler.AccountDetails GetStoresByRegionID(int regionID, DateTime? lastModifiedDate)
        {
            var results = new Types.Account.Bottler.AccountDetails();

            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                results = oBCRepository.GetStoresByRegionID(regionID, lastModifiedDate);
            }
            catch (Exception ex)
            {
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }

            return results;
        }

        public string RetrunValueByKey(string Format)
        {
            return oBCRepository.ReturnValueByKey(Format);
        }

        public void UploadStoreTieIN(List<Model.StoreCondition> storeCondition, List<Model.StoreConditionDisplay> lstoreConditionDisplay, List<Model.StoreConditionDisplayDetail> lstoreConditionDisplayDetail, List<Model.StoreTieInRate> lstoreTieInRate)
        {
           // oBCRepository.UploadStoreTieIN(storeCondition, lstoreConditionDisplay, lstoreConditionDisplayDetail, lstoreTieInRate);
        }

        private bool IsDwsErrorResult(string ResultFragment)
        {
            System.IO.StringReader srResult = new System.IO.StringReader(ResultFragment);
            System.Xml.XmlTextReader xtr = new System.Xml.XmlTextReader(srResult);
            xtr.Read();
            if (xtr.Name == "Error")
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        private void ParseDwsErrorResult(string ErrorFragment, ref int ErrorID, ref string ErrorMsg)
        {
            System.IO.StringReader srError = new System.IO.StringReader(ErrorFragment);
            System.Xml.XmlTextReader xtr = new System.Xml.XmlTextReader(srError);
            xtr.Read();
            xtr.MoveToAttribute("ID");
            xtr.ReadAttributeValue();
            //ErrorID = xtr.Value;
            ErrorMsg = xtr.ReadString();
        }

        private string ParseDwsSingleResult(string ResultFragment)
        {
            System.IO.StringReader srResult = new System.IO.StringReader(ResultFragment);
            System.Xml.XmlTextReader xtr = new System.Xml.XmlTextReader(srResult);
            xtr.Read();
            return xtr.ReadString();
        }

    }
}
