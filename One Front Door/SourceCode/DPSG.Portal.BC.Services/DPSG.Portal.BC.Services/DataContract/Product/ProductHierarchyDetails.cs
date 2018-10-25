using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.Product
{
    [DataContract]
    public class ProductHierarchyDetails:ResponseBase
    {
        [DataMember]
        public IList<Types.Product.Contract.Hierarchy.Brand> Brands = new List<Types.Product.Contract.Hierarchy.Brand>();
        [DataMember]
        public IList<Types.Product.Contract.Hierarchy.Package> Packages = new List<Types.Product.Contract.Hierarchy.Package>();
        [DataMember]
        public IList<Types.Product.Contract.Hierarchy.Trademark> TradeMarks = new List<Types.Product.Contract.Hierarchy.Trademark>();
    }
}