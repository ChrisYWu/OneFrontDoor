using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DPSG.Portal.BC.BAL;
using DPSG.Portal.BC.Common;
using System.Collections;
using DPSG.Portal.BC.Model;
using System.Net;
using System.IO;
using DPSG.Portal.Framework.CommonUtils;
using System.Reflection;
using System.Text;
using System.Diagnostics;
using DPSG.Portal.BC.Services.DataContract.RetailExecution;

namespace DPSG.Portal.BC.Services.OperationContract.ServiceWrapper
{
    public class RetailExecution
    {
        public static DataContract.RetailExecution.StoreExecutionData GetStoreExecutionDetailsByRouteNumber(string RouteNumber, DateTime? LastModifiedDate)
        {

            Types.RetailExecution.StoreExecutionData spData = DPSG.Portal.BC.BAL.RetailExecution.GetStoreExecutionDetailsByRouteNumber(RouteNumber, LastModifiedDate);
            DataContract.RetailExecution.StoreExecutionData data = new DataContract.RetailExecution.StoreExecutionData();
            data.StoreExecution = spData.StoreExecution;
            data.StoreExecutionDisplay = spData.StoreExecutionDisplay;
            return data;
        }

        //public static int UploadStoreExecutionDetails(string json)
        //{
        //    Types.RetailExecution.StoreExecution input = null;

        //    try
        //    {
        //        input = JSONSerelization.Deserialize<Types.RetailExecution.StoreExecution>(json);  //for deserialization
        //    }
        //    catch (Exception ex)
        //    {
        //        DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "UploadStoreExecutionDetails");
        //        throw ex;
        //    }

        //    return DPSG.Portal.BC.BAL.RetailExecution.UploadStoreExecutionDetails(input);
        //}

        public static int UploadStoreExecutionDetails(string json)
        {
            var input = new Types.RetailExecution.StoreExecution();
            var obj = new BAL.RetailExecution();

            input = JSONSerelization.Deserialize<Types.RetailExecution.StoreExecution>(json);  //for deserialization
            int results = obj.UploadStoreExecutionDetails(input);
            return results;

        }

        //public static DataContract.IPE.SurveyDataResults GetIpeSurvey(string type, string typeValue, int responderID)
        //{
        //    var obj = new BAL.IPE();
        //    Types.IPE.SurveyData.SurveyDataResults data = obj.GetIpeSurvey(type, typeValue, responderID);
        //    var results = new DataContract.IPE.SurveyDataResults();

        //    results.EventQuestionDates = data.EventQuestionDates;
        //    results.EventBottlerPhase = data.EventBottlerPhase;

        //    return results;
        //}

    }
}