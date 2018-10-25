using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Portal.BC.Types;
using DPSG.Portal.BC.Common;
using System.Reflection;
using DPSG.Portal.BC.DAL;

namespace DPSG.Portal.BC.BAL
{

    public class Base
    {
        
        private BCRepository _bcrepository;

        public BCRepository oBCRepository
        {
            get
            {
                if (_bcrepository == null)
                    _bcrepository = new BCRepository();

                return _bcrepository;
            }
        }

        private ServiceLog _servicelog;

        public ServiceLog objServiceLog
        {
            get
            {
                if (_servicelog == null)
                {
                    _servicelog = new ServiceLog();
                }
                return _servicelog;
            }
        }

        //protected string GSN { get; set; }

        string gsn = "";
        protected string GSN
        {
            get
            {
                if (gsn == "")
                {
                    try
                    {
                        gsn = System.Web.HttpContext.Current.Request.UserAgent.Split(',')[4];
                    }
                    catch { }
                }
                return gsn;
            }
        }

        string userAgent = "";
        protected string UserAgent
        {
            get
            {
                if (userAgent == "")
                {
                    try
                    {
                        userAgent = System.Web.HttpContext.Current.Request.UserAgent.ToString();
                    }
                    catch { }
                }
                return userAgent;
            }
        }


        public Base()
        {           
            
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.UserAgent = UserAgent;
            objServiceLog.Type = "Info";
            objServiceLog.Exception = "";
            objServiceLog.GUID = ServiceContext.CallID;
            objServiceLog.ComputerName = Environment.MachineName;
            

            // Disabled default autolog every exeuction on the base inhereited class
            // All Exceptions will be logged
            // WILTX006 4_13_2016
            //oBCRepository.InsertWebServiceLog(objServiceLog);            
        }

        public static string GetException(Exception ex)
        {
            if (ex.InnerException != null)
            {
                return string.Format("{0} > {1} ", ex.Message, GetException(ex.InnerException));
            }
            else
            {
                string retval = ex.Message;
                if (retval == "Object reference not set to an instance of an object.")
                {
                    retval = retval + "Stack Trace:" + ex.StackTrace;
                }
                return retval;
            }
        }
    }
}
