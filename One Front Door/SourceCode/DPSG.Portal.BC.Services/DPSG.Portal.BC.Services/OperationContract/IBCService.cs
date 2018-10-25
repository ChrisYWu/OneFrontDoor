using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace DPSG.Portal.BC.Services.OperationContract
{
    [ServiceContract]
    public interface IBCService
    {
        [OperationContract]
        string DoWork();

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DataContract.Config.BCMYDAY.ConfigValuesResults GetConfig();

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DataContract.IPE.MarketingProgramResults GetMarketingPrograms(DateTime? lastModified);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DataContract.IPE.IpeBottlerDataResults GetIpeBottlers(string type, string typeValue);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DataContract.IPE.SurveyHistoryResults GetIpeSurveyHistory(string type, string typeValue, DateTime? lastModified);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DataContract.IPE.SurveyDataResults GetIpeSurvey(string type, string typeValue, int responderID);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DataContract.IPE.EventResponseDataDetails UploadIpeSurveyEventResponses(string applicationType);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DataContract.IPE.IpeMasterDataDetails GetIpeMaster();

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DataContract.BottlerHierarchy.BotttlerHierarchyDataDetails GetBottlerHierarchy(DateTime? lastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DataContract.Programs.ProgramRegionDetails GetProgramsByRegionID(int regionID, DateTime? lastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DataContract.Programs.ProgramMilestonesDetails GetProgramMaster(DateTime? lastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DataContract.Programs.ProgramBottlerDetails GetProgramIDsByBottler(int bottlerID);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DataContract.CDE.AssetDetails GetAssetDetail(string routeNumber);
        
        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        List<DPSG.Portal.BC.Services.DataContract.Bottler> GetBottlers(DateTime? LastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.Chains GetCustomerHierarchyMaster(DateTime? LastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.LOS.LOSData GetLOSMaster(DateTime? LastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DataContract.Product.ProductHierarchyDetails GetProductHierarchy(DateTime? lastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.Store.StoreData GetStoreTieInHistoryByRegionID(int RegionID, DateTime? LastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.Account.Bottler.AccountDetails GetStores(int bottlerID, DateTime? lastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.Account.Bottler.AccountDetails GetStoresByRegionID(int regionID, DateTime? lastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.SalesMaster.SalesMasterDataDetails GetSalesMaster(DateTime? lastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.SalesHierarchy.SalesHierarchyData GetSalesHierarchyMaster(DateTime? LastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.SalesAccountabilityHierarchy GetSalesAccountabilityMaster(DateTime? LastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.DownloadFile DownloadFile(string url);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.Store.ConditionResponse UploadStoreData(string json);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.Store.UploadTieIn GetUploadStoreDataJSON();

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.Promotion.PromotionData GetPromotionsByRegionID(int RegionID, DateTime? LastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.Promotion.BottlerPromotion GetPromotionsIDsByBottler(int BottlerID);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DataContract.Promotion.PromotionData GetPromotionsByRouteNumber(string routeNumber, DateTime? lastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.RetailExecution.StoreExecutionReponse UploadStoreExecutionDetails();

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.Account.AdHoc.AdHocResponseDetails UploadAdhocStoreAccount();

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.RetailExecution.StoreExecutionData GetStoreExecutionDetailsByRouteNumber(string RouteNumber, DateTime? LastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.OtherPromo.OtherPromoData GetOtherPromoMaster(DateTime? LastModifiedDate);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.Promotion.Documents GetDocumentsByRouteNumber(string RouteNumber);

        [OperationContract]
        [FaultContract(typeof(DPSG.Portal.BC.Services.DataContract.ExceptionErrorMsg))]
        DPSG.Portal.BC.Services.DataContract.Priority.PriorityQuestionsResults GetPriorityQuestionsByRegionID(int regionID, DateTime? lastModifiedDate);

    }
}
