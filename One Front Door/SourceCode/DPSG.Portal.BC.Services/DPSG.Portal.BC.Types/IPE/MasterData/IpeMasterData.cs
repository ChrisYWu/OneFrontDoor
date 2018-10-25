using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types.IPE.MasterData
{
    [DataContract]
    public class IpeMasterData
    {
        [DataMember]
        public IList<IPE.MasterData.Contract.EventPriorityEntity> EventPriority = new List<IPE.MasterData.Contract.EventPriorityEntity>();
        [DataMember]
        public IList<IPE.MasterData.Contract.EventTypeEntity> EventType = new List<IPE.MasterData.Contract.EventTypeEntity>();
        [DataMember]
        public IList<IPE.MasterData.Contract.PhaseEntity> Phase = new List<IPE.MasterData.Contract.PhaseEntity>();
        [DataMember]
        public IList<IPE.MasterData.Contract.QuestionResponderEntity> QuestionResponder = new List<IPE.MasterData.Contract.QuestionResponderEntity>();
        [DataMember]
        public IList<IPE.MasterData.Contract.QuestionsEntity> Questions = new List<IPE.MasterData.Contract.QuestionsEntity>();
        [DataMember]
        public IList<IPE.MasterData.Contract.ResponderEntity> Responder = new List<IPE.MasterData.Contract.ResponderEntity>();
        [DataMember]
        public IList<IPE.MasterData.Contract.ResponseTypeEntity> ResponseType = new List<IPE.MasterData.Contract.ResponseTypeEntity>();
        [DataMember]
        public IList<IPE.MasterData.Contract.ResponseTypeValuesEntity> ResponseTypeValues = new List<IPE.MasterData.Contract.ResponseTypeValuesEntity>();
    }
}
