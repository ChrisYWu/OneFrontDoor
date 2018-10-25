using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity;

namespace DPSG.DSDDeliveryTime.WebAPI.DataService
{
    public class DSDDeliveryConnection : System.Data.Entity.DbContext
    {
        public DSDDeliveryConnection()
         : base("name=DSDDeliveryConnection")
        {
            Database.SetInitializer<DSDDeliveryConnection>(null);
        }

    }
}
