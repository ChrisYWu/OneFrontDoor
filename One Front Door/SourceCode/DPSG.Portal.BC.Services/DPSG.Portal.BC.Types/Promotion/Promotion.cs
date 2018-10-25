using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;


namespace DPSG.Portal.BC.Types.Promotion
{
    [DataContract]
    public class Promotion
    {
        [DataMember]
        public int PromotionID { get; set; }
        [DataMember]
        public string PromotionName { get; set; }
        [DataMember]
        public string PromotionDescription { get; set; }
        [DataMember]
        public string InStoreStartDate { get; set; }
        [DataMember]
        public string InStoreEndDate { get; set; }
        [DataMember]
        public string DisplayStartDate { get; set; }
        [DataMember]
        public string DisplayEndDate { get; set; }
        [DataMember]
        public string PricingStartDate { get; set; }
        [DataMember]
        public string PricingEndDate { get; set; }
        [DataMember]
        public string ForecastedVolume { get; set; }
        [DataMember]
        public string NationalDisplayTarget { get; set; }
        [DataMember]
        public string RetailPrice { get; set; }
        [DataMember]
        public string InvoicePrice { get; set; }
        [DataMember]
        public string Category { get; set; }
        [DataMember]
        public string DisplayRequirement { get; set; }       
        [DataMember]
        public int DisplayLocationID { get; set; }
        [DataMember]
        public int DisplayTypeID { get; set; }
        [DataMember]
        public string PromotionType { get; set; }
        [DataMember]
        public string DisplayComments { get; set; }
        [DataMember]
        public int? Priority { get; set; }
        [DataMember]
        public string CreatedDate { get; set; }
        [DataMember]
        public string ModifiedDate { get; set; }
        [DataMember]
        public string InformationCategory { get; set; }
        [DataMember]
        public string BrandComments { get; set; }
        [DataMember]
        public bool SendBottlerAnnouncement { get; set; }
        [DataMember]
        public bool IsActive { get; set; }
        [DataMember]
        public bool IsDeleted { get; set; }
        [DataMember]
        public int CategoryID { get; set; }
        [DataMember]
        public string ModifiedBy { get; set; }
        [DataMember]
        public string LastName { get; set; }
        [DataMember]
        public string FirstName { get; set; }
        [DataMember]
        public string EmailID { get; set; }
        [DataMember]
        public int AccountProgramID { get; set; }
        [DataMember]
        public int MarketingProgramID { get; set; }
        [DataMember]
        public string MarketingProgramName { get; set; }
        [DataMember]
        public int PromotionGroupID { get; set; }
       


      

      

      
    }
}
