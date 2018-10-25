using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.Types
{
   public class LOS
    {
        
        public int LOSID{get;set;}

        
        public int ChannelID{get;set;}
        
        public int SAPChannelID{get;set;}

        
        public int? LocalChainID{get;set;}
        
        public int? SAPLocalChainID{get;set;}

        
        public int? StoreID{get;set;}

        
        public int? SAPStoreID{get;set;}

        
        public string ImageURL{get;set;}

        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
    }
}
