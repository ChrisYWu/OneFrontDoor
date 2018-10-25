using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Runtime.Caching;
using System.Web;
using SecurityCommon = DPSG.Webservices.Security.Hmac.Common;

namespace DPSG.Webservices.Security.Hmac.WCF
{
    public class HmacAuthenticationAttribute 
    {

        private static Dictionary<string, string> allowedApps = new Dictionary<string, string>();

        // hmacRequestMaxAgeInSeconds, sets the default Replay time to hold nonce/time to prevent replay attacks
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

        /// <summary>
        /// This is the Calling method for validating the Authorization header/token
        /// </summary>
        /// Incomming web request object
        /// <param name="req"></param>
        /// Determine if requesting URL is internal vs. external
        /// <param name="isInternalSite"></param>
        /// <returns>True or False if token is valid</returns>
        public static bool IsTokenValid(HttpRequest req, bool isInternalSite)
        {
            IsInternalSite = isInternalSite;

            //Set default values if web.config appsettings are missing
            hmacRequestMaxAgeInSeconds = hmacRequestMaxAgeInSeconds > 0 ? hmacRequestMaxAgeInSeconds : SecurityCommon.Constants.AppKeyDefaults.APPKEY_REPLAY_SECONDS;
            hmacAuthenticationScheme = hmacAuthenticationScheme != null ? hmacAuthenticationScheme : SecurityCommon.Constants.AppKeyDefaults.APPKEY_AUTH_SCHEME;
            hmacVaildApplicationScheme = hmacVaildApplicationScheme != null ? hmacVaildApplicationScheme : SecurityCommon.Constants.AppKeyDefaults.APPKEY_APP_NAME_SCHEME;
            hmacAppNameHeader = hmacAppNameHeader != null ? hmacAppNameHeader : SecurityCommon.Constants.AppKeyDefaults.APPKEY_APP_NAME_HEADER;

            string authorizationHeader = req.Headers["Authorization"];
            string appNameHeader = req.Headers[hmacAppNameHeader];
            string requestUri = HttpUtility.UrlDecode(req.Url.AbsoluteUri.ToLower());

            if (string.IsNullOrEmpty(appNameHeader))
            {
                string customExceptionMessage = SecurityCommon.CustomException.GetErrorMessage(SecurityCommon.Constants.ResponseErrorMessages.KEY_HMAC_APP_NAME, IsInternalSite);
                throw new ArgumentNullException(message: customExceptionMessage, paramName: "Authorization");
            }
            else
            {
                bool? isvalidAppNameSpace = appNameHeader.StartsWith(hmacVaildApplicationScheme);
                if (isvalidAppNameSpace == false)
                {
                    string customExceptionMessage = SecurityCommon.CustomException.GetErrorMessage(SecurityCommon.Constants.ResponseErrorMessages.KEY_HMAC_APP_NAME_SCHEME, IsInternalSite);
                    throw new ArgumentNullException(message: customExceptionMessage, paramName: "Authorization");
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
                throw new ArgumentNullException(message: customExceptionMessage, paramName: "Authorization");
            }

            string authorizationScheme = authorizationHeader.Substring(startIndex: 0, length: authorizationHeader.IndexOf(value: " "));
            if (req.Headers["Authorization"] != null && hmacAuthenticationScheme.Equals(authorizationScheme, StringComparison.OrdinalIgnoreCase))
            {
                string[] authHeaderValues = SecurityCommon.Helper.GetAuthHeaderValues(authorizationHeader);
                if (authHeaderValues != null && appNameHeader != null)
                {
                    //appID, substring portion is unique to WCF; WEBAPI would be using the full webclient result messaging. e.g. (200 OK etc)
                    string appID = authHeaderValues[0].Substring((hmacAuthenticationScheme + " ").Length).Trim();
                    string incomingBase64Signature = authHeaderValues[1];
                    string nonce = authHeaderValues[2];
                    string requestTimeStamp = authHeaderValues[3];
                    string applicationName = appNameHeader; //BundledID or ApplicationName

                    bool isValid = IsWebRequestValid(req, appID, incomingBase64Signature, nonce, requestTimeStamp, applicationName);

                    if (isValid == true)
                    {
                        return true;
                    }
                    else
                    {
                        string customExceptionMessage = SecurityCommon.CustomException.GetErrorMessage(SecurityCommon.Constants.ResponseErrorMessages.KEY_HMAC_REQUEST_FAILED, IsInternalSite, ExtendedExceptionMessage);
                        throw new ArgumentException(message: customExceptionMessage, paramName: "Authorization");
                    }
                }
            }

            ExtendedExceptionMessage = SecurityCommon.CustomException.GetErrorMessage(SecurityCommon.Constants.ResponseErrorMessages.KEY_HMAC_AUTH_SCHEME, IsInternalSite);
            return false;
        }

        /// <summary>
        /// This method is the core validation process for the Authorization Header object
        /// </summary>
        /// <param name="req"></param> Incoming web request object
        /// <param name="appId"></param> Application ID
        /// <param name="incomingBase64Signature"></param> hash value of (Application ID, RequestMethod, Request URI, Request Timestamp & Nonce
        /// <param name="nonce"></param> 
        /// <param name="requestTimeStamp"></param>
        /// <param name="appName"></param>
        /// <returns></returns>
        private static bool IsWebRequestValid(HttpRequest req, string appId, string incomingBase64Signature, string nonce, string requestTimeStamp, string appName)
        {
            string requestUri = HttpUtility.UrlEncode(req.Url.AbsoluteUri.ToLower());

            string requestHttpMethod = req.HttpMethod;

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

            requestUri = SecurityCommon.Helper.ReverseProxySslTerminationAdjustment(requestUri, IsInternalSite);

            //string data = $"{appId}{requestHttpMethod}{requestUri}{requestTimeStamp}{nonce}";

            string data = string.Format("{0}{1}{2}{3}{4}",appId,requestHttpMethod,requestUri,requestTimeStamp,nonce);

            bool isValidHmacSignature = SecurityCommon.Helper.IsValidHmacSignature(data, sharedKey, incomingBase64Signature);

            if (isValidHmacSignature == false)
            {
                ExtendedExceptionMessage = SecurityCommon.CustomException.GetErrorMessage(SecurityCommon.Constants.ResponseErrorMessages.KEY_HMAC_REQUEST_FAILED_HASH, IsInternalSite);
            }

            return isValidHmacSignature;

        }

        /// <summary>
        /// This method determines if a request is a replay attack
        /// validates nonce and timestamp
        /// </summary>
        /// <param name="nonce"></param> Unique string
        /// <param name="requestTimeStamp"></param> UTC Timestamp in seconds
        /// <returns>True/False</returns>
        private static bool IsReplayRequest(string nonce, string requestTimeStamp)
        {
            MemoryCache cache = MemoryCache.Default;
            if (cache.Contains(nonce))
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

            MemoryCache.Default.Add(nonce, requestTimeStamp, DateTimeOffset.UtcNow.AddSeconds(hmacRequestMaxAgeInSeconds));

            return false;
        }
        
    }
}
