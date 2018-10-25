using System;
using System.Collections.Generic;

namespace DPSG.Webservices.Security.Hmac.Common
{
    public static class Constants
    {
        public static class ResponseErrorMessages
        {

            public const string KEY_HMAC_APP_NAME = "HMAC_APP_NAME";
            public const string KEY_HMAC_APP_NAME_SCHEME = "HMAC_APP_NAME_SCHEME";
            public const string KEY_HMAC_API_SECRET = "HMAC_API_SECRET";
            public const string KEY_HMAC_REQUEST_FAILED = "HMAC_REQUEST_FAILED";
            public const string KEY_HMAC_REQUEST_FAILED_APPNAME = "HMAC_REQUEST_FAILED_APP";
            public const string KEY_HMAC_REQUEST_FAILED_NONCE = "HMAC_REQUEST_FAILED_NONCE";
            public const string KEY_HMAC_REQUEST_FAILED_TIME = "HMAC_REQUEST_FAILED_TIME";
            public const string KEY_HMAC_REQUEST_FAILED_HASH = "HMAC_REQUEST_FAILED_HASH";
            public const string KEY_HMAC_AUTH_ARRAY = "HMAC_AUTH_ARRAY";
            public const string KEY_HMAC_AUTH_SCHEME = "HMAC_AUTH_SCHEME";

            public static readonly Dictionary<string, Tuple<string, string>> Codes = new Dictionary<string, Tuple<string, string>>
            {
                {"HMAC_APP_NAME",new Tuple<string,string>(item1: "ERROR_A_1000", item2: "The application name is invalid or missing!")},
                {"HMAC_APP_NAME_SCHEME",new Tuple<string,string>(item1: "ERROR_A_2000", item2: "The application name space is invalid or missing!")},
                {"HMAC_API_SECRET",new Tuple<string,string>(item1: "ERROR_A_3000", item2: "The application key is invalid or missing!")},
                {"HMAC_REQUEST_FAILED",new Tuple<string,string>(item1: "ERROR_A_4000", item2: "The authorization validation process failed!")},
                {"HMAC_REQUEST_FAILED_APPNAME",new Tuple<string,string>(item1: "ERROR_A_4001", item2: "Application name validation failed!")},
                {"HMAC_REQUEST_FAILED_NONCE",new Tuple<string,string>(item1: "ERROR_A_4002", item2: "The nonce already exist!")},
                {"HMAC_REQUEST_FAILED_TIME",new Tuple<string,string>(item1: "ERROR_A_4003", item2: "The request Date/Time is invalid!")},
                {"HMAC_REQUEST_FAILED_HASH",new Tuple<string,string>(item1: "ERROR_A_4004", item2: "The signature hash is invalid!")},
                {"HMAC_AUTH_ARRAY",new Tuple<string,string>(item1: "ERROR_A_5000", item2: "The authorization header is invalid!")},
                {"HMAC_AUTH_SCHEME",new Tuple<string,string>(item1: "ERROR_A_6000", item2: "The authorization header and/or authorization scheme is invalid or missing!")},
            };

        }

        public static class AppKeyDefaults
        {
            public const UInt64 APPKEY_REPLAY_SECONDS = 300; // 5 minutes
            public const string APPKEY_AUTH_SCHEME = "dps";
            public const string APPKEY_APP_NAME_SCHEME = "com.dpsg.internal.";
            public const string APPKEY_APP_NAME_HEADER = "X-APPNAME";
            public const string APPKEY_SECRETS_SECTION = "hmacApplicationSecrets";
            public const string APPKEY_NETWORKCHECK_SECTION = "hmacInternalExternalUris";

        }

    }
}
