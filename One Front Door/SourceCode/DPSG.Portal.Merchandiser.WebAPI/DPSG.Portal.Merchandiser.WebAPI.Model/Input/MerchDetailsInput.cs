using System;
using System.Collections.Generic;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Input
{
   public class MerchDetailsInput
    {
        public List<int> SAPAccountNumbers
        {
            get; set;
        }

        public DateTime? OperationDate
        {
            get; set;
        }
    }
}

