using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;


namespace DPSG.Portal.BC.Services.DataContract.RetailExecution
{
    [DataContract]
    public class StoreExecutionDisplay
    {

        [DataMember]
        public int ExecutionID;
        [DataMember]
        public int DisplayLocationID;
        [DataMember]
        public int DisplayTypeID;
        [DataMember]
        public string Notes;
        [DataMember]
        public int TotalCases;
        [DataMember]
        public int ReasonId;
        [DataMember]
        public DateTime DisplayRemoveDate;
        [DataMember]
        public string  ImageURL;
        [DataMember]
        public string ImageName;


        
    }
}