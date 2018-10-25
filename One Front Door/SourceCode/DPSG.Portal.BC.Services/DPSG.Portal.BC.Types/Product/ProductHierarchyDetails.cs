using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Product
{  
    [DataContract]
    public class ProductHierarchyDetails
    {
        [DataMember]
        public IList<Types.Product.Contract.Hierarchy.Brand> Brands = new List<Types.Product.Contract.Hierarchy.Brand>();
        [DataMember]
        public IList<Types.Product.Contract.Hierarchy.Package> Packages = new List<Types.Product.Contract.Hierarchy.Package>();
        [DataMember]
        public IList<Types.Product.Contract.Hierarchy.Trademark> TradeMarks = new List<Types.Product.Contract.Hierarchy.Trademark>();
    }
}
