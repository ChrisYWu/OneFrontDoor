using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Portal.BC.Types;
using DPSG.Portal.BC.DAL;
using DPSG.Portal.BC.Common;
using System.Collections;
using System.Reflection;
using System.Data;

namespace DPSG.Portal.BC.BAL
{
    public class IPE : Base
    {
        public Types.IPE.Programs.MarketingProgramResults GetMarketingPrograms(DateTime? lastModified)
        {
            var results = new Types.IPE.Programs.MarketingProgramResults();
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                results = oBCRepository.GetMarketingPrograms(lastModified);
            }
            catch (Exception ex)
            {
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }

            return results;
        }

        public Types.IPE.Bottler.IpeBottlerDataResults GetIpeBottlers(string type, string typeValue)
        {
            var results = new Types.IPE.Bottler.IpeBottlerDataResults();
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                results = oBCRepository.GetIpeBottlers(type, typeValue);
            }
            catch (Exception ex)
            {
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }

            return results;
        }

        public Types.IPE.SurveyData.SurveyHistoryResults GetIpeSurveyHistory(string type, string typeValue, DateTime? lastModified)
        {
            var results = new Types.IPE.SurveyData.SurveyHistoryResults();
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                results = oBCRepository.GetIpeSurveyHistory(type, typeValue, lastModified);
            }
            catch (Exception ex)
            {
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }

            return results;
        }
        
        //public Types.IPE.SurveyData.SurveyHistoryResults GetIpeSurveyHistoryByRegionID(int regionID, DateTime? lastModified)
        //{
        //    var results = new Types.IPE.SurveyData.SurveyHistoryResults();
        //    objServiceLog.ServiceName = Constants.SERVICE_NAME;
        //    objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
        //    objServiceLog.ModifiedDate = System.DateTime.Now;
        //    objServiceLog.GSN = GSN;
        //    objServiceLog.Type = "Info";
        //    objServiceLog.GUID = ServiceContext.CallID;

        //    try
        //    {
        //        results = oBCRepository.GetIpeSurveyHistoryByRegionID(regionID, lastModified);
        //        //objServiceLog.Exception = "";
        //        // oBCRepository.InsertWebServiceLog(objServiceLog);
        //    }
        //    catch (Exception ex)
        //    {
        //        objServiceLog.Exception = GetException(ex);
        //        oBCRepository.InsertWebServiceLog(objServiceLog);
        //        throw ex;
        //    }

        //    return results;
        //}

        public Types.IPE.SurveyData.SurveyDataResults GetIpeSurvey(string type, string typeValue, int responderID)
        {
            var results = new Types.IPE.SurveyData.SurveyDataResults();
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                results = oBCRepository.GetIpeSurvey(type, typeValue, responderID);
                //objServiceLog.Exception = "";
                // oBCRepository.InsertWebServiceLog(objServiceLog);
            }
            catch (Exception ex)
            {
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }

            return results;
        }

        //public Types.IPE.SurveyData.SurveyDataResults GetIpeSurveyByRegionID(int regionID, int responderID)
        //{
        //    var results = new Types.IPE.SurveyData.SurveyDataResults();
        //    objServiceLog.ServiceName = Constants.SERVICE_NAME;
        //    objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
        //    objServiceLog.ModifiedDate = System.DateTime.Now;
        //    objServiceLog.GSN = GSN;
        //    objServiceLog.Type = "Info";
        //    objServiceLog.GUID = ServiceContext.CallID;

        //    try
        //    {
        //        results = oBCRepository.GetIpeSurveyByRegionID(regionID, responderID);
        //        //objServiceLog.Exception = "";
        //        // oBCRepository.InsertWebServiceLog(objServiceLog);
        //    }
        //    catch (Exception ex)
        //    {
        //        objServiceLog.Exception = GetException(ex);
        //        oBCRepository.InsertWebServiceLog(objServiceLog);
        //        throw ex;
        //    }

        //    return results;
        //}

        public Types.IPE.MasterData.IpeMasterDataDetails GetIpeMaster()
        {
            var results = new Types.IPE.MasterData.IpeMasterDataDetails();
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                results = oBCRepository.GetIpeMaster();
                //objServiceLog.Exception = "";
                // oBCRepository.InsertWebServiceLog(objServiceLog);
            }
            catch (Exception ex)
            {
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }

            return results;
        }

        public Types.IPE.ResponseData.EventResponseDataDetails UploadIpeSurveyEventResponses(DataTable dataTable, string applicationType)
        {
            var results = new Types.IPE.ResponseData.EventResponseDataDetails();
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                results = oBCRepository.UploadIpeSurveyEventResponses(dataTable, applicationType);
                //objServiceLog.Exception = "";
                // oBCRepository.InsertWebServiceLog(objServiceLog);
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
