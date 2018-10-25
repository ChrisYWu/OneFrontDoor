using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class PromotionPreferences
    {
        private string _gsn;
        private bool _isOverridden;
        private string _NationalAccount;
        private string _RegionalAccount;
        private string _LocalAccount;
        private string _businessUnit;
        private string _region;
        private string _area;
        private string _branch;
        private string _channel;
        private string _superChannel;

        public string Branch
        {
            get { return _branch; }
            set { _branch = value; }
        }
        public string Area 
        { 
            get { return _area; } 
            set{ _area=value; }
        }
        public string Region
        {
            get { return _region; }
            set { _region = value; }
        }

        public string BusinessUnit
        {
            get { return _businessUnit; }
            set { _businessUnit = value; }
        }

        public string LocalAccount
        {
            get { return _LocalAccount; }
            set { _LocalAccount = value; }
        }


        public string RegionalAccount
        {
            get { return _RegionalAccount; }
            set { _RegionalAccount = value; }
        }

        public string NationalAccount
        {
            get { return _NationalAccount; }
            set { _NationalAccount = value; }
        }
        public string Channel
        {
            get { return _channel; }
            set { _channel = value; }
        }
        public string SuperChannel
        {
            get { return _superChannel; }
            set { _superChannel = value; }
        }

        public bool IsOverridden
        {
            get { return _isOverridden; }
            set { _isOverridden = value; }
        }

        public string GSN
        {
            get { return _gsn; }
            set { _gsn = value; }
        }
    }
}
