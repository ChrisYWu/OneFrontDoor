using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
   public class LocationHier
    {
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

        private string _sAPRegionID;
        public  string SAPRegionID
        {
            get
            {
                return this._sAPRegionID;
            }
            set
            {
                this._sAPRegionID = value;
            }
        }

        private string _sAPBUID;
        public  string SAPBUID
        {
            get
            {
                return this._sAPBUID;
            }
            set
            {
                this._sAPBUID = value;
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
