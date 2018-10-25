using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Input
{
    public class MerchStopCheckIn
    {
        public DateTime ScheduleDate { get; set; }
        public string GSN { get; set; }
        public int MerchGroupID { get; set; }
        public int ClientSequence { get; set; }
        public int SameStoreSequence { get; set; }
        public int? RouteID { get; set; }
        public Int64 SAPAccountNumber { get; set; }
        public Boolean IsOffRouteStop { get; set; }
        public DateTime ClientCheckInTime { get; set; }
        public string ClientCheckInTimeZone { get; set; }        
        public decimal CheckInLatitude { get; set; }
        public decimal CheckInLongitude { get; set; }
        public int DriveTimeInMinutes { get; set; }
        public decimal StandardMileage { get; set; }
        public decimal UserMileage { get; set; }
    }
}
