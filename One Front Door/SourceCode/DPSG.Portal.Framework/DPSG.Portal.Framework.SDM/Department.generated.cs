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
	public partial class Department
	{
		private int _deptID;
		public virtual int DeptID
		{
			get
			{
				return this._deptID;
			}
			set
			{
				this._deptID = value;
			}
		}
		
		private string _deptName;
		public virtual string DeptName
		{
			get
			{
				return this._deptName;
			}
			set
			{
				this._deptName = value;
			}
		}
		
		private IList<MeasursType> _measursTypes = new List<MeasursType>();
		public virtual IList<MeasursType> MeasursTypes
		{
			get
			{
				return this._measursTypes;
			}
		}
		
	}
}
#pragma warning restore 1591