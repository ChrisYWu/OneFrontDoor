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
using DPSG.Portal.Framework.SDM;

namespace DPSG.Portal.Framework.SDM	
{
	public partial class Area
	{
		private int _areaID;
		public virtual int AreaID
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
		
		private string _sAPAreaID;
		public virtual string SAPAreaID
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
		
		private string _areaName;
		public virtual string AreaName
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
		
		private int _regionID;
		public virtual int RegionID
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
		
		private int? _changeTrackNumber;
		public virtual int? ChangeTrackNumber
		{
			get
			{
				return this._changeTrackNumber;
			}
			set
			{
				this._changeTrackNumber = value;
			}
		}
		
		private DateTime? _lastModified;
		public virtual DateTime? LastModified
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
		
		private IList<Branch> _branches = new List<Branch>();
		public virtual IList<Branch> Branches
		{
			get
			{
				return this._branches;
			}
		}
		
	}
}
#pragma warning restore 1591