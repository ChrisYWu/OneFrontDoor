using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DPSG.Portal.BC.Services.DataContract.Promotion;
using System.Collections;
using System.Data;
using Microsoft.SharePoint;
using System.Data;
using Microsoft.Office.Server.Search.Administration;
using Microsoft.Office.Server.Search.Query;
using System.Text;

namespace DPSG.Portal.BC.Services.OperationContract.ServiceWrapper
{
    public class Promotion
    {
        public static DataContract.Promotion.PromotionData GetPromotionsByRegionID(int regionID, DateTime? lastModifiedDate)
        {
            Types.Promotion.PromotionData spData = DPSG.Portal.BC.BAL.Promotion.GetPromotionsByRegionID(regionID, lastModifiedDate);

            DataContract.Promotion.PromotionData data = new DataContract.Promotion.PromotionData();
            data.Promotions = spData.Promotions;
            data.PromotionBrands = spData.PromotionBrands;
            data.PromotionPackages = spData.PromotionPackages;
            data.PromotionAccounts = spData.PromotionAccounts;
            data.PromotionAttachments = spData.PromotionAttachments;
            data.PromotionStates = spData.PromotionStates;
            return data;
        }

        public static int[] GetPromotionsIDsByBottler(int BottlerID)
        {
            return DPSG.Portal.BC.BAL.Promotion.GetPromotionsIDsByBottler(BottlerID);
        }

        public static DataContract.Promotion.PromotionData GetPromotionsByRouteID(string routeID, DateTime? lastModifiedDate)
        {

            var obj = new BAL.Promotion();
            Types.Promotion.PromotionData data = obj.GetPromotionsByRouteID(routeID, lastModifiedDate);

            DataContract.Promotion.PromotionData results = new DataContract.Promotion.PromotionData();
            results.Promotions = data.Promotions;
            results.PromotionBrands = data.PromotionBrands;
            results.PromotionPackages = data.PromotionPackages;
            results.PromotionAccounts = data.PromotionAccounts;
            results.PromotionAttachments = data.PromotionAttachments;
            results.PromotionPriority = data.PromotionsWeekPriority;
            results.PromotionCustomers = data.PromotionCustomers;
            results.PromotionStatus = data.PromotionStatus;
            return results;
        }

        public static DPSG.Portal.BC.Services.DataContract.OtherPromo.OtherPromoData GetOtherPromoMaster(DateTime? LastModifiedDate)
        {
            DPSG.Portal.BC.Types.Promotion.OtherPromoData data = DPSG.Portal.BC.BAL.Promotion.GetOtherPromoMaster(LastModifiedDate);
            DPSG.Portal.BC.Services.DataContract.OtherPromo.OtherPromoData retval = new DataContract.OtherPromo.OtherPromoData();
            retval.PromotionCategories = data.PromotionCategories;
            retval.PromotionExecutionStatus = data.PromotionExecutionStatus;
            retval.PromotionRefusalReasons = data.PromotionRefusalReasons;
            return retval;
        }

        public static DPSG.Portal.BC.Services.DataContract.Promotion.Documents GetDocumentsByRouteNumber(string RouteNumber)
        {
            DPSG.Portal.BC.Services.DataContract.Promotion.Documents data = new DPSG.Portal.BC.Services.DataContract.Promotion.Documents();
            ArrayList metaData = DPSG.Portal.BC.BAL.Promotion.GetDocumentsByRouteNumber(RouteNumber);

            DataTable dtMetaData = (DataTable)metaData[0];
            
            int returnStatus = -1;
            
            List<Types.Promotion.DocumentCustomerMapping> customerMapping = (List<Types.Promotion.DocumentCustomerMapping>)metaData[1];
            List<Types.Promotion.DocumentCustomerMapping> returnValue = new List<Types.Promotion.DocumentCustomerMapping>();
            Types.Promotion.DocumentCustomerMapping value;

            //Query documents
            List<Types.Promotion.Document> documents = GetNonPromotionalData(dtMetaData, ref returnStatus);
            
            //Populating return data
            foreach (Types.Promotion.DocumentCustomerMapping custMap in customerMapping)
            {
                string [] files = documents.Where(i => i.MetaDataID == custMap.MetaDataTableID).Select(i => i.AttachmentID).ToArray();
                if (files.Length > 0)
                {
                    value=new Types.Promotion.DocumentCustomerMapping();
                    value.CustomerNumber = custMap.CustomerNumber;
                    value.Attachments = files;
                    returnValue.Add(value);
                }
            }
            data.ResponseStatus = returnStatus;
            data.AttachmentCustomerMapping = returnValue;
            data.Attachments = documents.GroupBy(x=>x.AttachmentID).Select(x=>x.First()).ToList();
            return data;

        }

