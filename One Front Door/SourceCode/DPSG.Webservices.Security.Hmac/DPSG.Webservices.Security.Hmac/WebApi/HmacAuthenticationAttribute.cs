using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Principal;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Filters;
using SecurityCommon = DPSG.Webservices.Security.Hmac.Common;

namespace DPSG.Webservices.Security.Hmac.WebApi
{
    public class HmacAuthenticationAttribute :  Attribute, IAuthenticationFilter
    {
        // Holds application ID and secret Keys
        private static Dictionary<string, string> allowedApps = new Dictionary<string, string>();

        // hmacRequestMaxAgeInSeconds
        // sets the default Replay time to hold nonce/time to prevent replay attacks
        private static UInt64 hmacRequestMaxAgeInSeconds = Convert.ToUInt64(ConfigurationManager.AppSettings.Get(name: "HMAC-Auth-ReplaySeconds"));

        // hmacAuthenticationScheme, default header scheme for calling methods.
        // if there is a need to change; must be changed in source and host configurations (e.g. client / server)
        private static string hmacAuthenticationScheme = ConfigurationManager.AppSettings.Get(name: "HMAC-Auth-Scheme");

        // hmacVaildApplicationScheme, is an application naming convention for name the application e.g. com.dpsg.internal.
        // combined with a application name, com.dpsg.internal.mytime .. this allows for controlling the application name that is 
        // used in parts of this method.
        private static string hmacVaildApplicationScheme = ConfigurationManager.AppSettings.Get(name: "HMAC-Auth-Valid-AppNameSpace");

        // hmacAppNameHeader, this holds the web header space for populating Application name; in conjunction with the critiera of
        // attribute hmacVaildApplicationScheme
        private static string hmacAppNameHeader = ConfigurationManager.AppSettings.Get(name: "HMAC-Auth-AppNameHeader");

        private static readonly NameValueCollection hmacApplicationSecretsCollection = (NameValueCollection) ConfigurationManager.GetSection(sectionName: SecurityCommon.Constants.AppKeyDefaults.APPKEY_SECRETS_SECTION);

        private static string ExtendedExceptionMessage { get; set; }
        private static bool IsInternalSite { get; set; }
        private static string HmacSecretKey { get; set; }
        private static string AppName { get; set; }

        public HmacAuthenticationAttribute()
        {
        }

