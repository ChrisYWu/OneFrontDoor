using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class SelectedTreeItem
    {
        [DataMember]
        public string Value { get; set; }

        [DataMember]
        public string Name { get; set; }

        [DataMember]
        public string Type { get; set; }

        [DataMember]
        public int ItemLevel { get; set; }

        [DataMember]
        public string SAPID { get; set; }

    }
}
