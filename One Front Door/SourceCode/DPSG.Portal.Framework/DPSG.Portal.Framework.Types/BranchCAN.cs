using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class BranchCAN
    {
        private Branch branch = new Branch();
        private CAN cans = new CAN();
        [DataMember]
        public Branch Branch
        {
            get { return branch; }
            set { branch = value; }
        }
        [DataMember]
        public CAN CANs
        {
            get { return cans; }
            set { cans = value; }
        }
    }
}
