using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DPSG.Portal.BC.BAL;
using DPSG.Portal.BC.Common;
using System.Collections;
using DPSG.Portal.BC.Model;
using System.Net;
using System.IO;
using DPSG.Portal.BC.Services.DataContract.Programs;
using DPSG.Portal.Framework.CommonUtils;
using System.Text;
using System.Diagnostics;
using System.ServiceModel;
using Newtonsoft.Json.Schema;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Data;

namespace DPSG.Portal.BC.Services.OperationContract.ServiceWrapper
{
    public class BCMaster
    {
        public static DataContract.Config.BCMYDAY.ConfigValuesResults GetConfigurationValues()
        {
            var obj = new BAL.Config();
            Types.Config.BCMYDAY.ConfigValuesResults data = obj.GetConfigurationValues();
            var results = new DataContract.Config.BCMYDAY.ConfigValuesResults();
            
            results.Config = data.Config;
            
            return results; 
        }

        public static DataContract.IPE.MarketingProgramResults GetMarketingPrograms(DateTime? lastModified)
        {
            var obj = new BAL.IPE();
            Types.IPE.Programs.MarketingProgramResults data = obj.GetMarketingPrograms(lastModified);
            var results = new DataContract.IPE.MarketingProgramResults();
            
            results.MarketingProgramAttachments = data.MarketingProgramAttachments;
            results.MarketingProgramBrands = data.MarketingProgramBrands;
            results.MarketingProgramPackages = data.MarketingProgramPackages;
            results.MarketingPrograms = data.MarketingPrograms;
            
            return results;
        }

        public static DataContract.IPE.IpeBottlerDataResults GetIpeBottlers(string type, string typeValue)
        {
            var obj = new BAL.IPE();
            Types.IPE.Bottler.IpeBottlerDataResults data = obj.GetIpeBottlers(type, typeValue);
            var results = new DataContract.IPE.IpeBottlerDataResults();

            results.IpeBottlers = data.IpeBottlers;

            return results; 
        }

        public static DataContract.IPE.SurveyHistoryResults GetIpeSurveyHistory(string type, string typeValue, DateTime? lastModified)
        {
            var obj = new BAL.IPE();
            Types.IPE.SurveyData.SurveyHistoryResults data = obj.GetIpeSurveyHistory(type, typeValue, lastModified);
            var results = new DataContract.IPE.SurveyHistoryResults();

            results.EventResponseHistory = data.EventResponseHistory;

            return results;
        }
        
        public static DataContract.IPE.SurveyDataResults GetIpeSurvey(string type, string typeValue, int responderID)
        {
            var obj = new BAL.IPE();
            Types.IPE.SurveyData.SurveyDataResults data = obj.GetIpeSurvey(type, typeValue, responderID);
            var results = new DataContract.IPE.SurveyDataResults();

            results.EventQuestionDates = data.EventQuestionDates;
            results.EventBottlerPhase = data.EventBottlerPhase;

            return results;
        }

        public static DataContract.IPE.EventResponseDataDetails UploadIpeSurveyEventResponses(string json, string applicationType)
        {
            JSchemaGenerator generator = new JSchemaGenerator();
            JSchema schema = generator.Generate(typeof(Types.IPE.ResponseData.EventResponseSchemaValidate));
            

            IList<string> messages = new List<string>();
            JsonSerializer jsonSerializer = new JsonSerializer();

            using (JSchemaValidatingReader jschemaValidatingReader = new JSchemaValidatingReader(new JsonTextReader(new StringReader(json))))
            {
                jschemaValidatingReader.Schema = schema;
                jschemaValidatingReader.ValidationEventHandler += (sender, args) => messages.Add(args.Message);  //{ Console.WriteLine(args.Message); };
                DataSet dataSet = jsonSerializer.Deserialize<DataSet>(jschemaValidatingReader);
                DataTable dataTable = dataSet.Tables["EventResponseData"];

                //foreach (DataRow row in dataTable.Rows) { var x = row["EventResponseDate"].ToString(); }
                
                bool? isValid = (messages.Count == 0);

                if (isValid == false)
                {
                    throw new System.ArgumentException(string.Join(",", messages).ToString());
                }

                var obj = new BAL.IPE();
                Types.IPE.ResponseData.EventResponseDataDetails data = obj.UploadIpeSurveyEventResponses(dataTable,applicationType);
                var results = new DataContract.IPE.EventResponseDataDetails();
                // results will be from try/catch/error/succuess code from SQL
                results.EventResponseData = data.EventResponseData;
                return results;
            }

        }

        public static DataContract.IPE.IpeMasterDataDetails GetIpeMaster()
        {
            var obj = new BAL.IPE();
            Types.IPE.MasterData.IpeMasterDataDetails data = obj.GetIpeMaster();
            var results = new DataContract.IPE.IpeMasterDataDetails();

            results.IpeMasterData = new Types.IPE.MasterData.IpeMasterData();
            results.IpeMasterData.Questions = data.IpeMasterData.Questions;
            results.IpeMasterData.Phase = data.IpeMasterData.Phase;
            results.IpeMasterData.Responder = data.IpeMasterData.Responder;
            results.IpeMasterData.QuestionResponder = data.IpeMasterData.QuestionResponder;
            results.IpeMasterData.ResponseType = data.IpeMasterData.ResponseType;
            results.IpeMasterData.ResponseTypeValues = data.IpeMasterData.ResponseTypeValues;
            results.IpeMasterData.EventType = data.IpeMasterData.EventType;
            results.IpeMasterData.EventPriority = data.IpeMasterData.EventPriority;

            return results;
        }

        public static DataContract.BottlerHierarchy.BotttlerHierarchyDataDetails GetBottlerHierarchy(DateTime? lastModifiedDate)
        {
            var obj = new BAL.Bottler();
            Types.BottlerHierarchy.BotttlerHierarchyDataDetails data = obj.GetBottlerHierarchyDetails(lastModifiedDate);
            var results = new DataContract.BottlerHierarchy.BotttlerHierarchyDataDetails();
            
            results.BottlerHierarchyMaster = new Types.BottlerHierarchy.Contract.BottlerHiearchyData();
            results.BottlerHierarchyMaster.EBH1 = data.BottlerHierarchyMaster.EBH1;
            results.BottlerHierarchyMaster.EBH2 = data.BottlerHierarchyMaster.EBH2;
            results.BottlerHierarchyMaster.EBH3 = data.BottlerHierarchyMaster.EBH3;
            results.BottlerHierarchyMaster.EBH4 = data.BottlerHierarchyMaster.EBH4;

            return results; 
        }
        
