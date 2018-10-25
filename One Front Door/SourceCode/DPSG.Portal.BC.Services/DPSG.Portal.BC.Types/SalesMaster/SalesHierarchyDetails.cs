using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.SalesMaster
{
    [DataContract]
    public class SalesHierarchyDetails
    {
        [DataMember]
        public IList<Types.SalesMaster.Contract.SalesHierarchyDivision> Divisons = new List<Types.SalesMaster.Contract.SalesHierarchyDivision>();

        [DataMember]
        public IList<Types.SalesMaster.Contract.SalesHierarchyRegion> Regions = new List<Types.SalesMaster.Contract.SalesHierarchyRegion>();

        [DataMember]
        public IList<Types.SalesMaster.Contract.SalesHierarchySystem> Systems = new List<Types.SalesMaster.Contract.SalesHierarchySystem>();

        [DataMember]
        public IList<Types.SalesMaster.Contract.SalesHierarchyZone> Zones = new List<Types.SalesMaster.Contract.SalesHierarchyZone>();
    }
}
