using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.RetailExecution
{
    [DataContract]
    public class StoreExecution
    {
        [DataMember]
        public int ExecutionID;
        [DataMember]
        public int PromotionID;
        [DataMember]
        public string CustomerNumber;
        [DataMember]
        public int StatusID;
        [DataMember]
        public DateTime StatusDate;
        [DataMember]
        public string GSN;
        [DataMember]
        public int EmployeeID;
        [DataMember]
        public string EmployeeName;
        [DataMember]
        public string RouteNumber;
        [DataMember]
        public string ManagerNotes;
        [DataMember]
        public StoreExecutionDisplay Display;


    }
}