        public Task AuthenticateAsync(HttpAuthenticationContext context, CancellationToken cancellationToken)
        {

            //Set default values if web.config appsettings are missing
            hmacRequestMaxAgeInSeconds = hmacRequestMaxAgeInSeconds > 0 ? hmacRequestMaxAgeInSeconds : SecurityCommon.Constants.AppKeyDefaults.APPKEY_REPLAY_SECONDS;
            hmacAuthenticationScheme = hmacAuthenticationScheme != null ? hmacAuthenticationScheme : SecurityCommon.Constants.AppKeyDefaults.APPKEY_AUTH_SCHEME;
            hmacVaildApplicationScheme = hmacVaildApplicationScheme != null ? hmacVaildApplicationScheme : SecurityCommon.Constants.AppKeyDefaults.APPKEY_APP_NAME_SCHEME;
            hmacAppNameHeader = hmacAppNameHeader != null ? hmacAppNameHeader : SecurityCommon.Constants.AppKeyDefaults.APPKEY_APP_NAME_HEADER;

            HttpRequestMessage req = context.Request;

            AuthenticationHeaderValue authHeaderCheck = req.Headers.Authorization;

            string requestUri = HttpUtility.UrlDecode(req.RequestUri.AbsoluteUri.ToLower());

            IsInternalSite = SecurityCommon.LocalNetworkValidation.IsInternalSite(requestUri);

            if (IsInternalSite == true && authHeaderCheck == null)
            {
                return Task.FromResult(result: 0);
            }

            string appNameHeader = SecurityCommon.Helper.GetCustomHeaderValue(req, hmacAppNameHeader);

            //http://www.asp.net/web-api/overview/error-handling/exception-handling

            if (string.IsNullOrEmpty(appNameHeader))
            {

                string customExceptionMessage = SecurityCommon.CustomException.GetErrorMessage(SecurityCommon.Constants.ResponseErrorMessages.KEY_HMAC_APP_NAME, IsInternalSite);
                throw new HttpResponseException(req.CreateErrorResponse(HttpStatusCode.Unauthorized, customExceptionMessage));

            }
            else
            {

                bool isvalidAppNameSpace = appNameHeader.StartsWith(hmacVaildApplicationScheme);
                if (isvalidAppNameSpace == false)
                {

                    string customExceptionMessage = SecurityCommon.CustomException.GetErrorMessage(SecurityCommon.Constants.ResponseErrorMessages.KEY_HMAC_APP_NAME_SCHEME, IsInternalSite);
                    throw new HttpResponseException(req.CreateErrorResponse(HttpStatusCode.Unauthorized, customExceptionMessage));

                }

                // Extracts Application Name from X-APPNAME header e.g. com.dpsg.internal.ABC would equal ABC
                AppName = appNameHeader.Substring(appNameHeader.LastIndexOf(value: ".") + 1);

            }

            // Grabs Secret Key from Web.config custom section <hmacApplicationSecrets> 
            // <hmacApplicationSecrets> name must pass hmacVaildApplicationScheme and variable "appName" check
            HmacSecretKey = hmacApplicationSecretsCollection[AppName];

            if (string.IsNullOrEmpty(HmacSecretKey))
            {

                string customExceptionMessage = SecurityCommon.CustomException.GetErrorMessage(SecurityCommon.Constants.ResponseErrorMessages.KEY_HMAC_API_SECRET, IsInternalSite);
                throw new HttpResponseException(req.CreateErrorResponse(HttpStatusCode.Unauthorized, customExceptionMessage));

            }

            if (req.Headers.Authorization != null && hmacAuthenticationScheme.Equals(req.Headers.Authorization.Scheme, StringComparison.OrdinalIgnoreCase))
            {

                string rawAuthzHeader = req.Headers.Authorization.Parameter;
                string[] autherizationHeaderArray = SecurityCommon.Helper.GetAuthHeaderValues(rawAuthzHeader);

                if (autherizationHeaderArray != null)
                {
                    string appId = autherizationHeaderArray[0];
                    string incomingBase64Signature = autherizationHeaderArray[1];
                    string nonce = autherizationHeaderArray[2];
                    string requestTimeStamp = autherizationHeaderArray[3];
                    string applicationName = appNameHeader; //BundledID or ApplicationName

                    Task<bool> isValid = IsWebRequestValid(req, appId, incomingBase64Signature, nonce, requestTimeStamp, applicationName);

                    if (isValid.Result)
                    {
                        var currentPrincipal = new GenericPrincipal(new GenericIdentity(appId), roles: null);
                        context.Principal = currentPrincipal;
                    }
                    else
                    {
                        string customExceptionMessage = SecurityCommon.CustomException.GetErrorMessage(SecurityCommon.Constants.ResponseErrorMessages.KEY_HMAC_REQUEST_FAILED, IsInternalSite, ExtendedExceptionMessage);
                        throw new HttpResponseException(req.CreateErrorResponse(HttpStatusCode.Unauthorized, customExceptionMessage));

                    }
                }
                else
                {

                    string customExceptionMessage = SecurityCommon.CustomException.GetErrorMessage(SecurityCommon.Constants.ResponseErrorMessages.KEY_HMAC_AUTH_ARRAY, IsInternalSite);
                    throw new HttpResponseException(req.CreateErrorResponse(HttpStatusCode.Unauthorized, customExceptionMessage));

                }
            }
            else
            {

                string customExceptionMessage = SecurityCommon.CustomException.GetErrorMessage(SecurityCommon.Constants.ResponseErrorMessages.KEY_HMAC_AUTH_SCHEME, IsInternalSite);
                throw new HttpResponseException(req.CreateErrorResponse(HttpStatusCode.Unauthorized, customExceptionMessage));


            }

            return Task.FromResult(result: 0);
        }

        public Task ChallengeAsync(HttpAuthenticationChallengeContext context, CancellationToken cancellationToken)
        {
            context.Result = new ResultWithChallenge(context.Result);
            return Task.FromResult(result: 0);
        }

