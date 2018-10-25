/// <summary>
/*  Module Name         : User Preference 
 *  Purpose             : Provide the Structure For User Preferences
 *  Created Date        : 23-Jan-2013
 *  Created By          : Himanshu Panwar
 *  Last Modified Date  : 23-Jan-2013
 *  Last Modified By    : 23-Jan-2013
 *  Where to use        : In One Portal
 *  Dependency          : 
*/
/// </summary>

#region using

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.SharePoint;
using System.Collections;

#endregion

namespace DPSG.Portal.Framework.Types
{
    public class UserInfo
    {
        //newly added User Profile Properties

        //public OnePortalRole PrimaryRole { get; set; }
        public List<Branch> AdditionalBranches { get; set; }
        public List<BranchTradeMarks> TradeMarks { get; set; }

        //For CAN
        public List<BranchCAN> BranchCAN { get; set; }

        public bool IsPreferenceSaved { get; set; }

        //Old User Profile Properties Used
        public ArrayList MyLinks { get; set; }
        public string LoginName { get; set; }

        //Added For Playbook
        public BranchInfo PrimaryBranch { get; set; }

        public BCRegionInfo PrimaryBCRegion { get; set; }

        public List<BCRegion> AdditionalBCRegion { get; set; }

        

        //Used in SDM 
        public string GSN { get; set; }

        //AD attributes
        public string UserCity { get; set; }
        public int? ZipCode { get; set; }

        //Accounts
        public UserAccounts Accounts { get; set; }
        public GeoRelevancy Geo { get; set; }
        public UserChannels Channels { get; set; }
        public string DefaultPromotion { get; set; }
        //public string DefaultSystem {get; set; }
        //public IList<ProgramSystem>Systems{get; set; }
        //public int PrimaryRoleId { get; set; }

        //Route 
        public List<UserRoutes> Routes { get; set; }

        //Goal Accounts
        public List<UserGoalAccount> GoalAccount { get; set; }
        public int DefaultGoalFunctionID { get; set; }

        public List<BCRegion> BCRegion { get; set; }

       // public string LocalAccounts { get; set; }
       
        //public string BCLocations { get; set; }

       
        //User Locations 
        public List<UserGeoLocations> UserLocations { get; set; }

        //User Persona 
        public List<Persona> UserPersona { get; set; }
        public int SPUserProfileID { get; set; }

        public List<AccountInfo> MyAccounts { get; set; }
        public List<AccountInfo> MyChannels { get; set; }

        // For Plants
        public List<Plants> MyPlants { get; set; }
        public string DefaultManufacture { get; set; }
        public ProductLine ProductLines { get; set; }

        // For Product Line of Supply Chain
        public List<UserProductLinesItem> UserProductLineItems { get; set; }
        public string DefaultInventoryPerf { get; set; }
    }
}



