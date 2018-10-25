using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.BC.Types
{
    public class BottlerSalesHier
    {       
        public string TotalCompanyName{get;set;}       
        public int TotalCompanyID{get;set;}       
        public string HierType{get;set;}       
        public string CountryName{get;set;}       
        public int CountryID{get;set;}       
        public string SystemName{get;set;}       
        public string ZoneName{get;set;}       
        public int ZoneID{get;set;}       
        public string DivisionName{get;set;}      
        public int DivisionID{get;set;}       
        public string RegionName{get;set;}       
        public int RegionID{get;set;}       
        public string RegionBCNodeID{get;set;}        
        public bool IsActive { get; set; }        
        public bool IsDeleted { get; set; }
    }
}
