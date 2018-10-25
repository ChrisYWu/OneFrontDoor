

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace DPSG.Webapi.Merchandiser.CommonUtils
{
    public class MercContext : IDisposable
    {
        public string CorrelationID;
        private static System.Collections.Hashtable htContexts;
        public string RouteURL = "";

        static MercContext()
        {
            htContexts = new System.Collections.Hashtable();
        }
        private MercContext()
        {

        }


        public static string CreateContext()
        {
            string id = Guid.NewGuid().ToString();
            if (!htContexts.ContainsKey(id))
            {
                MercContext context = new MercContext();
                context.CorrelationID = id;
                htContexts.Add(id, context);
            }
            return id;
        }
        public static MercContext Current
        {
            get
            {

                if (htContexts.ContainsKey(System.Web.HttpContext.Current.Items["MercSessionID"]))
                {
                    return (MercContext)htContexts[System.Web.HttpContext.Current.Items["MercSessionID"]];
                }
                throw new Exception("Merchandiser context not created or not found.");
            }
        }

        public void Dispose()
        {
            htContexts.Clear();
            htContexts = null;
        }

    }
}
