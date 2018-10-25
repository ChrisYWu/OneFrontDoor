using System;
using System.Linq;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Types.Account.Bottler.Contract
{
    [DataContract]
    public class BottlerAccount : Base
    {
        [DataMember]
        public int StoreID { get; set; }
        [DataMember]
        public int SAPAccountID { get; set; }
        [DataMember]
        public int BottlerID { get; set; }
        [DataMember]
        public string StoreName { get; set; }
        [DataMember]
        public string Address { get; set; }
        [DataMember]
        public string City { get; set; }
        [DataMember]
        public string State { get; set; }
        [DataMember]
        public string PostalCode { get; set; }
        [DataMember]
        public string PhoneNumber { get; set; }
        [DataMember]
        public decimal Latitude { get; set; }
        [DataMember]
        public decimal Longitude { get; set; }
        [DataMember]
        public int ChannelID { get; set; }
        [DataMember]
        public int NationalChainID { get; set; }
        [DataMember]
        public int RegionalChainID { get; set; }
        [DataMember]
        public int LocalChainID { get; set; }
        [DataMember]
        public int BCRegionID { get; set; }




    }
}