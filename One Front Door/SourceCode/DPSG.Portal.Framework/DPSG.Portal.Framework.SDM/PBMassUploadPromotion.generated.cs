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
	public partial class PBMassUploadPromotion
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
		
		private string _rowNumber;
		public virtual string RowNumber
		{
			get
			{
				return this._rowNumber;
			}
			set
			{
				this._rowNumber = value;
			}
		}
		
		private string _promotionName;
		public virtual string PromotionName
		{
			get
			{
				return this._promotionName;
			}
			set
			{
				this._promotionName = value;
			}
		}
		
		private string _comments;
		public virtual string Comments
		{
			get
			{
				return this._comments;
			}
			set
			{
				this._comments = value;
			}
		}
		
		private string _systemRTM;
		public virtual string SystemRTM
		{
			get
			{
				return this._systemRTM;
			}
			set
			{
				this._systemRTM = value;
			}
		}
		
		private string _nationalChainAccount;
		public virtual string NationalChainAccount
		{
			get
			{
				return this._nationalChainAccount;
			}
			set
			{
				this._nationalChainAccount = value;
			}
		}
		
		private string _accountsXML;
		public virtual string AccountsXML
		{
			get
			{
				return this._accountsXML;
			}
			set
			{
				this._accountsXML = value;
			}
		}
		
		private string _accountImageName;
		public virtual string AccountImageName
		{
			get
			{
				return this._accountImageName;
			}
			set
			{
				this._accountImageName = value;
			}
		}
		
		private string _accounts;
		public virtual string Accounts
		{
			get
			{
				return this._accounts;
			}
			set
			{
				this._accounts = value;
			}
		}
		
		private string _brands;
		public virtual string Brands
		{
			get
			{
				return this._brands;
			}
			set
			{
				this._brands = value;
			}
		}
		
		private string _packages;
		public virtual string Packages
		{
			get
			{
				return this._packages;
			}
			set
			{
				this._packages = value;
			}
		}
		
		private string _retailPrice;
		public virtual string RetailPrice
		{
			get
			{
				return this._retailPrice;
			}
			set
			{
				this._retailPrice = value;
			}
		}
		
		private string _invoicePrice;
		public virtual string InvoicePrice
		{
			get
			{
				return this._invoicePrice;
			}
			set
			{
				this._invoicePrice = value;
			}
		}
		
		private string _category;
		public virtual string Category
		{
			get
			{
				return this._category;
			}
			set
			{
				this._category = value;
			}
		}
		
		private string _displayLocation;
		public virtual string DisplayLocation
		{
			get
			{
				return this._displayLocation;
			}
			set
			{
				this._displayLocation = value;
			}
		}
		
		private string _otherDisplayLocation;
		public virtual string OtherDisplayLocation
		{
			get
			{
				return this._otherDisplayLocation;
			}
			set
			{
				this._otherDisplayLocation = value;
			}
		}
		
		private string _startDate;
		public virtual string StartDate
		{
			get
			{
				return this._startDate;
			}
			set
			{
				this._startDate = value;
			}
		}
		
		private string _endDate;
		public virtual string EndDate
		{
			get
			{
				return this._endDate;
			}
			set
			{
				this._endDate = value;
			}
		}
		
		private string _forecastVolume;
		public virtual string ForecastVolume
		{
			get
			{
				return this._forecastVolume;
			}
			set
			{
				this._forecastVolume = value;
			}
		}
		
		private string _nationalDisplayTarget;
		public virtual string NationalDisplayTarget
		{
			get
			{
				return this._nationalDisplayTarget;
			}
			set
			{
				this._nationalDisplayTarget = value;
			}
		}
		
		private string _promotionStatus;
		public virtual string PromotionStatus
		{
			get
			{
				return this._promotionStatus;
			}
			set
			{
				this._promotionStatus = value;
			}
		}
		
		private string _createdBy;
		public virtual string CreatedBy
		{
			get
			{
				return this._createdBy;
			}
			set
			{
				this._createdBy = value;
			}
		}
		
		private DateTime? _createdDate;
		public virtual DateTime? CreatedDate
		{
			get
			{
				return this._createdDate;
			}
			set
			{
				this._createdDate = value;
			}
		}
		
		private bool? _processed;
		public virtual bool? Processed
		{
			get
			{
				return this._processed;
			}
			set
			{
				this._processed = value;
			}
		}
		
		private bool? _cancelled;
		public virtual bool? Cancelled
		{
			get
			{
				return this._cancelled;
			}
			set
			{
				this._cancelled = value;
			}
		}
		
		private string _errorDescription;
		public virtual string ErrorDescription
		{
			get
			{
				return this._errorDescription;
			}
			set
			{
				this._errorDescription = value;
			}
		}
		
		private bool? _submitted;
		public virtual bool? Submitted
		{
			get
			{
				return this._submitted;
			}
			set
			{
				this._submitted = value;
			}
		}
		
		private bool? _readyToDelete;
		public virtual bool? ReadyToDelete
		{
			get
			{
				return this._readyToDelete;
			}
			set
			{
				this._readyToDelete = value;
			}
		}
		
		private string _tPMPromotionNumberPASO;
		public virtual string TPMPromotionNumberPASO
		{
			get
			{
				return this._tPMPromotionNumberPASO;
			}
			set
			{
				this._tPMPromotionNumberPASO = value;
			}
		}
		
		private string _tPMPromotionNumberISO;
		public virtual string TPMPromotionNumberISO
		{
			get
			{
				return this._tPMPromotionNumberISO;
			}
			set
			{
				this._tPMPromotionNumberISO = value;
			}
		}
		
		private string _tPMPromotionNumberCASO;
		public virtual string TPMPromotionNumberCASO
		{
			get
			{
				return this._tPMPromotionNumberCASO;
			}
			set
			{
				this._tPMPromotionNumberCASO = value;
			}
		}
		
		private string _sMARequired;
		public virtual string SMARequired
		{
			get
			{
				return this._sMARequired;
			}
			set
			{
				this._sMARequired = value;
			}
		}
		
		private string _pricingStartDate;
		public virtual string PricingStartDate
		{
			get
			{
				return this._pricingStartDate;
			}
			set
			{
				this._pricingStartDate = value;
			}
		}
		
		private string _pricingEndDate;
		public virtual string PricingEndDate
		{
			get
			{
				return this._pricingEndDate;
			}
			set
			{
				this._pricingEndDate = value;
			}
		}
		
		private string _geoRelevancy;
		public virtual string GeoRelevancy
		{
			get
			{
				return this._geoRelevancy;
			}
			set
			{
				this._geoRelevancy = value;
			}
		}
		
		private string _displayStartDate;
		public virtual string DisplayStartDate
		{
			get
			{
				return this._displayStartDate;
			}
			set
			{
				this._displayStartDate = value;
			}
		}
		
		private string _displayRequirement;
		public virtual string DisplayRequirement
		{
			get
			{
				return this._displayRequirement;
			}
			set
			{
				this._displayRequirement = value;
			}
		}
		
		private string _displayEndDate;
		public virtual string DisplayEndDate
		{
			get
			{
				return this._displayEndDate;
			}
			set
			{
				this._displayEndDate = value;
			}
		}
		
		private string _costPerStore;
		public virtual string CostPerStore
		{
			get
			{
				return this._costPerStore;
			}
			set
			{
				this._costPerStore = value;
			}
		}
		
		private string _tPMPromotionNumberPB;
		public virtual string TPMPromotionNumberPB
		{
			get
			{
				return this._tPMPromotionNumberPB;
			}
			set
			{
				this._tPMPromotionNumberPB = value;
			}
		}
		
		private string _costInfo;
		public virtual string CostInfo
		{
			get
			{
				return this._costInfo;
			}
			set
			{
				this._costInfo = value;
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
		
		private int? _personaID;
		public virtual int? PersonaID
		{
			get
			{
				return this._personaID;
			}
			set
			{
				this._personaID = value;
			}
		}
		
		private string _displayType;
		public virtual string DisplayType
		{
			get
			{
				return this._displayType;
			}
			set
			{
				this._displayType = value;
			}
		}
		
		private bool? _isNationalAccountPromotion;
		public virtual bool? IsNationalAccountPromotion
		{
			get
			{
				return this._isNationalAccountPromotion;
			}
			set
			{
				this._isNationalAccountPromotion = value;
			}
		}
		
		private string _rPC;
		public virtual string RPC
		{
			get
			{
				return this._rPC;
			}
			set
			{
				this._rPC = value;
			}
		}
		
		private string _redemption;
		public virtual string Redemption
		{
			get
			{
				return this._redemption;
			}
			set
			{
				this._redemption = value;
			}
		}
		
		private string _gEOXML;
		public virtual string GEOXML
		{
			get
			{
				return this._gEOXML;
			}
			set
			{
				this._gEOXML = value;
			}
		}
		
		private string _fixedCost;
		public virtual string FixedCost
		{
			get
			{
				return this._fixedCost;
			}
			set
			{
				this._fixedCost = value;
			}
		}
		
		private string _accrualComments;
		public virtual string AccrualComments
		{
			get
			{
				return this._accrualComments;
			}
			set
			{
				this._accrualComments = value;
			}
		}
		
		private string _unit;
		public virtual string Unit
		{
			get
			{
				return this._unit;
			}
			set
			{
				this._unit = value;
			}
		}
		
		private string _accounting;
		public virtual string Accounting
		{
			get
			{
				return this._accounting;
			}
			set
			{
				this._accounting = value;
			}
		}
		
	}
}
#pragma warning restore 1591