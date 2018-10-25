using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.RetailExecution
{
    [DataContract ]
  public class StoreExecutionData
    {
        [DataMember]
        public List<DPSG.Portal.BC.Types.RetailExecution.StoreExecution> StoreExecution = new List<DPSG.Portal.BC.Types.RetailExecution.StoreExecution>();
        [DataMember]
        public List<DPSG.Portal.BC.Types.RetailExecution.StoreExecutionDisplay> StoreExecutionDisplay = new List<DPSG.Portal.BC.Types.RetailExecution.StoreExecutionDisplay>();
    }
}
