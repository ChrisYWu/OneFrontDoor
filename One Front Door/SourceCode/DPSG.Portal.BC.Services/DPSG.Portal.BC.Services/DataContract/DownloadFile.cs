using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract
{
    [DataContract]
    public class DownloadFile:ResponseBase
    {
        [DataMember]
        public string _fielByte { get; set; }
        [DataMember]
        public long _fileLength { get; set; }
    }
}