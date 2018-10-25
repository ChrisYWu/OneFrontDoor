using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class ViewPromotionFilter
    {
        public bool IsNew { get; set; }
        public bool IsCancelled { get; set; }
        public bool IsUpdated { get; set; }
        public bool RefreshData { get; set; }
        public int BranchID { get; set; }
        public string GSN { get; set; }
        public DateTime LastLoginTIme { get; set; }
        public string SelectedSortValue { get; set; }
        public PlaybookSortOrder SortOrder { get; set; }
        public string SearchText { get; set; }
        public string Status { get; set; }
    }
}
