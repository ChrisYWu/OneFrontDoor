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
	public partial class PBPromotionAccount
	{
		private int? _regionalChainID;
		public virtual int? RegionalChainID
		{
			get
			{
				return this._regionalChainID;
			}
			set
			{
				this._regionalChainID = value;
			}
		}
		
		private int _promotionID;
		public virtual int PromotionID
		{
			get
			{
				return this._promotionID;
			}
			set
			{
				this._promotionID = value;
			}
		}
		
		private int _promotionAccountID;
		public virtual int PromotionAccountID
		{
			get
			{
				return this._promotionAccountID;
			}
			set
			{
				this._promotionAccountID = value;
			}
		}
		
		private int? _nationalChainID;
		public virtual int? NationalChainID
		{
			get
			{
				return this._nationalChainID;
			}
			set
			{
				this._nationalChainID = value;
			}
		}
		
		private int? _localChainID;
		public virtual int? LocalChainID
		{
			get
			{
				return this._localChainID;
			}
			set
			{
				this._localChainID = value;
			}
		}
		
		private bool? _isRoot;
		public virtual bool? IsRoot
		{
			get
			{
				return this._isRoot;
			}
			set
			{
				this._isRoot = value;
			}
		}
		
	}
}
#pragma warning restore 1591