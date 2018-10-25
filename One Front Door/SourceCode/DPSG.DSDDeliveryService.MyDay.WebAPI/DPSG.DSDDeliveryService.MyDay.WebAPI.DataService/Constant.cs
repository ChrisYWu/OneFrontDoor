using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.DataService
{
    public static class StoredProcedureName
    {
        //Delivery
        public const string GetMaster = "Mesh.pGetMaster";
        public const string GetDeliveryManifest = "Mesh.pGetDeliveryManifest";

        public const string InsertWebAPILog = "Setup.pInsertWebAPILog";
        public const string InsertMeshMyDayLog = "Mesh.pInsertMeshMyDayLog";
        public const string UploadRouteCheckout = "Mesh.pUploadRouteCheckout";
        public const string UploadAddedStop = "Mesh.pUploadAddedStop";
        public const string DeleteStop = "Mesh.pDeleteStop";
        public const string UpdateEstimatedArrivals = "Mesh.pUpdateEstimatedArrivals";
        public const string CheckInDeliveryStop = "Mesh.pCheckInDeliveryStop";
        public const string CheckOutDeliveryStop = "Mesh.pCheckOutDeliveryStop";
        public const string UploadStopsDNS = "Mesh.pUploadStopDNS";
        public const string CancelStopsDNS = "Mesh.pCancelStopDNS";
        public const string UploadNewSequence = "Mesh.pUploadNewSequence";
        public const string UploadInvoice = "Mesh.pInsertInvoice";

    }
}
