using System;
using System.Collections.Generic;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Input
{
   public class StoreDeliveryInput
    {
        public List<int> SAPAccountNumbers
        {
            get; set;
        }

        public bool IsDetailNeeded
        {
            get; set;
        }

        public DateTime? DeliveryDate
        {
            get; set;
        }
    }
}

