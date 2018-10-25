using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.SalesHierarchy
{
    [DataContract]
    public class SalesHierarchyData : Base
    {
        //[DataMember]
        //public IList<TotalCompany> totalcompany = new List<TotalCompany>();
        //[DataMember]
        //public IList<Country> country = new List<Country>();
        [DataMember]
        public IList<System> Systems = new List<System>();
        [DataMember]
        public IList<Zone> Zones = new List<Zone>();
        [DataMember]
        public IList<Division> Divisons = new List<Division>();
        [DataMember]
        public IList<Region> Regions = new List<Region>();
        //[DataMember]
        //public IList<BottlerSalesHier> bottlersaleshier = new List<BottlerSalesHier>();
    }
}