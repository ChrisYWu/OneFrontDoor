using System;
using System.Collections.Specialized;
using System.Configuration;

namespace DPSG.Webservices.Security.Hmac.Common
{
    public class LocalNetworkValidation
    {
        private static readonly NameValueCollection hmacInternalExternalUrisCollection = (NameValueCollection) ConfigurationManager.GetSection(sectionName: Constants.AppKeyDefaults.APPKEY_NETWORKCHECK_SECTION);

        public static bool IsInternalSite(string requestUri)
        {
            var requestUriBuilder = new UriBuilder(requestUri);
            string requestUriHost = requestUriBuilder.Host;

            //IEnumerable<string> reverseDomainSplit = requestUriHost.Split(separator: new char[] { '.' }).Reverse().Take(count: 2);
            //string domain = String.Join(separator: ".", values: reverseDomainSplit);

            string uriInternal = hmacInternalExternalUrisCollection["Internal"];
            string uriExternal = hmacInternalExternalUrisCollection["External"];

            bool isUrisEqual = uriInternal.Equals(uriExternal, StringComparison.OrdinalIgnoreCase);

            if (string.IsNullOrEmpty(uriInternal) || string.IsNullOrEmpty(uriExternal) || isUrisEqual == true)
            {
                return false;
            }

            return uriInternal.Equals(requestUriHost, StringComparison.OrdinalIgnoreCase);

        }
    }
}
