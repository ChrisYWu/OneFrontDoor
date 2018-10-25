using System.Data.Linq;
using System.Data.Linq.Mapping;
using System.Data;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using System.Linq.Expressions;
using System.ComponentModel;
using System;

namespace DPSG.Portal.BC.DAL
{
    public partial class StoreConditionNote
    {
        public string ImageBytes { get; set; }
        public string ClientNoteID { get; set; }
    }

    public partial class PriorityStoreConditionExecution
    {
        public string ClientPriorityExecutionID { get; set; }
    }

    public partial class PromotionExecution
    {
        public string ClientPromotionExecutionID { get; set; }
        public string ClientDisplayID { get; set; }
    }

    public partial class StoreConditionDisplay
    {
        public string ImageBytes;
    }

    public partial class StoreConditionDisplayDetail
    {
        public int ClientDisplayId;
    }

    public partial class UploadedImage
    {
        public string FileUrl { get; set; }
        public string ID { get; set; }
    }
    
}
