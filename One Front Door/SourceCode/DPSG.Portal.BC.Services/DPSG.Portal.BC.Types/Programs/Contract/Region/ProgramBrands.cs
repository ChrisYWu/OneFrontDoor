using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Programs.Contract.Region
{
    [DataContract]
    public class ProgramBrands
    {
        [DataMember]
        public int ProgramID { get; set; }
        [DataMember]
        public int TrademarkID {get; set;}
        [DataMember]
        public int BrandID { get; set; }

    }
}
