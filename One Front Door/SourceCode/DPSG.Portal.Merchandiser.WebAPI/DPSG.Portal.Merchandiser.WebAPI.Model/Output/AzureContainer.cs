using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Output
{
    public class ContainerList : OutputBase
    {
        public List<AzureContainer> Containers { get; set; }
    }

    public class AzureContainer
    {
        public int ContainerID {get; set;}
        public string ConnectionString {get; set;}
        public string Container { get; set;}

    }
}

