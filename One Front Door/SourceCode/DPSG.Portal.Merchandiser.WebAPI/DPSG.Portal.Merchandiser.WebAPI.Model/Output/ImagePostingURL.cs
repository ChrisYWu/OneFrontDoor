using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Output
{
    public class ImagePostingURL : OutputBase
    {
        public string RelativePath { get; set; }
        public string AbsolutePath { get; set; }
        public string PostingPath { get; set; }
        public string Container { get; set; }
        public string StorageAccount { get; set; }
    }
}