        private static List<Types.Promotion.Document> GetNonPromotionalData(DataTable objNonPromotionDocument, ref int ReturnStatus)
        {
            ReturnStatus = 1;
            int searchMaxRecordCount = Convert.ToInt32(System.Configuration.ConfigurationSettings.AppSettings.Get("SearchMaxRecordCount"));
            List<Types.Promotion.Document> documents = new List<Types.Promotion.Document>();
            DataTable result = null;
            DataTable dt = new DataTable();
            string query = @"<QueryPacket><Query><Context><QueryText>#QUERY#</QueryText></Context>
                                <Range>
                                    <Count>" + searchMaxRecordCount.ToString() +@"</Count>
                                </Range>
                                <Properties>
                                    <Property name='Title'></Property>
                                    <Property name='" + DPSG.Portal.BC.Common.Constants.KQLProperties.KQL_PROPERTIES_FileName+ @"'></Property>
                                    <Property name='"+ DPSG.Portal.BC.Common.Constants.KQLProperties.KQL_PROPERTIES_URL+ @"'></Property>
                                    <Property name='"+ DPSG.Portal.BC.Common.Constants.KQLProperties.KQL_PROPERTIES_SizeInBytes+ @"'></Property>
                                    <Property name='ItemID'></Property>
                                    <Property name='"+ DPSG.Portal.BC.Common.Constants.KQLProperties.KQL_COLUMN_LastUpdated+ @"'></Property>
                                    <Property name='" + DPSG.Portal.BC.Common.Constants.KQLProperties.KQL_PROPERTIES_DocumentType + @"'></Property>
                                    <Property name='ManagedStartDate'></Property>
                                    <Property name='ManagedExpiredDate'></Property>
                                </Properties>
                            </Query></QueryPacket>";



            try
            {
                string url = System.Configuration.ConfigurationSettings.AppSettings.Get("SharePointWebAppUrl");
                DPSG.Portal.BC.BAL.SPSearch.QueryService search = new DPSG.Portal.BC.BAL.SPSearch.QueryService();
                search.Url = url;
                search.Credentials = System.Net.CredentialCache.DefaultCredentials;
                foreach (DataRow dr in objNonPromotionDocument.Rows)
                {
                    try
                    {
                        string kqlQuery = KQLQueryBuilder(dr);
                        DPSG.Portal.BC.Common.ExceptionHelper.LogException(kqlQuery, "");
                        string updatedQuery = query.Replace("#QUERY#", System.Web.HttpUtility.HtmlEncode(kqlQuery));
                        DPSG.Portal.BC.Common.ExceptionHelper.LogException(updatedQuery, "");

                        DataSet ds = search.QueryEx(updatedQuery);
                        result = ds.Tables[0];

                        if (result != null && result.Rows.Count > 0)
                        {


                            documents.AddRange(result.AsEnumerable().Select(row => new Types.Promotion.Document()
                            {
                                Name = Convert.ToString(row[DPSG.Portal.BC.Common.Constants.KQLProperties.KQL_PROPERTIES_FileName]),
                                URL = Convert.ToString(row[DPSG.Portal.BC.Common.Constants.KQLProperties.KQL_PROPERTIES_URL]),
                                Size = Convert.ToInt32(row[DPSG.Portal.BC.Common.Constants.KQLProperties.KQL_PROPERTIES_SizeInBytes]),
                                ModifiedDate = Convert.ToDateTime(row["OFDModified"]).ToString("MM/dd/yyyy"),
                                AttachmentID = Convert.ToString(row["ItemID"]),
                                AttachmentType = Convert.ToString(row[DPSG.Portal.BC.Common.Constants.KQLProperties.KQL_PROPERTIES_DocumentType]),
                                StartDate = Convert.ToDateTime(row["ManagedStartDate"]).ToString("MM/dd/yyyy"),
                                EndDate = Convert.ToDateTime(row["ManagedExpiredDate"]).ToString("MM/dd/yyyy"),
                                MetaDataID = Convert.ToInt32(dr["ID"])
                            }).Distinct().ToList());
                        }
                    }
                    catch (Exception ex)
                    {
                        ReturnStatus = 2; //Warning
                        DPSG.Portal.BC.Common.ExceptionHelper.LogException("Exception occured in query Sharepoint Search", "DSPG.Portal.BC.BAL.GetNonPromotionalData");
                        DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "DSPG.Portal.BC.BAL.GetNonPromotionalData");
                    }
                }
            }
            catch (Exception ex)
            {
                DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "DSPG.Portal.BC.BAL.GetNonPromotionalData");
                throw (ex);
            }

