using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.MYDAY.SHARED.API.DataAccess
{
    public class DatabaseContextWrapper
    {
        private static readonly string connStr = ConfigurationManager.AppSettings.Get("dBConnect");

        protected DatabaseContext DbConnection { get; private set; }

        protected void CommitTransaction(bool closeSession)
        {
            DbConnection.SaveChanges();
        }

        protected void RollbackTransaction(bool closeSession)
        {
        }

        protected void Save(object entity) { }

        protected void CreateSession()
        {
            DbConnection = new DatabaseContext(connStr);
        }

        protected void BeginTransaction() { }

        protected void CloseSession()
        {
            if (DbConnection == null) return;
            DbConnection.Database.Connection.Close();
            DbConnection.Dispose();
        }

        public void Dispose()
        {
            DbConnection?.Dispose();
        }
        protected IList<T> ExecuteReader<T>(string commandName, DbParameter[] paramArray)
        {
            var cmd = DbConnection.Database.Connection.CreateCommand();
            cmd.CommandText = commandName;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            DbConnection.Database.Connection.Open();
            if (paramArray != null)
                cmd.Parameters.AddRange(paramArray);
            var reader = cmd.ExecuteReader();
            var results = ((System.Data.Entity.Infrastructure.IObjectContextAdapter)DbConnection).ObjectContext.Translate<T>(reader).ToList<T>();
            return results;
        }

        protected IList<T> ExecuteReader<T>(string commandName)
        {
            return ExecuteReader<T>(commandName, null);
        }

        protected async Task<IList<T>> ExecuteReaderAsync<T>(string commandName, DbParameter[] paramArray)
        {
            var cmd = this.DbConnection.Database.Connection.CreateCommand();
            cmd.CommandText = commandName;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            await this.DbConnection.Database.Connection.OpenAsync();
            if (paramArray != null)
                cmd.Parameters.AddRange(paramArray);
            var reader = await cmd.ExecuteReaderAsync();
            var results = ((System.Data.Entity.Infrastructure.IObjectContextAdapter)DbConnection).ObjectContext.Translate<T>(reader).ToList<T>();
            return results;
        }

        protected async Task<IList<T>> ExecuteReaderAsync<T>(string commandName)
        {
            return await ExecuteReaderAsync<T>(commandName, null);
        }

        internal DatabaseContextReader ExecuteReader(string commandName, SqlParameter[] paramArray)
        {
            var cmd = DbConnection.Database.Connection.CreateCommand();
            cmd.CommandText = commandName;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            DbConnection.Database.Connection.Open();
            if (paramArray != null)
                cmd.Parameters.AddRange(paramArray);
            var reader = cmd.ExecuteReader();
            var results = new DatabaseContextReader(reader, ((System.Data.Entity.Infrastructure.IObjectContextAdapter)DbConnection).ObjectContext);
            return results;
        }

        internal async Task<DatabaseContextReader> ExecuteReaderAsync(string commandName, SqlParameter[] paramArray)
        {
            var cmd = DbConnection.Database.Connection.CreateCommand();
            cmd.CommandText = commandName;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            await DbConnection.Database.Connection.OpenAsync();
            if (paramArray != null)
                cmd.Parameters.AddRange(paramArray);
            var reader = await cmd.ExecuteReaderAsync();
            var results = new DatabaseContextReader(reader, ((System.Data.Entity.Infrastructure.IObjectContextAdapter)DbConnection).ObjectContext);
            return results;
        }

        internal int ExecuteNonQuery(string commandName, SqlParameter[] paramArray)
        {
            var cmd = DbConnection.Database.Connection.CreateCommand();
            cmd.CommandText = commandName;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            DbConnection.Database.Connection.Open();
            if (paramArray != null)
                cmd.Parameters.AddRange(paramArray);
            return cmd.ExecuteNonQuery();
        }

        internal async Task<int> ExecuteNonQueryAsync(string commandName, SqlParameter[] paramArray)
        {
            var cmd = DbConnection.Database.Connection.CreateCommand();
            cmd.CommandText = commandName;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            await DbConnection.Database.Connection.OpenAsync();
            if (paramArray != null)
                cmd.Parameters.AddRange(paramArray);
            return await cmd.ExecuteNonQueryAsync();
        }

        internal object ExecuteScalar(string commandName, SqlParameter[] paramArray)
        {
            var cmd = DbConnection.Database.Connection.CreateCommand();
            cmd.CommandText = commandName;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            DbConnection.Database.Connection.Open();
            if (paramArray != null)
                cmd.Parameters.AddRange(paramArray);
            return cmd.ExecuteScalar();
        }

        internal async Task<object> ExecuteScalarAsync(string commandName, SqlParameter[] paramArray)
        {
            var cmd = DbConnection.Database.Connection.CreateCommand();
            cmd.CommandText = commandName;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            await DbConnection.Database.Connection.OpenAsync();
            if (paramArray != null)
                cmd.Parameters.AddRange(paramArray);
            return await cmd.ExecuteScalarAsync();
        }
    }

    internal class DatabaseContextReader
    {
        public DatabaseContextReader(DbDataReader rdr, System.Data.Entity.Core.Objects.ObjectContext ctxt)
        {
            reader = rdr;
            _context = ctxt;
        }

        readonly DbDataReader reader;
        readonly System.Data.Entity.Core.Objects.ObjectContext _context;
        public IList<T> GetResults<T>()
        {
            var retval = _context.Translate<T>(reader).ToList<T>();
            reader.NextResult();
            return retval;
        }

        public async Task<IList<T>> GetResultsAsync<T>()
        {
            var retval = _context.Translate<T>(reader).ToList<T>();
            await reader.NextResultAsync();
            return retval;
        }

    }
}
