using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.RetailExecution
{
    [DataContract]
   public class StoreExecution
    {

        [DataMember]
        public int ExecutionID {get; set;}
        [DataMember]
        public int PromotionID {get; set;}
        [DataMember]
        public string CustomerNumber { get; set; }
        //[DataMember]
        //public int CustomerNumber { get; set; }
        [DataMember]
        public int StatusID {get; set;}
        [DataMember]
        public string StatusDate {get; set;}
        [DataMember]
        public string GSN { get; set; }
        [DataMember]
        public int EmployeeID { get; set; }
        [DataMember]
        public string EmployeeName { get; set; }
        [DataMember]
        public string RouteNumber { get; set; }
        //[DataMember]
        //public int RouteNumber { get; set; }
        [DataMember]
        public string ManagerNotes { get; set; }
        [DataMember]
        public StoreExecutionDisplay StoreExecutionDisplay { get; set; }
        [DataMember]
        public decimal Latitude { get; set; }
        [DataMember]
        public decimal Longitude { get; set; }
    }
}
