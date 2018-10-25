using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types.Constants
{
    public class CommonConstants
    {
        public const string LocationHierarchyAllDSD = "All PB";
        public const string ManageBrandPackageCategory = "ManageBrandPackageCategoryKey";
        public const string PromotionGEORelevancyKey = "PromotionGEORelevancyKey";
        public const string PromotionLocationSupplyRelevancyKey = "PromotionLocationSupplyRelevancyKey";
        public const string ProductLineSupplyRelevancyKey = "ProductLineSupplyRelevancyKey";
        public const string PromotionBCGEORelevancyKey = "PromotionBCGEORelevancyKey";
        public const string PromotionBCGEOStatesRelevancyKey = "PromotionBCGEOStatesRelevancyKey";
        public const string PromotionGEOSurveyRelevancyKey = "PromotionGEOSurveyRelevancyKey";
        public const string PREFERENCEBCACCOUNTKEY = "Preferencebcaccountkey";

        public const string PromotionSiteURL="PromoLibbaseUrl";
        public const string PROMOTION_REGIONAL_ALL_OTHER = "All Other";
        public const string PROMOTION_NATIONAL_ALL_OTHER = "All Other";
        public const string PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR = "^";
        public const string PROMOTION_GEO_TREE_VIEW_SEPERATOR = "^";
        public const string PROMOTION_CHANNEL_TREE_VIEW_SEPERATOR = "^";

        public const string PROMOTION_GEO_TYPE_BU = "BU";
        public const string PROMOTION_GEO_TYPE_REGIONAL = "Region";
        public const string PROMOTION_GEO_TYPE_AREA = "Area";
        public const string PROMOTION_GEO_TYPE_BRANCH = "Branch";

        public const string PROMOTION_GEO_TYPE_SYSTEM = "System";
        public const string PROMOTION_GEO_TYPE_ZONE = "Zone";
        public const string PROMOTION_GEO_TYPE_DIVISION = "Division";
        public const string PROMOTION_GEO_TYPE_REGION = "Region";
        public const string PROMOTION_GEO_TYPE_BC_REGION = "BCRegion";
        public const string PROMOTION_GEO_TYPE_BOTTLER = "Bottler";


        public const string PROMOTION_TREE_DATA_FIELD_ID = "Id";
        public const string PROMOTION_TREE_DATA_FIELD_VALUE = "Value";
        public const string PROMOTION_TREE_DATA_FIELD_TEXT = "Text";
        public const string PROMOTION_TREE_DATA_FIELD_PARENT_ID = "ParentId";
        public const string PROMOTION_TREE_DATA_FIELD_SAPVALUE = "SAPValue";
        public const char ACCOUNT_TREE_VIEW_SEPERATOR = '^';
        public const int CACHE_TIME_LIMIT_1_DAY = 24 * 60;
        public const int CACHE_TIME_LIMIT_1_WEEK = 24 * 60 * 7;

        public const string SUPPLY_CHAIN_PLANT_KEY = "SUPPLY_CHAIN_PLANT_ALL_KEY";
        public const string SUPPLY_CHAIN_MANUFACTURE_MYSETTING_KEY = "SUPPLY_CHAIN_MANUFACTURE_MYSETTING_KEY";
        public const string SUPPLY_CHAIN_INVENTORY_MYSETTING_KEY = "SUPPLY_CHAIN_INVENTORY_MYSETTING_KEY";
        public const string SUPPLY_CHAIN_TREE_VIEW_SEPERATOR = "^";
        public const string SUPPLY_CHAIN_PRODUCTLINE = "Product Line";
        public const string SUPPLY_CHAIN_TRADEMARK = "Trademark";

        public const string CSS_VERSION = "CssVersion";
        public const string CSS_PATH = "/_layouts/DPSG.Portal.Branding/CSS/";
        public const string JS_PATH = "/_layouts/DPSG.Portal.Branding/JS/";
        
        public const string CAL_TYPE_TRIMESTER = "Trimester";
        public const string CAL_TYPE_QUARTER = "Quarter";
        public const string CAL_TYPE_MONTH = "Month";
        public const string CAL_TYPE_ANNUAL = "Year";
        public const string CAL_TYPE_DATE_RANGE = "Date Range";

        public const string APPROVAL_DOCUMENT_UPLOAD = "document upload & approved";
        public const string APPROVAL_MANUAL_SELECTION = "manual selection";
        public const string APPROVAL_AUTOMATIC_DATE = "automatic date range";
        public const string APPROVAL_AUTOMATIC_SINGLE_DATE = "automatic single date";

        public const string DOCUMENT_UPLOAD_TEXT = "On Document Upload and Approval";
        public const string MANUAL_SELECTION_TEXT = "Manual";
        public const string AUTOMATIC_DATE_TEXT = "Automatic";
        public const string AUTOMATIC_SINGLE_DATE_TEXT = "Automatic";
        public const string NON_PROMOTION_TYPE = "Non-Promotion";
        public const int NON_PROMO_CONTENT_ATTACHMENTTYPE_ID = 8;
        #region Export Promotion
        public const string EXPORT_PROMOTION_LIST_ACCOUNT = "Accounts";
        public const string EXPORT_PROMOTION_LIST_CHANNEL = "Channels";

        #endregion

        #region BrandingComponents

        public const string STOCK_TICKER = "DPSGStockTicker";
        public const string SAVED_PREFERENCES = "SAVED_PREFERENCES";
        public const string LOCATION = "LOCATION";
        public const string SALES_BRANCH = "SALES_BRANCH";
        public const string DEFAULT_PREFERENCE = "DEFAULT_PREFERENCE";
        public const string NO_IT_UPDATES = "NO_IT_UPDATES";
        public const string NO_MARKETING_UPDATES = "NO_MARKETING_UPDATES";
        public const string NO_ORDER_DEADLINES = "NO_ORDER_DEADLINES";
        public const string SYSTEM_ERROR = "SYSTEM_ERROR";
        public const string MY_PREFERENCE_MANUFACTURING_SETTINGS_INFO = "MY_PREFERENCE_MANUFACTURING_SETTINGS_INFO";
        public const string MY_PREFERENCE_INVENTORY_SETTINGS_INFO = "MY_PREFERENCE_INVENTORY_SETTINGS_INFO";


        #endregion

        #region MySplashNet

        public const string SALES_TARGET_FORECAST = "SALES_TARGET_FORECAST";
        public const string SALES_TARGET_WEEKEND = "SALES_TARGET_WEEKEND";
        public const string CALL_OUT = "CALL_OUT";

        #endregion

        #region SplashNet

        public const string NO_RECORDS = "NO_RECORDS";
        public const string LIST_NOT_EXIST = "LIST_NOT_EXIST";

        #endregion

        #region Image
        public const string IMAGE_PLAYBOOK_PATH = "/_layouts/DPSG.Portal.Branding/Images/Playbook/";
        public const string IMAGE_PB_ACCOUNT_PHYSICAL_PATH = "TEMPLATE\\LAYOUTS\\DPSG.Portal.Branding\\images\\PlayBook\\Accounts\\";
        public const string IMAGE_ACCOUNT_PATH = "/_layouts/DPSG.Portal.Branding/Images/Playbook/Accounts/";
        public const string IMAGE_SORT_ASC = "sorting_icon_asc.png";
        public const string IMAGE_SORT_DESC = "sorting_icon_desc.png";
        public const string IMG_APPROVED = "approve_icon.png";
        public const string IMG_REJECTED = "del_icon.png";
        public const string IMG_DRAFT = "pending_icon.png";
        public const string IMG_READY_FOR_APPROVAL = "readyApproval_icon.png";
        #endregion

        #region Program
        public const string PROGRAM_LIBRARY_NAME = "PromotionLibrary";
        #endregion

        #region Message list
        public const string CACHE_MESSAGE_KEY = "MessageHardCode";
        public const string MessageKey = "MessageKey";
        public const string lstPromoBrand_sMessage = "lstPromoBrand_sMessage";
        public const string lstPromoPackage_sMessage = "lstPromoPackage_sMessage";
        public const string PageTitleMsg = "Add Brands and Packages";
        public const string Quickstart = "Quickstart";
        public const string Promo_attach = "Promo_attach";
        public const string UpdatePromo_msg = "UpdatePromo_msg";
        public const string PromoList_tooltip = "PromoList_tooltip";
        public const string Promoupdate_msg = "Promoupdate_msg";
        public const string Promofail_msg = "Promofail_msg";
        public const string Milestone_Info_Tooltip = "Milestone_Info_Tooltip";
        #endregion 

        public const string MASS_UPLOAD_EXCEL_SHEET_DEFAULT_DATE = "1/1/1900";

        #region Promotion Activitiy
        public const string PROMOTION_LIBRARY_NAME = "PromotionLibrary";
        public const string CONNECTION_STRING_NMAE = "Portal_DataConnection";
        public const string DEFAULT_CATEGORY = "Promotion";
        public const string PROMOTION_ALL_ACCOUNTS = "All Accounts";
        public const string PROMOTION_MY_ACCOUNTS = "My Accounts";
        public const string PROMOTION_ALL_CHANNELS = "All Channels";
        public const string PROMOTION_MY_CHANNEL = "My Channels";
        public const string PROMOTION_ALL_BRANDS = "All Brands";
        public const string PROMOTION_ALL_BOTTLER = "All Bottler";
        public const string PROMOTION_ALL_PACKAGES = "All Packages";
        public const string PROMOTION_SORT_VALUE_ACCOUNT = "Account";
        public const string PROMOTION_SORT_VALUE_CHANNEL = "Channel";
        public const string PROMOTION_SORT_VALUE_STATUS = "Status";
        public const string PROMOTION_SORT_VALUE_PRIORITY = "Priority";
        public const string PROMOTION_SORT_VALUE_PROMO_CATEGORY = "Promotion Category";
        public const string PROMOTION_SORT_VALUE_BRAND = "Brand";
        public const string PROMOTION_SORT_VALUE_BOTTLER = "Bottler";

        public const string PROMOTION_CREATE_VALUE_EVERYONE = "All";            

        public const string PROMOTION_CREATE_VALUE_ME = "Created By Me";
        public const string PROMOTION_CREATE_VALUE_NA = "Created By NA";
        public const string PROMOTION_CREATE_VALUE_FIELD = "Created By Field";
        public const string BC_LIST_ITEM_SEPERATOR = "^";
        public const string SYSTEM_NAME_DSD = "DSD";
        public const string SYSTEM_NAME_WD = "WD";
        public const string PROMOTION_CREATE_VALUE_PROMOTION = "Promotion";
        public const string PROMOTION_CREATE_VALUE_NONPROMOTION = "Non-Promotion";
        #endregion

        public const string ALL_OTHER = "All Other";

        public const string PLANT_ID = "PlantID";
        public const string PLANT_NAME = "PlantName";

        public const string MEASURS_ID = "MeasursID";
        public const string MEASURS_TYPE = "MeasursType";
        

    }
}
