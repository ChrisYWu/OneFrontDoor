using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class TreeViewItem
    {
        public int Id { get; set; }
        public string Text { get; set; }
        public string SAPValue { get; set; }
        public int ParentId { get; set; }
        public string Value { get; set; }
        public string CreatedBy { get; set; }
    }
}
