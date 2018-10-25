using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class BCGeoRelevancy
    {

        private string _zoneName;
        public string ZoneName
        {
            get
            {
                return this._zoneName;
            }
            set
            {
                this._zoneName = value;
            }
        }

        private int? _zoneID;
        public int? ZoneID
        {
            get
            {
                return this._zoneID;
            }
            set
            {
                this._zoneID = value;
            }
        }
        private string _systemName;
        public string SystemName
        {
            get
            {
                return this._systemName;
            }
            set
            {
                this._systemName = value;
            }
        }

        private int? _bcSystemID;
        public int? BCSystemID
        {
            get
            {
                return this._bcSystemID;
            }
            set
            {
                this._bcSystemID = value;
            }
        }

        private int? _systemID;
        public int? SystemID
        {
            get
            {
                return this._systemID;
            }
            set
            {
                this._systemID = value;
            }
        }
        private int? _bcRegionID;
        public int? BCRegionID
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
        private string _regionName;
        public string RegionName
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

        private int? _regionID;
        public int? RegionID
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
        private string _divisionName;
        public string DivisionName
        {
            get
            {
                return this._divisionName;
            }
            set
            {
                this._divisionName = value;
            }
        }

        private int? _divisionID;
        public int? DivisionID
        {
            get
            {
                return this._divisionID;
            }
            set
            {
                this._divisionID = value;
            }
        }


        private string _bottlerName;
        public string BottlerName
        {
            get
            {
                return this._bottlerName;
            }
            set
            {
                this._bottlerName = value;
            }
        }

        private int? _bottlerID;
        public int? BottlerID
        {
            get
            {
                return this._bottlerID;
            }
            set
            {
                this._bottlerID = value;
            }
        }

        public int? BUID { get; set; }
        public string BUName { get; set; }
        public int? AreaID { get; set; }
        public string AreaName { get; set; }
        public int? BranchID { get; set; }
        public string BranchName { get; set; }


    }
}
