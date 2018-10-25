/// <summary>
/*  
    * Module Name         :DPSG.Portal.Framework.Types.PromoAttachment.cs
    * Purpose             :attachment details of Promotion.
    * Created Date        :4/15/2013
    * Created By          :Ranjeet Tiwari
    * Last Modified Date  :4/15/2013
    * Last Modified By    :Ranjeet Tiwari
    * Where To Use        :PlayBook
    * Dependancy          :
*/
/// </summary>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class PromoAttachment
    {
        [DataMember]
        public int ID { get; set; }
        
        [DataMember]
        public string Name { get; set; }
        
        [DataMember]
        public string URL { get;set; }
        
        [DataMember]
        public string Type { get; set; }
        
        [DataMember]
        public byte[] Content { get; set; }
        
        [DataMember]
        public int SystemId { get; set; }

        [DataMember]
        public string SystemName { get; set; }

        [DataMember]
        public string SystemIds { get; set; }
        [DataMember]
        public string SystemDisplayNames { get; set; }

        [DataMember]
        public int TypeId { get; set; }
        [DataMember]
        public bool IsDeleted { get; set; }
        [DataMember]
        public bool IsNew { get; set; }
        [DataMember]
        public string AttachmentDocumentID { get; set; }

        [DataMember]
        public int AttachmentSize { get; set; }

        
    }
}
