using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.CompilerServices;
using System.Data.Common;
using System.Data.SqlClient;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.DataService
{
   public class MerchConnectionWrapper
    {
        MerchConnection _connection;

        protected MerchConnection dbConnection
        {
            get { return _connection; }
        }


        protected void CommitTransaction(Boolean closeSession)
        {
            dbConnection.SaveChanges();
        }

        protected void RollbackTransaction(Boolean closeSession)
        {

        }

        protected void Save(object entity) { }

        protected void CreateSession()
        {
            _connection = new MerchConnection();
        }
        protected void BeginTransaction() { }

        protected void CloseSession()
        {
            if (_connection != null)
            {
                _connection.Database.Connection.Close();
                _connection.Dispose();
            }
        }

        protected void CloseSessionOnly()
        {
            if (_connection != null)
            {
                _connection.Database.Connection.Close();
            }
        }

        public void Dispose()
        {
            if (_connection != null)
                _connection.Dispose();
        }
        protected IList<T> ExecuteReader<T>(string commandName, System.Data.Common.DbParameter[] paramArray)
        {
            var cmd = this.dbConnection.Database.Connection.CreateCommand();
            cmd.CommandText = commandName;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            this.dbConnection.Database.Connection.Open();
            if (paramArray != null)
                cmd.Parameters.AddRange(paramArray);
            var reader = cmd.ExecuteReader();
            var results = ((System.Data.Entity.Infrastructure.IObjectContextAdapter)dbConnection).ObjectContext.Translate<T>(reader).ToList<T>();
            return results;
        }

        protected IList<T> ExecuteReader<T>(string commandName)
        {
            return ExecuteReader<T>(commandName, null);
        }

        internal MerchReader ExecuteReader(string commandName, SqlParameter[] paramArray)
        {
            var cmd = this.dbConnection.Database.Connection.CreateCommand();
            cmd.CommandText = commandName;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            this.dbConnection.Database.Connection.Open();
            if (paramArray != null)
                cmd.Parameters.AddRange(paramArray);
            var reader = cmd.ExecuteReader();
            MerchReader MerchReader = new MerchReader(reader, ((System.Data.Entity.Infrastructure.IObjectContextAdapter)dbConnection).ObjectContext);
            return MerchReader;
        }

        internal int ExecuteNonQuery(string commandName, SqlParameter[] paramArray)
        {
            var cmd = this.dbConnection.Database.Connection.CreateCommand();
            cmd.CommandText = commandName;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            this.dbConnection.Database.Connection.Open();
            if (paramArray != null)
                cmd.Parameters.AddRange(paramArray);
            return cmd.ExecuteNonQuery();
        }

        internal object ExecuteScalar(string commandName, SqlParameter[] paramArray)
        {
            var cmd = this.dbConnection.Database.Connection.CreateCommand();
            cmd.CommandText = commandName;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            this.dbConnection.Database.Connection.Open();
            if (paramArray != null)
                cmd.Parameters.AddRange(paramArray);
            return cmd.ExecuteScalar();
        }
    }
    internal class MerchReader
    {
        public MerchReader(DbDataReader rdr, System.Data.Entity.Core.Objects.ObjectContext ctxt)
        {
            reader = rdr;
            context = ctxt;
        }

        DbDataReader reader;
        System.Data.Entity.Core.Objects.ObjectContext context;
        public IList<T> GetResults<T>()
        {
            var retval = context.Translate<T>(reader).ToList<T>();
            reader.NextResult();
            return retval;
        }
    }

}

