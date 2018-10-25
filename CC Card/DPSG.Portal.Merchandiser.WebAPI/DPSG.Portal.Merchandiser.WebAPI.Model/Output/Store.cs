using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Output
{
    public class StoreList : OutputBase
    {
        List<Store> storeLst;

        public List<Store> Stores
        {
            get { return storeLst; }
            set { storeLst = value; }
        }

    }

    public class Store
    {
        public string SAPBranchID { get; set; }
        public Int64 SAPAccountNumber { get; set; }
        public string AccountName { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostalCode { get; set; }
        public string PhoneNumber { get; set; }
        public decimal? Latitude { get; set; }
        public decimal? Longitude { get; set; }
        public bool Active { get; set; }
        public DateTime LastModified { get; set; }

        public string AccountManagerName {get; set;}
        public string AccountManagerPhoneNumber { get; set;}

    }
}

