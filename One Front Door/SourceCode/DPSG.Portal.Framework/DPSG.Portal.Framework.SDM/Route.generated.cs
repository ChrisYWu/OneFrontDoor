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
	public partial class Route
	{
		private int _routeID;
		public virtual int RouteID
		{
			get
			{
				return this._routeID;
			}
			set
			{
				this._routeID = value;
			}
		}
		
		private string _sAPRouteNumber;
		public virtual string SAPRouteNumber
		{
			get
			{
				return this._sAPRouteNumber;
			}
			set
			{
				this._sAPRouteNumber = value;
			}
		}
		
		private int _branchID;
		public virtual int BranchID
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
		
		private string _routeName;
		public virtual string RouteName
		{
			get
			{
				return this._routeName;
			}
			set
			{
				this._routeName = value;
			}
		}
		
		private bool _active;
		public virtual bool Active
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
		
		private string _defaultAccountManagerGSN;
		public virtual string DefaultAccountManagerGSN
		{
			get
			{
				return this._defaultAccountManagerGSN;
			}
			set
			{
				this._defaultAccountManagerGSN = value;
			}
		}
		
		private long? _employeeID;
		public virtual long? EmployeeID
		{
			get
			{
				return this._employeeID;
			}
			set
			{
				this._employeeID = value;
			}
		}
		
		private int _routeTypeID;
		public virtual int RouteTypeID
		{
			get
			{
				return this._routeTypeID;
			}
			set
			{
				this._routeTypeID = value;
			}
		}
		
		private Branch _branch;
		public virtual Branch Branch
		{
			get
			{
				return this._branch;
			}
			set
			{
				this._branch = value;
			}
		}
		
	}
}
#pragma warning restore 1591