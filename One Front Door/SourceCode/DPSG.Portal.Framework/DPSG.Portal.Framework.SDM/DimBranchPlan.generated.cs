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
	public partial class DimBranchPlan
	{
		private decimal _planVolume;
		public virtual decimal PlanVolume
		{
			get
			{
				return this._planVolume;
			}
			set
			{
				this._planVolume = value;
			}
		}
		
		private int _monthid;
		public virtual int Monthid
		{
			get
			{
				return this._monthid;
			}
			set
			{
				this._monthid = value;
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