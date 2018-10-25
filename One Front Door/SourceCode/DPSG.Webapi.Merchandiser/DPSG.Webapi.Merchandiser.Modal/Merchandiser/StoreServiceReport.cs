using DPSG.Webapi.Merchandiser.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.Modal
{
    public class StoreServiceReport
    {
    }

    public class StoreServiceOutput : IResponseInformation
    {
        List<StoreService> _storeServices;
        public List<StoreService> StoreServices
        {
            get { return _storeServices; }
            set { _storeServices = value; }
        }

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class StoreServiceInput
    {
        public string MerchGroupIDs { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }      
    }

    public class StoreService
    {
        public string Branch { get; set; }
        public string Merchandiser { get; set; }
        public string Date { get; set; }
        public string Chain { get; set; }
        public string StoreName { get; set; }
        public string StartTime { get; set; }
        public string EndTime { get; set; }
        public string TimeinStoreMins { get; set; }
        public string TimeinStoreHours { get; set; }
        public string ManagerName { get; set; }
        public string ManagerSignature { get; set; }
        public Int32? CasesWorked { get; set; }
        public Int32? CasesInBackstock { get; set; }
        public string StorePics { get; set; }
        public string PicsLocation { get; set; }
        public string Comments { get; set; }
        public string CKINLocation { get; set; }
        public string CKOUTLocation { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string PostalCode { get; set; }
        public string State { get; set; }
    }


    public class UserMerchGroupOutput : IResponseInformation
    {
        List<UserMerchGroup> _userMerchGroups;
        public List<UserMerchGroup> UserMerchGroups
        {
            get { return _userMerchGroups; }
            set { _userMerchGroups = value; }
        }

        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class UserMerchGroup
    {
        public int id { get; set; }
        public string name { get; set; }
    }

    public class UserMerchGroupInput
    {
        public string UserGSN { get; set; }
    }

}
