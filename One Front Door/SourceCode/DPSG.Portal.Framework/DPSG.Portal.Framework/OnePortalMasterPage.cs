using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Portal.Framework.Types;
using System.Web;
using Microsoft.SharePoint;

namespace DPSG.Portal.Framework
{
    public class OnePortalMasterPage : System.Web.UI.MasterPage
    {
        public OnePortalBase portalBase;

        public DateTime StartTime = DateTime.Now;
        System.Diagnostics.Stopwatch _stopWatch ;

        public System.Diagnostics.Stopwatch StopWatch
        {
            get {
                if (_stopWatch == null)
                {
                    _stopWatch = new System.Diagnostics.Stopwatch();
                    _stopWatch.Start();
                }
                return _stopWatch;
            }
        }
        
        protected string RiverbedJSFilePath
        {
            get { return CommonUtils.HelperUtils.GetConfigEntrybyKey(Types.Constants.Config.RiverbedJSFilePath); }
        }
        protected override void OnInit(EventArgs e)
        {


            //StopWatch.

            DateTime starttime = DateTime.Now;

            base.OnInit(e);

            StopWatch.Stop();
            DPSG.Portal.Framework.CommonUtils.HelperUtils.writeLog("MasterPage-OnItStart", StopWatch.ElapsedMilliseconds.ToString());
            StopWatch.Start();

            portalBase = new OnePortalBase();

            if (this.portalBase.IsUserInRole())
            {
                if (this.Request.Url.AbsolutePath.ToLower() == "/pages/home.aspx")
                {
                    string keyValue = this.portalBase.DefaultURL();
                    if (!string.IsNullOrEmpty(keyValue))
                    {
                        if (!(keyValue.Contains(this.Request.Url.AbsolutePath.ToLower())))
                            HttpContext.Current.Response.Redirect(keyValue.ToLower(), true);
                    }
                }


                StopWatch.Stop();
                DPSG.Portal.Framework.CommonUtils.HelperUtils.writeLog("MasterPage-OnePortalInit", StopWatch.ElapsedMilliseconds.ToString());
                StopWatch.Start();


                string replaceby = string.Empty;
                replaceby = this.portalBase.TopNavigationHeader();

                StringBuilder topNavigationFixScript = new StringBuilder();
                StringBuilder breadcrumbFixScript = new StringBuilder();

                if (!string.IsNullOrEmpty(replaceby))
                {
                    topNavigationFixScript.Append("<script>");
                    topNavigationFixScript.Append("fixOFDMenus ('" + replaceby + "');");
                    topNavigationFixScript.Append("</script>");

                    this.Page.ClientScript.RegisterStartupScript(this.GetType(), "TopNavigationFix", topNavigationFixScript.ToString());
                }
            }

            //If called from angular and with isdlg then hiding the title
            if (Request.QueryString["msnAngularModal"] != null && Request.QueryString["IsDlg"] != null)
            {
                this.Page.ClientScript.RegisterStartupScript(this.GetType() , "HideTitleForNGPopups", "<style>.h3pheading2{display:none;}</style>");
            }


            StopWatch.Stop();
            DPSG.Portal.Framework.CommonUtils.HelperUtils.writeLog("MasterPage-OnItStop", StopWatch.ElapsedMilliseconds.ToString());
            StopWatch.Start();
        }

        protected override void OnUnload(EventArgs e)
        {
            if (portalBase != null)
            {
                portalBase.Dispose();
            }
            base.OnUnload(e);
            
            StopWatch.Stop();
            DPSG.Portal.Framework.CommonUtils.HelperUtils.writeLog("MasterPage-OnUnload", StopWatch.ElapsedMilliseconds.ToString());
            StopWatch.Start();

        }
    }
}
