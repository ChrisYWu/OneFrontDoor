using System;
using Newtonsoft.Json;

namespace DPSG.MYDAY.SHARED.API.Common
{
    public class Helper
    {
        public static string GetGsnFromUserAgent(string userAgent, int gsnPosition, int userAgentLength)
        {
            var userAgentArray = userAgent.Split(',');

            return userAgentArray.Length == userAgentLength ? userAgentArray[gsnPosition] : "NO-GSN";
        }

        public static string JsonSerializeObject(dynamic obj)
        {
            string jsonData;
            try
            {
                jsonData = JsonConvert.SerializeObject(obj);
            }
            catch (Exception)
            {
                return "Unable to Seralize Incoming Object to Json"; 
            }

            return jsonData;
        }
    }
}
