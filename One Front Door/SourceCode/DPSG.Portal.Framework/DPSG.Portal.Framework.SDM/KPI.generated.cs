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
	public partial class KPI
	{
		private int _kPIID;
		public virtual int KPIID
		{
			get
			{
				return this._kPIID;
			}
			set
			{
				this._kPIID = value;
			}
		}
		
		private string _sAPKPIID;
		public virtual string SAPKPIID
		{
			get
			{
				return this._sAPKPIID;
			}
			set
			{
				this._sAPKPIID = value;
			}
		}
		
		private string _kPIName;
		public virtual string KPIName
		{
			get
			{
				return this._kPIName;
			}
			set
			{
				this._kPIName = value;
			}
		}
		
	}
}
#pragma warning restore 1591