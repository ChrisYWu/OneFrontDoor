using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Promotion
{
    [DataContract]
    public class Documents:ResponseBase
    {
        [DataMember]
        public List<DPSG.Portal.BC.Types.Promotion.Document> Attachments = new List<DPSG.Portal.BC.Types.Promotion.Document>();
        [DataMember]
        public List<DPSG.Portal.BC.Types.Promotion.DocumentCustomerMapping> AttachmentCustomerMapping = new List<DPSG.Portal.BC.Types.Promotion.DocumentCustomerMapping>();

    }
}