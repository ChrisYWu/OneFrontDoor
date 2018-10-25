using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    [DataContract]
    public enum PromoGeoType
    {
        System = 1,
        Zone = 2,
        Division = 3,
        BCRegion = 4,
        Bottler = 5,
        BU = 6,
        Area = 8,
        Region = 7,
        Branch = 9,
        State = 10
    }
}
