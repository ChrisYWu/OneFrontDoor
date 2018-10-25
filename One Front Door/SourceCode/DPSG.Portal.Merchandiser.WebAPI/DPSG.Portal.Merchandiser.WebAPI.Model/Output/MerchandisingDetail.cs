using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Output
{
    public class MerchandisingList : OutputBase
    {
        public List<MerchandisingDetail> MerchandisingDetails { get; set; }
    }

    public class MerchandisingDetail
    {
        public int SameStoreCheckInSequence { get; set; }
        public Int64 SAPAccountNumber { get; set; }
        public string GSN { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Phone { get; set; }
        public DateTime? CheckInTime { get; set; }
        public DateTime? CheckOutTime { get; set; }

    }
}

