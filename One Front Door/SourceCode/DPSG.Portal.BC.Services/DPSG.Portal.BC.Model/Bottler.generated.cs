#pragma warning disable 1591
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by the ClassGenerator.ttinclude code generation file.
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------
using System;
using System.Data;
using System.Linq;
using System.Linq.Expressions;
using System.Data.Common;
using System.Collections.Generic;
using Telerik.OpenAccess;
using Telerik.OpenAccess.Metadata;
using Telerik.OpenAccess.Data.Common;
using Telerik.OpenAccess.Metadata.Fluent;
using Telerik.OpenAccess.Metadata.Fluent.Advanced;
using DPSG.Portal.BC.Model;

namespace DPSG.Portal.BC.Model	
{
	public partial class Bottler
	{
		private int _bottlerID;
		public virtual int BottlerID
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
		
		private long _bCBottlerID;
		public virtual long BCBottlerID
		{
			get
			{
				return this._bCBottlerID;
			}
			set
			{
				this._bCBottlerID = value;
			}
		}
		
		private string _bottlerName;
		public virtual string BottlerName
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
		
		private int? _channelID;
		public virtual int? ChannelID
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
		
		private int _globalStatusID;
		public virtual int GlobalStatusID
		{
			get
			{
				return this._globalStatusID;
			}
			set
			{
				this._globalStatusID = value;
			}
		}
		
		private int? _eB4ID;
		public virtual int? EB4ID
		{
			get
			{
				return this._eB4ID;
			}
			set
			{
				this._eB4ID = value;
			}
		}
		
		private int? _bCRegionID;
		public virtual int? BCRegionID
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
		
		private int? _fSRegionID;
		public virtual int? FSRegionID
		{
			get
			{
				return this._fSRegionID;
			}
			set
			{
				this._fSRegionID = value;
			}
		}
		
		private string _address;
		public virtual string Address
		{
			get
			{
				return this._address;
			}
			set
			{
				this._address = value;
			}
		}
		
		private string _city;
		public virtual string City
		{
			get
			{
				return this._city;
			}
			set
			{
				this._city = value;
			}
		}
		
		private string _county;
		public virtual string County
		{
			get
			{
				return this._county;
			}
			set
			{
				this._county = value;
			}
		}
		
		private string _state;
		public virtual string State
		{
			get
			{
				return this._state;
			}
			set
			{
				this._state = value;
			}
		}
		
		private string _postalCode;
		public virtual string PostalCode
		{
			get
			{
				return this._postalCode;
			}
			set
			{
				this._postalCode = value;
			}
		}
		
		private string _country;
		public virtual string Country
		{
			get
			{
				return this._country;
			}
			set
			{
				this._country = value;
			}
		}
		
		private string _email;
		public virtual string Email
		{
			get
			{
				return this._email;
			}
			set
			{
				this._email = value;
			}
		}
		
		private string _phoneNumber;
		public virtual string PhoneNumber
		{
			get
			{
				return this._phoneNumber;
			}
			set
			{
				this._phoneNumber = value;
			}
		}
		
		private decimal? _longitude;
		public virtual decimal? Longitude
		{
			get
			{
				return this._longitude;
			}
			set
			{
				this._longitude = value;
			}
		}
		
		private decimal? _latitude;
		public virtual decimal? Latitude
		{
			get
			{
				return this._latitude;
			}
			set
			{
				this._latitude = value;
			}
		}
		
		private DateTime _lastModified;
		public virtual DateTime LastModified
		{
			get
			{
				return this._lastModified;
			}
			set
			{
				this._lastModified = value;
			}
		}
		
		private DateTime? _addressLastModified;
		public virtual DateTime? AddressLastModified
		{
			get
			{
				return this._addressLastModified;
			}
			set
			{
				this._addressLastModified = value;
			}
		}
		
		private DateTime? _eB4LastModified;
		public virtual DateTime? EB4LastModified
		{
			get
			{
				return this._eB4LastModified;
			}
			set
			{
				this._eB4LastModified = value;
			}
		}
		
		private DateTime? _bCRegionLastModified;
		public virtual DateTime? BCRegionLastModified
		{
			get
			{
				return this._bCRegionLastModified;
			}
			set
			{
				this._bCRegionLastModified = value;
			}
		}
		
		private DateTime? _fSRegionLastModified;
		public virtual DateTime? FSRegionLastModified
		{
			get
			{
				return this._fSRegionLastModified;
			}
			set
			{
				this._fSRegionLastModified = value;
			}
		}
		
		private bool? _active;
		public virtual bool? Active
		{
			get
			{
				return this._active;
			}
			set
			{
				this._active = value;
			}
		}
		
		private Region _region;
		public virtual Region Region
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
		
		private Region _region1;
		public virtual Region Region1
		{
			get
			{
				return this._region1;
			}
			set
			{
				this._region1 = value;
			}
		}
		
		private IList<TBottlerTrademark> _tBottlerTrademarks = new List<TBottlerTrademark>();
		public virtual IList<TBottlerTrademark> TBottlerTrademarks
		{
			get
			{
				return this._tBottlerTrademarks;
			}
		}
		
	}
}
#pragma warning restore 1591