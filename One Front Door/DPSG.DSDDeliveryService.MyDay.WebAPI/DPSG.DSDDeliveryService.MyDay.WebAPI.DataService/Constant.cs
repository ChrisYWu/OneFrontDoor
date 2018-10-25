using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.DataService
{
    class Constant
    {
        internal static class StoredProcedureName
        {
            //Delivery
            public const string GetMaster = "Mesh.pGetMaster";
            public const string GetDeliveryManifest = "Mesh.pGetDeliveryManifest";

            public const string InsertWebAPILog = "Setup.pInsertWebAPILog";
        }
    }
}
