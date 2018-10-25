using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Priority
{
    [DataContract]
    public class PriorityQuestionsResults : ResponseBase
    {
        [DataMember]
        public IList<Types.Priority.Contract.PriorityBrand> PriorityBrands = new List<Types.Priority.Contract.PriorityBrand>();
        [DataMember]
        public IList<Types.Priority.Contract.PriorityCustomer> PriorityCustomers = new List<Types.Priority.Contract.PriorityCustomer>();
        [DataMember]
        public IList<Types.Priority.Contract.PriorityQuestion> PriorityQuestions = new List<Types.Priority.Contract.PriorityQuestion>();
    }
}
