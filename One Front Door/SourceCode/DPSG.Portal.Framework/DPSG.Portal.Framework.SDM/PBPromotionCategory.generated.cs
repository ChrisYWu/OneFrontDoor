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
	public partial class PBPromotionCategory
	{
		private int _promotionCategoryID;
		public virtual int PromotionCategoryID
		{
			get
			{
				return this._promotionCategoryID;
			}
			set
			{
				this._promotionCategoryID = value;
			}
		}
		
		private string _shortPromotionCategoryName;
		public virtual string ShortPromotionCategoryName
		{
			get
			{
				return this._shortPromotionCategoryName;
			}
			set
			{
				this._shortPromotionCategoryName = value;
			}
		}
		
		private string _promotionCategoryName;
		public virtual string PromotionCategoryName
		{
			get
			{
				return this._promotionCategoryName;
			}
			set
			{
				this._promotionCategoryName = value;
			}
		}
		
		private bool _isDeleted;
		public virtual bool IsDeleted
		{
			get
			{
				return this._isDeleted;
			}
			set
			{
				this._isDeleted = value;
			}
		}
		
	}
}
#pragma warning restore 1591
