using DPSG.Portal.BC.Common;
using DPSG.Portal.BC.Services.DataContract;
using DPSG.Portal.BC.Services.DataContract.Store;
using DPSG.Portal.BC.Services.OperationContract.ServiceWrapper;
using System;
using System.Collections.Generic;
using System.Net;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using Newtonsoft.Json.Schema;
using System.Diagnostics.Contracts;

namespace DPSG.Portal.BC.Services.OperationContract
{
    [System.ServiceModel.Activation.AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class BCService : DPSG.Portal.BC.Services.OperationContract.Base, IBCService
    {
        // JSON Schema license key
        public readonly string JsonSchemaLicenseKey = Constants.JSONNET_SCHEMA_LICENSE;

        public BCService()
            : base()
        {

        }

        private static T GetHeader<T>(string name, string ns)
        {
            return OperationContext.Current.IncomingMessageHeaders.FindHeader(name, ns) > -1
                ? OperationContext.Current.IncomingMessageHeaders.GetHeader<T>(name, ns)
                : default(T);
        }

        public string DoWork()
        {
            if (OperationContext.Current.IncomingMessageHeaders.FindHeader("web-user", "ns") <= -1)
                throw new WebFaultException<string>("invalid Call", HttpStatusCode.BadRequest);

            //Capture Headers
            var userName = GetHeader<string>("web-user", "ns");
            var webNodeId = GetHeader<string>("web-saml-token", "ns");
            var webSessionId = GetHeader<Guid>("web-session-id", "ns");

            var s = string.Format("HeaderInfo: {0}, {1}, {2}",
                userName,
                webNodeId,
                webSessionId);

            //Log a unique session id
            var webSdmToken = new MessageHeader<Guid>(Guid.NewGuid());
            var webSessionIdHeader = webSdmToken.GetUntypedHeader("web-session-id", "ns");

            OperationContext.Current.OutgoingMessageHeaders.Add(webSessionIdHeader);

            return s;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetMarketingPrograms?mdate={lastModified}")]
        public DataContract.IPE.MarketingProgramResults GetMarketingPrograms(DateTime? lastModified)
        {
            var results = new DataContract.IPE.MarketingProgramResults();
            try
            {
                if (IsSessionValid)
                {
                    results = ServiceWrapper.BCMaster.GetMarketingPrograms(lastModified);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {

                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.EXCEPTION;
                results.StackTrace = BAL.Base.GetException(ex);
            }

            return results;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetIpeBottlers?type={type}&typeValue={typeValue}")]
        public DataContract.IPE.IpeBottlerDataResults GetIpeBottlers(string type, string typeValue)
        {
            var results = new DataContract.IPE.IpeBottlerDataResults();
            try
            {
                if (IsSessionValid)
                {
                    results = ServiceWrapper.BCMaster.GetIpeBottlers(type, typeValue);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {

                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.EXCEPTION;
                results.StackTrace = BAL.Base.GetException(ex);
            }

            return results;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetConfig")]
        public DataContract.Config.BCMYDAY.ConfigValuesResults GetConfig() 
        {
            var results = new DataContract.Config.BCMYDAY.ConfigValuesResults();
            try
            {
                if (IsSessionValid)
                {
                    results = ServiceWrapper.BCMaster.GetConfigurationValues();
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {

                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.EXCEPTION;
                results.StackTrace = BAL.Base.GetException(ex);
            }

            return results;

        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetIpeSurveyHistory?type={type}&typeValue={typeValue}&mdate={lastModified}")]
        public DataContract.IPE.SurveyHistoryResults GetIpeSurveyHistory(string type, string typeValue, DateTime? lastModified)
        {
            var results = new DataContract.IPE.SurveyHistoryResults();
            try
            {
                if (IsSessionValid)
                {
                    results = ServiceWrapper.BCMaster.GetIpeSurveyHistory(type, typeValue, lastModified);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {

                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.EXCEPTION;
                results.StackTrace = BAL.Base.GetException(ex);
            }

            return results;

        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetIpeSurvey?type={type}&typevalue={typeValue}&responderid={responderID}")]
        public DataContract.IPE.SurveyDataResults GetIpeSurvey(string type, string typeValue, int responderID)
        {
            var results = new DataContract.IPE.SurveyDataResults();
            try
            {
                if (IsSessionValid)
                {
                    results = ServiceWrapper.BCMaster.GetIpeSurvey(type, typeValue, responderID);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {

                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.ACCESS_DENIED;
                results.StackTrace = BAL.Base.GetException(ex);
            }

            return results;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetIPEMaster")]
        public DataContract.IPE.IpeMasterDataDetails GetIpeMaster()
        {
            var results = new DataContract.IPE.IpeMasterDataDetails();
            try
            {
                if (IsSessionValid)
                {
                    results = ServiceWrapper.BCMaster.GetIpeMaster();
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {

                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.ACCESS_DENIED;
                results.StackTrace = BAL.Base.GetException(ex);
            }

            return results;
        }

        [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/UploadIPESurveyEventResponses?appType={applicationType}")]
        public DataContract.IPE.EventResponseDataDetails UploadIpeSurveyEventResponses(string applicationType = null)
        {
            if (String.IsNullOrEmpty(applicationType)) { applicationType = ""; }
            //bool? isValidapp = Enum.IsDefined(typeof(Constants.IPE_SURVEY_EVENT_RESPONSE_APPLICAITON_TYPES), applicationType.ToUpper());

            var results = new DataContract.IPE.EventResponseDataDetails();
            string jsonData = "";

            try
            {
                //if (isValidapp == false)
                //{
                //    if (String.IsNullOrEmpty(applicationType)) { applicationType = "Null"; }
                //    throw new ArgumentException(String.Format("{0}, is not a valid Application Type parameter, Please correct and try again", applicationType), "");
                //}

                HTTPModule.BCModule bm = (HTTPModule.BCModule)System.Web.HttpContext.Current.ApplicationInstance.Modules["BCModule"];
                jsonData = bm.InputBody;
                bm.Dispose();

                if (IsSessionValid)
                {
                    License.RegisterLicense(JsonSchemaLicenseKey);
                    results = ServiceWrapper.BCMaster.UploadIpeSurveyEventResponses(jsonData, applicationType.ToUpper());
                    results.ErrorMessage = Constants.RESPONSE_STATUS_PASS_MESSAGE;
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {
                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.ERROR_MESSAGE_FAIL;
                results.StackTrace = BAL.Base.GetException(ex);
            }

            return results;

        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetBottlerHierarchy?mdate={lastModifiedDate}")]
        public DataContract.BottlerHierarchy.BotttlerHierarchyDataDetails GetBottlerHierarchy(DateTime? lastModifiedDate)
        {
            var results = new DataContract.BottlerHierarchy.BotttlerHierarchyDataDetails();
            try
            {
                if (IsSessionValid)
                {
                    results = ServiceWrapper.BCMaster.GetBottlerHierarchy(lastModifiedDate);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {

                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.ACCESS_DENIED;
                results.StackTrace = BAL.Base.GetException(ex);
            }

            return results;

        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetProgramsByRegionID?regionid={regionID}&mdate={lastModifiedDate}")]
        public DataContract.Programs.ProgramRegionDetails GetProgramsByRegionID(int regionID, DateTime? lastModifiedDate)
        {
            var results = new DataContract.Programs.ProgramRegionDetails();

            try
            {
                if (IsSessionValid)
                {
                    results = ServiceWrapper.BCMaster.GetProgramsByRegionID(regionID, lastModifiedDate);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {

                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.ACCESS_DENIED;
                results.StackTrace = BAL.Base.GetException(ex);
            }

            return results;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetProgramIDsByBottler?bottlerid={bottlerID}")]
        public DataContract.Programs.ProgramBottlerDetails GetProgramIDsByBottler(int bottlerID)
        {
            var results = new DataContract.Programs.ProgramBottlerDetails();
            try
            {
                if (IsSessionValid)
                {
                    results.BottlerID = bottlerID;
                    results.ProgramID = ServiceWrapper.BCMaster.GetProgramIDsByBottler(bottlerID);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {

                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.ACCESS_DENIED;
                results.StackTrace = BAL.Base.GetException(ex);
            }

            return results;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetProgramMaster?mdate={lastModifiedDate}")]
        public DataContract.Programs.ProgramMilestonesDetails GetProgramMaster(DateTime? lastModifiedDate)
        {
            var results = new DataContract.Programs.ProgramMilestonesDetails();
            try
            {
                if (IsSessionValid)
                {
                    results = ServiceWrapper.BCMaster.GetProgramMilestones(lastModifiedDate);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {
                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.ACCESS_DENIED;
                results.StackTrace = BAL.Base.GetException(ex);
            }

            return results;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetAssetDetail?routenumber={routeNumber}")]
        public DataContract.CDE.AssetDetails GetAssetDetail(string routeNumber)
        {
            var results = new DataContract.CDE.AssetDetails();
            try
            {
                if (IsSessionValid)
                {
                    results = ServiceWrapper.BCMaster.GetAssetDetail(routeNumber);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {
                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.ACCESS_DENIED;
                results.StackTrace = BAL.Base.GetException(ex);
            }

            return results;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetBottlers?mdate={LastModifiedDate}")]
        public List<DPSG.Portal.BC.Services.DataContract.Bottler> GetBottlers(DateTime? LastModifiedDate = null)
        {
            List<DPSG.Portal.BC.Services.DataContract.Bottler> _lstbottler = new List<DPSG.Portal.BC.Services.DataContract.Bottler>();
            try
            {
                //if (IsSessionValid)
                //{
                _lstbottler = BCMaster.GetBottlers(LastModifiedDate);
                return _lstbottler;
                //}
                //return _lstbottler;
            }
            catch (Exception ex)
            {
                DPSG.Portal.BC.Services.DataContract.Bottler bottler = new DPSG.Portal.BC.Services.DataContract.Bottler();
                //bottler.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                //bottler.ErrorMessage = Constants.ERROR_MESSAGE_FAIL;
                //bottler.StackTrace = DPSG.Portal.BC.BAL.Base.GetException(ex);
                _lstbottler.Add(bottler);
                return _lstbottler;
            }
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetCustomerHierarchyMaster?mdate={LastModifiedDate}")]
        public DPSG.Portal.BC.Services.DataContract.Chains GetCustomerHierarchyMaster(DateTime? LastModifiedDate = null)
        {
            DPSG.Portal.BC.Services.DataContract.Chains _chain = new DPSG.Portal.BC.Services.DataContract.Chains();
            try
            {
                if (IsSessionValid)
                {
                    _chain = DPSG.Portal.BC.Services.OperationContract.ServiceWrapper.BCMaster.GetCustomerHierarchyMaster(LastModifiedDate);
                    return _chain;
                }
                else
                {
                    _chain.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    _chain.ErrorMessage = Constants.ACCESS_DENIED;
                    return _chain;
                }
            }
            catch (Exception ex)
            {
                _chain.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                _chain.ErrorMessage = Constants.ERROR_MESSAGE_FAIL;
                _chain.StackTrace = DPSG.Portal.BC.BAL.Base.GetException(ex);
                return _chain;
            }
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetLOSMaster?mdate={LastModifiedDate}")]
        public DPSG.Portal.BC.Services.DataContract.LOS.LOSData GetLOSMaster(DateTime? LastModifiedDate = null)
        {
            DPSG.Portal.BC.Services.DataContract.LOS.LOSData _losdata = new DataContract.LOS.LOSData();

            try
            {
                if (IsSessionValid)
                {
                    _losdata = DPSG.Portal.BC.Services.OperationContract.ServiceWrapper.BCMaster.GetLOSMaster(LastModifiedDate);
                    return _losdata;
                }
                else
                {
                    _losdata.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    _losdata.ErrorMessage = Constants.ACCESS_DENIED;
                    return _losdata;
                }
            }
            catch (Exception ex)
            {
                _losdata.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                _losdata.ErrorMessage = Constants.ERROR_MESSAGE_FAIL;
                _losdata.StackTrace = DPSG.Portal.BC.BAL.Base.GetException(ex);
                return _losdata;
            }
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetProductHierarchy?mdate={lastModifiedDate}")]
        public DataContract.Product.ProductHierarchyDetails GetProductHierarchy(DateTime? lastModifiedDate = null)
        {
            var results = new DataContract.Product.ProductHierarchyDetails();

            try
            {
                if (IsSessionValid)
                {
                    results = ServiceWrapper.BCMaster.GetProductHierarchy(lastModifiedDate);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {
                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.ERROR_MESSAGE_FAIL;
                results.StackTrace = DPSG.Portal.BC.BAL.Base.GetException(ex);
            }
            return results;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetSalesMaster?mdate={lastModifiedDate}")]
        public DPSG.Portal.BC.Services.DataContract.SalesMaster.SalesMasterDataDetails GetSalesMaster(DateTime? lastModifiedDate = null)
        {
            var results = new DataContract.SalesMaster.SalesMasterDataDetails();

            try
            {
                if (IsSessionValid)
                {
                    results = ServiceWrapper.BCMaster.GetSalesMaster(lastModifiedDate);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {
                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.ERROR_MESSAGE_FAIL;
                results.StackTrace = DPSG.Portal.BC.BAL.Base.GetException(ex);
            }
            return results;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetStoreTieInHistoryByRegionID?regionid={RegionID}&mdate={LastModifiedDate}")]
        public DPSG.Portal.BC.Services.DataContract.Store.StoreData GetStoreTieInHistoryByRegionID(int RegionID, DateTime? LastModifiedDate = null)
        {
            DPSG.Portal.BC.Services.DataContract.Store.StoreData _storedata = new DataContract.Store.StoreData();
            try
            {
                if (IsSessionValid)
                {
                    _storedata = DPSG.Portal.BC.Services.OperationContract.ServiceWrapper.BCMaster.GetStoreTieInsHistoryByRegionID(RegionID, LastModifiedDate);
                    return _storedata;
                }
                else
                {
                    _storedata.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    _storedata.ErrorMessage = Constants.ACCESS_DENIED;
                    return _storedata;
                }
            }
            catch (Exception ex)
            {
                _storedata.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                _storedata.ErrorMessage = Constants.ERROR_MESSAGE_FAIL;
                _storedata.StackTrace = DPSG.Portal.BC.BAL.Base.GetException(ex);
                return _storedata;
            }
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetStores?botid={BottlerID}&mdate={LastModifiedDate}")]
        public DPSG.Portal.BC.Services.DataContract.Account.Bottler.AccountDetails GetStores(int bottlerID, DateTime? lastModifiedDate = null)
        {
            var results = new DataContract.Account.Bottler.AccountDetails();

            try
            {
                if (IsSessionValid)
                {
                    results = OperationContract.ServiceWrapper.BCMaster.GetStores(bottlerID, lastModifiedDate);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {
                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.EXCEPTION;
                results.StackTrace = BAL.Base.GetException(ex);
            }

            return results;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetStoresByRegionID?regionid={RegionID}&mdate={LastModifiedDate}")]
        public DPSG.Portal.BC.Services.DataContract.Account.Bottler.AccountDetails GetStoresByRegionID(int regionID, DateTime? lastModifiedDate = null)
        {
            var results = new DataContract.Account.Bottler.AccountDetails();

            try
            {
                if (IsSessionValid)
                {
                    results = OperationContract.ServiceWrapper.BCMaster.GetStoresByRegionID(regionID, lastModifiedDate);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {
                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.EXCEPTION;
                results.StackTrace = BAL.Base.GetException(ex);
            }

            return results;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetSalesHierarchyMaster?mdate={LastModifiedDate}")]
        public DPSG.Portal.BC.Services.DataContract.SalesHierarchy.SalesHierarchyData GetSalesHierarchyMaster(DateTime? LastModifiedDate = null)
        {
            DPSG.Portal.BC.Services.DataContract.SalesHierarchy.SalesHierarchyData _salesdata = new DataContract.SalesHierarchy.SalesHierarchyData();
            try
            {
                if (IsSessionValid)
                {
                    _salesdata = DPSG.Portal.BC.Services.OperationContract.ServiceWrapper.BCMaster.GetSalesHierarchyMaster(LastModifiedDate);
                    return _salesdata;
                }
                else
                {
                    return _salesdata;
                }
            }
            catch (Exception ex)
            {
                return _salesdata;
            }
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetSalesAccountabilityMaster?mdate={LastModifiedDate}")]
        public DPSG.Portal.BC.Services.DataContract.SalesAccountabilityHierarchy GetSalesAccountabilityMaster(DateTime? LastModifiedDate = null)
        {
            IsSessionValid = true;
            DPSG.Portal.BC.Services.DataContract.SalesAccountabilityHierarchy _salesaccount = new DPSG.Portal.BC.Services.DataContract.SalesAccountabilityHierarchy();
            try
            {
                if (IsSessionValid)
                {
                    _salesaccount.SalesAccount = DPSG.Portal.BC.Services.OperationContract.ServiceWrapper.BCMaster.GetSalesAccount(LastModifiedDate);
                    return _salesaccount;
                }
                else
                {
                    _salesaccount.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    _salesaccount.ErrorMessage = Constants.ACCESS_DENIED;
                    return _salesaccount;
                }
            }
            catch (Exception ex)
            {
                _salesaccount.ErrorMessage = ex.InnerException.Message;
                _salesaccount.StackTrace = ex.StackTrace;
                _salesaccount.ResponseStatus = 0;
                return _salesaccount;
            }
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/DownloadFile?fileUrl={url}")]
        public DPSG.Portal.BC.Services.DataContract.DownloadFile DownloadFile(string url)
        {
            DPSG.Portal.BC.Services.DataContract.DownloadFile _file = null;
            try
            {
                if (IsSessionValid)
                {
                    _file = DPSG.Portal.BC.Services.OperationContract.ServiceWrapper.BCMaster.GetFile(url);
                    // _file.ResponseStatus = Constants.RESPONSE_STATUS_PASS;
                }
                else
                {
                    _file.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    _file.ErrorMessage = Constants.ACCESS_DENIED;
                }
                return _file;
            }
            catch (Exception ex)
            {
                _file.ErrorMessage = ex.InnerException.Message;
                _file.StackTrace = ex.StackTrace;
                _file.ResponseStatus = 0;
                return _file;
            }
        }

        [WebInvoke(Method = "POST", BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, UriTemplate = "/UploadStoreData?Json={json}")]
        public DPSG.Portal.BC.Services.DataContract.Store.ConditionResponse UploadStoreData(string json = null)
        {

            DPSG.Portal.BC.Common.ExceptionHelper.LogException("UploadStoreData", "");
            DPSG.Portal.BC.Services.DataContract.Store.ConditionResponse _conditionResp = new ConditionResponse();
            try
            {
                try
                {
                    HTTPModule.BCModule bm = (HTTPModule.BCModule)System.Web.HttpContext.Current.ApplicationInstance.Modules["BCModule"];
                    json = bm.InputBody;

                }
                catch (Exception ex)
                {
                    BC.Common.ExceptionHelper.LogException("Exception " + ex.Message, "");
                }

                BC.Common.ExceptionHelper.LogException("InputJSON " + json, "");

                if (IsSessionValid)
                {
                    _conditionResp = DPSG.Portal.BC.Services.OperationContract.ServiceWrapper.StoreTieIn.UploadStoreData(this, json);
                    return _conditionResp;
                }
                else
                {
                    _conditionResp.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    _conditionResp.ErrorMessage = Constants.ACCESS_DENIED;
                    return _conditionResp;
                }
            }
            catch (Exception ex)
            {
                _conditionResp.ErrorMessage = ex.Message;
                if (ex.InnerException != null)
                    _conditionResp.ErrorMessage += "-->" + ex.InnerException.Message;
                _conditionResp.StackTrace = ex.StackTrace;
                _conditionResp.ResponseStatus = 0;
                BC.Common.ExceptionHelper.LogException(ex, "UploadStoreData");
                return _conditionResp;
            }
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetUploadStoreDataJSON")]
        public DPSG.Portal.BC.Services.DataContract.Store.UploadTieIn GetUploadStoreDataJSON()
        {
            DPSG.Portal.BC.Services.DataContract.Store.UploadTieIn t = new UploadTieIn();
            //t.StoreCondition = new Condition();
            //t.StoreCondition.StoreDisplays.Add(new Display());
            //t.StoreCondition.StoreDisplays[0].StoreDisplayDetails.Add(new DisplayDetails());
            //t.StoreCondition.StoreTieInRates.Add(new TieInRate());
            return t;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetPriorityQuestionsByRegionID?regionid={RegionID}&mdate={LastModifiedDate}")]
        public DataContract.Priority.PriorityQuestionsResults GetPriorityQuestionsByRegionID(int regionID, DateTime? lastModifiedDate = null)
        {
            var results = new DataContract.Priority.PriorityQuestionsResults();
            try
            {
                if (IsSessionValid)
                {
                    results = ServiceWrapper.BCMaster.GetPriorityQuestionsByRegionID(regionID, lastModifiedDate);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {
                DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "DPSG.Portal.BC.Services.OperationContract.BCService.GetPriorityQuestionsByRegionID");
                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.ERROR_MESSAGE_FAIL;
                results.StackTrace = DPSG.Portal.BC.BAL.Base.GetException(ex);
            }
            return results;
        }

        [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/UploadAdhocStoreAccount")]
        public DPSG.Portal.BC.Services.DataContract.Account.AdHoc.AdHocResponseDetails UploadAdhocStoreAccount()
        {
            var results = new DPSG.Portal.BC.Services.DataContract.Account.AdHoc.AdHocResponseDetails();
            string jsonData = "";
            try
            {
                HTTPModule.BCModule bm = (HTTPModule.BCModule)System.Web.HttpContext.Current.ApplicationInstance.Modules["BCModule"];
                jsonData = bm.InputBody;
                bm.Dispose();

                if (IsSessionValid)
                {
                    License.RegisterLicense(JsonSchemaLicenseKey);
                    results = ServiceWrapper.StoreTieIn.UploadAdhocStoreAccount(jsonData);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {
                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.ERROR_MESSAGE_FAIL;
                results.StackTrace = BAL.Base.GetException(ex);
            }

            return results;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetPromotionsByRegionID?regionid={RegionID}&mdate={LastModifiedDate}")]
        public DPSG.Portal.BC.Services.DataContract.Promotion.PromotionData GetPromotionsByRegionID(int RegionID, DateTime? LastModifiedDate = null)
        {

            var results = new DataContract.Promotion.PromotionData();
            try
            {
                if (IsSessionValid)
                {
                    results = ServiceWrapper.Promotion.GetPromotionsByRegionID(RegionID, LastModifiedDate);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {
                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.ERROR_MESSAGE_FAIL;
                results.StackTrace = DPSG.Portal.BC.BAL.Base.GetException(ex);
            }

            return results;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetPromotionsIDsByBottler?bottlerid={BottlerID}")]
        public DPSG.Portal.BC.Services.DataContract.Promotion.BottlerPromotion GetPromotionsIDsByBottler(int BottlerID)
        {
            DPSG.Portal.BC.Services.DataContract.Promotion.BottlerPromotion data;
            data = new DataContract.Promotion.BottlerPromotion();
            try
            {
                if (IsSessionValid)
                {
                    data.BottlerID = BottlerID;
                    data.PromotionID = ServiceWrapper.Promotion.GetPromotionsIDsByBottler(BottlerID);
                    return data;
                }
                else
                {
                    data.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    data.ErrorMessage = Constants.ACCESS_DENIED;
                    return data;
                }
            }
            catch (Exception ex)
            {
                data.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                data.ErrorMessage = Constants.ERROR_MESSAGE_FAIL;
                data.StackTrace = DPSG.Portal.BC.BAL.Base.GetException(ex);
                return data;
            }
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetPromotionsByRouteNumber?routenumber={RouteNumber}&mdate={LastModifiedDate}")]
        public DPSG.Portal.BC.Services.DataContract.Promotion.PromotionData GetPromotionsByRouteNumber(string routeNumber, DateTime? lastModifiedDate = null)
        {
            var results = new DataContract.Promotion.PromotionData();

            try
            {
                if (IsSessionValid)
                {
                    results = ServiceWrapper.Promotion.GetPromotionsByRouteID(routeNumber, lastModifiedDate);
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {
                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.EXCEPTION;
                results.StackTrace = BAL.Base.GetException(ex);
            }

            return results;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetDocumentsByRouteNumber?routenumber={RouteNumber}")]
        public DPSG.Portal.BC.Services.DataContract.Promotion.Documents GetDocumentsByRouteNumber(string RouteNumber)
        {
            DPSG.Portal.BC.Services.DataContract.Promotion.Documents _data = new DataContract.Promotion.Documents();
            try
            {
                if (IsSessionValid)
                {
                    _data = DPSG.Portal.BC.Services.OperationContract.ServiceWrapper.Promotion.GetDocumentsByRouteNumber(RouteNumber);
                    return _data;
                }
                else
                {
                    _data.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    _data.ErrorMessage = Constants.ACCESS_DENIED;
                    return _data;
                }
            }
            catch (Exception ex)
            {
                _data.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                _data.ErrorMessage = Constants.ERROR_MESSAGE_FAIL;
                _data.StackTrace = DPSG.Portal.BC.BAL.Base.GetException(ex);
                return _data;
            }
        }

        [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json, UriTemplate = "UploadStoreExecutionDetails")]
        public DPSG.Portal.BC.Services.DataContract.RetailExecution.StoreExecutionReponse UploadStoreExecutionDetails()
        {
            var results = new DataContract.RetailExecution.StoreExecutionReponse();
            string json = "";

            //BC.Common.ExceptionHelper.LogException("UploadStoreExecutionDetails", "");

            try
            {
                HTTPModule.BCModule bm = (HTTPModule.BCModule)System.Web.HttpContext.Current.ApplicationInstance.Modules["BCModule"];
                json = bm.InputBody;
                bm.Dispose();

                //BC.Common.ExceptionHelper.LogException("InputJSON " + json, "");

                if (IsSessionValid)
                {
                    int executionID = ServiceWrapper.RetailExecution.UploadStoreExecutionDetails(json);
                    results.ExecutionID = executionID;
                }
                else
                {
                    results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    results.ErrorMessage = Constants.ACCESS_DENIED;
                }
            }
            catch (Exception ex)
            {
                results.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                results.ErrorMessage = Constants.ACCESS_DENIED;
                results.StackTrace = BAL.Base.GetException(ex);
            }
            return results;

        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetStoreExecutionDetailsByRouteNumber?routenumber={RouteNumber}&mdate={LastModifiedDate}")]
        public DPSG.Portal.BC.Services.DataContract.RetailExecution.StoreExecutionData GetStoreExecutionDetailsByRouteNumber(string RouteNumber, DateTime? LastModifiedDate)
        {
            DPSG.Portal.BC.Services.DataContract.RetailExecution.StoreExecutionData _lstexecutiondatar = new DPSG.Portal.BC.Services.DataContract.RetailExecution.StoreExecutionData();

            try
            {
                if (IsSessionValid)
                {
                    _lstexecutiondatar = DPSG.Portal.BC.Services.OperationContract.ServiceWrapper.RetailExecution.GetStoreExecutionDetailsByRouteNumber(RouteNumber, LastModifiedDate);
                    _lstexecutiondatar.ResponseStatus = Constants.RESPONSE_STATUS_PASS;
                }
                else
                {
                    _lstexecutiondatar.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    _lstexecutiondatar.ErrorMessage = Constants.ACCESS_DENIED;
                    return _lstexecutiondatar;
                }
            }
            catch (Exception ex)
            {
                _lstexecutiondatar.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                _lstexecutiondatar.ErrorMessage = ex.Message;
                _lstexecutiondatar.StackTrace = ex.StackTrace;
            }
            return _lstexecutiondatar;
        }

        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "/GetOtherPromoMaster?mdate={LastModifiedDate}")]
        public DPSG.Portal.BC.Services.DataContract.OtherPromo.OtherPromoData GetOtherPromoMaster(DateTime? LastModifiedDate)
        {
            DPSG.Portal.BC.Services.DataContract.OtherPromo.OtherPromoData _lstexecutiondatar = new DPSG.Portal.BC.Services.DataContract.OtherPromo.OtherPromoData();
            try
            {
                if (IsSessionValid)
                {
                    _lstexecutiondatar = DPSG.Portal.BC.Services.OperationContract.ServiceWrapper.Promotion.GetOtherPromoMaster(LastModifiedDate);
                }
                else
                {
                    _lstexecutiondatar.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                    _lstexecutiondatar.ErrorMessage = Constants.ACCESS_DENIED;
                    return _lstexecutiondatar;
                }
            }
            catch (Exception ex)
            {
                _lstexecutiondatar.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
                _lstexecutiondatar.ErrorMessage = ex.Message;
                _lstexecutiondatar.StackTrace = ex.StackTrace;
            }
            return _lstexecutiondatar;
        }


    }
}
