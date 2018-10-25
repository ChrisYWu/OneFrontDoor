using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Store
{
    public class UploadTieIn: Base
    {
        //[DataMember]
        //Condition StoreCondition;
        //List<Display> StoreDisplays;
        //List<DisplayDetails> StoreDisplayDetails;
        //List<TieInRate> StoreTieInRates;
        
        //[DataMember]
        //public Condition StoreCondition;


        //public List<Condition> StoreCondition { get; set; }

        public Condition StoreCondition;
        
    }
}