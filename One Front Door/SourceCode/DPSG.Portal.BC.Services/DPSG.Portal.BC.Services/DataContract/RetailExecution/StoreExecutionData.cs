using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.RetailExecution
{
    [DataContract]
    public class StoreExecutionData : ResponseBase
    {
        [DataMember]
        public List<DPSG.Portal.BC.Types.RetailExecution.StoreExecution> StoreExecution = new List<DPSG.Portal.BC.Types.RetailExecution.StoreExecution>();

        [DataMember]
        public List<DPSG.Portal.BC.Types.RetailExecution.StoreExecutionDisplay> StoreExecutionDisplay = new List<DPSG.Portal.BC.Types.RetailExecution.StoreExecutionDisplay>();
    }
}