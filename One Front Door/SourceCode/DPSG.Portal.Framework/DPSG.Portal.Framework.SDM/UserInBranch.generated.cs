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
	public partial class UserInBranch
	{
		private int _userInBranchID;
		public virtual int UserInBranchID
		{
			get
			{
				return this._userInBranchID;
			}
			set
			{
				this._userInBranchID = value;
			}
		}
		
		private bool _isPrimary;
		public virtual bool IsPrimary
		{
			get
			{
				return this._isPrimary;
			}
			set
			{
				this._isPrimary = value;
			}
		}
		
		private string _gSN;
		public virtual string GSN
		{
			get
			{
				return this._gSN;
			}
			set
			{
				this._gSN = value;
			}
		}
		
		private int _branchID;
		public virtual int BranchID
		{
			get
			{
				return this._branchID;
			}
			set
			{
				this._branchID = value;
			}
		}
		
		private IList<UserBranchTradeMark> _userBranchTradeMarks = new List<UserBranchTradeMark>();
		public virtual IList<UserBranchTradeMark> UserBranchTradeMarks
		{
			get
			{
				return this._userBranchTradeMarks;
			}
		}
		
	}
}
#pragma warning restore 1591