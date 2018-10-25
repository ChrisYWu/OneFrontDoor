using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.DataService
{
    public class MerchConnection : System.Data.Entity.DbContext
    {
        public MerchConnection()
         : base("name=MerchConnection")
        {
            Database.SetInitializer<MerchConnection>(null);
        }

    }
}
