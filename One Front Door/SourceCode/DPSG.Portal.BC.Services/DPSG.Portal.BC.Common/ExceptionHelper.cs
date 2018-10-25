using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace DPSG.Portal.BC.Common
{
    public class ExceptionHelper
    {
        public static void LogException(Exception ex, string Operation)
        {
            //string LogWarning = System.Configuration.ConfigurationSettings.AppSettings.Get("LogWarning");
            //if (LogWarning == "1")
            AddToLog(ex.Message, Operation, ex);
        }

        public static void LogException(string Message, string Operation)
        {
            try
            {
                string LogWarning = System.Configuration.ConfigurationSettings.AppSettings.Get("LogWarning");
                if (LogWarning == "1")
                    AddToLog(Message, Operation, null);
            }
            catch { }
        }

        private static void AddToLog(string Message, string Operation, Exception ex)
        {
            AddToLogFile(Message, Operation, ex);
        }

        private static void AddToLogFile(string Message, string Operation, Exception ex)
        {
            string fileName = System.Configuration.ConfigurationSettings.AppSettings.Get("LogFileName");
            if (fileName != null && fileName != "")
            {
                using (StreamWriter w = File.AppendText(fileName))
                {
                    if (ex == null)
                        w.Write(ServiceContext.CallID + "\t" + DateTime.Now + "\t" + Operation + "\t" + Message + "\r\n");
                    else
                        w.Write(ServiceContext.CallID + "\t" + DateTime.Now + "\t" + Operation + "\t" + Message + "\t" + ex.StackTrace + "\r\n");
                }
            }
        }
    }
}
