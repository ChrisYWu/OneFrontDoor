using System.Collections.Generic;
using System.Data;
using System.Reflection;

namespace DPSG.MYDAY.SHARED.API.Common
{
    public class ListtoDataTableConverter
    {
        public DataTable ToDataTable<T>(List<T> items, string tblName)
        {
            var dataTable = new DataTable(typeof(T).Name)
            {
                TableName = tblName
            };

            //Get all the properties
            var props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (var prop in props)
            {
                //Setting column names as Property names
                dataTable.Columns.Add(prop.Name);
            }
            foreach (var item in items)
            {
                var values = new object[props.Length];
                for (var i = 0; i < props.Length; i++)
                {
                    //inserting property values to datatable rows
                    values[i] = props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }
            //put a breakpoint here and check datatable
            return dataTable;
        }
    }
}

