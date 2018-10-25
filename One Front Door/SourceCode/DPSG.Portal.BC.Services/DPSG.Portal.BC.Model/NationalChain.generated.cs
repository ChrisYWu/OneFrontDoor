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
	public partial class NationalChain
	{
		private int _nationalChainID;
		public virtual int NationalChainID
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
		
		private int? _sAPNationalChainID;
		public virtual int? SAPNationalChainID
		{
			get
			{
				return this._sAPNationalChainID;
			}
			set
			{
				this._sAPNationalChainID = value;
			}
		}
		
		private string _nationalChainName;
		public virtual string NationalChainName
		{
			get
			{
				return this._nationalChainName;
			}
			set
			{
				this._nationalChainName = value;
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
		
		private bool? _inCapstone;
		public virtual bool? InCapstone
		{
			get
			{
				return this._inCapstone;
			}
			set
			{
				this._inCapstone = value;
			}
		}
		
		private bool? _inBW;
		public virtual bool? InBW
		{
			get
			{
				return this._inBW;
			}
			set
			{
				this._inBW = value;
			}
		}
		
		private DateTime? _capstoneLastModified;
		public virtual DateTime? CapstoneLastModified
		{
			get
			{
				return this._capstoneLastModified;
			}
			set
			{
				this._capstoneLastModified = value;
			}
		}
		
		private IList<RegionalChain> _regionalChains = new List<RegionalChain>();
		public virtual IList<RegionalChain> RegionalChains
		{
			get
			{
				return this._regionalChains;
			}
		}
		
	}
}
#pragma warning restore 1591