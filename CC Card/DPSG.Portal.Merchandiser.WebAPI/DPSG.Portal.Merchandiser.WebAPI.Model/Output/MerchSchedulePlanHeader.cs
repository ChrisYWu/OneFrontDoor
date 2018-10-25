using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Output
{
    public class MerchPlanList : OutputBase
    {
        public List<MerchSchedule> MerchPlans { get; set; }
        public List<MerchPlan> PlanHeader { get; set; }
    }

    public class MerchPlan
    {
        public string DispatchDate {get; set;}
        public bool IsPlan {get; set;}
        public bool IsSchedule { get; set;}
        public int DayAway { get; set;}

    }
}

