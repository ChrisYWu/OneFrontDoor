using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace DPSG.Portal.Framework.CommonUtils
{
    public class CacheHelper
    {
        /// <summary>
        /// Returns the value from cache by Key
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static object GetCacheValue(string key)
        {
            if (HttpContext.Current.Cache[key] != null)
                return HttpContext.Current.Cache[key] as object;
            else
                return null;
        }


        /// <summary>
        /// Sets the value in caching if key exists else creates a new key
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        public static void SetCacheValue(string key, object value, int CacheTimeInHours = 2)
        {
            if (value == null)
            {
                HttpContext.Current.Cache.Remove(key);
            }
            else
            {
                HttpContext.Current.Cache.Remove(key);
                HttpContext.Current.Cache.Add(key, value, null, DateTime.Now.AddHours(CacheTimeInHours), System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.High, null);
            }
        }
    }
}
