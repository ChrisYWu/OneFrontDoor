using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.BC.Types
{
    public class ServiceLog
    {
        public string ServiceName { get; set; }
        public string OperationName { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string GSN { get; set; }
        public string Type { get; set; }
        public string Exception { get; set; }
        public string GUID { get; set; }
        public string ComputerName { get; set; }
        public string UserAgent { get; set; }
    }
}
