using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class UserRoutes
    {
        [DataMember]
        public int RouteId { get; set; }
        [DataMember]
        public string RouteName { get; set; }      
    }
}
