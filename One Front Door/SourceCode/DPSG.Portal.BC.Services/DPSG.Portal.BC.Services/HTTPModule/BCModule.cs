using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using DPSG.Portal.BC.Common;

namespace DPSG.Portal.BC.Services.HTTPModule
{
    public class BCModule:IHttpModule
    {
        public void Dispose()
        {

        }
        public string InputBody = "";
        public void Init(HttpApplication context)
        {
            ErrorLogging er = new ErrorLogging();            
            context.BeginRequest += context_BeginRequest;
        }

        void context_BeginRequest(object sender, EventArgs e)
        {                        
            //This will force the HttpContext.Request.ReadEntityBody to be "Classic" and will ensure compatibility..

            Stream str = (sender as HttpApplication).Request.InputStream;                       
            str.Position = 0;
            StreamReader read = new StreamReader(str);
            InputBody = read.ReadToEnd();
            BC.Common.ExceptionHelper.LogException("Module Input " + InputBody, "");

            
        }
    }
}