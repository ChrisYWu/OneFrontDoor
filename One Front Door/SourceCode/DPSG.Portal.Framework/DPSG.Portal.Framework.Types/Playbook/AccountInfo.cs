using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Portal.Framework.Types.Constants;

namespace DPSG.Portal.Framework.Types
{
    public class AccountInfo
    {
        /// <summary>
        /// Holds the name of the account
        /// </summary>
        public string AccountName { get; set; }

        /// <summary>
        /// Account ID of the Account
        /// </summary>
        public int AccountID { get; set; }

        /// <summary>
        /// Local Chain relationship with the current account
        /// </summary>
        public int LocalChainID { get; set; }

        /// <summary>
        /// Regional Chain relationship with the current account
        /// </summary>
        public int RegionalChainID { get; set; }

        /// <summary>
        /// National Chain relationship with the current account
        /// </summary>
        public int NationalChainID { get; set; }

        /// <summary>
        /// Tree Value of the current account for TreeView
        /// </summary>
        public string TreeValue
        {
            get
            {
                return string.Concat(this.AccountID, CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR, this.AccountType.ToString());
            }
        }


        AccountType _accountType;
        /// <summary>
        /// Account Type of the current Account
        /// </summary>
        public AccountType AccountType { 
            get {return _accountType;}
            set
            {
                _accountType=value;
                Attributes.Clear();
                if (_accountType == Types.AccountType.Local)
                    Attributes.Add("AccountType", "Local");
                else if (_accountType == Types.AccountType.Regional)
                    Attributes.Add("AccountType", "Regional");
                else
                    Attributes.Add("AccountType", "National");
            } 
        }

        /// <summary>
        /// Parent Id of the current account
        /// </summary>
        public int ParentID
        {
            get
            {
                int retVal = 0;
                switch (this.AccountType)
                {

                    case AccountType.Local:
                        retVal = this.RegionalChainID;
                        break;
                    case AccountType.Regional:
                        retVal = this.NationalChainID;
                        break;
                }

                return retVal;
            }
        }

        public string ParentTreeValue
        {
            get
            {
                return string.Concat(this.ParentID, CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR, this.ParentAccountType.ToString());
            }
        }

        public AccountType ParentAccountType
        {
            get
            {
                AccountType retVal = Types.AccountType.National;
                switch (this.AccountType)
                {

                    case AccountType.Local:
                        retVal = Types.AccountType.Regional;
                        break;
                    case AccountType.Regional:
                        retVal = Types.AccountType.National;
                        break;
                }

                return retVal;
            }
        }
        string _accountTrueType;
        public string AccountTrueType {
            get { return _accountTrueType; }
            set
            {
                _accountTrueType = value;
                Attributes.Add("AccountTrueType", value);
            } 
        }
        public string LocalChainName { get; set; }
        public string NationalChainName { get; set; }
        public string RegionalChainName { get; set; }
        public Dictionary<string, object> Attributes = new Dictionary<string, object>();
    }
}
