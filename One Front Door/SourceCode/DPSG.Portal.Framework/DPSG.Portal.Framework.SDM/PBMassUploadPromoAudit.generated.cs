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
	public partial class PBMassUploadPromoAudit
	{
		private int _iD;
		public virtual int ID
		{
			get
			{
				return this._iD;
			}
			set
			{
				this._iD = value;
			}
		}
		
		private string _gSNID;
		public virtual string GSNID
		{
			get
			{
				return this._gSNID;
			}
			set
			{
				this._gSNID = value;
			}
		}
		
		private DateTime _promotionUploadDate;
		public virtual DateTime PromotionUploadDate
		{
			get
			{
				return this._promotionUploadDate;
			}
			set
			{
				this._promotionUploadDate = value;
			}
		}
		
		private int _promotionCount;
		public virtual int PromotionCount
		{
			get
			{
				return this._promotionCount;
			}
			set
			{
				this._promotionCount = value;
			}
		}
		
	}
}
#pragma warning restore 1591