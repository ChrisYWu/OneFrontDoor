using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Input
{
    public class MerchAdhocMileage
    {
        public DateTime ScheduleDate { get; set; }
        public string GSN { get; set; }
        public int ClientMileageID { get; set; }
        public decimal UserMileage { get; set; }
        public string Description { get; set; }
        public int MerchGroupID { get; set; }
        public DateTime ClientTime { get; set; }
        public string ClientTimeZone { get; set; }
    }
}
