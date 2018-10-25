using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Priority.Contract
{
    [DataContract]
    public class PriorityQuestion : Base
    {
        private DateTime _startDate;
        private DateTime _endDate;
        private DateTime _createdDate;
        private DateTime _modifiedDate;

        [DataMember]
        public int PriorityID { get; set; }

        [DataMember]
        public string PriorityDesc { get; set; }

        [DataMember]
        public string StartDate
        {
            get { return _startDate.ToString("MM/dd/yyyy"); }
            set { _startDate = DateTime.Parse(value); }
        }

        [DataMember]
        public string EndDate
        {
            get { return _endDate.ToString("MM/dd/yyyy"); }
            set { _endDate = DateTime.Parse(value); }
        }

        [DataMember]
        public string CreatedDate
        {
            get { return _createdDate.ToString("MM/dd/yyyy"); }
            set { _createdDate = DateTime.Parse(value); }
        }

        [DataMember]
        public string ModifiedDate
        {
            get { return _modifiedDate.ToString("MM/dd/yyyy"); }
            set { _modifiedDate = DateTime.Parse(value); }
        }
    }
}