        public static DataContract.Programs.ProgramRegionDetails GetProgramsByRegionID(int regionID, DateTime? lastModifiedDate)
        {
            var obj = new BAL.Programs();
            Types.Programs.ProgramRegionDetails data = obj.GetProgramsByRegionID(regionID, lastModifiedDate);
           
            var results = new DataContract.Programs.ProgramRegionDetails();

            results.AccountPrograms = data.AccountPrograms;
            results.ProgramAccounts = data.ProgramAccounts;
            results.ProgramAttachments = data.ProgramAttachments;
            results.ProgramBrands = data.ProgramBrands;
            results.ProgramPackages = data.ProgramPackages;

            results.MarketingPrograms = data.MarketingPrograms;
            results.MarketingProgramAccounts = data.MarketingProgramAccounts;
            results.MarketingProgramAttachments = data.MarketingProgramAttachments;
            results.MarketingProgramBrands = data.MarketingProgramBrands;
            results.MarketingProgramPackages = data.MarketingProgramPackages;
            
            return results;
        }

        public static List<int> GetProgramIDsByBottler(int bottlerID)
        {

            var obj = new BAL.Programs();
            var results = new List<int>();
            results = obj.GetProgramIDsByBottler(bottlerID);
            return results;
            
        }

        public static DataContract.Programs.ProgramMilestonesDetails GetProgramMilestones(DateTime? lastModifiedDate)
        {

            var obj = new BAL.Programs();
            Types.Programs.ProgramMilestoneDetails data = obj.GetProgramMilestones(lastModifiedDate);
           
            var results = new DataContract.Programs.ProgramMilestonesDetails();
            results.MilestoneMaster = data.MilestoneMaster;

            return results;
        }

        public static DataContract.CDE.AssetDetails GetAssetDetail(string routeNumber)
        {
            var obj = new BAL.CDE();
            Types.CDE.AssetDetails data = obj.GetAssetDetail(routeNumber);

            var results = new DataContract.CDE.AssetDetails();
            results.Asset = data.Asset;

            return results;
        }
        
        public static List<DPSG.Portal.BC.Services.DataContract.Bottler> GetBottlers(DateTime? LastModifiedDate)
        {
            DPSG.Portal.BC.BAL.Bottler objBottler = new BAL.Bottler();
            List<DPSG.Portal.BC.Services.DataContract.Bottler> _lstbottler = null;

            _lstbottler = objBottler.GetBottler(LastModifiedDate).Select(i => new DataContract.Bottler
             {
                 BottlerID = i.BottlerID,
                 SAPBottlerID = Convert.ToString(i.BCBottlerID),
                 BottlerName = i.BottlerName,
                 ChannelID = i.ChannelID,
                 StatusID = i.GlobalStatusID,
                 BCRegionID = i.BCRegionID,
                 Address = i.Address,
                 City = i.City,
                 County = i.County,
                 State = i.State,
                 PostalCode = i.PostalCode,
                 Country = i.Country,
                 Email = i.Email,
                 PhoneNumber = i.PhoneNumber,
                 GeoLatitude = i.Latitude,
                 GeoLongitude = i.Longitude,
                 //ModifydDate = Helper.ReturnUTCDateTime(i.LastModified),
                 IsActive = i.Active

             }).ToList();

            return _lstbottler;
        }

