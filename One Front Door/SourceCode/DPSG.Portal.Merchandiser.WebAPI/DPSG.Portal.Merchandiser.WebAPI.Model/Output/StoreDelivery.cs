using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Output
{
    public class StoreDeliveryList : OutputBase
    {
        List<StoreDelivery> storeDeliveries;

        public List<StoreDelivery> StoreDeliveries
        {
            get { return storeDeliveries; }
            set { storeDeliveries = value; }
        }
    }

   public class StoreDelivery
    {
        public string DeliveryDate { get; set; }
        public Int64? SAPAccountNumber { get; set; }
        public DateTime? PlannedArrival { get; set; }
        public DateTime? ActualArrival { get; set; }
        public DateTime? EstimatedArrival { get; set; }
        public string DriverID { get; set; }
        public string DriverFirstName { get; set; }
        public string DriverLastname { get; set; }
        public string DriverPhone { get; set; }
        public List<StoreDeliveryItem> Items { get; set; }
    }


    public class StoreDeliveryItemRAW
    {
        public Int64? SAPAccountNumber { get; set; }
        public string SAPMaterialID { get; set; }
        public string Description { get; set; }
        public int? Quantity { get; set; }      
        public bool? Delivered { get; set; }
        public string RMPackageID { get; set; }
        public string PackageName { get; set; }
    }

    public class StoreDeliveryItem
    {      
        public string SAPMaterialID { get; set; }
        public int? Quantity { get; set; }      
        public bool? Delivered { get; set; }
    }

}
