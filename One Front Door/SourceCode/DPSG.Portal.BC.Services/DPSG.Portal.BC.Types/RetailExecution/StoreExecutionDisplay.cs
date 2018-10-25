using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.RetailExecution
{
    [DataContract]
  public   class StoreExecutionDisplay
    {
        [DataMember]
        public int ExecutionID {get; set;}
        [DataMember]
        public int DisplayLocationID { get; set; }
        [DataMember]
        public int DisplayTypeID { get; set; }
        [DataMember]
        public string Notes { get; set; }
        [DataMember]
        public int TotalCases { get; set; }
        //[DataMember]
        //public string TotalCases { get; set; }
        [DataMember]
        public int ReasonId { get; set; }
        [DataMember]
        public string DisplayRemoveDate { get; set; }
        [DataMember]
        public string ImageURL { get; set; }
        [DataMember]
        public string ImageName { get; set; }
        [DataMember]
        public decimal? Latitude { get; set; }
        [DataMember]
        public decimal? Longitude { get; set; }

    }
}