        public static DPSG.Portal.BC.Services.DataContract.Chains GetCustomerHierarchyMaster(DateTime? LastModifiedDate)
        {
            BAL.Chain objChain = new Chain();
            ArrayList _arrListCustomerHierarchy = objChain.ReturnCustomerHierarchyDetails(LastModifiedDate);

            List<Model.NationalChain> _lstmodelnationalchain = _arrListCustomerHierarchy != null && _arrListCustomerHierarchy.Count >= 1 ? _arrListCustomerHierarchy[Constants.NATIONAL_CHAIN_INDEX] as List<Model.NationalChain> : new List<Model.NationalChain>();
            List<Model.RegionalChain> _lstmodelregionalchain = _arrListCustomerHierarchy != null && _arrListCustomerHierarchy.Count >= 2 ? _arrListCustomerHierarchy[Constants.REGIONAL_CHAIN_INDEX] as List<Model.RegionalChain> : new List<Model.RegionalChain>();
            List<Model.LocalChain> _lstmodellocalchain = _arrListCustomerHierarchy != null && _arrListCustomerHierarchy.Count >= 3 ? _arrListCustomerHierarchy[Constants.LOCAL_CHAIN_INDEX] as List<Model.LocalChain> : new List<Model.LocalChain>();
            List<Model.Channel> _lstmodelchannel = _arrListCustomerHierarchy != null && _arrListCustomerHierarchy.Count >= 4 ? _arrListCustomerHierarchy[Constants.CHANNEL_INDEX] as List<Model.Channel> : new List<Model.Channel>();
            List<Model.SuperChannel> _lstmodelsuperchannel = _arrListCustomerHierarchy != null && _arrListCustomerHierarchy.Count >= 5 ? _arrListCustomerHierarchy[Constants.SUPER_CHANNEL_INDEX] as List<Model.SuperChannel> : new List<Model.SuperChannel>();
            


            List<DPSG.Portal.BC.Services.DataContract.NationalChain> _lstnationalchain =
            _lstmodelnationalchain.Select
            (i => new DPSG.Portal.BC.Services.DataContract.NationalChain
            {
                SAPNationalChainID = i.NationalChainID,
                NationalChainID = i.NationalChainID,
                NationalChainName = i.NationalChainName
            }).ToList();


            List<DPSG.Portal.BC.Services.DataContract.RegionalChain> _lstregionalchain =
            _lstmodelregionalchain.Select
            (i => new DPSG.Portal.BC.Services.DataContract.RegionalChain
            {
                SAPRegionalChainID = i.SAPRegionalChainID,
                NationalChainID = i.NationalChainID,
                RegionalChainName = i.RegionalChainName,
                RegionalChainID = i.RegionalChainID
            }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.LocalChain> _lstlocalchain =
            _lstmodellocalchain.Select
            (i => new DPSG.Portal.BC.Services.DataContract.LocalChain
            {
                SAPLocalChainID = i.SAPLocalChainID,
                RegionalChainID = i.RegionalChainID,
                LocalChainID = i.LocalChainID,
                LocalChainName = i.LocalChainName
            }).ToList();


            List<DPSG.Portal.BC.Services.DataContract.Channel> _lstchain =
           _lstmodelchannel.Select
           (i => new DPSG.Portal.BC.Services.DataContract.Channel
           {
               ChannelID = i.ChannelID,
               SuperChannelID = i.SuperChannelID,
               SAPChannelID = i.SAPChannelID,
               ChannelName = i.ChannelName
           }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.SuperChannel> _lstsuperchain =
          _lstmodelsuperchannel.Select
          (i => new DPSG.Portal.BC.Services.DataContract.SuperChannel
          {
              SuperChannelID = i.SuperChannelID,
              SAPSuperChannelID = i.SAPSuperChannelID,
              SuperChannelName = i.SuperChannelName

          }).ToList();

            DPSG.Portal.BC.Services.DataContract.Chains chain = new DataContract.Chains();

            chain.NationalChains = _lstnationalchain;
            chain.RegionalChains = _lstregionalchain;
            chain.LocalChains = _lstlocalchain;
            chain.Channels = _lstchain;
            chain.SuperChannels = _lstsuperchain;
            chain.ChainGroups = _arrListCustomerHierarchy[Constants.CHAIN_GROUP_INDEX] as List<Types.ChainGroup>;

            return chain;
        }

        public static DPSG.Portal.BC.Services.DataContract.LOS.LOSData GetLOSMaster(DateTime? LastModifiedDate)
        {
            BAL.LOS objLOS = new BAL.LOS();
            ArrayList _arrLOSdata = objLOS.GetLOSMasterData(LastModifiedDate);

            List<Types.LOS> _lstmodelLOS = _arrLOSdata != null && _arrLOSdata.Count >= 1 ? _arrLOSdata[Constants.LOS_INDEX] as List<Types.LOS> : new List<Types.LOS>();
            List<Model.LOSDisplayLocation> _lstmodeldisplaylocation = _arrLOSdata != null && _arrLOSdata.Count >= 2 ? _arrLOSdata[Constants.LOSDISPLAYLOCATION_INDEX] as List<Model.LOSDisplayLocation> : new List<Model.LOSDisplayLocation>();
            List<Model.TieInReason> _lstmodeltieinreason = _arrLOSdata != null && _arrLOSdata.Count >= 3 ? _arrLOSdata[Constants.TIEINREASONMASTER_INDEX] as List<Model.TieInReason> : new List<Model.TieInReason>();
            List<Model.DisplayTypeMaster> _lstmodeldisplaymaster = _arrLOSdata != null && _arrLOSdata.Count >= 4 ? _arrLOSdata[Constants.DISPLAYTYPEMASTER_INDEX] as List<Model.DisplayTypeMaster> : new List<Model.DisplayTypeMaster>();
            List<Types.SystemBrand> _lstmodelsystembrand = _arrLOSdata != null && _arrLOSdata.Count >= 5 ? _arrLOSdata[Constants.SYSTEMBRAND_INDEX] as List<Types.SystemBrand> : new List<Types.SystemBrand>();
            List<Model.SystemPackage> _lstmodelsystempackage = _arrLOSdata != null && _arrLOSdata.Count >= 6 ? _arrLOSdata[Constants.SYSTEMPACKAGE_INDEX] as List<Model.SystemPackage> : new List<Model.SystemPackage>();
            List<Types.SystemPackageBrand> _lstmodelsystempackagebrand = _arrLOSdata != null && _arrLOSdata.Count >= 7 ? _arrLOSdata[Constants.SYSTEMPACKAGEBRAND_INDEX] as List<Types.SystemPackageBrand> : new List<Types.SystemPackageBrand>();
            List<Model.Config> _lstmodelconfig = _arrLOSdata != null && _arrLOSdata.Count >= 8 ? _arrLOSdata[Constants.CONFIG_INDEX] as List<Model.Config> : new List<Model.Config>();
            List<Model.DisplayLocation> _lstLocations = _arrLOSdata != null && _arrLOSdata.Count >= 9 ? _arrLOSdata[Constants.DISPLAYLOCATION_INDEX] as List<Model.DisplayLocation> : new List<Model.DisplayLocation>();
            List<Types.SystemTradeMark> _lstsystemtrademark = _arrLOSdata != null && _arrLOSdata.Count >= 9 ? _arrLOSdata[Constants.SYSTEMTRADEMARK_INDEX] as List<Types.SystemTradeMark> : new List<Types.SystemTradeMark>();
            List<Types.SystemCompetitionBrand> _lstsystemcompetionbrand = _arrLOSdata != null && _arrLOSdata.Count >= 10 ? _arrLOSdata[Constants.SYSTEMCOMPETITIONBRAND_INDEX] as List<Types.SystemCompetitionBrand> : new List<Types.SystemCompetitionBrand>();
            List<Types.BCPromotionExecutionStatus> _lstsystempromotionexecutionstatus = _arrLOSdata != null && _arrLOSdata.Count >= 11 ? _arrLOSdata[Constants.PROMOTIONEXECUTIONSTATUS_INDEX] as List<Types.BCPromotionExecutionStatus> : new List<Types.BCPromotionExecutionStatus>();

            List<DPSG.Portal.BC.Services.DataContract.LOS.LOS> _lstlos =
                _lstmodelLOS.Select(i => new DPSG.Portal.BC.Services.DataContract.LOS.LOS
                {
                    LOSID = i.LOSID,
                    ChannelID = i.ChannelID,
                    LocalChainID = i.LocalChainID,
                    // StoreID = i.StoreID,
                    ImageURL = i.ImageURL,
                    //ModifydDate = Helper.ReturnUTCDateTime(i.ModifiedDate),
                    IsActive = i.IsActive
                }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.LOS.LOSDisplayLocation> _lstlosdisplaylocation =
              _lstmodeldisplaylocation.Select(i => new DPSG.Portal.BC.Services.DataContract.LOS.LOSDisplayLocation
              {
                  LOSID = i.LOSID,
                  DisplayLocationID = i.DisplayLocationID,
                  DisplaySequence = i.DisplaySequence,
                  GridX = i.GridX,
                  GridY = i.GridY,
                  //ModifydDate = Helper.ReturnUTCDateTime(i.ModifiedDate),
                  IsActive = i.IsActive == 1 ? true : false
              }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.LOS.TieInReasonMaster> _lsttieinreasonmaster =
             _lstmodeltieinreason.Select(i => new DPSG.Portal.BC.Services.DataContract.LOS.TieInReasonMaster
             {
                 TieReasonId = i.TieReasonId,
                 Description = i.Description,
                 //ModifydDate = Helper.ReturnUTCDateTime(i.ModifiedDate),
                 IsActive = i.IsActive
             }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.LOS.DisplayTypeMaster> _lsttdisplaytypemaster =
             _lstmodeldisplaymaster.Select(i => new DPSG.Portal.BC.Services.DataContract.LOS.DisplayTypeMaster
             {
                 DisplayTypeId = i.DisplayTypeId,
                 Description = i.Description,
                 //ModifydDate = Helper.ReturnUTCDateTime(i.ModifiedDate),
                 IsActive = i.IsActive
             }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.LOS.SystemBrand> _lsttsystembrand =
             _lstmodelsystembrand.Select(i => new DPSG.Portal.BC.Services.DataContract.LOS.SystemBrand
             {
                 SystemBrandID = i.SystemBrandID,
                 BrandName = i.ExternalBrandName,
                 BrandID = i.BrandID,
                 //TradeMarkID = 0,
                 TieInType = i.TieInType,
                 BrandLevelSort = i.BrandLevelSort,
                 ImageURL = i.ImageURL,
                 IsActive = i.IsActive,
                 SystemTradeMarkID = i.SystemTradeMarkID
             }).ToList();


            List<DPSG.Portal.BC.Services.DataContract.LOS.SystemPackage> _lsttsystempackage =
             _lstmodelsystempackage.Select(i => new DPSG.Portal.BC.Services.DataContract.LOS.SystemPackage
             {
                 SystemPackageID = i.SystemPackageID,
                 BCNodeID = i.BCSystemID,
                 //PackageName = i.PackageName,
                 SAPContainerType = i.ContainerType.Split('|')[0],
                 PackageConfigID = i.PackageConfigID,
                 SAPPackageConfig = i.ContainerType.Split('|')[1],
                 SDMNodeID = i.BCSystemID,
                 PackageLevelSort = i.PackageLevelSort,
                 PackageName = i.PackageName,
                 IsActive = i.IsActive
             }).ToList();


            List<DPSG.Portal.BC.Services.DataContract.LOS.SystemPackageBrand> _lsttsystempackagebrand =
             _lstmodelsystempackagebrand.Select(i => new DPSG.Portal.BC.Services.DataContract.LOS.SystemPackageBrand
             {
                 SystemBrandID = i.SystemBrandID,
                 SystemPackageID = i.SystemPackageID,
                 IsActive = i.IsActive
             }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.LOS.Config> _lstconfig =
            _lstmodelconfig.Select(i => new DPSG.Portal.BC.Services.DataContract.LOS.Config
            {
                ConfigID = i.ConfigID,
                Key = i.Key,
                Value = i.Value,
                Description = i.Description,
                //ModifydDate = Helper.ReturnUTCDateTime(i.ModifiedDate)

            }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.LOS.DisplayLocation> _lstdisplaylocation =
            _lstLocations.Select(i => new DPSG.Portal.BC.Services.DataContract.LOS.DisplayLocation
            {
                DisplayLocationID = i.DisplayLocationID,
                DisplayLocationName = i.DisplayLocationName

            }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.LOS.SystemTrademarkMaster> _lstsystrademark =
            _lstsystemtrademark.Select(i => new DPSG.Portal.BC.Services.DataContract.LOS.SystemTrademarkMaster
            {
                TrademarkName = Convert.ToString(i.ExternalTradeMarkName),
                SysTrademarkId = Convert.ToInt32(i.SystemTradeMarkID),
                TrademarkLvlSort = Convert.ToInt32(i.TradeMarkLevelSort),
                TrademarkID = i.TradeMarkID,
                ImageURL = i.ImageURL,
                IsActive = i.IsActive

            }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.LOS.SystemCompetitionBrand> _lstsyscompetitionbrand =
            _lstsystemcompetionbrand.Select(i => new DPSG.Portal.BC.Services.DataContract.LOS.SystemCompetitionBrand
            {
                NodeID = i.NodeID,
                SystemBrandID = i.SystemBrandID,
                SystemDPSTrademarkID = i.SystemDPSTrademarkID,
                IsActive = i.Active
            }).ToList();


            List<DPSG.Portal.BC.Services.DataContract.LOS.BCPromotionExecutionStatus> _lstsyspromotionexecutionstatus =
            _lstsystempromotionexecutionstatus.Select(i => new DPSG.Portal.BC.Services.DataContract.LOS.BCPromotionExecutionStatus
            {
                StatusID = i.StatusID,
                StatusDesc = i.StatusDesc,
                IsActive = i.Active
            }).ToList();

            DPSG.Portal.BC.Services.DataContract.LOS.LOSData los = new DataContract.LOS.LOSData();

            los.LOS = _lstlos;
            los.LOSDisplayLocations = _lstlosdisplaylocation;
            los.TieInReasons = _lsttieinreasonmaster;
            los.DisplayTypes = _lsttdisplaytypemaster;
            los.SystemBrands = _lsttsystembrand;
            los.SystemPackages = _lsttsystempackage;
            los.SystemPackageBrands = _lsttsystempackagebrand;
            los.Config = _lstconfig;
            los.DisplayLocations = _lstdisplaylocation;
            los.SystemTrademark = _lstsystrademark;
            los.SystemCompetitionBrands = _lstsyscompetitionbrand;
            los.PromotionExecutionStatusMaster = _lstsyspromotionexecutionstatus;

            return (los);
        }

        public static DataContract.Product.ProductHierarchyDetails GetProductHierarchy(DateTime? lastModifiedDate)
        {
            var obj = new BAL.Product();
            Types.Product.ProductHierarchyDetails data = obj.GetProductHierarchyDetails(lastModifiedDate);
            var results = new DataContract.Product.ProductHierarchyDetails();
            results.Brands = data.Brands;
            results.Packages = data.Packages;
            results.TradeMarks = data.TradeMarks;

            return results;
        }

        public static DataContract.Priority.PriorityQuestionsResults GetPriorityQuestionsByRegionID(int regionID, DateTime? lastModifiedDate)
        {
            if (lastModifiedDate == null)
            {
                lastModifiedDate = new DateTime(2000, 1, 1);
            }

            var obj = new BAL.Priority();
            Types.Priority.PriorityQuestionsResults data = obj.GetPriorityQuestionsByRegionID(regionID, lastModifiedDate);
            var results = new DataContract.Priority.PriorityQuestionsResults();
            results.PriorityBrands = data.PriorityBrands;
            results.PriorityCustomers = data.PriorityCustomers;
            results.PriorityQuestions = data.PriorityQuestions;

            return results;
        }

        public static DPSG.Portal.BC.Services.DataContract.Store.StoreData GetStoreTieInsHistoryByRegionID(int RegionID, DateTime? LastModifiedDate)
        {
            BAL.Store _objStore = new BAL.Store();
            // int storetieinhistory = Convert.ToInt32(_objStore.RetrunValueByKey(Constants.STORE_TIEIN_HISTORY));

            ArrayList _arrStoredata = _objStore.ReturnStoreTieInsHistoryByRegionID(RegionID, LastModifiedDate);
            // ArrayList _arrStoredata = _objStore.ReturnStoreTieInsHistory(storetieinhistory);

            List<Model.StoreCondition> _lststoreCondition = _arrStoredata != null && _arrStoredata.Count >= 1 ? _arrStoredata[Constants.STORECONDITION_INDEX] as List<Model.StoreCondition> : new List<Model.StoreCondition>();
            List<Model.StoreConditionDisplay> _lststoreConditionDisp = _arrStoredata != null && _arrStoredata.Count >= 2 ? _arrStoredata[Constants.STORECONDITION_DISPLAY_INDEX] as List<Model.StoreConditionDisplay> : new List<Model.StoreConditionDisplay>();
            List<Model.StoreConditionDisplayDetail> _lststoreConditionDispDetail = _arrStoredata != null && _arrStoredata.Count >= 3 ? _arrStoredata[Constants.STORECONDITION_DISPLAY_DET_INDEX] as List<Model.StoreConditionDisplayDetail> : new List<Model.StoreConditionDisplayDetail>();
            List<Model.StoreTieInRate> _lststoreTieInRate = _arrStoredata != null && _arrStoredata.Count >= 4 ? _arrStoredata[Constants.STORE_TIE_IN_RATE_INDEX] as List<Model.StoreTieInRate> : new List<Model.StoreTieInRate>();
            List<Types.BCPromotionExecution> _lstbcpromotionexecution = _arrStoredata != null && _arrStoredata.Count >= 5 ? _arrStoredata[Constants.STORE_BC_PROMOTION_EXECUTION_INDEX] as List<Types.BCPromotionExecution> : new List<Types.BCPromotionExecution>();
            List<Types.StoreNote> _lststorenote = _arrStoredata != null && _arrStoredata.Count >= 6 ? _arrStoredata[Constants.STORE_NOTES_INDEX] as List<Types.StoreNote> : new List<Types.StoreNote>();
            List<Types.PriorityAnswer> _lstpriorityanswer = _arrStoredata != null && _arrStoredata.Count >= 7 ? _arrStoredata[Constants.STORE_PRIORITY_STATUS_INDEX] as List<Types.PriorityAnswer> : new List<Types.PriorityAnswer>();

            List<DPSG.Portal.BC.Services.DataContract.Store.Condition> _lstCondition =
                _lststoreCondition.Select(i => new DPSG.Portal.BC.Services.DataContract.Store.Condition
                {
                    ConditionID = i.StoreConditionID,
                    StoreID = i.AccountId,
                    SDMNodeID = i.BCSystemID,
                    BottlerID = i.BottlerID,
                    GSN = i.GSN,
                    ConditionDate = Helper.ReturnUTCDateTime(i.ConditionDate),
                    Longitude = i.Longitude,
                    Latitude = i.Latitude,
                    //ModifydDate = Helper.ReturnUTCDateTime(i.ModifiedDate),
                    IsActive = i.IsActive,
                    Name = i.Name,
                    IsDeleted = false


                }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.Store.Display> _lstDisplay =
           _lststoreConditionDisp.Select(j => new DPSG.Portal.BC.Services.DataContract.Store.Display
           {
               DisplayID = j.StoreConditionDisplayID,
               ConditionID = j.StoreConditionID,
               DisplayLocationID = j.DisplayLocationID,
               PromotionID = j.PromotionID,
               DisplayLocationNote = j.DisplayLocationNote,
               OtherNote = j.OtherNote,
               ImageURL = j.DisplayImageURL,
               GridX = j.GridX,
               GridY = j.GridY,
               DisplayTypeID = j.DisplayTypeID,
               //ModifydDate = Helper.ReturnUTCDateTime(i.ModifiedDate),
               IsActive = j.IsActive,
               IsDeleted = false,
               ReasonID = j.ReasonID.ToString(),
               IsFairShare = Convert.ToInt32(j.IsFairShare),
               DPTieInFlag = (j.DPTieInFlag)
           }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.Store.DisplayDetails> _lstDisplayDetails =
              _lststoreConditionDispDetail.Select(k => new DPSG.Portal.BC.Services.DataContract.Store.DisplayDetails
              {
                  StoreConditionDisplayID = k.StoreConditionDisplayID,
                  SystemPackageID = k.SystemPackageID,
                  SystemBrandID = k.SystemBrandID,
                  IsActive = k.IsActive,
                  IsDeleted = false,
                  ConditionID = _lststoreConditionDisp.Where(l => l.StoreConditionDisplayID == k.StoreConditionDisplayID).FirstOrDefault().StoreConditionID

              }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.Store.TieInRate> _lstTieInRate =
             _lststoreTieInRate.Select(j => new DPSG.Portal.BC.Services.DataContract.Store.TieInRate
             {
                 ConditionID = j.StoreConditionID,
                 SystemBrandId = j.SystemBrandId,
                 SysTieInRate = j.TieInRate,
                 IsActive = j.IsActive,
                 IsDeleted = false
             }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.Store.BCPromotionExecution> _lstBCPromotionexecution =
                _lstbcpromotionexecution.Select(j => new DPSG.Portal.BC.Services.DataContract.Store.BCPromotionExecution
                {
                    ConditionID = j.StoreConditionID,
                    PromotionExecutionStatusID = j.PromotionExecutionStatusID,
                    PromotionID = j.PromotionID,
                    StoreConditionDisplayID = j.StoreConditionDisplayID,
                    PromotionExecutionID = j.PromotionExecutionID,
                    Comments = j.Comments
                }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.Store.StoreNote> _lstStoreNote =
                _lststorenote.Select(j => new DPSG.Portal.BC.Services.DataContract.Store.StoreNote
                {
                    ConditionID = j.StoreConditionID,
                    ImageName = j.ImageName,
                    ImageURL = j.ImageURL,
                    NoteDescription = j.Note,
                    NoteID = j.StoreConditionNoteID
                }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.Store.PriorityAnswer> _lstPriorityAnswer =
                _lstpriorityanswer.Select(j => new DPSG.Portal.BC.Services.DataContract.Store.PriorityAnswer
                {
                    ConditionID = j.StoreConditionID,
                    ManagementPriorityID = j.ManagementPriorityID,
                    PriorityExecutionStatusID = j.PriorityExecutionStatusID,
                    PriorityExecutionID = j.PriorityExecutionID
                }).ToList();

            DPSG.Portal.BC.Services.DataContract.Store.StoreData storedata =
                new DPSG.Portal.BC.Services.DataContract.Store.StoreData();

            storedata.StoreConditions = _lstCondition;
            storedata.StoreDisplays = _lstDisplay;
            storedata.StoreDisplayDetails = _lstDisplayDetails;
            storedata.StoreTieInRates = _lstTieInRate;
            storedata.PromotionExecutions = _lstBCPromotionexecution;
            storedata.StoreNotes = _lstStoreNote;
            storedata.PriorityAnswers = _lstPriorityAnswer;

            return storedata;

        }

        private static DPSG.Portal.BC.Services.DataContract.SalesHierarchy.SalesHierarchyData GetSalesHierarchyMaster(ArrayList _arrSaleshierarchy)
        {

            //List<Model.TotalCompany> _lstmodeltotalcompany = _arrSaleshierarchy != null && _arrSaleshierarchy.Count >= 1 ? _arrSaleshierarchy[Constants.SALES_HIERARCHY_MASTER_TOTALCOMPANY] as List<Model.TotalCompany> : new List<Model.TotalCompany>();
            //List<Model.Country> _lstmodelcountry = _arrSaleshierarchy != null && _arrSaleshierarchy.Count >= 1 ? _arrSaleshierarchy[Constants.SALES_HIERARCHY_MASTER_COUNTRY] as List<Model.Country> : new List<Model.Country>();
            List<Model.System> _lstmodelsystem = _arrSaleshierarchy != null && _arrSaleshierarchy.Count >= 1 ? _arrSaleshierarchy[Constants.SALES_HIERARCHY_MASTER_SYSTEM] as List<Model.System> : new List<Model.System>();
            List<Model.Zone> _lstmodelzone = _arrSaleshierarchy != null && _arrSaleshierarchy.Count >= 1 ? _arrSaleshierarchy[Constants.SALES_HIERARCHY_MASTER_ZONE] as List<Model.Zone> : new List<Model.Zone>();
            List<Model.Division> _lstmodeldivison = _arrSaleshierarchy != null && _arrSaleshierarchy.Count >= 1 ? _arrSaleshierarchy[Constants.SALES_HIERARCHY_MASTER_DIVISION] as List<Model.Division> : new List<Model.Division>();
            List<Model.Region> _lstmodelregion = _arrSaleshierarchy != null && _arrSaleshierarchy.Count >= 1 ? _arrSaleshierarchy[Constants.SALES_HIERARCHY_MASTER_REGION] as List<Model.Region> : new List<Model.Region>();

            //List<DPSG.Portal.BC.Services.DataContract.SalesHierarchy.TotalCompany> _lsttotalcompany =
            //_lstmodeltotalcompany.Select
            //(i => new DPSG.Portal.BC.Services.DataContract.SalesHierarchy.TotalCompany
            //{
            //    TotalCompanyID = i.TotalCompanyID,
            //    BCNodeID = i.BCNodeID,
            //    TotalCompanyName = i.TotalCompanyName,
            //    //ModifydDate = Helper.ReturnUTCDateTime(i.LastModified)
            //}).ToList();

            //List<DPSG.Portal.BC.Services.DataContract.SalesHierarchy.Country> _lstcountry =
            //_lstmodelcountry.Select
            //(i => new DPSG.Portal.BC.Services.DataContract.SalesHierarchy.Country
            //{
            //    CountryID = i.CountryID,
            //    BCNodeID = i.BCNodeID,
            //    CountryName = i.CountryName,
            //    TotalCompanyID = i.TotalCompanyID,
            //    //ModifydDate = Helper.ReturnUTCDateTime(i.LastModified)
            //}).ToList();

            List<DPSG.Portal.BC.Services.DataContract.SalesHierarchy.System> _lstsystem =
          _lstmodelsystem.Select
          (i => new DPSG.Portal.BC.Services.DataContract.SalesHierarchy.System
          {
              SystemID = i.SystemID,
              BCNodeID = i.BCNodeID,
              SystemName = i.SystemName,
              CountryID = i.CountryID,
              IsActive = i.Active
              //ModifydDate = Helper.ReturnUTCDateTime(i.LastModified)

          }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.SalesHierarchy.Zone> _lstzone =
          _lstmodelzone.Select
          (i => new DPSG.Portal.BC.Services.DataContract.SalesHierarchy.Zone
          {
              SystemID = i.SystemID,
              BCNodeID = i.BCNodeID,
              ZoneID = i.ZoneID,
              ZoneName = i.ZoneName,
              IsActive = i.Active
              //ModifydDate = Helper.ReturnUTCDateTime(i.LastModified)
          }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.SalesHierarchy.Division> _lstdivison =
         _lstmodeldivison.Select
         (i => new DPSG.Portal.BC.Services.DataContract.SalesHierarchy.Division
         {
             ZoneID = i.ZoneID,
             DivisionID = i.DivisionID,
             DivisionName = i.DivisionName,
             BCNodeID = i.BCNodeID,
             IsActive = i.Active
             //ModifydDate = Helper.ReturnUTCDateTime(i.LastModified)

         }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.SalesHierarchy.Region> _lstregion =
          _lstmodelregion.Select
             (i => new DPSG.Portal.BC.Services.DataContract.SalesHierarchy.Region
             {
                 RegionID = i.RegionID,
                 RegionName = i.RegionName,
                 BCNodeID = i.BCNodeID,
                 DivisionID = i.DivisionID,
                 IsActive = i.Active
                 //ModifydDate = Helper.ReturnUTCDateTime(i.LastModified)

             }).ToList();

            DPSG.Portal.BC.Services.DataContract.SalesHierarchy.SalesHierarchyData salesdata = new DataContract.SalesHierarchy.SalesHierarchyData();

            //salesdata.totalcompany = _lsttotalcompany;
            //salesdata.country = _lstcountry;
            salesdata.Systems = _lstsystem;
            salesdata.Zones = _lstzone;
            salesdata.Divisons = _lstdivison;
            salesdata.Regions = _lstregion;

            return salesdata;
        }

        private static List<DPSG.Portal.BC.Services.DataContract.SalesAccount> GetSalesAccount(ArrayList _arrSaleshierarchy)
        {

            List<Model.BCSalesAccountability> _lstmodelSalesAccount = _arrSaleshierarchy != null && _arrSaleshierarchy.Count >= 1 ? _arrSaleshierarchy[Constants.SALES_ACCOUNT_BCSALESACCOUNTABILITY] as List<Model.BCSalesAccountability> : new List<Model.BCSalesAccountability>();

            List<DPSG.Portal.BC.Services.DataContract.SalesAccount> _lstsalesaccount = _lstmodelSalesAccount.Select(i => new DataContract.SalesAccount
            {
                BCSalesAccountabilityID = i.BCSalesAccountabilityID,
                GSN = i.GSN,
                TotalCompanyID = i.TotalCompanyID,
                CountryID = i.CountryID,
                SystemID = i.SystemID,
                ZoneID = i.ZoneID,
                DivisionID = i.DivisionID,
                RegionID = i.RegionID,
                IsPrimary = i.IsPrimary,
                IsSystemLoad = i.IsSystemLoad,
                //ModifydBy = Helper.ReturnUTCDateTime(i.LastModified)
            }).ToList();

            return _lstsalesaccount;
        }

        public static DataContract.SalesMaster.SalesMasterDataDetails GetSalesMaster(DateTime? lastModifedDate)
        {
            var obj = new BAL.Sales();
            Types.SalesMaster.SalesMasterDataDetails data = obj.GetSalesMaster(lastModifedDate);
            var results = new DataContract.SalesMaster.SalesMasterDataDetails();

            //Bottlers
            results.Bottler = data.Bottler;

            //Bottler Trademarks
            results.BottlerTradeMark = data.BottlerTradeMark;

            //Sales Accounts
            results.SalesAccounts = data.SalesAccounts;

            //SalesHierarchy
            results.SalesHierarchyData = new Types.SalesMaster.SalesHierarchyDetails();
            results.SalesHierarchyData.Systems = data.SalesHierarchyData.Systems;
            results.SalesHierarchyData.Zones = data.SalesHierarchyData.Zones;
            results.SalesHierarchyData.Divisons = data.SalesHierarchyData.Divisons;
            results.SalesHierarchyData.Regions = data.SalesHierarchyData.Regions;

            return results;
        }

        public static DataContract.Account.Bottler.AccountDetails GetStores( int bottlerID, DateTime? lastModifiedDate)
        {
            var obj = new BAL.Store();
            Types.Account.Bottler.AccountDetails data = obj.GetStoresByBottlerID(bottlerID, lastModifiedDate);
            var results = new DataContract.Account.Bottler.AccountDetails();
            results.Stores = data.Stores;
            return results;

        }

        public static DataContract.Account.Bottler.AccountDetails GetStoresByRegionID(int regionID, DateTime? lastModifiedDate)
        {
            var obj = new BAL.Store();
            Types.Account.Bottler.AccountDetails data = obj.GetStoresByRegionID(regionID, lastModifiedDate);
            var results = new DataContract.Account.Bottler.AccountDetails();
            results.Stores = data.Stores;
            return results;
           
        }

        public static DPSG.Portal.BC.Services.DataContract.SalesHierarchy.SalesHierarchyData GetSalesHierarchyMaster(DateTime? LastModifiedDate)
        {
            Sales objSales = new Sales();
            ArrayList _arrSaleshierarchy = objSales.GetSalesHierarchyMaster(LastModifiedDate);

            List<Model.TotalCompany> _lstmodeltotalcompany = _arrSaleshierarchy != null && _arrSaleshierarchy.Count >= 1 ? _arrSaleshierarchy[Constants.SALES_HIERARCHY_DATA_TOTALCOMPANY] as List<Model.TotalCompany> : new List<Model.TotalCompany>();
            List<Model.Country> _lstmodelcountry = _arrSaleshierarchy != null && _arrSaleshierarchy.Count >= 1 ? _arrSaleshierarchy[Constants.SALES_HIERARCHY_DATA_COUNTRY] as List<Model.Country> : new List<Model.Country>();
            List<Model.System> _lstmodelsystem = _arrSaleshierarchy != null && _arrSaleshierarchy.Count >= 1 ? _arrSaleshierarchy[Constants.SALES_HIERARCHY_DATA_SYSTEM] as List<Model.System> : new List<Model.System>();
            List<Model.Zone> _lstmodelzone = _arrSaleshierarchy != null && _arrSaleshierarchy.Count >= 1 ? _arrSaleshierarchy[Constants.SALES_HIERARCHY_DATA_ZONE] as List<Model.Zone> : new List<Model.Zone>();
            List<Model.Division> _lstmodeldivison = _arrSaleshierarchy != null && _arrSaleshierarchy.Count >= 1 ? _arrSaleshierarchy[Constants.SALES_HIERARCHY_DATA_DIVISION] as List<Model.Division> : new List<Model.Division>();
            List<Model.Region> _lstmodelregion = _arrSaleshierarchy != null && _arrSaleshierarchy.Count >= 1 ? _arrSaleshierarchy[Constants.SALES_HIERARCHY_DATA_REGION] as List<Model.Region> : new List<Model.Region>();


            List<DPSG.Portal.BC.Services.DataContract.SalesHierarchy.TotalCompany> _lsttotalcompany =
            _lstmodeltotalcompany.Select
            (i => new DPSG.Portal.BC.Services.DataContract.SalesHierarchy.TotalCompany
            {
                TotalCompanyID = i.TotalCompanyID,
                BCNodeID = i.BCNodeID,
                TotalCompanyName = i.TotalCompanyName,
            }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.SalesHierarchy.Country> _lstcountry =
            _lstmodelcountry.Select
            (i => new DPSG.Portal.BC.Services.DataContract.SalesHierarchy.Country
            {
                CountryID = i.CountryID,
                BCNodeID = i.BCNodeID,
                CountryName = i.CountryName,
                TotalCompanyID = i.TotalCompanyID,
            }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.SalesHierarchy.System> _lstsystem =
          _lstmodelsystem.Select
          (i => new DPSG.Portal.BC.Services.DataContract.SalesHierarchy.System
          {
              SystemID = i.SystemID,
              BCNodeID = i.BCNodeID,
              SystemName = i.SystemName,
              CountryID = i.CountryID,
              IsActive = i.Active

          }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.SalesHierarchy.Zone> _lstzone =
          _lstmodelzone.Select
          (i => new DPSG.Portal.BC.Services.DataContract.SalesHierarchy.Zone
          {
              SystemID = i.SystemID,
              BCNodeID = i.BCNodeID,
              ZoneID = i.ZoneID,
              ZoneName = i.ZoneName,
              IsActive = i.Active
          }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.SalesHierarchy.Division> _lstdivison =
         _lstmodeldivison.Select
         (i => new DPSG.Portal.BC.Services.DataContract.SalesHierarchy.Division
         {
             ZoneID = i.ZoneID,
             DivisionID = i.DivisionID,
             DivisionName = i.DivisionName,
             BCNodeID = i.BCNodeID,
             IsActive = i.Active

         }).ToList();

            List<DPSG.Portal.BC.Services.DataContract.SalesHierarchy.Region> _lstregion =
          _lstmodelregion.Select
             (i => new DPSG.Portal.BC.Services.DataContract.SalesHierarchy.Region
             {
                 RegionID = i.RegionID,
                 RegionName = i.RegionName,
                 BCNodeID = i.BCNodeID,
                 DivisionID = i.DivisionID,
                 IsActive = i.Active

             }).ToList();

            DPSG.Portal.BC.Services.DataContract.SalesHierarchy.SalesHierarchyData salesdata = new DataContract.SalesHierarchy.SalesHierarchyData();

            salesdata.Systems = _lstsystem;
            salesdata.Zones = _lstzone;
            salesdata.Divisons = _lstdivison;
            salesdata.Regions = _lstregion;

            return salesdata;
        }

        public static List<DPSG.Portal.BC.Services.DataContract.SalesAccount> GetSalesAccount(DateTime? LastModifiedDate)
        {
            DPSG.Portal.BC.BAL.Sales objSales = new BAL.Sales();
            List<DPSG.Portal.BC.Services.DataContract.SalesAccount> _lstsalesaccount = null;

            _lstsalesaccount = objSales.GetSalesAccountability(LastModifiedDate).Select(i => new DataContract.SalesAccount
            {
                BCSalesAccountabilityID = i.BCSalesAccountabilityID,
                GSN = i.GSN,
                TotalCompanyID = i.TotalCompanyID,
                CountryID = i.CountryID,
                SystemID = i.SystemID,
                ZoneID = i.ZoneID,
                DivisionID = i.DivisionID,
                RegionID = i.RegionID,
                IsPrimary = i.IsPrimary,
                IsSystemLoad = i.IsSystemLoad,
                //ModifydBy = Helper.ReturnUTCDateTime(i.LastModified)
            }).ToList();

            return _lstsalesaccount;
        }

        public static DPSG.Portal.BC.Services.DataContract.DownloadFile GetFile(string _url)
        {
            DPSG.Portal.BC.Services.DataContract.DownloadFile _fileDetais = new DataContract.DownloadFile();
            try
            {
                WebRequest request = WebRequest.Create(_url);
                byte[] result;
                byte[] buffer = new byte[4096];
                //  request.Credentials = new NetworkCredential("test", "test@123", "DPSG");
                Uri uri = new Uri(_url);
                ICredentials credentials = CredentialCache.DefaultCredentials;
                NetworkCredential credential = credentials.GetCredential(uri, "Basic");
                request.Credentials = credential;
                using (WebResponse response = request.GetResponse())
                {
                    using (Stream responseStream = response.GetResponseStream())
                    {
                        using (MemoryStream ms = new MemoryStream())
                        {
                            int count = 0;
                            do
                            {
                                count = responseStream.Read(buffer, 0, buffer.Length);
                                ms.Write(buffer, 0, count);
                            } while (count != 0);
                            result = ms.ToArray();
                        }
                    }
                }

                _fileDetais._fielByte = Convert.ToBase64String(result);
                _fileDetais._fileLength = result.Length;
                _fileDetais.ResponseStatus = Constants.RESPONSE_STATUS_PASS;
                return _fileDetais;
            }
            catch (Exception ex)
            {
                _fileDetais.ErrorMessage = ex.Message;
                _fileDetais.StackTrace = ex.StackTrace;
                _fileDetais.ResponseStatus = Constants.RESPONSE_STATUS_FAIL;
            }

            return _fileDetais;
        }

    }
}