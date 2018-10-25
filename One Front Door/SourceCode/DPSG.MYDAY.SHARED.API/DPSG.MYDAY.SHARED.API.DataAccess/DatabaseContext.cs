using System.Data.Entity;

namespace DPSG.MYDAY.SHARED.API.DataAccess
{
    public class DatabaseContext : DbContext
    {
        public DatabaseContext(string connStringValue)
           : base(connStringValue)
        {
            Database.SetInitializer<DatabaseContext>(null);
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
        }

    }
}
