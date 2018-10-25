using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace DPSG.Webservices.Security.Hmac.Common
{
    public class Helper
    {
        /// <summary>
        /// This method ensures the Authorization header contains 4 sections to it, anything other will return a Null value
        /// </summary>
        /// Authorization Header from web request
        /// <param name="rawAuthzHeader"></param> 
        /// <returns>Array of strings or Null</returns>
        internal static string[] GetAuthHeaderValues(string rawAuthzHeader)
        {
            string[] credArray = rawAuthzHeader.Split(separator: new char[] { ':' });

            if (credArray.Length == 4)
            {
                return credArray;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// WEB API version
        /// </summary>
        /// <param name="req"></param>
        /// <param name="headerName"></param>
        /// <returns></returns>
        internal static string GetCustomHeaderValue(HttpRequestMessage req, string headerName)
        {
            IEnumerable<string> values;
            bool foundHeader = req.Headers.TryGetValues(headerName, out values);

            if (foundHeader == true)
            {
                return values.FirstOrDefault();
            }

            return null;
        }

        /// <summary>
        /// This method validates the Application ID generated from the ApplicationName encrypted with Secret key
        /// </summary>
        /// Application Name : encrypted
        /// <param name="appID"></param> 
        /// Application Name : Text
        /// <param name="appName"></param> 
        /// Secret Key : Text
        /// <param name="hmacSecret"></param> 
        /// <returns>True/False</returns>
        internal static bool IsValidApplicationID(string appID, string appName, string hmacSecret)
        {
            string data = appName;

            byte[] secretKeyBytes = Convert.FromBase64String(hmacSecret);

            byte[] signature = Encoding.UTF8.GetBytes(data);

            using (HMACSHA256 hmac = new HMACSHA256(secretKeyBytes))
            {
                byte[] signatureBytes = hmac.ComputeHash(signature);

                bool? isValidSignature = appID.Equals(Convert.ToBase64String(signatureBytes), StringComparison.Ordinal);

                if (isValidSignature == false)
                {
                    return false;
                }

                return true;
            }

        }

        /// <summary>
        /// The method, ReverseProxySslTerminationAdjustment handles SSL termination from reverse proxy
        /// where client, starts with SSL/https and terminates behind the proxy to HTTP
        /// the Uri scheme needs to match what the client is sending(https); this changes the scheme to https
        /// not doing this will fail the method. If SSL was enabled from end to end; this method is not needed
        /// </summary>
        /// URL generated from called endpoint 
        /// <param name="uri"></param>
        /// Determine if requesting URL is internal vs. external
        /// <param name="isInternalSite"></param>
        /// <returns></returns>
        internal static string ReverseProxySslTerminationAdjustment(string uri, bool isInternalSite)
        {

            uri = HttpUtility.UrlDecode(uri.ToLower());
            var uriString = new UriBuilder(uri);

            // Internal(Http) vs External(Https): Reverse Proxy
            uriString.Scheme = isInternalSite == true ? Uri.UriSchemeHttp : Uri.UriSchemeHttps;
            uriString.Port = -1;
            uri = HttpUtility.UrlEncode(uriString.ToString());

            return uri;
        }

        /// <summary>
        /// Validates Hmac process
        /// </summary>
        /// <param name="data"></param>
        /// <param name="sharedKey"></param>
        /// <param name="incomingBase64Signature"></param>
        /// <returns></returns>
        internal static bool IsValidHmacSignature(string data, string sharedKey, string incomingBase64Signature)
        {
            byte[] secretKeyBytes = Convert.FromBase64String(sharedKey);

            byte[] signature = Encoding.UTF8.GetBytes(data);

            using (HMACSHA256 hmac = new HMACSHA256(secretKeyBytes))
            {
                byte[] signatureBytes = hmac.ComputeHash(signature);

                //string requestSignatureBase64String = Convert.ToBase64String(signatureBytes);

                return incomingBase64Signature.Equals(Convert.ToBase64String(signatureBytes), StringComparison.Ordinal);

                //bool? isValidSignature = incomingBase64Signature.Equals(Convert.ToBase64String(signatureBytes), StringComparison.Ordinal);

                //if (isValidSignature == false)
                //{
                //    ExtendedExceptionMessage = SecurityCommon.CustomException.GetErrorMessage(SecurityCommon.Constants.ResponseErrorMessages.KEY_HMAC_REQUEST_FAILED_HASH, IsInternalSite);
                //    return false;
                //}

                //return true;
            }
        }

        /// <summary>
        ///  Can be used to hash POST data body and compare if using HTTP; not needed in our implementation.
        /// </summary>
        /// <param name="httpContent"></param>
        /// <returns></returns>
        private static async Task<byte[]> ComputeHash(HttpContent httpContent)
        {
            using (MD5 md5 = MD5.Create())
            {
                byte[] hash = null;
                byte[] content = await httpContent.ReadAsByteArrayAsync();
                if (content.Length != 0)
                {
                    hash = md5.ComputeHash(content);
                }
                return hash;
            }
        }
    }
}