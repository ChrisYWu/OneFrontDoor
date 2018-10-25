using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Output
{
    public class DeliveryManifest: OutputBase
    {
        public ManifestHeader Header { get; set; }
        public List<DeliveryStop> Stops { get; set; }
    }

    public class ManifestHeader
    {
        public DateTime DeliveryDateUTC { get; set; }
        public int RouteID { get; set; }
        public bool MeshEnabled { get; set; }
        public int TotalQuantity { get; set; }
        public DateTime PlannedStartTime { get; set; }
        public DateTime PlannedCompleteTime { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PhoneNumber { get; set; }
        public int PlannedServiceTime { get; set; }
        public int PlannedTravelTime { get; set; }
        public int PlannedBreakTime { get; set; }
        public int PlannedPreRouteTime { get; set; }
        public int PlannedPostRouteTime { get; set; }
      
    }

    public class DeliveryStop
    {
        public int DeliveryStopID { get; set; }
        public DateTime DeliveryDateUTC { get; set; }
        public int  RouteID { get; set; }
        public int Sequence { get; set; }
        public string StopType { get; set; }
        public string StopDescription { get; set; }
        public string SAPAccountNumber { get; set; }
        public int Quantity { get; set; }
        public DateTime PlannedArrival { get; set; }
        public int ServiceTime { get; set; }
        public int TravelToTime { get; set; }
        public decimal? Latitude { get; set; }
        public decimal? Longitude { get; set; }
    
    }
}
