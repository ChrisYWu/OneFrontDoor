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
	public partial class PBLocalChain
	{
		private int _localChainID;
		public virtual int LocalChainID
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
		
		private int? _sAPLocalChainID;
		public virtual int? SAPLocalChainID
		{
			get
			{
				return this._sAPLocalChainID;
			}
			set
			{
				this._sAPLocalChainID = value;
			}
		}
		
		private string _localChainName;
		public virtual string LocalChainName
		{
			get
			{
				return this._localChainName;
			}
			set
			{
				this._localChainName = value;
			}
		}
		
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
		
		private PBRegionalChain _pBRegionalChain;
		public virtual PBRegionalChain PBRegionalChain
		{
			get
			{
				return this._pBRegionalChain;
			}
			set
			{
				this._pBRegionalChain = value;
			}
		}
		
	}
}
#pragma warning restore 1591