        private async Task<bool> IsWebRequestValid(HttpRequestMessage req, string appId, string incomingBase64Signature, string nonce, string requestTimeStamp, string appName)
        {

            string requestUri = HttpUtility.UrlEncode(req.RequestUri.AbsoluteUri.ToLower());

            string requestHttpMethod = req.Method.Method;

            if (SecurityCommon.Helper.IsValidApplicationID(appId, appName, HmacSecretKey) == false)
            {
                ExtendedExceptionMessage = SecurityCommon.CustomException.GetErrorMessage(SecurityCommon.Constants.ResponseErrorMessages.KEY_HMAC_REQUEST_FAILED_APPNAME, IsInternalSite);

                return false;
            }

            bool appIdExists = allowedApps.ContainsKey(appId);

            if (appIdExists == false)
            {
                allowedApps.Add(appId, HmacSecretKey);
            }

            string sharedKey = allowedApps[appId];

            if (IsReplayRequest(nonce, requestTimeStamp))
            {
                return false;
            }

            requestUri = SecurityCommon.Helper.ReverseProxySslTerminationAdjustment(requestUri,IsInternalSite);

            //string data = $"{appId}{requestHttpMethod}{requestUri}{requestTimeStamp}{nonce}";
            string data = string.Format("{0}{1}{2}{3}{4}",appId,requestHttpMethod,requestUri,requestTimeStamp,nonce);

            bool isValidHmacSignature = SecurityCommon.Helper.IsValidHmacSignature(data, sharedKey, incomingBase64Signature);

            if (isValidHmacSignature == false)
            {
                ExtendedExceptionMessage = SecurityCommon.CustomException.GetErrorMessage(SecurityCommon.Constants.ResponseErrorMessages.KEY_HMAC_REQUEST_FAILED_HASH, IsInternalSite);
            }

            return isValidHmacSignature;

        }

        private bool IsReplayRequest(string nonce, string requestTimeStamp)
        {
            if (System.Runtime.Caching.MemoryCache.Default.Contains(nonce))
            {
                ExtendedExceptionMessage = SecurityCommon.CustomException.GetErrorMessage(SecurityCommon.Constants.ResponseErrorMessages.KEY_HMAC_REQUEST_FAILED_NONCE, IsInternalSite);
                return true;
            }

            var epochStart = new DateTime(year: 1970, month: 01, day: 01, hour: 0, minute: 0, second: 0, millisecond: 0, kind: DateTimeKind.Utc);
            TimeSpan currentTs = DateTime.UtcNow - epochStart;

            double serverTotalSeconds = Math.Round(currentTs.TotalSeconds);
            double requestTotalSeconds = Math.Round(Convert.ToDouble(requestTimeStamp));
            double requestPastTime = (serverTotalSeconds - requestTotalSeconds); // 1 minute check to prevent back dating

            if ((serverTotalSeconds - requestTotalSeconds) > hmacRequestMaxAgeInSeconds || requestPastTime < -60)
            {
                ExtendedExceptionMessage = SecurityCommon.CustomException.GetErrorMessage(SecurityCommon.Constants.ResponseErrorMessages.KEY_HMAC_REQUEST_FAILED_TIME, IsInternalSite);
                return true;
            }

            System.Runtime.Caching.MemoryCache.Default.Add(nonce, requestTimeStamp, DateTimeOffset.UtcNow.AddSeconds(hmacRequestMaxAgeInSeconds));

            return false;
        }

        public bool AllowMultiple
        {
            get { return false; }
        }

    }

    public class ResultWithChallenge : IHttpActionResult
    {
        private readonly string authenticationScheme = SecurityCommon.Constants.AppKeyDefaults.APPKEY_AUTH_SCHEME;

        private readonly IHttpActionResult next;

        public ResultWithChallenge(IHttpActionResult next)
        {
            this.next = next;
        }

        public async Task<HttpResponseMessage> ExecuteAsync(CancellationToken cancellationToken)
        {
            HttpResponseMessage response = await next.ExecuteAsync(cancellationToken);

            if (response.StatusCode == HttpStatusCode.Unauthorized)
            {
                response.Headers.WwwAuthenticate.Add(new AuthenticationHeaderValue(authenticationScheme));
            }

            return response;
        }

    }
}