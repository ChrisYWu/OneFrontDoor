using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Output
{
    public class BlobWithAccess : OutputBase
    {
        public string AbsoluteURL { get; set; }
        public string SAS { get; set; }
    }

    public class StringResponse : OutputBase
    {
        public string Response { get; set; }
    }

    public class StringsResponse : OutputBase
    {
        public List<string> Response { get; set; }
    }
}

