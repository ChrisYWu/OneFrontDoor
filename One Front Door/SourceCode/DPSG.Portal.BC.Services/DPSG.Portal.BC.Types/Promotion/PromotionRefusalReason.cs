using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Promotion
{
    [DataContract]
    public class PromotionRefusalReason
    {
        [DataMember]
        public int PromotionRefusalReasonID;
        [DataMember]
        public string PromotionRefusalReasonName;
        [DataMember]
        public string Category;

        bool? isActive = true;
        [DataMember]
        public bool? IsActive { get { return isActive; } set { isActive = value; } }

        bool? isDeleted = false;
        [DataMember]
        public virtual bool? IsDeleted
        {
            get { return !isActive; }
            set { isDeleted = value; }
        }
    }
}
