using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;
using Microsoft.SharePoint;
using DPSG.Portal.Framework.Types;
using System.IO;

namespace DPSG.Portal.Framework
{
    public class OnePortalUserControl : UserControl
    {
        private DateTime startTime;
        OnePortalBase _portalBase;
        public OnePortalBase PortalBase
        {
            get
            {
                if (_portalBase == null)
                {
                    _portalBase = ((OnePortalMasterPage)this.Page.Master).portalBase;
                }
                return _portalBase;
            }
        }

        protected override void OnInit(EventArgs e)
        {           
            base.OnInit(e);
            startTime = DateTime.Now;
            writeLog("OnIt"); 
        }
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            writeLog("Load"); 
        }
        protected override void OnUnload(EventArgs e)
        {
            base.OnUnload(e);
            writeLog( "OnUnLoad");
            writeLog("TotalTime " + (DateTime.Now - startTime).Seconds.ToString()); 
        }

        public void writeLog(string e)
        {
            System.Diagnostics.Stopwatch stopWatch = ((OnePortalMasterPage)this.Page.Master).StopWatch;
            stopWatch.Stop();
            DPSG.Portal.Framework.CommonUtils.HelperUtils.writeLog(this.ID + "-" + e, stopWatch.ElapsedMilliseconds.ToString());
            stopWatch.Start();
        }
    }
}