            return documents;
        }

        public static string KQLQueryBuilder(DataRow dr)
        {
            StringBuilder queryBuilder = new StringBuilder();
            try
            {
                queryBuilder.Append(BuildKQLQueryString(Common.Constants.KQLProperties.KQL_PROPERTIES_LOCATION, "All Locations:DSD:" + dr["BUName"].ToString() + ":" + dr["RegionName"].ToString() + ":" + dr["AreaName"].ToString() + ":" + dr["BranchName"].ToString()));
                queryBuilder.Append(" AND ");
                queryBuilder.Append(" (( ");
                queryBuilder.Append(BuildKQLQueryString(Common.Constants.KQLProperties.KQL_PROPERTIES_CHAIN, "All Chains:" +dr["NationalChainName"].ToString() +":"+dr["RegionalChainName"].ToString()+":"+dr["LocalChainName"].ToString()));
                queryBuilder.Append(" OR ");
                queryBuilder.Append(" " + Common.Constants.KQLProperties.KQL_PROPERTIES_CHAIN + "=\"" + "Not Chain Specific" + "\"");
                queryBuilder.Append(" ) ");
                queryBuilder.Append(" OR ");
                queryBuilder.Append(" ( ");
                queryBuilder.Append(BuildKQLQueryString("OFDChannel", "All Channels:" + dr["SuperChannelName"].ToString() +":"+dr["ChannelName"].ToString()));
                queryBuilder.Append(" OR ");
                queryBuilder.Append("OFDChannel" + "=\"" + "Not Channel Specific" + "\"");
                queryBuilder.Append(" ) ");
                queryBuilder.Append(" ) ");
                queryBuilder.Append(" AND ");
                queryBuilder.Append(" ( ");
                queryBuilder.Append("  " + Common.Constants.KQLProperties.KQL_PROPERTIES_StartDate + "<=\"" + DateTime.Now.ToString("yyyy-MM-dd") + "\"");
                queryBuilder.Append(" AND " + Common.Constants.KQLProperties.KQL_PROPERTIES_ExpiredDate + ">=\"" + DateTime.Now.ToString("yyyy-MM-dd") + "\"");
                queryBuilder.Append(" ) ");
                queryBuilder.Append(" AND ");

                queryBuilder.Append(BuildKQLQueryString("OFDSystem", "All Systems/RTMs:PB:DSD"));
                queryBuilder.Append(" AND scope:BUManaged ");
            }
            catch (Exception ex)
            {
                DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "DSPG.Portal.BC.BAL.KQLQueryBuilder");
                throw (ex);   
            }
            DPSG.Portal.BC.Common.ExceptionHelper.LogException(queryBuilder.ToString(), "DSPG.Portal.BC.BAL.KQLQueryBuilder");
            return queryBuilder.ToString();
        }

        private static string BuildKQLQueryString(string PropertyName, string Value)
        {
            StringBuilder queryBuilder = new StringBuilder();
            string[] Values = Value.Split(':');
            string tmp = "";

            foreach (string value in Values)
            {
                if (tmp == "")
                    tmp = value;
                else
                    tmp = tmp + ":" + value;

                queryBuilder.Append(PropertyName + "=\"" + tmp + "\" OR ");
            }

            return "(" + queryBuilder.ToString().Substring(0, queryBuilder.Length - 3).Trim() + ")"; 
        }

    }
}