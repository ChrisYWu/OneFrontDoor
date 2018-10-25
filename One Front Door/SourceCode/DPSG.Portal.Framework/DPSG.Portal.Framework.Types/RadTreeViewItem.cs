using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    public class RadTreeViewItem
    {
        private string _text;
        private int _id;
        private int _parentId;
        private string _sapId;

        public string Text
        {
            get { return _text; }
            set { _text = value; }
        }


        public int ID
        {
            get { return _id; }
            set { _id = value; }
        }

        public int ParentID
        {
            get { return _parentId; }
            set { _parentId = value; }
        }

        public string SAPID
        {
            get { return _sapId; }
            set { _sapId = value; }
        }

        public RadTreeViewItem(int id, int parentId, string text, string sapId)
        {
            _id = id;
            _parentId = parentId;
            _text = text;
            _sapId = sapId;
        }
    }
}
