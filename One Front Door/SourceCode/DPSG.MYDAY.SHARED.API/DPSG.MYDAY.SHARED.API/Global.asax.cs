using System;
using System.Web;
using System.Web.Http;

namespace DPSG.MYDAY.SHARED.API
{
    public class Global : HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            //AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(App_Start.WebApiConfig.Register);
            //RouteConfig.RegisterRoutes(RouteTable.Routes);    
        }

    }
}