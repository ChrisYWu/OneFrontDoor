using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Input
{
    public class RouteCheckout
    {
        public DateTime? DeliveryDateUTC { get; set; }
        public int RouteID { get; set; }
        public DateTime ActualStartTime { get; set; }
        public string ActualStartGSN { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PhoneNumber { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public DateTime? LastModifiedUTC { get; set; }
    }
}
