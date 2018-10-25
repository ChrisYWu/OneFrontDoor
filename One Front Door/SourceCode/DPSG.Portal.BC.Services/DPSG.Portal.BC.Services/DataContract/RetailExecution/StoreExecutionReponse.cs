using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.RetailExecution
{
    [DataContract]
    public class StoreExecutionReponse : ResponseBase
    {
        [DataMember]
        public int ExecutionID;
    }
}