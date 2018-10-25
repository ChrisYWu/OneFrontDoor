using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class CustomLocationChain
    {

        private int? _sAPRegionalChainID;
        public int? SAPRegionalChainID
        {
            get
            {
                return this._sAPRegionalChainID;
            }
            set
            {
                this._sAPRegionalChainID = value;
            }
        }

        private int? _sAPNationalChainID;
        public int? SAPNationalChainID
        {
            get
            {
                return this._sAPNationalChainID;
            }
            set
            {
                this._sAPNationalChainID = value;
            }
        }

        private int? _sAPLocalChainID;
        public int? SAPLocalChainID
        {
            get
            {
                return this._sAPLocalChainID;
            }
            set
            {
                this._sAPLocalChainID = value;
            }
        }

        private int _regionID;
        public int RegionID
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

        private int _regionalChainID;
        public int RegionalChainID
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

        private string _region;
        public string Region
        {
            get
            {
                return this._region;
            }
            set
            {
                this._region = value;
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

        private int _nationalChainID;
        public int NationalChainID
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

        private int _localChainID;
        public int LocalChainID
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

        private int _bUID;
        public int BUID
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

        private string _bU;
        public string BU
        {
            get
            {
                return this._bU;
            }
            set
            {
                this._bU = value;
            }
        }

        private string _branchName;
        public string BranchName
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
        public int BranchID
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

        private int _areaID;
        public int AreaID
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

        private int _bcRegionID;
        public int BCRegionID
        {
            get
            {
                return this._bcRegionID;
            }
            set
            {
                this._bcRegionID = value;
            }
        }

    }
}
