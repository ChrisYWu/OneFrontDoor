using System;
using System.Collections.Generic;
using DPSG.Portal.Framework.Types.Constants;

namespace DPSG.Portal.Framework.Types
{
    public class ViewProgramFilter
    {
        public string GSN { get; set; }
        public bool RefreshData { get; set; }
        public int BranchId { get; set; }
        public int RegionID { get; set; }
        public string SelectedAccount { get; set; }
        public string SelectedMarketingProgram { get; set; }
        public string SelectedTrademark { get; set; }
        public string SelectedPackage { get; set; }
        //public string SelectedSystem { get; set; }
        public string SearchText { get; set; }
        public string SelectedSort { get; set; }
        public ProgramSortOrder SelectedSortOrder { get; set; }
        public int SelectedPageSize { get; set; }
        public string SelectedCalendarType { get; set; }
        public bool IncludeNextPeriod { get; set; }
        public bool DisplayRefreshImage { get; set; }
        public bool CacheExists { get; set; }
        //public string UserSystems { get; set; }
        //public string RoleSystems { get; set; }
        //public OnePortalRole UserRole { get; set; }
        //public bool IsAdmin { get; set; }
        public string StatusFilter { get; set; }
        public List<string> userActions { get; set; }
        public List<string> Accounts { get; set; }
        public List<string> MarketingPrograms { get; set; }
        public List<string> Brands { get; set; }
        //public List<string> Systems { get; set; }
        public List<string> SortValues { get; set; }

        //getters
        public string SortImageUrl
        {
            get
            {
                if (SelectedSortOrder == ProgramSortOrder.Ascending)
                    return "/_layouts/dpsg.portal.marketingprograms/images/" + CommonConstants.IMAGE_SORT_ASC;
                else
                    return "/_layouts/dpsg.portal.marketingprograms/images/" + CommonConstants.IMAGE_SORT_DESC;
            }
        }

        private DateTime _startDate;
        public DateTime StartDate
        {
            get
            {
                DateTime _startDatetemp = DateTime.Now;

                switch (SelectedCalendarType)
                {
                    case CommonConstants.CAL_TYPE_MONTH:        //Monthly
                        {
                            _startDatetemp = new DateTime(_startDate.Year, _startDate.Month, 1);
                            break;
                        }
                    case CommonConstants.CAL_TYPE_QUARTER:          // Quarter
                        {
                            int quarter = ((((_startDate.Month - 1) / 3) + 1) * 3) - 2;
                            _startDatetemp = new DateTime(_startDate.Year, quarter, 1);
                            break;
                        }
                    case CommonConstants.CAL_TYPE_TRIMESTER:        //Trimester
                        {
                            int trimester = ((((_startDate.Month - 1) / 4) + 1) * 4) - 3;
                            _startDatetemp = new DateTime(_startDate.Year, trimester, 1);
                            break;
                        }
                    case CommonConstants.CAL_TYPE_ANNUAL:           //Annual
                        {
                            _startDatetemp = new DateTime(_startDate.Year, 1, 1);
                            break;
                        }
                    case CommonConstants.CAL_TYPE_DATE_RANGE:       //Date Range
                        {
                            _startDatetemp = _startDate;
                            break;
                        }
                }

                return _startDatetemp;
            }
            set
            {
                _startDate = value;
            }
        }

        private DateTime _endDate;
        public DateTime EndDate
        {
            get
            {
                DateTime _tempEendDate = DateTime.Now;
                int months = 0;

                switch (SelectedCalendarType)
                {
                    case CommonConstants.CAL_TYPE_MONTH:        //Monthly
                        {
                            months = IncludeNextPeriod ? 2 : 1;
                            break;
                        }
                    case CommonConstants.CAL_TYPE_QUARTER:          // Quarter
                        {
                            months = IncludeNextPeriod ? 6 : 3;
                            break;
                        }
                    case CommonConstants.CAL_TYPE_TRIMESTER:        //Trimester
                        {
                            months = IncludeNextPeriod ? 8 : 4;
                            break;
                        }
                    case CommonConstants.CAL_TYPE_ANNUAL:           //Annual
                        {
                            months = IncludeNextPeriod ? 24 : 12;
                            break;
                        }
                    case CommonConstants.CAL_TYPE_DATE_RANGE:
                        {
                            return _endDate;
                        }
                }
                
                _tempEendDate = this.StartDate.AddMonths(months).AddDays(-1);

                return _tempEendDate;
            }
            set
            {
                _endDate = value;
            }
        }

        public string SelectedGeo { get; set; }

        #region Properties for Latest Program Updates
        public bool New { get; set; }
        public bool Updated { get; set; }
        public bool Cancelled { get; set; }
        public bool Milestones { get; set; }
        public bool ViewDraft { get; set; }
        #endregion
    }
}
