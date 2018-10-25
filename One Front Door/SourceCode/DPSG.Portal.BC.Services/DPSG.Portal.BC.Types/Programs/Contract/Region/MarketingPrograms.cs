using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Programs.Contract.Region
{
    [DataContract]
    public class MarketingPrograms : Base
    {
        [DataMember]
        public int ProgramID { get; set; }
        [DataMember]
        public string ProgramName { get; set; }
        [DataMember]
        public string ProgramDescription { get; set; }
        [DataMember]
        public int ParentProgramID { get; set; }
        [DataMember]
        public string StartDate { get; set; }
        [DataMember]
        public string EndDate { get; set; }
        [DataMember]
        public string CreatedDate { get; set; }
        [DataMember]
        public string ModifiedDate { get; set; }
        [DataMember]
        public string ImageName { get; set; }
        [DataMember]
        public string ImageURL { get; set; }
        [DataMember]
        public string ModifiedBy { get; set; }
        [DataMember]
        public string LastName { get; set; }
        [DataMember]
        public string FirstName { get; set; }
        [DataMember]
        public string EmailID { get; set; }
        [DataMember]
        public int EventTypeID { get; set; }
        [DataMember]
        public int PriorityID { get; set; }

    }
}
