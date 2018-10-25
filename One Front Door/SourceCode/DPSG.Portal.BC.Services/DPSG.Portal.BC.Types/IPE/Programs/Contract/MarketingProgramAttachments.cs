using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.IPE.Programs.Contract
{
    [DataContract]
    public class MarketingProgramAttachments
    {
        private DateTime _lastModifiedDate;

        [DataMember]
        public int ProgramID { get; set; }
        [DataMember]
        public int AttachmentID { get; set; }
        [DataMember]
        public string FileURL { get; set; }
        [DataMember]
        public string FileName { get; set; }
        [DataMember]
        public int Size { get; set; }
        [DataMember]
        public string LastModifiedDate
        {
            get { return _lastModifiedDate.ToString("MM/dd/yyyy"); }
            set { _lastModifiedDate = DateTime.Parse(value); }
        }
    }
}
