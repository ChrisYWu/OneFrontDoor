using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
 public class UserGeoLocations
    {        
            private int _userLocationID;
            public  int UserLocationID
            {
                get
                {
                    return this._userLocationID;
                }
                set
                {
                    this._userLocationID = value;
                }
            }

            private string _gSN;
            public  string GSN
            {
                get
                {
                    return this._gSN;
                }
                set
                {
                    this._gSN = value;
                }
            }

            private int? _bUID;
            public  int? BUID
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

            private int? _regionID;
            public  int? RegionID
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

            private int? _branchID;
            public  int? BranchID
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

            private int? _areaID;
            public  int? AreaID
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

            private int? _systemID;
            public  int? SystemID
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

            private int? _zoneID;
            public  int? ZoneID
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

            private int? _divisionID;
            public  int? DivisionID
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

            private int? _bCRegionID;
            public  int? BCRegionID
            {
                get
                {
                    return this._bCRegionID;
                }
                set
                {
                    this._bCRegionID = value;
                }
            }

            private bool? _isReadOnly;
            public  bool? IsReadOnly
            {
                get
                {
                    return this._isReadOnly;
                }
                set
                {
                    this._isReadOnly = value;
                }
            }

        
    }
}
