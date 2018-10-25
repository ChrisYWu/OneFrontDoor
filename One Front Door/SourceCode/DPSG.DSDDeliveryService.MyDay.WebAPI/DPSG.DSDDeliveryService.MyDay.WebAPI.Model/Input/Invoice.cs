using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Input
{
    public class Invoice
    {
        public List<InvoiceHeader> Headers { get; set; }
        public List<InvoiceItem> Items { get; set; }
        public string LastModifiedBy { get; set; }
        public DateTime LastModifiedUTC { get; set; }
        public DateTime? DeliveryDateUTC { get; set; }
        public int? RouteID { get; set; }
    }

    public class InvoiceHeader
    {
        public DateTime? DeliveryDateUTC { get; set; }
        public int? SAPBranchID { get; set; }
        public Int64? RMInvoiceID { get; set; }
        public Int64? RMOrderID { get; set; }
        public string SAPAccountNumber { get; set; }
    }

    public class InvoiceItem
    {
        public int ItemNumber { get; set; }
        public int Quantity { get; set; }
        public Int64? RMInvoiceID { get; set; }
        public DateTime LastModifiedUTC { get; set; }
        public string LastModifiedBy { get; set; }
    }
}
