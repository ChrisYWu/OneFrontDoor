using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Output
{
    public class MerchScheduleList : OutputBase
    {
        List<MerchSchedule> merchScheduleLst;

        public List<MerchSchedule> MerchSchedules
        {
            get { return merchScheduleLst; }
            set { merchScheduleLst = value; }
        }
        public int BatchID { get; set; }
        public string Notes { get; set; }
        public string UpdateStatus { get; set; }
    }


    public class MerchSchedule
    {
        string dispatchDate;
        public string DispatchDate
        {
            get { return dispatchDate; }
            set { dispatchDate = value; }
        }
        public Int64 SAPAccountNumber { get; set; }
        public int Sequence { get; set; }   
        public int SameStoreSequence { get; set; }
        public int RouteID { get; set; }
        public string RouteName { get; set; }
        public string TargetAction { get; set; }
    }

    public class ScheduleStatus
    {
        public int BatchID { get; set; }
        public string Notes { get; set; }
        public string UpdateStatus { get; set; }
    }
}
