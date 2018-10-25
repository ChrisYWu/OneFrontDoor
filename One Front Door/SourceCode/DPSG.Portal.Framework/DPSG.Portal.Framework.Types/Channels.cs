using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class Channels
    {
        private int _superChannelID;
        public  int SuperChannelID
        {
            get
            {
                return this._superChannelID;
            }
            set
            {
                this._superChannelID = value;
            }
        }
        private string _SAPSuperChannelID;
        public string SAPSuperChannelID
        {
            get
            {
                return this._SAPSuperChannelID;
            }
            set
            {
                this._SAPSuperChannelID = value;
            }
        }
        
        private string _sPRegionName;
        public  string SPRegionName
        {
            get
            {
                return this._sPRegionName;
            }
            set
            {
                this._sPRegionName = value;
            }
        }
        private string _sPSuperChannelName;
        public  string SuperChannelName
        {
            get
            {
                return this._sPSuperChannelName;
            }
            set
            {
                this._sPSuperChannelName = value;
            }
        }

        private string _sPBUName;
        public  string SPBUName
        {
            get
            {
                return this._sPBUName;
            }
            set
            {
                this._sPBUName = value;
            }
        }

        private string _sPBranchName;
        public  string SPBranchName
        {
            get
            {
                return this._sPBranchName;
            }
            set
            {
                this._sPBranchName = value;
            }
        }

        private string _sAPChannelID;
        public  string SAPChannelID
        {
            get
            {
                return this._sAPChannelID;
            }
            set
            {
                this._sAPChannelID = value;
            }
        }

        private string _sAPBranchID;
        public  string SAPBranchID
        {
            get
            {
                return this._sAPBranchID;
            }
            set
            {
                this._sAPBranchID = value;
            }
        }

        private string _sAPAreaID;
        public  string SAPAreaID
        {
            get
            {
                return this._sAPAreaID;
            }
            set
            {
                this._sAPAreaID = value;
            }
        }

        private string _regionName;
        public  string RegionName
        {
            get
            {
                return this._regionName;
            }
            set
            {
                this._regionName = value;
            }
        }

        private int _regionID;
        public  int RegionID
        {
            get
            {
                return this._regionID;
            }
            set
            {
                this._regionID = value;
            }
        }

        private string _channelName;
        public  string ChannelName
        {
            get
            {
                return this._channelName;
            }
            set
            {
                this._channelName = value;
            }
        }

        private int _channelID;
        public  int ChannelID
        {
            get
            {
                return this._channelID;
            }
            set
            {
                this._channelID = value;
            }
        }

        private string _bUName;
        public  string BUName
        {
            get
            {
                return this._bUName;
            }
            set
            {
                this._bUName = value;
            }
        }

        private int _bUID;
        public  int BUID
        {
            get
            {
                return this._bUID;
            }
            set
            {
                this._bUID = value;
            }
        }

        private string _branchName;
        public  string BranchName
        {
            get
            {
                return this._branchName;
            }
            set
            {
                this._branchName = value;
            }
        }

        private int _branchID;
        public  int BranchID
        {
            get
            {
                return this._branchID;
            }
            set
            {
                this._branchID = value;
            }
        }

        private string _areaName;
        public  string AreaName
        {
            get
            {
                return this._areaName;
            }
            set
            {
                this._areaName = value;
            }
        }

        private int _areaID;
        public  int AreaID
        {
            get
            {
                return this._areaID;
            }
            set
            {
                this._areaID = value;
            }
        }

    }
}
