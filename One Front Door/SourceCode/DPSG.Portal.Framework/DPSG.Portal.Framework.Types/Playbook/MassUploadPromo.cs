using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class MassUploadPromo
    {
        public int ID { get; set; }
        public string Row_Number { get; set; }
        public int PromotionID { get; set; }
        public string Promotion_Name { get; set; }
        public string Comments { get; set; }
        public string System_RTM { get; set; }
        public string Select_National_Chain_Account { get; set; }
        public string Accounts { get; set; }
        public string Brand_Package_Category { get; set; }
        public string Brands { get; set; }
        public string Packages { get; set; }
        public string Retail_Price { get; set; }
        public string Invoice_Price { get; set; }
        public string Category { get; set; }
        public string Display_Location { get; set; }
        public string Other_Display_Location { get; set; }  // Edited as per BC2 by saurabh
        public string Start_Date { get; set; } // Edited as per BC2 by saurabh
        public string End_Date { get; set; }   // Edited as per BC2 by saurabh
        public string Forecast_Volume { get; set; }
        public string National_Display_Target { get; set; }
        public string Status { get; set; }
        public string ErrorDescription { get; set; }
        public string AccountImageName { get; set; }
        public string CreatedBy { get; set; }
        public bool Succeed { get; set; }        
        public List<PromoAttachment> Attachments { get; set; }

        // New columns as per BC2 added by saurabh
        public string GEOXML { get; set; }
        public string Geo_Relevancy { get; set; }
        public string Display_Requirement { get; set; }
        public string Display_Start_Date { get; set; }
        public string Display_End_Date { get; set; }
        public string Pricing_Start_Date { get; set; }
        public string Pricing_End_Date { get; set; }
        public string SMA_Required { get; set; }
        
        public string Cost_Per_Store { get; set; }
        public string TPM_Promotion_Number_CASO { get; set; }
        public string TPM_Promotion_Number_PASO { get; set; }
        public string TPM_Promotion_Number_ISO { get; set; }
        public string TPM_Promotion_Number_PB { get; set; }
        public string Cost_Info { get; set; }
        public string RoleName { get; set; }
        public int PersonaID { get; set; }
        public int PromotionTypeID { get; set; }
        public string Display_Type { get; set; }
        public bool IsNationalAccountPromotion { get; set; }
        public string VariableRPC { get; set; }
        public string Redemption { get; set; }
        public string FixedCost { get; set; }
        public string AccrualComments { get; set; }
        public string Unit { get; set; }
        public string Accounting { get; set; }
        public string RegionalChain { get; set; }
        public string LocalChain { get; set; }
        public string DPSGHierarchyLevel1 { get; set; }
        public string DPSGHierarchyLevel2 { get; set; }
        public string DPSGHierarchyLevel3 { get; set; }
        public string OtherBrand { get; set; }
        public string SendBottlerAnnouncement { get; set; }
        

    }
}
