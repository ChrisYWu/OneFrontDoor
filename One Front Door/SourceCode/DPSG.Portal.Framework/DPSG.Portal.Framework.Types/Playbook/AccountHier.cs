using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class AccountHier
    {
        public virtual int? SAPRegionalChainID
        {
            get;
            set;
        }
        public virtual int? SAPNationalChainID
        {
            get;
            set;
        }
        public virtual int? SAPLocalChainID
        {
            get;
            set;
        }
        public virtual string RegionalChainName
        {
            get;
            set;
        }
        public virtual int RegionalChainID
        {
            get;
            set;
        }
        public virtual string NationalChainName
        {
            get;
            set;
        }
        public virtual int NationalChainID
        {
            get;
            set;
        }
        public virtual string LocalChainName
        {
            get;
            set;
        }
        public virtual int LocalChainID
        {
            get;
            set;

        }
    }
}
