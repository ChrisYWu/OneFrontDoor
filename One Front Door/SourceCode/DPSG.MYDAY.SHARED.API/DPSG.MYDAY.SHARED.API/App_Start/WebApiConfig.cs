using System.Net.Http.Formatting;
using System.Web.Http;
using Security = DPSG.Webservices.Security.Hmac.WebApi;

namespace DPSG.MYDAY.SHARED.API.App_Start
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services

            // Web API HMAC Global Configuriton
            // Do not disable this; will render HMAC authtication useless.
            config.Filters.Add(new Security.HmacAuthenticationAttribute());

            // Handles Runtime Per Request Full Excpetion/Stack messages 
            // Internal URL will return Full stack trace; 
            // External URL will return short message {"Message":"An error has occurred."}
            config.MessageHandlers.Add(new Security.OverrideErrorPolicyHandler());


            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
                name: "Common",
                routeTemplate: "api/{controller}/{action}/{id}",
                defaults: new { id = RouteParameter.Optional }
                );

            //config.Routes.MapHttpRoute(
            //    name: "DefaultApi",
            //    routeTemplate: "api/{controller}/{id}",
            //    defaults: new { id = RouteParameter.Optional }
            //);

            var jsonFormatter = new JsonMediaTypeFormatter();
            //optional: set serializer settings here
            config.Services.Replace(typeof(IContentNegotiator), new JsonContentNegotiator(jsonFormatter));
        }

    }
}