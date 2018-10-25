using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract
{
    [DataContractAttribute]
    public class Base
    {
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