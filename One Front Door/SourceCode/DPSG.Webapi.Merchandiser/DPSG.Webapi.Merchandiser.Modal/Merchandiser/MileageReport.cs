using DPSG.Webapi.Merchandiser.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.Modal
{
    public class MileageReport
    {
    }

    public class MileageOutput : IResponseInformation
    {
        List<Mileage> _mileages;
        public List<Mileage> Mileages
        {
            get { return _mileages; }
            set { _mileages = value; }
        }

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class MileageInput
    {
        public string MerchGroupIDs { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
    }

    public class Mileage
    {
        public string Branch { get; set; }  
        public string GroupName { get; set; }     
        public string Supervisor { get; set; }
        public string Merchandiser { get; set; }
        public string Date { get; set; }
        public decimal? CalculatedMiles { get; set; }
        public decimal? AdjustedMiles { get; set; }
        public string ShortReason { get; set; }
        public string LongReason { get; set; }

    }
}
