using System;

namespace DPSG.Webservices.Security.Hmac.Common
{
    public class CustomException
    {
        public static string GetErrorMessage(string key, bool isLocal, string extdMsg)
        {
            var outTuple = new Tuple<string, string>(string.Empty, string.Empty);
            bool valueExist = Constants.ResponseErrorMessages.Codes.TryGetValue(key, out outTuple);

            if (valueExist == true)
            {
                var outValue1 = string.Format("[{0}:{1}]:{2}", outTuple.Item1, outTuple.Item2, extdMsg);
                var outValue2 = string.Format("[{0}]",outTuple.Item1);

                //return isLocal == true ? $"[{outTuple.Item1}:{outTuple.Item2}]:{extdMsg}" : $"[{outTuple.Item1}]";
                return isLocal == true ? outValue1 : outValue2;
            }

            return string.Empty;
        }

        public static string GetErrorMessage(string key, bool isLocal)
        {
            var outTuple = new Tuple<string, string>(string.Empty, string.Empty);
            bool valueExist = Constants.ResponseErrorMessages.Codes.TryGetValue(key, out outTuple);

            var outValue1 = string.Format("[{0}:{1}]", outTuple.Item1, outTuple.Item2);
            var outValue2 = string.Format("[{0}]",outTuple.Item1);

            if (valueExist == true)
            {
                //return isLocal == true ? $"[{outTuple.Item1}:{outTuple.Item2}]" : $"[{outTuple.Item1}]";
                return isLocal == true ? outValue1 : outValue2;
            }

            return string.Empty;
        }

        public static string GetErrorMessage(string key)
        {
            var outTuple = new Tuple<string, string>(string.Empty, string.Empty);
            bool valueExist = Constants.ResponseErrorMessages.Codes.TryGetValue(key, out outTuple);
            var outValue = string.Format("[{0}:{1}]", outTuple.Item1, outTuple.Item2);

            if (valueExist == true)
            {
                //return $"[{outTuple.Item1}:{outTuple.Item2}]";
                return outValue;
            }

            return string.Empty;
        }


    }
}
