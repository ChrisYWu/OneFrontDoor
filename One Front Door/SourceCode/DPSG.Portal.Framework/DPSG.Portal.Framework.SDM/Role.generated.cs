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
	public partial class Role
	{
		private string _roleShortName;
		public virtual string RoleShortName
		{
			get
			{
				return this._roleShortName;
			}
			set
			{
				this._roleShortName = value;
			}
		}
		
		private string _roleScope;
		public virtual string RoleScope
		{
			get
			{
				return this._roleScope;
			}
			set
			{
				this._roleScope = value;
			}
		}
		
		private string _roleName;
		public virtual string RoleName
		{
			get
			{
				return this._roleName;
			}
			set
			{
				this._roleName = value;
			}
		}
		
		private int _roleID;
		public virtual int RoleID
		{
			get
			{
				return this._roleID;
			}
			set
			{
				this._roleID = value;
			}
		}
		
		private string _aDGroupName;
		public virtual string ADGroupName
		{
			get
			{
				return this._aDGroupName;
			}
			set
			{
				this._aDGroupName = value;
			}
		}
		
		private IList<UserInRole> _userInRoles = new List<UserInRole>();
		public virtual IList<UserInRole> UserInRoles
		{
			get
			{
				return this._userInRoles;
			}
		}
		
		private IList<Job> _jobs = new List<Job>();
		public virtual IList<Job> Jobs
		{
			get
			{
				return this._jobs;
			}
		}
		
	}
}
#pragma warning restore 1591