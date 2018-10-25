
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using  System.Data.Entity;

namespace DPSG.Webapi.Merchandiser.DataServices
{
    public class MerchandiserConnection : System.Data.Entity.DbContext
    {
        public MerchandiserConnection()
            : base("name=Merchandiser_DataConnection")
        {
            Database.SetInitializer<MerchandiserConnection>(null);
        }
    }
}
