

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Webapi.Merchandiser.Model
{
    public class MerchException
    {
        int appliationID;

        public int AppliationID
        {
            get { return appliationID; }
            set { appliationID = value; }
        }
        int severityID;

        public int SeverityID
        {
            get { return severityID; }
            set { severityID = value; }
        }
        string source;

        public string Source
        {
            get { return source; }
            set { source = value; }
        }
        string userName;

        public string UserName
        {
            get { return userName; }
            set { userName = value; }
        }
        string detail;

        public string Detail
        {
            get { return detail; }
            set { detail = value; }
        }
        string stackTrace;

        public string StackTrace
        {
            get { return stackTrace; }
            set { stackTrace = value; }
        }

        string lastModified;
        public string LastModified
        {
            get { return lastModified; }
            set { lastModified = value; }
        }
    }

    public class MerchExceptionResponse : IResponseInformation
    {
        int sqlReturnCode;
        public int SqlReturnCode
        {
            get { return sqlReturnCode; }
            set { sqlReturnCode = value; }
        }
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }
}
