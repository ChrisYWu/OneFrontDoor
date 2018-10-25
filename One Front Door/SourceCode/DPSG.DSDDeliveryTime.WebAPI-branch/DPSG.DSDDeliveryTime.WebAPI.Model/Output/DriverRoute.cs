using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryTime.WebAPI.Model.Output
{
    public class DriverRouteOutput : OutputBase
    {
        public List<DriverRoute> Routes { get; set; }
    }

    public class DriverRoute
    {
        public int? RMLocationID { get; set; }
        public string BranchName { get; set; }
        public string RouteNumber { get; set; }
        public string RouteName { get; set; }
    }
}
