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

namespace DPSG.Portal.Framework.SDM	
{
	public partial class PBStatus
	{
		private int _statusID;
		public virtual int StatusID
		{
			get
			{
				return this._statusID;
			}
			set
			{
				this._statusID = value;
			}
		}
		
		private string _statusName;
		public virtual string StatusName
		{
			get
			{
				return this._statusName;
			}
			set
			{
				this._statusName = value;
			}
		}
		
		private int _isActive;
		public virtual int IsActive
		{
			get
			{
				return this._isActive;
			}
			set
			{
				this._isActive = value;
			}
		}
		
	}
}
#pragma warning restore 1591