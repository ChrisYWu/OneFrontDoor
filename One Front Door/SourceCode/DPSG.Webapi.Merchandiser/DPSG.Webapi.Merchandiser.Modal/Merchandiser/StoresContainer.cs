using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.Model
{
    /// <summary>
    /// Store return response model
    /// </summary>
    public class StoresContainer : IResponseInformation
    {

        
        List<Store> unassignedStores;

        public List<Store> UnassignedStores
        {
            get { return unassignedStores; }
            set { unassignedStores = value; }
        }

        List<Store> allStores;

        public List<Store> AllStores
        {
            get { return allStores; }
            set { allStores = value; }
        }
        List<Store> otherStores;

        public List<Store> OtherStores
        {
            get { return otherStores; }
            set { otherStores = value; }
        }


        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }

    }

    // This class is used in Route store assignment, doesn't need OtherStores
    public class StoreContainer : IResponseInformation
    {
        List<Store> unassignedStores;

        public List<Store> UnassignedStores
        {
            get { return unassignedStores; }
            set { unassignedStores = value; }
        }

        List<Store> allStores;

        public List<Store> AllStores
        {
            get { return allStores; }
            set { allStores = value; }
        }
       
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }

    }


    // This input model is used for retrieving Stores
    public class StoresInput
    {
        public DateTime DispatchDate { get; set; }
        public System.Int32 MerchGroupID { get; set; }


    }

    // Store Models

    public class Store
    {
        public System.Int64 SAPAccountNumber { get; set; }
        public string AccountName { get; set; }
        public int? DisplayTaskCount { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostalCode { get; set; }
        public string CheckInGSN { get; set; }
        public string ActualArrival { get; set; }


    }

    public class StorePredispatch
    {
        public DateTime DispatchDate { get; set; }
        public int MerchGroupID { get; set; }
        public int RouteID { get; set; }
        public string GSN { get; set; }
        public Int64 SAPAccountNumber { get; set; }

        public string LastModifiedBy { get; set; }

    }
}
