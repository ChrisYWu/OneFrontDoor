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
	public partial class PBPromotionType
	{
		private int _promotionTypeID;
		public virtual int PromotionTypeID
		{
			get
			{
				return this._promotionTypeID;
			}
			set
			{
				this._promotionTypeID = value;
			}
		}
		
		private string _promotionType;
		public virtual string PromotionType
		{
			get
			{
				return this._promotionType;
			}
			set
			{
				this._promotionType = value;
			}
		}
		
	}
}
#pragma warning restore 1591