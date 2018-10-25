using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Portal.Framework.Types.Constants;

namespace DPSG.Portal.Framework.Types
{
    public class PromotionViewFilter
    {
        #region Filter Properties

        private string _selectedAccount;
        public string SelectedAccount
        {
            get
            {
                if (string.IsNullOrEmpty(_selectedAccount))
                {
                    // Return My Accounts only if the user prefered account consists of atleast one National or Regional Account
                    _selectedAccount = (this.NationalAccountCount > 0 || this.RegionalAccountCount > 0) ? CommonConstants.PROMOTION_MY_ACCOUNTS : CommonConstants.PROMOTION_ALL_ACCOUNTS;
                }

                return _selectedAccount;
            }
            set { _selectedAccount = value; }
        }

        private string _selectedChannel;
        public string SelectedChannel
        {
            get
            {
                if (string.IsNullOrEmpty(_selectedChannel))
                {
                    // Return My Channel only if the user prefered channel consists of atleast one Channel or Super Channel
                    _selectedChannel = (this.ChannelCount > 0 || this.SuperChannelCount > 0) ? CommonConstants.PROMOTION_MY_CHANNEL : CommonConstants.PROMOTION_ALL_CHANNELS;
                }

                return _selectedChannel;
            }
            set { _selectedChannel = value; }
        }

        private string _selectedPackage;
        public string SelectedPackage
        {
            get { return (string.IsNullOrEmpty(_selectedPackage)) ? CommonConstants.PROMOTION_ALL_PACKAGES : _selectedPackage; }
            set { _selectedPackage = value; }
        }

        private string _selectedBrand;
        public string SelectedBrand
        {
            get { return (string.IsNullOrEmpty(_selectedBrand)) ? CommonConstants.PROMOTION_ALL_BRANDS : _selectedBrand; }
            set { _selectedBrand = value; }
        }

        private string _selectedBottler;
        public string SelectedBottler
        {
            get { return (string.IsNullOrEmpty(_selectedBottler)) ? CommonConstants.PROMOTION_ALL_BOTTLER : _selectedBottler; }
            set { _selectedBottler = value; }
        }


        private string _selectedCreatedBy;
        public string SelectedCreatedBy
        {
            get { return (string.IsNullOrEmpty(_selectedCreatedBy)) ? CommonConstants.PROMOTION_CREATE_VALUE_EVERYONE : _selectedCreatedBy; }
            set { _selectedCreatedBy = value; }
        }

        private DateTime? _selectedDate;
        public DateTime SelectedDate
        {
            get { return _selectedDate.HasValue ? _selectedDate.Value : DateTime.Now.Subtract(new TimeSpan(DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second)); }
            set { _selectedDate = value; }
        }


        public DateTime StartDate
        {
            get
            {
                DateTime _startDate = this.SelectedDate;

                //Calculate start date of the selected week
                if (SelectedDate.DayOfWeek > DayOfWeek.Monday)
                {
                    int diff = SelectedDate.DayOfWeek - DayOfWeek.Monday;
                    _startDate = SelectedDate.Subtract(new TimeSpan(diff, 0, 0, 0));
                }
                else
                {
                    if (SelectedDate.DayOfWeek == DayOfWeek.Sunday)
                    {
                        _startDate = SelectedDate.Subtract(new TimeSpan(6, 0, 0, 0));
                    }
                    else
                        _startDate = SelectedDate;
                }


                return _startDate;
            }
        }

        public DateTime EndDate
        {
            get { return this.StartDate.AddDays(6); }
        }

        private int _pageSize;
        public int PageSize
        {
            get { return _pageSize == 0 ? 20 : _pageSize; }
            set { _pageSize = value; }
        }

        private PlaybookSortOrder? _sortOrder;
        public PlaybookSortOrder SortOrder
        {
            get { return _sortOrder.HasValue ? _sortOrder.Value : PlaybookSortOrder.ASC; }
            set { _sortOrder = value; }
        }

        public string SortImageUrl
        {
            get
            {
                string imgURL = string.Empty;
                switch (this.SortOrder)
                {
                    case PlaybookSortOrder.ASC:
                        imgURL = CommonConstants.IMAGE_PLAYBOOK_PATH + CommonConstants.IMAGE_SORT_ASC;
                        break;
                    case PlaybookSortOrder.DESC:
                        imgURL = CommonConstants.IMAGE_PLAYBOOK_PATH + CommonConstants.IMAGE_SORT_DESC;
                        break;
                }

                return imgURL;
            }
        }

        private string _sortBy;
        public string SortBy
        {
            get { return string.IsNullOrEmpty(_sortBy) ? CommonConstants.PROMOTION_SORT_VALUE_ACCOUNT : _sortBy; }
            set { _sortBy = value; }
        }

        public string SearchText { get; set; }

        public bool RefreshData { get; set; }

