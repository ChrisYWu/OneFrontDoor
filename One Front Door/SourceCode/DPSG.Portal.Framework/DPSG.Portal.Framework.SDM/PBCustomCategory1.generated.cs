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
	public partial class PBCustomCategory1
	{
		private int? _tradeMarkID;
		public virtual int? TradeMarkID
		{
			get
			{
				return this._tradeMarkID;
			}
			set
			{
				this._tradeMarkID = value;
			}
		}
		
		private int _sDMCategoryID;
		public virtual int SDMCategoryID
		{
			get
			{
				return this._sDMCategoryID;
			}
			set
			{
				this._sDMCategoryID = value;
			}
		}
		
		private int _categoryID;
		public virtual int CategoryID
		{
			get
			{
				return this._categoryID;
			}
			set
			{
				this._categoryID = value;
			}
		}
		
		private string _categoryGroupName;
		public virtual string CategoryGroupName
		{
			get
			{
				return this._categoryGroupName;
			}
			set
			{
				this._categoryGroupName = value;
			}
		}
		
		private int? _brandID;
		public virtual int? BrandID
		{
			get
			{
				return this._brandID;
			}
			set
			{
				this._brandID = value;
			}
		}
		
	}
}
#pragma warning restore 1591