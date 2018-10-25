using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using SecurityCommon = DPSG.Webservices.Security.Hmac.Common;

namespace DPSG.Webservices.Security.Hmac.WebApi
{
    public class OverrideErrorPolicyHandler : DelegatingHandler
    {
        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            string requestUri = HttpUtility.UrlDecode(request.RequestUri.AbsoluteUri.ToLower());
            bool isInternalSite = SecurityCommon.LocalNetworkValidation.IsInternalSite(requestUri);

            if (isInternalSite == true)
            {
                request.GetRequestContext().IncludeErrorDetail = true;
            }
            else
            {
                request.GetRequestContext().IncludeErrorDetail = false;
            }

            return base.SendAsync(request, cancellationToken);
        }
    }
}