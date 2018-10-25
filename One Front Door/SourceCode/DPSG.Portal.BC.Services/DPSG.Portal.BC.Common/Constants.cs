using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.BC.Common
{
    public class Constants
    {
        public const string EMPTY_GUID = "00000000-0000-0000-0000-000000000000";
        public const string SAML_XML_PATH = @"D:\SAML.XML";
        public const string SAML_XML_HEADER = "SAMLToken";
        public const string SDM_HEADER = "SDMToken";
        public const string SAML_RESPONSE_HEADER = "samlResponseHeader";
        public const string SAML_EXCEPTION_MSG = "Access denied";
        public const string ACCESS_DENIED = "Access denied";
        public const string EXCEPTION = "Exception";

        //IPE SURVEY APPLICATION TYPE (UPPER CASE VALUES)
        public enum IPE_SURVEY_EVENT_RESPONSE_APPLICAITON_TYPES {BOTTLER, CHAIN };

        #region DoNotRemove
        public const string JSONNET_SCHEMA_LICENSE = "3139-wEvaPBzC2SrRnhzwRQCc1TDza5OvS284TKzB6W3FL1pK73MW8n4h8T6zsb/PseibDIJa/JILemYuBPPC1AxrXXVHVw32UHmnH4Dl5pWyh8uw0EqXetaonAiCN9Yd3M6vhaNJjYExiIaro5IRKxoauIBR6Ul5EdrmA9O85r7sr4N7IklkIjozMTM5LCJFeHBpcnlEYXRlIjoiMjAxNi0xMS0zMFQxNzowMjozMS4yODU3ODczWiIsIlR5cGUiOiJKc29uU2NoZW1hQnVzaW5lc3MifQ==";
        #endregion

        #region Array ListIndex

        public const int NATIONAL_CHAIN_INDEX = 0;
        public const int REGIONAL_CHAIN_INDEX = 1;
        public const int LOCAL_CHAIN_INDEX = 2;
        public const int CHANNEL_INDEX = 3;
        public const int SUPER_CHANNEL_INDEX = 4;
        public const int CHAIN_GROUP_INDEX = 5;


        public const int BRAND_INDEX = 0;
        public const int PACKAGE_INDEX = 1;
        public const int TRADEMARK_INDEX = 2;


        public const int LOS_INDEX = 0;
        public const int LOSDISPLAYLOCATION_INDEX = 1;
        public const int TIEINREASONMASTER_INDEX = 2;
        public const int DISPLAYTYPEMASTER_INDEX = 3;
        public const int SYSTEMBRAND_INDEX = 4;
        public const int SYSTEMPACKAGE_INDEX = 5;
        public const int SYSTEMPACKAGEBRAND_INDEX = 6;
        public const int CONFIG_INDEX = 7;
        public const int DISPLAYLOCATION_INDEX = 8;
        public const int SYSTEMTRADEMARK_INDEX = 9;
        public const int SYSTEMCOMPETITIONBRAND_INDEX = 10;
        public const int PROMOTIONEXECUTIONSTATUS_INDEX = 11;

        public const int STORECONDITION_INDEX = 0;
        public const int STORECONDITION_DISPLAY_INDEX = 1;
        public const int STORECONDITION_DISPLAY_DET_INDEX = 2;
        public const int STORE_TIE_IN_RATE_INDEX = 3;
        public const int STORE_BC_PROMOTION_EXECUTION_INDEX = 4;
        public const int STORE_NOTES_INDEX = 5;
        public const int STORE_PRIORITY_STATUS_INDEX = 6;

        public const int BOTTLER_INDEX = 0;
        public const int BOTTLERACCOUNT_TRADEMARK_INDEX = 1;
        public const int SALES_HIERARCHY_MASTER_TOTALCOMPANY = 2;
        public const int SALES_HIERARCHY_MASTER_COUNTRY = 3;
        public const int SALES_HIERARCHY_MASTER_SYSTEM = 4;
        public const int SALES_HIERARCHY_MASTER_ZONE = 5;
        public const int SALES_HIERARCHY_MASTER_DIVISION = 6;
        public const int SALES_HIERARCHY_MASTER_REGION = 7;
        public const int SALES_ACCOUNT_BCSALESACCOUNTABILITY = 8;


        public const int SALES_HIERARCHY_DATA_TOTALCOMPANY = 0;
        public const int SALES_HIERARCHY_DATA_COUNTRY = 1;
        public const int SALES_HIERARCHY_DATA_SYSTEM = 2;
        public const int SALES_HIERARCHY_DATA_ZONE = 3;
        public const int SALES_HIERARCHY_DATA_DIVISION = 4;
        public const int SALES_HIERARCHY_DATA_REGION = 5;
        public const int SALES_HIERARCHY_DATA_BOTTLE_SALES = 6;
        

        #endregion

        #region ResponseMessage

        public const int RESPONSE_STATUS_FAIL = 0;
        public const int RESPONSE_STATUS_PASS = 1;
        public const int RESPONSE_STATUS_WARNING = 2;
        public const string ERROR_MESSAGE_FAIL = "Error processing request";
        public const string ERROR_MESSAGE_PASS = "";
        public const string RESPONSE_STATUS_PASS_MESSAGE = "Successful Transfer";
        

        public const string STACK_TRACE = "";

        #endregion

        public const string FORMAT = "Format";
        public const string TERRITORY_TYPE = "TType";
        public const string PRODUCT_TYPE = "PType";
        public const string STORE_TIEIN_HISTORY = "History";

        /// <summary>
        /// Use these constants for Upload file into SharePoint Library
        /// </summary>
        public const string SITE_URL = "http://win-chrf7jrmgk5:91/BC/";
        public const string LIST_NAME = "BCDocumentLib";

        public const string DATE_FORMAT = "MM/dd/yyyy";

        #region ServiceLog

        public const string SERVICE_NAME = "BC Service";
        public const string SERVICE_PASS_STATUS = "Pass";
        public const string SERVICE_FAIL_STATUS = "Fail";

        public const int SERVICE_VALIDATION_SUCCESS = 1;
        public const int SERVICE_VALIDATION_FAIL = 0;


        #endregion

        #region XML Node
        
        //common fields

        public const string XMLNODE_CREATEDBY = "CreatedBy";
        public const string XMLNODE_CREATEDDATE = "CreatedDate";
        public const string XMLNODE_MODIFIEDBY = "ModifiedBy";
        public const string XMLNODE_MODIFIEDDATE = "ModifiedDate";
        public const string XMLNODE_ISACTIVE = "IsActive";
        public const string CLIENTDISPLAYID = "ClientDisplayID";
        public const string SYSTEMBRANDID = "SystemBrandID";

        //StoreCondtionDisplay
        public const string STORECONDITIONDISPLAYS = "StoreConditionDisplays";
        public const string STORECONDITIONDISPLAY = "StoreConditionDisplay";
        public const string STORECONDITIONID = "StoreConditionID";
        public const string DISPLAYLOCATIONID = "DisplayLocationID";
        public const string PROMOTIONID = "PromotionID";
        public const string DISPLAYLOCATIONNOTE = "DisplayLocationNote";
        public const string DISPLAYTYPEID = "DisplayTypeID";
        public const string OTHERNOTE = "OtherNote";
        public const string DISPLAYIMAGEURL = "DisplayImageURL";
        public const string GRIDX = "GridX";
        public const string GRIDY = "GridY";       
        public const string REASONID = "ReasonID";
        public const string IMAGEBYTES = "ImageBytes";

        //StoreCondtion Display Details
        public const string STORECONDITIONDISPLAYDETAILS = "StoreConditionDisplayDetails";
        public const string STORECONDITIONDISPLAYDETAIL = "StoreConditionDisplayDetail";
        public const string SYSTEMPACKAGEID = "SystemPackageID";
        
        
        //Store Tie-in rates
        public const string STORETIEINRATES = "StoreTieInRates";
        public const string STORETIEINRATE = "StoreTieInRate";
        public const string TIEINRATE = "TieInRate";
        public const string TOTALDISPLAYS = "TotalDisplays";
        

        //Web Service Reference URL
        public const string IMAGESERVICEURL = "http://bplnshp02/promotions/_vti_bin/Imaging.asmx";
        public const string LISTSERVICEURL = "http://bplnshp02/promotions/_vti_bin/Lists.asmx";
        


        #endregion


        public class KQLProperties
        {
            public readonly static string KQL_COLUMN_PROMOTION_CHAIN = "OFDChain";
            public readonly static string KQL_COLUMN_PROMOTION_CHANNEL = "ManagedPromotionChannel";
            public readonly static string KQL_COLUMN_StartDate = "StartDate";
            public readonly static string KQL_COLUMN_EndDate = "ManagedEndDate";
            public readonly static string KQL_COLUMN_ExpiredDate = "ExpiredDate";
            // public readonly static string KQL_COLUMN_LastUpdated = "LastModifiedTime";
            public readonly static string KQL_COLUMN_LastUpdated = "OFDModified";
            public static string KQL_PROPERTIES_FileName = "FileName";
            public static string KQL_PROPERTIES_URL = "Path";
            public static string KQL_PROPERTIES_SizeInBytes = "Size";
            public static string KQL_PROPERTIES_DateModified = "OFDModified";
            public static string KQL_PROPERTIES_SharePointDocumentID = "spdocid";
            public static string KQL_PROPERTIES_DocumentType = "OFDDocumentType";
            public static string KQL_PROPERTIES_StartDate = "ManagedStartDate";
            public static string KQL_PROPERTIES_ExpiredDate = "ManagedExpiredDate";
            public static string KQL_PROPERTIES_AccountId = "AccountId";
            public static string KQL_PROPERTIES_SAPAccountNumber = "SAPAccountNumber";
            public static string KQL_PROPERTIES_CHAIN = "OFDChain";
            public static string KQL_PROPERTIES_LOCATION = "OFDDSDLocation";
        }
    }
}
