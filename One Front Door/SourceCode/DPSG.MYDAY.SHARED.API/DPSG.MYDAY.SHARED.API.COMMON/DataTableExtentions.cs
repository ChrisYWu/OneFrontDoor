using System.Data;

namespace DPSG.MYDAY.SHARED.API.Common
{
    public static class DataTableExtentions
    {
        public static void SetColumnsOrder(this DataTable table, params string[] columnNames)
        {
            var columnIndex = 0;
            foreach (var columnName in columnNames)
            {
                table.Columns[columnName].SetOrdinal(columnIndex);
                columnIndex++;
            }
        }
    }
}