        public bool ApplyAccountFilter { get; set; }

        public bool CacheExists { get; set; }

        public List<string> AccountValues { get; set; }
        public List<string> ChannelValues { get; set; }
        public List<string> PackageValues { get; set; }
        public List<string> BrandValues { get; set; }

        public List<string> SortValues
        {
            get
            {
                List<string> _sortValues = new List<string>();

                if (ApplyAccountFilter)
                    _sortValues.Add(CommonConstants.PROMOTION_SORT_VALUE_ACCOUNT);

                else
                    _sortValues.Add(CommonConstants.PROMOTION_SORT_VALUE_CHANNEL);

                _sortValues.Add(CommonConstants.PROMOTION_SORT_VALUE_STATUS);
                _sortValues.Add(CommonConstants.PROMOTION_SORT_VALUE_PRIORITY);
                _sortValues.Add(CommonConstants.PROMOTION_SORT_VALUE_PROMO_CATEGORY);


                return _sortValues;
            }
        }

        private List<string> _createdByValues;
        public List<string> CreatedByValues
        {
            get
            {
                if (_createdByValues == null)
                {
                    _createdByValues = new List<string>();
                    _createdByValues.Add(CommonConstants.PROMOTION_CREATE_VALUE_EVERYONE);
                    _createdByValues.Add(CommonConstants.PROMOTION_CREATE_VALUE_ME);
                    _createdByValues.Add(CommonConstants.PROMOTION_CREATE_VALUE_NA);
                    _createdByValues.Add(CommonConstants.PROMOTION_CREATE_VALUE_FIELD);
                    //_createdByValues.Add(CommonConstants.PROMOTION_CREATE_VALUE_PROMOTION);
                    //_createdByValues.Add(CommonConstants.PROMOTION_CREATE_VALUE_NONPROMOTION);
                }
                return _createdByValues;
            }

        }


        // Added by Nirvit
        public int? PromotionStatusId { get; set; }
        public DateTime CalenderEndDate { get; set; }

        public int SelectedNationalAccountID { get; set; }
        public int SelectedRegionalAccountID { get; set; }
        public int SelectedLocalAccountID { get; set; }
        public int SelectedRouteID { get; set; }
        public bool IsMyRoute { get; set; }

        // For Supply Chain Calendar
        public string SelectedtrademarksID { get; set; }
        public string SelectedpackagesID { get; set; }

        #endregion

        #region Portal Base Properties

        public int BranchID { get; set; }
        public int RegionID { get; set; }
        public string GSN { get; set; }
        public int NationalAccountCount { get; set; }
        public int RegionalAccountCount { get; set; }
        public int SuperChannelCount { get; set; }
        public int ChannelCount { get; set; }
        public bool ViewNAPromotions { get; set; }
        public bool ViewDraftNAPromotions { get; set; }
        public int CurrentPersonaID { get; set; }
        public int AreaID { get; set; }
        public int BUID { get; set; }
        #endregion

        public List<string> UserAccess { get; set; }

        /// <summary>
        /// Returns the value with the escape character
        /// </summary>
        /// <param name="Value"></param>
        /// <returns></returns>
        public static string ReplaceSpecialCharacter(string Value)
        {
            if (Value.Contains("'"))
                Value = Value.Replace("'", "''");

            if (Value.Contains("%"))
                Value = Value.Replace("%", "[%]");

            if (Value.Contains("*"))
                Value = Value.Replace("*", "[*]");

            return Value;
        }

        public bool Reset
        {
            set
            {
                if (value)
                {
                    // Initialize all the properties
                    this.SelectedAccount = null;
                    this.SelectedChannel = null;
                    this.SelectedPackage = null;
                    this.SelectedBrand = null;
                    this.SelectedBottler = null;
                    this._selectedDate = null;
                    this._sortOrder = null;
                    this.SortBy = null;
                    this.SearchText = string.Empty;
                    this.ApplyAccountFilter = true;
                    this.SelectedAssociatedPromotionAccount = null;
                    this.RefreshData = true;
                }
            }
        }

        #region Associated Promotions
        public int ProgramID { get; set; }

        private string _selectedAssociatedPromotionAccount;
        public string SelectedAssociatedPromotionAccount
        {
            get
            {
                return string.IsNullOrEmpty(_selectedAssociatedPromotionAccount) ? CommonConstants.PROMOTION_ALL_ACCOUNTS : _selectedAssociatedPromotionAccount;
            }
            set { _selectedAssociatedPromotionAccount = value; }
        }

        public List<string> AssociatedPromotionSortValues
        {
            get
            {
                List<String> lst = new List<string>();
                lst.Add(CommonConstants.PROMOTION_SORT_VALUE_ACCOUNT);
                lst.Add(CommonConstants.PROMOTION_SORT_VALUE_STATUS);

                return lst;
            }

        }

        #endregion

    }
}
