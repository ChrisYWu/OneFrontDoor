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
using DPSG.Portal.BC.Model;

namespace DPSG.Portal.BC.Model	
{
	public partial class Brand
	{
		private int _brandID;
		public virtual int BrandID
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
		
		private int _trademarkID;
		public virtual int TrademarkID
		{
			get
			{
				return this._trademarkID;
			}
			set
			{
				this._trademarkID = value;
			}
		}
		
		private string _sAPBrandID;
		public virtual string SAPBrandID
		{
			get
			{
				return this._sAPBrandID;
			}
			set
			{
				this._sAPBrandID = value;
			}
		}
		
		private string _brandName;
		public virtual string BrandName
		{
			get
			{
				return this._brandName;
			}
			set
			{
				this._brandName = value;
			}
		}
		
		private int? _changeTrackNumber;
		public virtual int? ChangeTrackNumber
		{
			get
			{
				return this._changeTrackNumber;
			}
			set
			{
				this._changeTrackNumber = value;
			}
		}
		
		private DateTime? _lastModified;
		public virtual DateTime? LastModified
		{
			get
			{
				return this._lastModified;
			}
			set
			{
				this._lastModified = value;
			}
		}
		
		private TradeMark _tradeMark;
		public virtual TradeMark TradeMark
		{
			get
			{
				return this._tradeMark;
			}
			set
			{
				this._tradeMark = value;
			}
		}
		
	}
}
#pragma warning restore 1591