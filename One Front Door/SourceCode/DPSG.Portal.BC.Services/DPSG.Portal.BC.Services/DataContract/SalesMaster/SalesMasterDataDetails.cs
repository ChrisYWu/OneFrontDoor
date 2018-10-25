using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract.SalesMaster
{
    [DataContract]
    public class SalesMasterDataDetails : ResponseBase
    {
        [DataMember]
        public IList<Types.SalesMaster.Contract.Bottler> Bottler = new List<Types.SalesMaster.Contract.Bottler>();

        [DataMember]
        public IList<Types.SalesMaster.Contract.BottlerTrademarks> BottlerTradeMark = new List<Types.SalesMaster.Contract.BottlerTrademarks>();

        [DataMember]
        public IList<Types.SalesMaster.Contract.SalesAccount> SalesAccounts = new List<Types.SalesMaster.Contract.SalesAccount>();

        [DataMember]
        public Types.SalesMaster.SalesHierarchyDetails SalesHierarchyData { get; set; }

    }
}