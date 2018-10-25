using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace DPSG.Portal.BC.Services.DataContract
{
    [DataContract]
    public class Bottler : Base
    {
        [DataMember]
        public int BottlerID { get; set; }
        [DataMember]
        public string  SAPBottlerID { get; set; }
        [DataMember]
        public string BottlerName { get; set; }                
        [DataMember]
        public int? ChannelID { get; set; }
        [DataMember]
        public int StatusID { get; set; }
        [DataMember]
        public int? BCRegionID { get; set; }
        [DataMember]
        public string Address { get; set; }
        [DataMember]
        public string City { get; set; }
        [DataMember]
        public string County { get; set; }
        [DataMember]
        public string State { get; set; }
        [DataMember]
        public string PostalCode { get; set; }
        [DataMember]
        public string Country { get; set; }
        [DataMember]
        public string Email { get; set; }
        [DataMember]
        public string PhoneNumber { get; set; }
        [DataMember]
        public decimal? GeoLatitude { get; set; }
        [DataMember]
        public decimal? GeoLongitude { get; set; }      
    }
}