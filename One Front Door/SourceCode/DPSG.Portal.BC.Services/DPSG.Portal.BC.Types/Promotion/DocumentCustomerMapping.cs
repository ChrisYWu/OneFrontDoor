using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Promotion
{
    [DataContract]
    public class DocumentCustomerMapping
    {
        [DataMember]
        public string CustomerNumber;

        //[DataMember]
        //public List<DPSG.Portal.BC.Types.Promotion.Document> Attachments = new List<DPSG.Portal.BC.Types.Promotion.Document>();

        [DataMember]
        public string[] Attachments;
        public int MetaDataTableID;
    }
}
