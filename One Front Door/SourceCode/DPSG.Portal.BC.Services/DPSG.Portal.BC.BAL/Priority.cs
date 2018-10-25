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
using DPSG.Portal.BC.Types.Priority;

namespace DPSG.Portal.BC.BAL
{
    public class Priority : Base
    {
        public Types.Priority.PriorityQuestionsResults GetPriorityQuestionsByRegionID(int regionID, DateTime? lastModifiedDate)
        {
            var results = new Types.Priority.PriorityQuestionsResults();

            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;
            try
            {
                results = oBCRepository.GetPriorityQuestionsByRegionID(regionID, lastModifiedDate);
            }
            catch (Exception ex)
            {
                //DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "DPSG.Portal.BC.BAL.Priority.GetPriorityQuestionsByRegionID");
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }
            return results;
        }
    }
}
