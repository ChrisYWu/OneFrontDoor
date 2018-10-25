using System;
using System.Runtime.Serialization;
using Newtonsoft.Json;

namespace DPSG.Portal.BC.Types.Account.AdHoc
{
    [DataContract]
    public class Account
    {
        [DataMember]
        [JsonProperty("ClientStoreID", Required = Required.Always)]
        public int ClientStoreID { get; set; }
        
        [DataMember]
        [JsonProperty("AccountName", Required = Required.Always)]
        public string AccountName { get; set; }

        [DataMember]
        [JsonProperty("AccountNumber", Required = Required.Always)]
        public int AccountNumber { get; set; }
        
        [DataMember]
        [JsonProperty("Address", Required = Required.Always)]
        public string Address { get; set; }

        [DataMember]
        [JsonProperty("City", Required = Required.Always)]
        public string City { get; set; }

        [DataMember]
        [JsonProperty("State", Required = Required.Always)]
        public string State { get; set; }

        [DataMember]
        [JsonProperty("PostalCode", Required = Required.Always)]
        public string PostalCode { get; set; }

        [DataMember]
        [JsonProperty("Longitude", Required = Required.Always)]
        public decimal Longitude { get; set; }

        [DataMember]
        [JsonProperty("Latitude", Required = Required.Always)]
        public decimal Latitude { get; set; }

        [DataMember]
        [JsonProperty("RegionID", Required = Required.Always)]
        public int RegionID { get; set; }

        [DataMember]
        [JsonProperty("LocalChainID", Required = Required.Always)]
        public int LocalChainID { get; set; }

        [DataMember]
        [JsonProperty("MyDayCreated", Required = Required.Always)]
        public DateTime MyDayCreated { get; set; }

        [DataMember]
        [JsonProperty("CreatedBy", Required = Required.Always)]
        public string CreatedBy { get; set; }

    }
}
