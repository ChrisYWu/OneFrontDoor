using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class PromoAccount
    {
        private int? _regionalChainID;
        public int? RegionalChainID
        {
            get
            {
                return this._regionalChainID;
            }
            set
            {
                this._regionalChainID = value;
            }
        }

        private string _regionalChainName;
        public string RegionalChainName
        {
            get
            {
                return this._regionalChainName;
            }
            set
            {
                this._regionalChainName = value;
            }
        }
        private int _promotionID;
        public int PromotionID
        {
            get
            {
                return this._promotionID;
            }
            set
            {
                this._promotionID = value;
            }
        }

        private int _promotionAccountID;
        public int PromotionAccountID
        {
            get
            {
                return this._promotionAccountID;
            }
            set
            {
                this._promotionAccountID = value;
            }
        }

        private int? _nationalChainID;
        public int? NationalChainID
        {
            get
            {
                return this._nationalChainID;
            }
            set
            {
                this._nationalChainID = value;
            }
        }
        private string _nationalChainName;
        public string NationalChainName
        {
            get
            {
                return this._nationalChainName;
            }
            set
            {
                this._nationalChainName = value;
            }
        }

        private int? _localChainID;
        public int? LocalChainID
        {
            get
            {
                return this._localChainID;
            }
            set
            {
                this._localChainID = value;
            }
        }

        private string _localChainName;
        public string LocalChainName
        {
            get
            {
                return this._localChainName;
            }
            set
            {
                this._localChainName = value;
            }
        }

        private bool? _isRoot;
        public bool? IsRoot
        {
            get
            {
                return this._isRoot;
            }
            set
            {
                this._isRoot = value;
            }
        }


         public string AccountName { get; set; }

         private string _accountchainID;
          public string AccountChainID
          {
              get
              {
                  if (LocalChainID != null && LocalChainID != 0)
                  {
                      _accountchainID = LocalChainID + "§Local";
                  }

                  else if (RegionalChainID != null && RegionalChainID != 0)
                  {
                      _accountchainID = RegionalChainID+"§Regional";
                  }

                  else if (NationalChainID != null && NationalChainID != 0)
                  {
                      _accountchainID = NationalChainID+"§National";
                      
                  }

                  return this._accountchainID;
              }
          }
          public string CreatedBy { get; set; }
          public int PromotionTypeID { get; set; }
          public bool IsMyAccount { get; set; }
    }
}
