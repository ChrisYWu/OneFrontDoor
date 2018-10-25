using DPSG.Portal.BC.Common;
using DPSG.Portal.BC.Model;
using DPSG.Portal.BC.Types;
using DPSG.Portal.BC.Types.Priority;
using DPSG.Portal.BC.Types.Promotion;
using DPSG.Portal.BC.Types.RetailExecution;
using DPSG.Portal.Framework;
using DPSG.Portal.Framework.CommonUtils;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Telerik.OpenAccess;
using Telerik.OpenAccess.Data.Common;

namespace DPSG.Portal.BC.DAL
{
    public partial class BCRepository
    {

        public Types.Config.BCMYDAY.ConfigValuesResults GetConfigurationValues()
        {
            var results = new Types.Config.BCMYDAY.ConfigValuesResults();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[BCMYDAY].[p-websvc-GetConfigValues]";
                            //oaCommand.Parameters.Add(new OAParameter { ParameterName = "@LastModified", DbType = DbType.DateTime, Value = lastModified });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                //=======================================================================
                                // Do not change this Result / Execution order without adjusting the 
                                // calling stored procedure. The order is critical to the JSON payload
                                //=======================================================================

                                //Select Result #1
                                List<Types.Config.BCMYDAY.ConfigValuesModel> resultsConfigValues = dbcontext.Translate<Types.Config.BCMYDAY.ConfigValuesModel>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsConfigValues = resultsConfigValues != null ? resultsConfigValues : new List<Types.Config.BCMYDAY.ConfigValuesModel>();

                                results.Config = resultsConfigValues;

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return results;
        }

        public Types.IPE.Programs.MarketingProgramResults GetMarketingPrograms(DateTime? lastModified)
        {
            var results = new Types.IPE.Programs.MarketingProgramResults();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[IPE].[p-websvc-GetMarketingPrograms]";
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@lastModified", DbType = DbType.DateTime, Value = lastModified });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                //=======================================================================
                                // Do not change this Result / Execution order without adjusting the 
                                // calling stored procedure. The order is critical to the JSON payload
                                //=======================================================================

                                //Select Result #1
                                List<Types.IPE.Programs.Contract.MarketingPrograms> resultsMarketingPrograms = dbcontext.Translate<Types.IPE.Programs.Contract.MarketingPrograms>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsMarketingPrograms = resultsMarketingPrograms != null ? resultsMarketingPrograms : new List<Types.IPE.Programs.Contract.MarketingPrograms>();

                                //Select Result #2
                                List<Types.IPE.Programs.Contract.MarketingProgramBrands> resultsMarketingProgramBrands = dbcontext.Translate<Types.IPE.Programs.Contract.MarketingProgramBrands>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsMarketingProgramBrands = resultsMarketingProgramBrands != null ? resultsMarketingProgramBrands : new List<Types.IPE.Programs.Contract.MarketingProgramBrands>();

                                //Select Result #3
                                List<Types.IPE.Programs.Contract.MarketingProgramAttachments> resultsMarketingProgramAttachments = dbcontext.Translate<Types.IPE.Programs.Contract.MarketingProgramAttachments>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsMarketingProgramAttachments = resultsMarketingProgramAttachments != null ? resultsMarketingProgramAttachments : new List<Types.IPE.Programs.Contract.MarketingProgramAttachments>();

                                //Select Result #4
                                List<Types.IPE.Programs.Contract.MarketingProgramPackages> resultsMarketingProgramPackages = dbcontext.Translate<Types.IPE.Programs.Contract.MarketingProgramPackages>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsMarketingProgramPackages = resultsMarketingProgramPackages != null ? resultsMarketingProgramPackages : new List<Types.IPE.Programs.Contract.MarketingProgramPackages>();


                                results.MarketingPrograms = resultsMarketingPrograms;
                                results.MarketingProgramPackages = resultsMarketingProgramPackages;
                                results.MarketingProgramBrands = resultsMarketingProgramBrands;
                                results.MarketingProgramAttachments = resultsMarketingProgramAttachments;

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return results;
        }

        public Types.IPE.Bottler.IpeBottlerDataResults GetIpeBottlers(string type, string typeValue)
        {
            var results = new Types.IPE.Bottler.IpeBottlerDataResults();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[IPE].[p-websvc-GetIpeBottler]";
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@Type", DbType = DbType.String, Value = type });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@TypeValue", DbType = DbType.String, Value = typeValue });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                //=======================================================================
                                // Do not change this Result / Execution order without adjusting the 
                                // calling stored procedure. The order is critical to the JSON payload
                                //=======================================================================

                                //Select Result #1
                                List<Types.IPE.Bottler.Contract.IpeBottlerModel> resultsIpeBottlers = dbcontext.Translate<Types.IPE.Bottler.Contract.IpeBottlerModel>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsIpeBottlers = resultsIpeBottlers != null ? resultsIpeBottlers : new List<Types.IPE.Bottler.Contract.IpeBottlerModel>();

                                results.IpeBottlers = resultsIpeBottlers;

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return results;
        }

        public Types.IPE.SurveyData.SurveyHistoryResults GetIpeSurveyHistory(string type, string typeValue, DateTime? lastModified)
        {
            var results = new Types.IPE.SurveyData.SurveyHistoryResults();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[IPE].[p-websvc-GetIpeSurveyHistory]";
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@Type", DbType = DbType.String, Value = type });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@TypeValue", DbType = DbType.String, Value = typeValue });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@LastModified", DbType = DbType.DateTime, Value = lastModified });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                //=======================================================================
                                // Do not change this Result / Execution order without adjusting the 
                                // calling stored procedure. The order is critical to the JSON payload
                                //=======================================================================

                                //Select Result #1
                                List<Types.IPE.SurveyData.Contract.SurveyHistoryModel> resultsEventSurveyHistory = dbcontext.Translate<Types.IPE.SurveyData.Contract.SurveyHistoryModel>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsEventSurveyHistory = resultsEventSurveyHistory != null ? resultsEventSurveyHistory : new List<Types.IPE.SurveyData.Contract.SurveyHistoryModel>();

                                results.EventResponseHistory = resultsEventSurveyHistory;

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return results;
        }

        public Types.IPE.SurveyData.SurveyDataResults GetIpeSurvey(string type, string typeValue, int responderID)
        {
            var results = new Types.IPE.SurveyData.SurveyDataResults();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[IPE].[p-websvc-GetIPESurvey]";
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@Type", DbType = DbType.String, Value = type });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@TypeValue", DbType = DbType.String, Value = typeValue });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@ResponderID", DbType = DbType.Int32, Value = responderID });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                //=======================================================================
                                // Do not change this Result / Execution order without adjusting the 
                                // calling stored procedure. The order is critical to the JSON payload
                                //=======================================================================

                                //Select Result #1
                                List<Types.IPE.SurveyData.Contract.EventQuestionDatesModel> resultsEventQuestionDates = dbcontext.Translate<Types.IPE.SurveyData.Contract.EventQuestionDatesModel>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsEventQuestionDates = resultsEventQuestionDates != null ? resultsEventQuestionDates : new List<Types.IPE.SurveyData.Contract.EventQuestionDatesModel>();

                                //Select Result #2
                                List<Types.IPE.SurveyData.Contract.EventBottlerPhaseModel> resultsEventBottlerPhase = dbcontext.Translate<Types.IPE.SurveyData.Contract.EventBottlerPhaseModel>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsEventBottlerPhase = resultsEventBottlerPhase != null ? resultsEventBottlerPhase : new List<Types.IPE.SurveyData.Contract.EventBottlerPhaseModel>();


                                results.EventQuestionDates = resultsEventQuestionDates;
                                results.EventBottlerPhase = resultsEventBottlerPhase;


                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return results;
        }

        public Types.IPE.ResponseData.EventResponseDataDetails UploadIpeSurveyEventResponses(DataTable dataTable, string applicationType)
        {

            var results = new Types.IPE.ResponseData.EventResponseDataDetails();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[IPE].[p-websvc-UploadIPESurveyEventResponses]";
                            oaCommand.Parameters.Add(new System.Data.SqlClient.SqlParameter { ParameterName = "@tvpSurveyEventResponseTable", SqlDbType = SqlDbType.Structured, Value = dataTable });
                            oaCommand.Parameters.Add(new System.Data.SqlClient.SqlParameter { ParameterName = "@applicationType", SqlDbType = SqlDbType.VarChar, Value = applicationType });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                //=======================================================================
                                // Do not change this Result / Execution order without adjusting the 
                                // calling stored procedure. The order is critical to the JSON payload
                                //=======================================================================

                                //Select Result #1
                                //List<Types.IPE.ResponseData.EventResponseDataDetails> resultsEventResponses = dbcontext.Translate<Types.IPE.ResponseData.EventResponseDataDetails>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                dbcontext.SaveChanges();
                                //resultsEventResponses = resultsEventResponses != null ? resultsEventResponses : new List<Types.IPE.ResponseData.EventResponseDataDetails>();

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return results;
        }

        public Types.IPE.MasterData.IpeMasterDataDetails GetIpeMaster()
        {
            var results = new Types.IPE.MasterData.IpeMasterDataDetails();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[IPE].[p-websvc-GetSurveyMasterData]";
                            //oaCommand.Parameters.Add(new OAParameter { ParameterName = "@lastmodified", DbType = DbType.DateTime, Value = lastModifiedDate });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                //=======================================================================
                                // Do not change this Result / Execution order without adjusting the 
                                // calling stored procedure. The order is critical to the JSON payload
                                //=======================================================================

                                //Select Result #1
                                List<Types.IPE.MasterData.Contract.QuestionsEntity> resultsQuestions = dbcontext.Translate<Types.IPE.MasterData.Contract.QuestionsEntity>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsQuestions = resultsQuestions != null ? resultsQuestions : new List<Types.IPE.MasterData.Contract.QuestionsEntity>();

                                //Select Result #2
                                List<Types.IPE.MasterData.Contract.PhaseEntity> resultsPhase = dbcontext.Translate<Types.IPE.MasterData.Contract.PhaseEntity>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsPhase = resultsPhase != null ? resultsPhase : new List<Types.IPE.MasterData.Contract.PhaseEntity>();

                                //Select Result #3
                                List<Types.IPE.MasterData.Contract.ResponderEntity> resultsResponder = dbcontext.Translate<Types.IPE.MasterData.Contract.ResponderEntity>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsResponder = resultsResponder != null ? resultsResponder : new List<Types.IPE.MasterData.Contract.ResponderEntity>();

                                //Select Result #4
                                List<Types.IPE.MasterData.Contract.QuestionResponderEntity> resultsQuestionResponder = dbcontext.Translate<Types.IPE.MasterData.Contract.QuestionResponderEntity>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsQuestionResponder = resultsQuestionResponder != null ? resultsQuestionResponder : new List<Types.IPE.MasterData.Contract.QuestionResponderEntity>();

                                //Select Result #5
                                List<Types.IPE.MasterData.Contract.ResponseTypeEntity> resultsResponeType = dbcontext.Translate<Types.IPE.MasterData.Contract.ResponseTypeEntity>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsResponeType = resultsResponeType != null ? resultsResponeType : new List<Types.IPE.MasterData.Contract.ResponseTypeEntity>();

                                //Select Result #6
                                List<Types.IPE.MasterData.Contract.ResponseTypeValuesEntity> resultsResponseTypeValues = dbcontext.Translate<Types.IPE.MasterData.Contract.ResponseTypeValuesEntity>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsResponseTypeValues = resultsResponseTypeValues != null ? resultsResponseTypeValues : new List<Types.IPE.MasterData.Contract.ResponseTypeValuesEntity>();

                                //Select Result #7
                                List<Types.IPE.MasterData.Contract.EventTypeEntity> resultsEventType = dbcontext.Translate<Types.IPE.MasterData.Contract.EventTypeEntity>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsEventType = resultsEventType != null ? resultsEventType : new List<Types.IPE.MasterData.Contract.EventTypeEntity>();

                                //Select Result #8
                                List<Types.IPE.MasterData.Contract.EventPriorityEntity> resultsEventPriority = dbcontext.Translate<Types.IPE.MasterData.Contract.EventPriorityEntity>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsEventPriority = resultsEventPriority != null ? resultsEventPriority : new List<Types.IPE.MasterData.Contract.EventPriorityEntity>();

                                results.IpeMasterData = new Types.IPE.MasterData.IpeMasterData();
                                results.IpeMasterData.Questions = resultsQuestions;
                                results.IpeMasterData.Phase = resultsPhase;
                                results.IpeMasterData.Responder = resultsResponder;
                                results.IpeMasterData.QuestionResponder = resultsQuestionResponder;
                                results.IpeMasterData.ResponseType = resultsResponeType;
                                results.IpeMasterData.ResponseTypeValues = resultsResponseTypeValues;
                                results.IpeMasterData.EventType = resultsEventType;
                                results.IpeMasterData.EventPriority = resultsEventPriority;


                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return results;
        }

        public Types.BottlerHierarchy.BotttlerHierarchyDataDetails GetBottlerHierarchy(DateTime? lastModifiedDate)
        {
            var results = new Types.BottlerHierarchy.BotttlerHierarchyDataDetails();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[BCMyday].[p-websvc-GetBottlerHierarchy]";
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@lastmodified", DbType = DbType.DateTime, Value = lastModifiedDate });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                //=======================================================================
                                // Do not change this Result / Execution order without adjusting the 
                                // calling stored procedure. The order is critical to the JSON payload
                                //=======================================================================

                                //Select Result #1
                                List<Types.BottlerHierarchy.Contract.BottlerHieararchy> EBH1 = dbcontext.Translate<Types.BottlerHierarchy.Contract.BottlerHieararchy>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                EBH1 = EBH1 != null ? EBH1 : new List<Types.BottlerHierarchy.Contract.BottlerHieararchy>();

                                //Select Result #2
                                List<Types.BottlerHierarchy.Contract.BottlerHieararchy> EBH2 = dbcontext.Translate<Types.BottlerHierarchy.Contract.BottlerHieararchy>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                EBH2 = EBH2 != null ? EBH2 : new List<Types.BottlerHierarchy.Contract.BottlerHieararchy>();

                                //Select Result #3
                                List<Types.BottlerHierarchy.Contract.BottlerHieararchy> EBH3 = dbcontext.Translate<Types.BottlerHierarchy.Contract.BottlerHieararchy>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                EBH3 = EBH3 != null ? EBH3 : new List<Types.BottlerHierarchy.Contract.BottlerHieararchy>();

                                //Select Result #4
                                List<Types.BottlerHierarchy.Contract.BottlerHieararchy> EBH4 = dbcontext.Translate<Types.BottlerHierarchy.Contract.BottlerHieararchy>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                EBH4 = EBH4 != null ? EBH4 : new List<Types.BottlerHierarchy.Contract.BottlerHieararchy>();

                                results.BottlerHierarchyMaster = new Types.BottlerHierarchy.Contract.BottlerHiearchyData();
                                results.BottlerHierarchyMaster.EBH1 = EBH1;
                                results.BottlerHierarchyMaster.EBH2 = EBH2;
                                results.BottlerHierarchyMaster.EBH3 = EBH3;
                                results.BottlerHierarchyMaster.EBH4 = EBH4;

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return results;
        }

        public Types.Programs.ProgramRegionDetails GetProgramsByRegionID(int regionID, DateTime? lastModifiedDate)
        {
            var results = new Types.Programs.ProgramRegionDetails();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[NationalAccount].[p-websvc-GetProgramsByRegionID]";
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@RegionID", DbType = DbType.Int32, Value = regionID });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@lastmodified", DbType = DbType.DateTime, Value = lastModifiedDate });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                //=======================================================================
                                // Do not change this Result / Execution order without adjusting the 
                                // calling stored procedure. The order is critical to the JSON payload
                                // 
                                //=======================================================================

                                //Select Result #1
                                List<Types.Programs.Contract.Region.AccountPrograms> accountPrograms = dbcontext.Translate<Types.Programs.Contract.Region.AccountPrograms>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                accountPrograms = accountPrograms != null ? accountPrograms : new List<Types.Programs.Contract.Region.AccountPrograms>();

                                //Select Result #2
                                List<Types.Programs.Contract.Region.ProgramBrands> programBrands = dbcontext.Translate<Types.Programs.Contract.Region.ProgramBrands>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                programBrands = programBrands != null ? programBrands : new List<Types.Programs.Contract.Region.ProgramBrands>();

                                //Select Result #3
                                List<Types.Programs.Contract.Region.ProgramAccounts> programAccounts = dbcontext.Translate<Types.Programs.Contract.Region.ProgramAccounts>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                programAccounts = programAccounts != null ? programAccounts : new List<Types.Programs.Contract.Region.ProgramAccounts>();

                                //Select Result #4
                                List<Types.Programs.Contract.Region.ProgramAttachments> programAttachments = dbcontext.Translate<Types.Programs.Contract.Region.ProgramAttachments>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                programAttachments = programAttachments != null ? programAttachments : new List<Types.Programs.Contract.Region.ProgramAttachments>();

                                //Select Result #5
                                List<Types.Programs.Contract.Region.ProgramPackages> programPackages = dbcontext.Translate<Types.Programs.Contract.Region.ProgramPackages>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                programPackages = programPackages != null ? programPackages : new List<Types.Programs.Contract.Region.ProgramPackages>();

                                //Select Result #6
                                List<Types.Programs.Contract.Region.MarketingPrograms> marketingPrograms = dbcontext.Translate<Types.Programs.Contract.Region.MarketingPrograms>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                marketingPrograms = marketingPrograms != null ? marketingPrograms : new List<Types.Programs.Contract.Region.MarketingPrograms>();

                                //Select Result #7
                                List<Types.Programs.Contract.Region.MarketingProgramBrands> marketingProgramBrands = dbcontext.Translate<Types.Programs.Contract.Region.MarketingProgramBrands>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                marketingProgramBrands = marketingProgramBrands != null ? marketingProgramBrands : new List<Types.Programs.Contract.Region.MarketingProgramBrands>();

                                //Select Result #8
                                List<Types.Programs.Contract.Region.MarketingProgramAttachments> marketingProgramAttachments = dbcontext.Translate<Types.Programs.Contract.Region.MarketingProgramAttachments>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                marketingProgramAttachments = marketingProgramAttachments != null ? marketingProgramAttachments : new List<Types.Programs.Contract.Region.MarketingProgramAttachments>();

                                //Select Result #9
                                List<Types.Programs.Contract.Region.MarketingProgramPackages> marketingProgramPackages = dbcontext.Translate<Types.Programs.Contract.Region.MarketingProgramPackages>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                marketingProgramPackages = marketingProgramPackages != null ? marketingProgramPackages : new List<Types.Programs.Contract.Region.MarketingProgramPackages>();

                                //Select Result #10 **** THIS DOES NOT EXIST FOR MARKETING passing NULL JSON NODE; per requirement
                                //List<Types.Programs.Contract.MarketingProgramAccounts> marketingProgramAcocunts = dbcontext.Translate<Types.Programs.Contract.MarketingProgramAccounts>(dataReader as DbDataReader).ToList();
                                //marketingProgramAcocunts = marketingProgramAcocunts != null ? marketingProgramAcocunts : new List<Types.Programs.Contract.MarketingProgramAccounts>();
                                List<Types.Programs.Contract.Region.MarketingProgramAccounts> marketingProgramAcocunts = new List<Types.Programs.Contract.Region.MarketingProgramAccounts>();

                                //Programs
                                results.AccountPrograms = accountPrograms;
                                results.ProgramBrands = programBrands;
                                results.ProgramAccounts = programAccounts;
                                results.ProgramAttachments = programAttachments;
                                results.ProgramPackages = programPackages;
                                //Marketing
                                results.MarketingPrograms = marketingPrograms;
                                results.MarketingProgramBrands = marketingProgramBrands;
                                results.MarketingProgramAttachments = marketingProgramAttachments;
                                results.MarketingProgramPackages = marketingProgramPackages;
                                //Marketing NULL NODE 
                                results.MarketingProgramAccounts = marketingProgramAcocunts;


                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return results;
        }

        public List<int> GetProgramIDsByBottler(int bottlerID)
        {

            var results = new List<int>();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[NationalAccount].[p-websvc-GetProgramIDsByBottler]";
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@BottlerID", DbType = DbType.Int32, Value = bottlerID });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                var dt = new DataTable();
                                dt.Load(dataReader);
                                results = (from row in dt.AsEnumerable() select Convert.ToInt32(row["ProgramID"])).ToList();

                            }

                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return results;

        }

        public Types.Programs.ProgramMilestoneDetails GetProgramMilestones(DateTime? lastModifiedDate)
        {
            var results = new Types.Programs.ProgramMilestoneDetails();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[NationalAccount].[p-websvc-GetProgramMilestones]";
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@lastmodified", DbType = DbType.DateTime, Value = lastModifiedDate });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                List<Types.Programs.Contract.Milestones.ProgramMilestones> programMilestones = dbcontext.Translate<Types.Programs.Contract.Milestones.ProgramMilestones>(dataReader as DbDataReader).ToList();
                                programMilestones = programMilestones != null ? programMilestones : new List<Types.Programs.Contract.Milestones.ProgramMilestones>();

                                results.MilestoneMaster = programMilestones;
                            }

                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return results;

        }

        public Types.CDE.AssetDetails GetAssetDetail(string routeNumber)
        {
            var results = new Types.CDE.AssetDetails();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[Playbook].[pGetAssetForRoute]";
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@routeNumber", DbType = DbType.String, Value = routeNumber });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                List<Types.CDE.Contract.Asset> assetDetails = dbcontext.Translate<Types.CDE.Contract.Asset>(dataReader as DbDataReader).ToList();
                                assetDetails = assetDetails != null ? assetDetails : new List<Types.CDE.Contract.Asset>();

                                results.Asset = assetDetails;
                            }

                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return results;

        }

        public List<Model.Bottler> GetBottler(DateTime? LastModifiedDate)
        {
            // DPSG.Portal.BC.Model.bcd   
            List<Model.Bottler> _lstBottler = null;
            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@lastmodified", DbType = DbType.DateTime, Value = LastModifiedDate }) };
                    _lstBottler = dbcontext.ExecuteQuery<Model.Bottler>("BCMyday.pGetBottlers", System.Data.CommandType.StoredProcedure, parm).ToList();
                    return _lstBottler;
                }
            }
            catch (Exception ex)
            {
                return _lstBottler;
            }
        }

        public Types.Account.Bottler.AccountDetails GetStoresByBottlerID(int bottlerID, DateTime? lastModifiedDate)
        {

            var results = new Types.Account.Bottler.AccountDetails();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[BCMYDAY].[pGetStoresByBottlerID]";
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@BottlerID", DbType = DbType.Int32, Value = bottlerID });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@lastModified", DbType = DbType.DateTime, Value = lastModifiedDate });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                //=======================================================================
                                // Do not change this Result / Execution order without adjusting the 
                                // calling stored procedure. The order is critical to the JSON payload
                                //=======================================================================

                                //Select Result #1
                                List<Types.Account.Bottler.Contract.BottlerAccount> resultsBottlerAccounts = dbcontext.Translate<Types.Account.Bottler.Contract.BottlerAccount>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsBottlerAccounts = resultsBottlerAccounts != null ? resultsBottlerAccounts : new List<Types.Account.Bottler.Contract.BottlerAccount>();
                                results.Stores = resultsBottlerAccounts;

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return results;
        }

        public Types.Account.Bottler.AccountDetails GetStoresByRegionID(int regionID, DateTime? lastModifiedDate)
        {

            var results = new Types.Account.Bottler.AccountDetails();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[BCMYDAY].[pGetStoresByRegionID]";
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@RegionID", DbType = DbType.Int32, Value = regionID });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@lastModified", DbType = DbType.DateTime, Value = lastModifiedDate });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                //=======================================================================
                                // Do not change this Result / Execution order without adjusting the 
                                // calling stored procedure. The order is critical to the JSON payload
                                //=======================================================================

                                //Select Result #1
                                List<Types.Account.Bottler.Contract.BottlerAccount> resultsBottlerAccounts = dbcontext.Translate<Types.Account.Bottler.Contract.BottlerAccount>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                resultsBottlerAccounts = resultsBottlerAccounts != null ? resultsBottlerAccounts : new List<Types.Account.Bottler.Contract.BottlerAccount>();
                                results.Stores = resultsBottlerAccounts;

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return results;



        }

        public ArrayList GetCustomerHierarchyDetails(DateTime? LastModifiedDate)
        {
            ArrayList _arrayListCustomerHierarchy = new ArrayList();
            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "BCMyday.pGetCustomerHierarchy";

                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@lastmodified", DbType = DbType.DateTime, Value = LastModifiedDate });


                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                List<Model.NationalChain> _lstnationalchaindata = dbcontext.Translate<Model.NationalChain>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstnationalchaindata = _lstnationalchaindata != null ? _lstnationalchaindata : new List<Model.NationalChain>();

                                List<Model.RegionalChain> _lstregionalchaindata = dbcontext.Translate<Model.RegionalChain>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstregionalchaindata = _lstregionalchaindata != null ? _lstregionalchaindata : new List<Model.RegionalChain>();

                                List<Model.LocalChain> _lstlocalchaindata = dbcontext.Translate<Model.LocalChain>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstlocalchaindata = _lstlocalchaindata != null ? _lstlocalchaindata : new List<Model.LocalChain>();

                                List<Model.Channel> _lstchannel = dbcontext.Translate<Model.Channel>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstchannel = _lstchannel != null ? _lstchannel : new List<Model.Channel>();

                                List<Model.SuperChannel> _lstsuperchannel = dbcontext.Translate<Model.SuperChannel>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstsuperchannel = _lstsuperchannel != null ? _lstsuperchannel : new List<Model.SuperChannel>();

                                List<Types.ChainGroup> _lstChanGroups = dbcontext.Translate<Types.ChainGroup>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstChanGroups = _lstChanGroups != null ? _lstChanGroups : new List<Types.ChainGroup>();


                                _arrayListCustomerHierarchy.Add(_lstnationalchaindata);
                                _arrayListCustomerHierarchy.Add(_lstregionalchaindata);
                                _arrayListCustomerHierarchy.Add(_lstlocalchaindata);
                                _arrayListCustomerHierarchy.Add(_lstchannel);
                                _arrayListCustomerHierarchy.Add(_lstsuperchannel);
                                _arrayListCustomerHierarchy.Add(_lstChanGroups);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {

            }
            return _arrayListCustomerHierarchy;
        }

        public Types.Product.ProductHierarchyDetails GetProductHeirarchyDetails(DateTime? lastModifiedDate)
        {
            var results = new Types.Product.ProductHierarchyDetails();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[BCMyday].[pGetProductHierarchy]";

                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@lastmodified", DbType = DbType.DateTime, Value = lastModifiedDate });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                List<Types.Product.Contract.Hierarchy.Brand> productBrands = dbcontext.Translate<Types.Product.Contract.Hierarchy.Brand>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                productBrands = productBrands != null ? productBrands : new List<Types.Product.Contract.Hierarchy.Brand>();

                                List<Types.Product.Contract.Hierarchy.Package> productPackages = dbcontext.Translate<Types.Product.Contract.Hierarchy.Package>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                productPackages = productPackages != null ? productPackages : new List<Types.Product.Contract.Hierarchy.Package>();

                                List<Types.Product.Contract.Hierarchy.Trademark> productTrademarks = dbcontext.Translate<Types.Product.Contract.Hierarchy.Trademark>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                productTrademarks = productTrademarks != null ? productTrademarks : new List<Types.Product.Contract.Hierarchy.Trademark>();

                                results.Brands = productBrands;
                                results.Packages = productPackages;
                                results.TradeMarks = productTrademarks;

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return results;
        }

        public ArrayList GetLosMasterDetails(DateTime? LastModifiedDate)
        {
            ArrayList _arrayListLOSMaster = new ArrayList();
            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {


                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "BCMyday.pGetLOSMaster";

                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@lastmodified", DbType = DbType.DateTime, Value = LastModifiedDate });


                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                List<Types.LOS> _lstlos = dbcontext.Translate<Types.LOS>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstlos = _lstlos != null ? _lstlos : new List<Types.LOS>();

                                List<Model.LOSDisplayLocation> _lstlosdisplaylocation = dbcontext.Translate<Model.LOSDisplayLocation>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstlosdisplaylocation = _lstlosdisplaylocation != null ? _lstlosdisplaylocation : new List<Model.LOSDisplayLocation>();

                                List<Model.TieInReason> _lsttieinreasonmaster = dbcontext.Translate<Model.TieInReason>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lsttieinreasonmaster = _lsttieinreasonmaster != null ? _lsttieinreasonmaster : new List<Model.TieInReason>();

                                List<Model.DisplayTypeMaster> _lstdisplaytypemaster = dbcontext.Translate<Model.DisplayTypeMaster>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstdisplaytypemaster = _lstdisplaytypemaster != null ? _lstdisplaytypemaster : new List<Model.DisplayTypeMaster>();

                                List<Types.SystemBrand> _lstsystembrand = dbcontext.Translate<Types.SystemBrand>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstsystembrand = _lstsystembrand != null ? _lstsystembrand : new List<Types.SystemBrand>();

                                List<Model.SystemPackage> _lstsystempackage = dbcontext.Translate<Model.SystemPackage>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstsystempackage = _lstsystempackage != null ? _lstsystempackage : new List<Model.SystemPackage>();

                                List<Types.SystemPackageBrand> _lstsystempackagebrand = dbcontext.Translate<Types.SystemPackageBrand>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstsystempackagebrand = _lstsystempackagebrand != null ? _lstsystempackagebrand : new List<Types.SystemPackageBrand>();

                                List<Model.Config> _lstconfig = dbcontext.Translate<Model.Config>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstconfig = _lstconfig != null ? _lstconfig : new List<Model.Config>();

                                List<Model.DisplayLocation> _lstdisplaylocation = dbcontext.Translate<Model.DisplayLocation>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstdisplaylocation = _lstdisplaylocation != null ? _lstdisplaylocation : new List<Model.DisplayLocation>();

                                List<Types.SystemTradeMark> _lstsystemtrademark = dbcontext.Translate<Types.SystemTradeMark>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstsystemtrademark = _lstsystemtrademark != null ? _lstsystemtrademark : new List<Types.SystemTradeMark>();

                                List<Types.SystemCompetitionBrand> _lstsystemcompetitionbrand = dbcontext.Translate<Types.SystemCompetitionBrand>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstsystemcompetitionbrand = _lstsystemcompetitionbrand != null ? _lstsystemcompetitionbrand : new List<Types.SystemCompetitionBrand>();

                                List<Types.BCPromotionExecutionStatus> _lstsystempromotionexecutionstatus = dbcontext.Translate<Types.BCPromotionExecutionStatus>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstsystempromotionexecutionstatus = _lstsystempromotionexecutionstatus != null ? _lstsystempromotionexecutionstatus : new List<Types.BCPromotionExecutionStatus>();

                                _arrayListLOSMaster.Add(_lstlos);
                                _arrayListLOSMaster.Add(_lstlosdisplaylocation);
                                _arrayListLOSMaster.Add(_lsttieinreasonmaster);
                                _arrayListLOSMaster.Add(_lstdisplaytypemaster);
                                _arrayListLOSMaster.Add(_lstsystembrand);
                                _arrayListLOSMaster.Add(_lstsystempackage);
                                _arrayListLOSMaster.Add(_lstsystempackagebrand);
                                _arrayListLOSMaster.Add(_lstconfig);
                                _arrayListLOSMaster.Add(_lstdisplaylocation);
                                _arrayListLOSMaster.Add(_lstsystemtrademark);
                                _arrayListLOSMaster.Add(_lstsystemcompetitionbrand);
                                _arrayListLOSMaster.Add(_lstsystempromotionexecutionstatus);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                string b = ex.Message;

            }
            return _arrayListLOSMaster;
        }

        public Types.Priority.PriorityQuestionsResults GetPriorityQuestionsByRegionID(int regionID, DateTime? lastModifiedDate)
        {
            var results = new Types.Priority.PriorityQuestionsResults();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[BCMyDay].[pGetBCPrioritiesByRegionID]";
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@RegionID", DbType = DbType.Int32, Value = regionID });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@LastModifiedTime", DbType = DbType.DateTime2, Value = lastModifiedDate });


                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {

                                //Select Result #1  -- Questions
                                List<Types.Priority.Contract.PriorityQuestion> priorityQuestions = dbcontext.Translate<Types.Priority.Contract.PriorityQuestion>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                priorityQuestions = priorityQuestions != null ? priorityQuestions : new List<Types.Priority.Contract.PriorityQuestion>();

                                //Select Result #2  -- Customers
                                List<Types.Priority.Contract.PriorityCustomer> priorityCustomers = dbcontext.Translate<Types.Priority.Contract.PriorityCustomer>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                priorityCustomers = priorityCustomers != null ? priorityCustomers : new List<Types.Priority.Contract.PriorityCustomer>();

                                //Select Result #3  -- Brands
                                List<Types.Priority.Contract.PriorityBrand> priorityBrands = dbcontext.Translate<Types.Priority.Contract.PriorityBrand>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                priorityBrands = priorityBrands != null ? priorityBrands : new List<Types.Priority.Contract.PriorityBrand>();

                                results.PriorityQuestions = priorityQuestions;
                                results.PriorityBrands = priorityBrands;
                                results.PriorityCustomers = priorityCustomers;

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                //DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "DSPG.Portal.BC.DAL.GetPriorityQuestionsByRegionID");
                throw ex;

            }

            return results;
        }

        public ArrayList GetStoreTieInsHistoryByRegionID(int RegionID, DateTime? LastModifiedDate)
        {
            ArrayList _arrayListStoreTieInsHistory = new ArrayList();
            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "BCMyday.pGetStoreTieInsHistoryByRegionID";

                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@RegionID", Value = RegionID });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@LastModifiedDate", Value = LastModifiedDate });


                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                List<Model.StoreCondition> _lstStoreCondition = dbcontext.Translate<Model.StoreCondition>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstStoreCondition = _lstStoreCondition != null ? _lstStoreCondition : new List<Model.StoreCondition>();

                                #region Store Condition Display
                                List<Model.StoreConditionDisplay> _lstStoreConditionDisplay = new List<Model.StoreConditionDisplay>();
                                DataTable dtStoreConditionDisplay = new DataTable();
                                dtStoreConditionDisplay.Load(dataReader);
                                foreach (DataRow _row in dtStoreConditionDisplay.Rows)
                                {
                                    Model.StoreConditionDisplay objSCD = new Model.StoreConditionDisplay();
                                    objSCD.StoreConditionID = Convert.ToInt32(_row["StoreConditionID"]);
                                    objSCD.StoreConditionDisplayID = Convert.ToInt32(_row["StoreConditionDisplayID"]);

                                    try
                                    {
                                        objSCD.DisplayLocationID = Convert.ToInt32(_row["DisplayLocationID"]);
                                    }
                                    catch
                                    {
                                        objSCD.DisplayLocationID = null;
                                    }

                                    try
                                    {
                                        objSCD.PromotionID = Convert.ToInt32(_row["PromotionID"]);
                                    }
                                    catch
                                    {
                                        objSCD.PromotionID = null;
                                    }

                                    objSCD.DisplayLocationNote = Convert.ToString(_row["DisplayLocationNote"]);
                                    objSCD.OtherNote = Convert.ToString(_row["OtherNote"]);
                                    objSCD.DisplayImageURL = Convert.ToString(_row["DisplayImageURL"]);


                                    try
                                    {
                                        objSCD.GridX = Convert.ToInt32(_row["GridX"]);
                                    }
                                    catch
                                    {
                                        objSCD.GridX = null;
                                    }

                                    try
                                    {
                                        objSCD.GridY = Convert.ToInt32(_row["GridY"]);
                                    }
                                    catch
                                    {
                                        objSCD.GridY = null;
                                    }

                                    if (_row["CreatedBy"] != null)
                                    {
                                        objSCD.CreatedBy = Convert.ToString(_row["CreatedBy"]);
                                    }

                                    objSCD.CreatedDate = Convert.ToDateTime(_row["CreatedDate"]);
                                    objSCD.ModifiedBy = Convert.ToString(_row["ModifiedBy"]);
                                    objSCD.ModifiedDate = Convert.ToDateTime(_row["ModifiedDate"]);
                                    objSCD.IsActive = Convert.ToBoolean(_row["IsActive"]);

                                    try
                                    {
                                        objSCD.DisplayTypeID = Convert.ToInt32(_row["DisplayTypeID"]);
                                    }
                                    catch
                                    {
                                        objSCD.DisplayTypeID = null;
                                    }

                                    try
                                    {
                                        objSCD.ReasonID = Convert.ToInt32(_row["ReasonID"]);
                                    }
                                    catch
                                    {
                                        objSCD.ReasonID = null;
                                    }

                                    objSCD.IsFairShare = Convert.ToInt32(_row["IsFairShare"]);
                                    try
                                    {
                                        objSCD.DPTieInFlag = Convert.ToInt32(_row["DPTieInFlag"]);
                                    }
                                    catch
                                    {
                                        objSCD.DPTieInFlag = null;
                                    }

                                    _lstStoreConditionDisplay.Add(objSCD);
                                }
                                #endregion

                                //List<Model.StoreConditionDisplay> _lstStoreConditionDisplay = dbcontext.Translate<Model.StoreConditionDisplay>(dataReader as DbDataReader).ToList();
                                //dataReader.NextResult();
                                //_lstStoreConditionDisplay = _lstStoreConditionDisplay != null ? _lstStoreConditionDisplay : new List<Model.StoreConditionDisplay>();

                                List<Model.StoreConditionDisplayDetail> _lstStoreConditionDisplayDetail = dbcontext.Translate<Model.StoreConditionDisplayDetail>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstStoreConditionDisplayDetail = _lstStoreConditionDisplayDetail != null ? _lstStoreConditionDisplayDetail : new List<Model.StoreConditionDisplayDetail>();

                                List<Model.StoreTieInRate> _lstStoreTieInRate = dbcontext.Translate<Model.StoreTieInRate>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstStoreTieInRate = _lstStoreTieInRate != null ? _lstStoreTieInRate : new List<Model.StoreTieInRate>();

                                List<Types.BCPromotionExecution> _lstBCPromotionExecution = dbcontext.Translate<Types.BCPromotionExecution>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstBCPromotionExecution = _lstBCPromotionExecution != null ? _lstBCPromotionExecution : new List<Types.BCPromotionExecution>();

                                List<Types.StoreNote> _lstStoreNote = dbcontext.Translate<Types.StoreNote>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstStoreNote = _lstStoreNote != null ? _lstStoreNote : new List<Types.StoreNote>();

                                List<Types.PriorityAnswer> _lstPriorityAnswer = dbcontext.Translate<Types.PriorityAnswer>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstPriorityAnswer = _lstPriorityAnswer != null ? _lstPriorityAnswer : new List<Types.PriorityAnswer>();

                                _arrayListStoreTieInsHistory.Add(_lstStoreCondition);
                                _arrayListStoreTieInsHistory.Add(_lstStoreConditionDisplay);
                                _arrayListStoreTieInsHistory.Add(_lstStoreConditionDisplayDetail);
                                _arrayListStoreTieInsHistory.Add(_lstStoreTieInRate);
                                _arrayListStoreTieInsHistory.Add(_lstBCPromotionExecution);
                                _arrayListStoreTieInsHistory.Add(_lstStoreNote);
                                _arrayListStoreTieInsHistory.Add(_lstPriorityAnswer);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {

            }
            return _arrayListStoreTieInsHistory;
        }

        public Types.SalesMaster.SalesMasterDataDetails GetSalesMaster(DateTime? lastModified)
        {
            var results = new Types.SalesMaster.SalesMasterDataDetails();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[BCMyday].[pGetSalesMasterData]";
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@lastmodified", DbType = DbType.DateTime, Value = lastModified });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                //=======================================================================
                                // Do not change this Result / Execution order without adjusting the 
                                // calling stored procedure. The order is critical to the JSON payload
                                //=======================================================================

                                //Select Result #1
                                List<Types.SalesMaster.Contract.Bottler> bottlerResults = dbcontext.Translate<Types.SalesMaster.Contract.Bottler>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                bottlerResults = bottlerResults != null ? bottlerResults : new List<Types.SalesMaster.Contract.Bottler>();

                                //Select Result #2
                                List<Types.SalesMaster.Contract.BottlerTrademarks> bottlerTrademarksResults = dbcontext.Translate<Types.SalesMaster.Contract.BottlerTrademarks>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                bottlerTrademarksResults = bottlerTrademarksResults != null ? bottlerTrademarksResults : new List<Types.SalesMaster.Contract.BottlerTrademarks>();

                                //Select Result #3
                                List<Types.SalesMaster.Contract.SalesHierarchySystem> salesHiearchySystemResults = dbcontext.Translate<Types.SalesMaster.Contract.SalesHierarchySystem>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                salesHiearchySystemResults = salesHiearchySystemResults != null ? salesHiearchySystemResults : new List<Types.SalesMaster.Contract.SalesHierarchySystem>();

                                //Select Result #4
                                List<Types.SalesMaster.Contract.SalesHierarchyZone> salesHiearchyZoneResults = dbcontext.Translate<Types.SalesMaster.Contract.SalesHierarchyZone>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                salesHiearchyZoneResults = salesHiearchyZoneResults != null ? salesHiearchyZoneResults : new List<Types.SalesMaster.Contract.SalesHierarchyZone>();

                                //Select Result #5
                                List<Types.SalesMaster.Contract.SalesHierarchyDivision> salesHiearchyDivisonResults = dbcontext.Translate<Types.SalesMaster.Contract.SalesHierarchyDivision>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                salesHiearchyDivisonResults = salesHiearchyDivisonResults != null ? salesHiearchyDivisonResults : new List<Types.SalesMaster.Contract.SalesHierarchyDivision>();

                                //Select Result #6
                                List<Types.SalesMaster.Contract.SalesHierarchyRegion> salesHiearchyRegionResults = dbcontext.Translate<Types.SalesMaster.Contract.SalesHierarchyRegion>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                salesHiearchyRegionResults = salesHiearchyRegionResults != null ? salesHiearchyRegionResults : new List<Types.SalesMaster.Contract.SalesHierarchyRegion>();

                                //Select Result #7
                                List<Types.SalesMaster.Contract.SalesAccount> salesAccountsResults = dbcontext.Translate<Types.SalesMaster.Contract.SalesAccount>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                salesAccountsResults = salesAccountsResults != null ? salesAccountsResults : new List<Types.SalesMaster.Contract.SalesAccount>();

                                //Bottlers
                                results.Bottler = bottlerResults;

                                //Bottler Trademarks
                                results.BottlerTradeMark = bottlerTrademarksResults;

                                //Sales Accounts
                                results.SalesAccounts = salesAccountsResults;

                                //SalesHierarchy
                                results.SalesHierarchyData = new Types.SalesMaster.SalesHierarchyDetails();
                                results.SalesHierarchyData.Systems = salesHiearchySystemResults;
                                results.SalesHierarchyData.Zones = salesHiearchyZoneResults;
                                results.SalesHierarchyData.Divisons = salesHiearchyDivisonResults;
                                results.SalesHierarchyData.Regions = salesHiearchyRegionResults;

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return results;

        }

        public ArrayList GetSalesHierarchyMaster(DateTime? LastModifiedDate)
        {
            ArrayList _arrayListSalesHierarchy = new ArrayList();
            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "BCMyDay.pGetSalesHierarchy";

                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@lastmodified", DbType = DbType.DateTime, Value = LastModifiedDate });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                List<Model.TotalCompany> _lsttotalcompany = dbcontext.Translate<Model.TotalCompany>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lsttotalcompany = _lsttotalcompany != null ? _lsttotalcompany : new List<Model.TotalCompany>();

                                List<Model.Country> _lstcountry = dbcontext.Translate<Model.Country>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstcountry = _lstcountry != null ? _lstcountry : new List<Model.Country>();

                                List<Model.System> _lstsystem = dbcontext.Translate<Model.System>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstsystem = _lstsystem != null ? _lstsystem : new List<Model.System>();

                                List<Model.Zone> _lstzone = dbcontext.Translate<Model.Zone>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstzone = _lstzone != null ? _lstzone : new List<Model.Zone>();

                                List<Model.Division> _lstdivision = dbcontext.Translate<Model.Division>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstdivision = _lstdivision != null ? _lstdivision : new List<Model.Division>();

                                List<Model.Region> _lstregion = dbcontext.Translate<Model.Region>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                _lstregion = _lstregion != null ? _lstregion : new List<Model.Region>();

                                _arrayListSalesHierarchy.Add(_lsttotalcompany);
                                _arrayListSalesHierarchy.Add(_lstcountry);
                                _arrayListSalesHierarchy.Add(_lstsystem);
                                _arrayListSalesHierarchy.Add(_lstzone);
                                _arrayListSalesHierarchy.Add(_lstdivision);
                                _arrayListSalesHierarchy.Add(_lstregion);

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {

            }
            return _arrayListSalesHierarchy;
        }

        public List<Model.BCSalesAccountability> GetSalesAccountablitymaster(DateTime? LastModifiedDate)
        {
            List<Model.BCSalesAccountability> _lstAccountability = null;

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@lastmodified", DbType = DbType.DateTime, Value = LastModifiedDate }) };
                    _lstAccountability = dbcontext.ExecuteQuery<Model.BCSalesAccountability>("BCMyDay.pGetSalesAccountabilityMaster", System.Data.CommandType.StoredProcedure, parm).ToList();
                    return _lstAccountability;
                }
            }
            catch (Exception ex)
            {
                return _lstAccountability;
            }
        }

        public DPSG.Portal.BC.Types.Account.AdHoc.AccountResponseDetails UploadAdhocStoreAccount(DPSG.Portal.BC.Types.Account.AdHoc.Account adhocStoreAccount)
        {
            var results = new DPSG.Portal.BC.Types.Account.AdHoc.AccountResponseDetails();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[BCMYDAY].[p-websvc-InsertAdhocStoreAccount]";

                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@ClientStoreID", DbType = DbType.Int32, Value = adhocStoreAccount.ClientStoreID });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@AccountName", DbType = DbType.String, Value = adhocStoreAccount.AccountName });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@AccountNumber", DbType = DbType.Int32, Value = adhocStoreAccount.AccountNumber });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@Address", DbType = DbType.String, Value = adhocStoreAccount.Address });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@City", DbType = DbType.String, Value = adhocStoreAccount.City });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@State", DbType = DbType.String, Value = adhocStoreAccount.State });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@PostalCode", DbType = DbType.String, Value = adhocStoreAccount.PostalCode });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@Longitude", DbType = DbType.Decimal, Value = adhocStoreAccount.Longitude });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@Latitude", DbType = DbType.Decimal, Value = adhocStoreAccount.Latitude });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@RegionID", DbType = DbType.Int32, Value = adhocStoreAccount.RegionID });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@LocalChainID", DbType = DbType.Int32, Value = adhocStoreAccount.LocalChainID });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@MyDayCreated", DbType = DbType.DateTime, Value = adhocStoreAccount.MyDayCreated });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@CreatedBy", DbType = DbType.String, Value = adhocStoreAccount.CreatedBy });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                //=======================================================================
                                // Do not change this Result / Execution order without adjusting the 
                                // calling stored procedure. The order is critical to the JSON payload
                                //=======================================================================

                                //Select Result #1
                                List<DPSG.Portal.BC.Types.Account.AdHoc.AccountResponse> adhocStoreAccountResponse = dbcontext.Translate<DPSG.Portal.BC.Types.Account.AdHoc.AccountResponse>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                adhocStoreAccountResponse = adhocStoreAccountResponse != null ? adhocStoreAccountResponse : new List<DPSG.Portal.BC.Types.Account.AdHoc.AccountResponse>();
                                dbcontext.SaveChanges();
                                //Programs
                                results.AdhocStoreAccounts = adhocStoreAccountResponse;

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return results;
        }

        public void InsertWebServiceLog(ServiceLog objServiceLog)
        {
            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@ServiceName", Value = objServiceLog.ServiceName }),
                                           (new OAParameter { ParameterName = "@OperationName", Value = objServiceLog.OperationName }),
                                           (new OAParameter { ParameterName = "@ModifiedDate", Value = objServiceLog.ModifiedDate }),
                                           (new OAParameter { ParameterName = "@GSN", Value = objServiceLog.GSN }),
                                           (new OAParameter { ParameterName = "@Type", Value = objServiceLog.Type }),
                                           (new OAParameter { ParameterName = "@Exception", Value = objServiceLog.Exception }),                                         
                                           (new OAParameter { ParameterName = "@GUID", Value = objServiceLog.GUID }),
                                           (new OAParameter { ParameterName = "@ComputerName", Value = objServiceLog.ComputerName }),
                                           (new OAParameter { ParameterName = "@UserAgent", Value = objServiceLog.UserAgent })
                                         };

                    dbcontext.ExecuteNonQuery("[BCMyDay].[pSaveServiceLog]", System.Data.CommandType.StoredProcedure, parm);
                    dbcontext.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string ReturnValueByKey(string Format)
        {

            string Value = string.Empty;
            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    Value = dbcontext.Configs.Where(i => i.Key == Format).SingleOrDefault().Value;
                    return Value;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteStoreTieIn(int StoreConditionID)
        {
            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@StoreConditionID", Value = StoreConditionID }) };
                    int retval = dbcontext.ExecuteNonQuery("BCMyDay.pDeleteStoreDataById", System.Data.CommandType.StoredProcedure, parm);
                    dbcontext.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                BC.Common.ExceptionHelper.LogException(ex, "DeleteStoreTieIn");
            }
        }

        public List<UploadStoreData> UploadStoreTieIN(List<Model.StoreCondition> storeCondition, List<Model.StoreConditionDisplay> lstoreConditionDisplay, List<Types.StoreConditionDisplayDetail> lstoreConditionDisplayDetail, List<Model.StoreTieInRate> lstoreTieInRate)
        {
            List<UploadStoreData> _lstuploadstore = null;
            ConvertXML ConvertToXML = new ConvertXML();

            string _storeConditionDisp = ConvertToXML.ReturnStoreConditionDisplayXml(lstoreConditionDisplay);
            string _storeConditionDispDtl = ConvertToXML.ReturnStoreConditionDisplayDetailXML(lstoreConditionDisplayDetail);
            string _storeTieInRate = ConvertToXML.ReturnStoreTieInRateXML(lstoreTieInRate);

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@AccountId", Value = storeCondition[0].AccountId}),
                                           (new OAParameter { ParameterName = "@ConditionDate", Value = storeCondition[0].ConditionDate }),
                                           (new OAParameter { ParameterName = "@GSN", Value = storeCondition[0].GSN   }),
                                           (new OAParameter { ParameterName = "@BCSystemID", Value = storeCondition[0].BCSystemID}),
                                           (new OAParameter { ParameterName = "@Longitude", Value = storeCondition[0].Longitude }),
                                           (new OAParameter { ParameterName = "@Latitude", Value = storeCondition[0].Latitude }) ,                                                                                  
                                           (new OAParameter { ParameterName = "@StoreNote", Value = storeCondition[0].StoreNote }),                                           
                                           (new OAParameter { ParameterName = "@CreatedBy", Value = storeCondition[0].CreatedBy }),
                                           (new OAParameter { ParameterName = "@CreatedDate", Value = storeCondition[0].CreatedDate }),
                                           (new OAParameter { ParameterName = "@ModifiedBy", Value = storeCondition[0].ModifiedBy }),
                                           (new OAParameter { ParameterName = "@ModifiedDate", Value = storeCondition[0].ModifiedDate }),                                      
                                           (new OAParameter { ParameterName = "@BottlerID", Value = storeCondition[0].BottlerID }),
                                           (new OAParameter { ParameterName = "@IsActive", Value = storeCondition[0].IsActive }),
                                           (new OAParameter { ParameterName = "@Name", Value = storeCondition[0].Name }),
                                           (new OAParameter { ParameterName = "@StoreConditionDisplay", Value = _storeConditionDisp }),
                                           (new OAParameter { ParameterName = "@StoreConditionDisplayDetail", Value = _storeConditionDispDtl }),
                                           (new OAParameter { ParameterName = "@StoreTieInRate", Value = _storeTieInRate })
                                         };


                    _lstuploadstore = dbcontext.ExecuteQuery<Types.UploadStoreData>("BCMyDay.pInsertUploadStoreData", System.Data.CommandType.StoredProcedure, parm).ToList();
                    dbcontext.SaveChanges();
                    return _lstuploadstore;
                }
            }
            catch (Exception ex)
            {
                BC.Common.ExceptionHelper.LogException(ex.Message, "");
                BC.Common.ExceptionHelper.LogException(ex.StackTrace, "");
                throw ex;
            }


            #region insert/update through Model
            /*
            try
            {              
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {

                    var results = (from chkStoreCond in dbcontext.StoreConditions
                                   where chkStoreCond.AccountId == storeCondition[0].AccountId
                                   && chkStoreCond.GSN == storeCondition[0].GSN
                               && chkStoreCond.ConditionDate.Value.Day == storeCondition[0].ConditionDate.Value.Day
                               && chkStoreCond.ConditionDate.Value.Month == storeCondition[0].ConditionDate.Value.Month
                               && chkStoreCond.ConditionDate.Value.Year == storeCondition[0].ConditionDate.Value.Year
                                   select chkStoreCond).FirstOrDefault();


                    if (results != null)
                    {
                        results.Latitude = storeCondition[0].Latitude;
                        results.Longitude = storeCondition[0].Longitude;
                        results.StoreNote = storeCondition[0].StoreNote;
                        results.BottlerID = storeCondition[0].BottlerID;
                        results.ModifiedBy = storeCondition[0].ModifiedBy;
                        results.ModifiedDate = storeCondition[0].ModifiedDate;
                        results.BCSystemID = storeCondition[0].BCSystemID;
                        results.BottlerID = storeCondition[0].BottlerID;

                        storeCondition[0].StoreConditionID = results.StoreConditionID;
                        dbcontext.Add(results);
                    }
                    else
                    {
                        dbcontext.Add(storeCondition);
                    }

                    dbcontext.SaveChanges();
                    int ConditionId = storeCondition[0].StoreConditionID;

                    lstoreConditionDisplay.ToList().ForEach(s => s.StoreConditionID = storeCondition[0].StoreConditionID);


                    //Deleting Display and display Details
                    var resultConditionDisp = (from chkStoreCondDisp in dbcontext.StoreConditionDisplays
                                               where chkStoreCondDisp.StoreConditionID == ConditionId
                                               select chkStoreCondDisp);

                    foreach (StoreConditionDisplay disp in resultConditionDisp)
                    {

                        var resultDispDetails = (from dispDetails in dbcontext.StoreConditionDisplayDetails
                                                 where dispDetails.StoreConditionDisplayID == disp.StoreConditionDisplayID
                                                 select dispDetails);
                        foreach (StoreConditionDisplayDetail detail in resultDispDetails)
                        {
                            dbcontext.Delete(detail);
                            dbcontext.SaveChanges();
                        }

                        dbcontext.Delete(disp);
                        dbcontext.SaveChanges();
                    }

                    for (int i = 0; i < lstoreConditionDisplay.Count; i++)
                    {
                        //lstoreConditionDisplay[i].StoreConditionDisplayID =(int) lstoreConditionDisplay[i].ClientDisplayID;
                        dbcontext.Add(lstoreConditionDisplay[i]);
                        dbcontext.SaveChanges();

                        //var displayDetails = lstoreConditionDisplayDetail.Where(k => k.ClientDisplayId == lstoreConditionDisplay[i].ClientDisplayID);
                        //foreach (StoreConditionDisplayDetail det in displayDetails)
                        //{
                        //    det.StoreConditionDisplayID = (int)lstoreConditionDisplay[i].ClientDisplayID + lstoreConditionDisplay[i].StoreConditionDisplayID;
                        //    dbcontext.Add(det);
                        //}
                        //  dbcontext.SaveChanges();
                    }


                    //Store Tie In


                    var resultTieinRates = (from chkStoreCondDisp in dbcontext.StoreTieInRates
                                            where chkStoreCondDisp.StoreConditionID == ConditionId
                                            select chkStoreCondDisp);

                    foreach (StoreTieInRate disp in resultTieinRates)
                    {
                        dbcontext.Delete(disp);
                        dbcontext.SaveChanges();
                    }

                    lstoreTieInRate.ToList().ForEach(s => s.StoreConditionID = ConditionId);
                    dbcontext.Add(lstoreTieInRate);

                    //Display Details


                    //for (int ii = 0; ii < lstoreConditionDisplayDetail.Count; ii++)
                    //{
                    //    if (ii <= lstoreConditionDisplay.Count)
                    //    {
                    //        lstoreConditionDisplayDetail[ii].StoreConditionDisplayID = lstoreConditionDisplay[ii].StoreConditionDisplayID;
                    //    }
                    //}

                    // for (int k = 0; k < lstoreConditionDisplayDetail.Count; k++)
                    //{
                    //    //var itemToUpdate = dbcontext.StoreConditionDisplayDetails.Where(t => t.StoreConditionDisplayID == lstoreConditionDisplayDetail[k].StoreConditionDisplayID).FirstOrDefault();
                    //    var itemToDelete = (from chkStoreCondDispDtl in dbcontext.StoreConditionDisplayDetails
                    //                        where chkStoreCondDispDtl.CreatedBy == lstoreConditionDisplayDetail[k].CreatedBy
                    //                               && chkStoreCondDispDtl.CreatedDate.Value.Day == lstoreConditionDisplayDetail[k].CreatedDate.Value.Day
                    //                               && chkStoreCondDispDtl.CreatedDate.Value.Month == lstoreConditionDisplayDetail[k].CreatedDate.Value.Month
                    //                               && chkStoreCondDispDtl.CreatedDate.Value.Year == lstoreConditionDisplayDetail[k].CreatedDate.Value.Year
                    //                        select chkStoreCondDispDtl).FirstOrDefault();
                    //    if (itemToDelete != null)
                    //    {
                    //        //itemToUpdate.SystemBrandID = lstoreConditionDisplayDetail[k].SystemBrandID;
                    //        //itemToUpdate.CreatedBy = lstoreConditionDisplayDetail[k].CreatedBy;
                    //        //itemToUpdate.CreatedDate = lstoreConditionDisplayDetail[k].CreatedDate;
                    //        //itemToUpdate.SystemPackageID = lstoreConditionDisplayDetail[k].SystemPackageID;
                    //        //itemToUpdate.ModifiedDate = lstoreConditionDisplayDetail[k].ModifiedDate;
                    //        //itemToUpdate.ModifiedBy = lstoreConditionDisplayDetail[k].ModifiedBy;

                    //        //dbcontext.Add(itemToUpdate);
                    //        dbcontext.Delete(itemToDelete);
                    //        dbcontext.SaveChanges();
                    //        dbcontext.Add(lstoreConditionDisplayDetail[k]);
                    //    }
                    //    else
                    //    {
                    //        dbcontext.Add(lstoreConditionDisplayDetail[k]);
                    //    }
                    //}




                    dbcontext.SaveChanges();
                }
            }
            // }
            catch (Exception ex)
            {
                throw (ex);
            }
            */
            #endregion
        }

        public void InsertUserSession(string GSN, string SessionID, DateTime ExpiryDate)
        {
            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@GSN", Value =GSN}),
                                           (new OAParameter { ParameterName = "@SessionID", Value =SessionID }),
                                           (new OAParameter { ParameterName = "@ExpiryDate", Value = ExpiryDate  }),                                          
                                         };

                    dbcontext.ExecuteNonQuery("BCMyDay.pInsertUserSession", System.Data.CommandType.StoredProcedure, parm);
                    dbcontext.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string GetUserSession(string GSN, string SessionID)
        {
            string SID = string.Empty;
            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    DbParameter[] parm = { 
                                           (new OAParameter { ParameterName = "@GSN", Value=GSN }),
                                           (new OAParameter { ParameterName = "@SessionID", Value=SessionID}),
                                         };

                    SID = dbcontext.ExecuteScalar<string>("BCMyDay.pGetUserSession", System.Data.CommandType.StoredProcedure, parm);
                    return SID;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateDisplayImageURL(int StoreCondtionDisplayID, string _urlName)
        {
            using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
            {
                //ObjectKey key = new ObjectKey("Model.StoreConditionDisplay", new[] { new KeyValuePair<string, object>("StoreConditionDisplayID", lstoreConditionDisplay.StoreConditionDisplayID) });
                //var updscd = dbcontext.GetObjectByKey<StoreConditionDisplay>(key);
                //updscd.DisplayImageURL = _urlName;
                //lstoreConditionDisplay.DisplayImageURL = _urlName;

                //dbcontext.Add(updscd);
                //dbcontext.SaveChanges();

                Model.StoreConditionDisplay _storedisplay = dbcontext.StoreConditionDisplays.First(i => i.StoreConditionDisplayID == StoreCondtionDisplayID);
                _storedisplay.DisplayImageURL = _urlName;
                dbcontext.SaveChanges();
            }
        }

        public List<Model.StoreConditionDisplay> ReturnImageDetails(int StoreCondtionID)
        {
            List<Model.StoreConditionDisplay> _lststorecondtiondispl = null;

            using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
            {
                _lststorecondtiondispl = dbcontext.StoreConditionDisplays.Where(i => i.StoreConditionID == StoreCondtionID).ToList();
            }

            return _lststorecondtiondispl;
        }

        public static DPSG.Portal.BC.Types.Promotion.PromotionData GetPromotionsByRegionID(int BCRegionID, DateTime? LastModifiedDate)
        {
            DPSG.Portal.BC.Types.Promotion.PromotionData promotionData = new PromotionData();

            try
            {

                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[BCMyday].[pGetPromotionsByRegionID]";

                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@BCRegionID", DbType = DbType.Int32, Value = BCRegionID });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@lastmodified", DbType = DbType.DateTime, Value = LastModifiedDate });


                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {

                                //Select Result #1  -- Promotion
                                List<Promotion> promotions = dbcontext.Translate<Promotion>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                promotions = promotions != null ? promotions : new List<Promotion>();


                                // Select Result #2 -- Promotion Brand
                                List<PromotionBrand> promotionBrands = dbcontext.Translate<PromotionBrand>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                promotionBrands = promotionBrands != null ? promotionBrands : new List<PromotionBrand>();


                                // Select Result #3 -- Promotion Account
                                List<PromotionAccount> promotionAccounts = dbcontext.Translate<PromotionAccount>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                promotionAccounts = promotionAccounts != null ? promotionAccounts : new List<PromotionAccount>();

                                // Select Result #4 -- Promotion Attachments
                                List<PromotionAttachment> promotionAttachments = dbcontext.Translate<PromotionAttachment>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                promotionAttachments = promotionAttachments != null ? promotionAttachments : new List<PromotionAttachment>();

                                // Select Result #5 -- Promotion pacakage

                                List<PromotionPackage> promotionPackages = dbcontext.Translate<PromotionPackage>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                promotionPackages = promotionPackages != null ? promotionPackages : new List<PromotionPackage>();

                                // Select Result #6 -- Promotion State

                                List<PromotionState> promotionStates = dbcontext.Translate<PromotionState>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                promotionStates = promotionStates != null ? promotionStates : new List<PromotionState>();

                                promotionData.Promotions = promotions;
                                promotionData.PromotionBrands = promotionBrands;
                                promotionData.PromotionAccounts = promotionAccounts;
                                promotionData.PromotionAttachments = promotionAttachments;
                                promotionData.PromotionPackages = promotionPackages;
                                promotionData.PromotionStates = promotionStates;

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "DSPG.Portal.BC.DAL.GetPromotionsByRegionID");
                throw ex;
            }
            return promotionData;
        }

        public static int[] GetPromotionsIDsByBottler(int BottlerID)
        {
            int[] retval;
            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "BCMyday.pGetPromotionIDsByBottler";
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@BottlerID", DbType = DbType.Int32, Value = BottlerID });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                /* Disabled 6/1/2015, corrected for faster execution -WILTX006
                                 * 
                                 */
                                //DataTable dtPromoBottler = new DataTable();
                                //dtPromoBottler.Load(dataReader);
                                //retval = new int[dtPromoBottler.Rows.Count];
                                //for (int ctr = 0; ctr < dtPromoBottler.Rows.Count; ctr++)
                                //{
                                //    retval[ctr] = Convert.ToInt32(dtPromoBottler.Rows[ctr]["PromotionID"]);
                                //}


                                //Improved by WILTX006 6/1/2015; removed "FOR LOOP" 
                                var dt = new DataTable();
                                dt.Load(dataReader);
                                retval = (from row in dt.AsEnumerable() select Convert.ToInt32(row["PromotionID"])).ToArray();

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "DSPG.Portal.BC.DAL.GetPromotionsByRegionID");
                throw ex;
            }
            return retval;
        }

        public Types.Promotion.PromotionData GetPromotionsByRouteID(string routeID, DateTime? lastModifiedDate)
        {
            //DPSG.Portal.BC.Types.Promotion.PromotionData promotionData = new PromotionData();
            var results = new Types.Promotion.PromotionData();

            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[Playbook].[pGetPromotionsByRouteID]";

                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@RouteNumber", DbType = DbType.String, Value = routeID });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@lastmodified", DbType = DbType.DateTime, Value = lastModifiedDate });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                //Select Result #1 Promotion details
                                List<Promotion> promotions = dbcontext.Translate<Promotion>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                promotions = promotions != null ? promotions : new List<Promotion>();

                                //Select Result #2 Promotion Brand Trademark details
                                List<PromotionBrand> promotionBrands = dbcontext.Translate<PromotionBrand>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                promotionBrands = promotionBrands != null ? promotionBrands : new List<PromotionBrand>();

                                //Select Result #3 Promotion chain details 
                                List<PromotionAccount> promotionAccounts = dbcontext.Translate<PromotionAccount>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                promotionAccounts = promotionAccounts != null ? promotionAccounts : new List<PromotionAccount>();

                                //Select Result #4 Promotion Attachments details 
                                List<PromotionAttachment> promotionAttachments = dbcontext.Translate<PromotionAttachment>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                promotionAttachments = promotionAttachments != null ? promotionAttachments : new List<PromotionAttachment>();

                                //Select Result #5 Promotion package details 
                                List<PromotionPackage> promotionPackages = dbcontext.Translate<PromotionPackage>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                promotionPackages = promotionPackages != null ? promotionPackages : new List<PromotionPackage>();

                                //Select Result #6 Promotion priority details 
                                List<PromotionWeekPriority> promotionPriority = dbcontext.Translate<PromotionWeekPriority>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                promotionPriority = promotionPriority != null ? promotionPriority : new List<PromotionWeekPriority>();

                                //Select Result #7 Promotion customer details 
                                List<PromotionCustomer> promotionCustomer = dbcontext.Translate<PromotionCustomer>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                promotionCustomer = promotionCustomer != null ? promotionCustomer : new List<PromotionCustomer>();

                                results.Promotions = promotions;
                                results.PromotionBrands = promotionBrands;
                                results.PromotionAccounts = promotionAccounts;
                                results.PromotionAttachments = promotionAttachments;
                                results.PromotionPackages = promotionPackages;
                                results.PromotionsWeekPriority = promotionPriority;
                                results.PromotionCustomers = promotionCustomer;

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
               // DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "DSPG.Portal.BC.DAL.GetPromotionsByRouteID");
                throw ex;
            }

            return results;
        }

        public static ArrayList GetDocumentsByRouteNumber(string RouteNumber)
        {
            ArrayList retunVal = new ArrayList();
            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[Playbook].[pGetDocumentsByRouteID]";
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@RouteNumber", Value = RouteNumber });

                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {

                                DataTable dtMetaDataValues = new DataTable();
                                dtMetaDataValues.Load(dataReader);
                                retunVal.Add(dtMetaDataValues);

                                DataTable dtCustomer = new DataTable();
                                dtCustomer.Load(dataReader);

                                List<Types.Promotion.DocumentCustomerMapping> customerMap = new List<DocumentCustomerMapping>();
                                foreach (DataRow _row in dtCustomer.Rows)
                                {
                                    DocumentCustomerMapping custMap = new DocumentCustomerMapping();
                                    custMap.CustomerNumber = Convert.ToString(_row["SAPAccountNumber"]);
                                    custMap.MetaDataTableID = Convert.ToInt32(_row["ID"]);

                                    customerMap.Add(custMap);
                                }
                                retunVal.Add(customerMap);
                                //dat
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "DSPG.Portal.BC.DAL.GetPromotionsByRouteID");
                throw ex;
            }
            return retunVal;
        }

        public static OtherPromoData GetOtherPromoMaster(DateTime? ModifiedDate)
        {
            OtherPromoData returnVal = new OtherPromoData();
            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "Playbook.pGetOtherPromoMaster";

                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@lastmodified", DbType = DbType.DateTime, Value = ModifiedDate });


                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                List<PromotionCategory> promotionCategory = new List<PromotionCategory>(); // dbcontext.Translate<Promotion>(dataReader as DbDataReader).ToList();
                                DataTable dtPromotionCategory = new DataTable();
                                dtPromotionCategory.Load(dataReader);

                                foreach (DataRow _row in dtPromotionCategory.Rows)
                                {
                                    PromotionCategory catg = new PromotionCategory();
                                    catg.PromotionCategoryID = Convert.ToInt32(_row["PromotionCategoryID"]);
                                    catg.PromotionCategoryName = Convert.ToString(_row["PromotionCategoryName"]);
                                    catg.ShortCategoryName = Convert.ToString(_row["ShortPromotionCategoryName"]);

                                    catg.IsActive = Convert.ToBoolean(_row["IsActive"]);
                                    promotionCategory.Add(catg);
                                }



                                List<PromotionRefusalReason> promotionRefusalReason = new List<PromotionRefusalReason>();  // dbcontext.Translate<PromotionBrand>(dataReader as DbDataReader).ToList();
                                DataTable dtPromotionRefusalReason = new DataTable();
                                dtPromotionRefusalReason.Load(dataReader);
                                foreach (DataRow _row in dtPromotionRefusalReason.Rows)
                                {
                                    PromotionRefusalReason temp = new PromotionRefusalReason();
                                    temp.PromotionRefusalReasonID = Convert.ToInt32(_row["PromotionRefusalReasonID"]);
                                    temp.PromotionRefusalReasonName = Convert.ToString(_row["PromotionRefusalReasonName"]);
                                    temp.IsActive = Convert.ToBoolean(_row["IsActive"]);
                                    promotionRefusalReason.Add(temp);
                                }



                                List<PromotionExecutionStatus> promotionStatus = new List<PromotionExecutionStatus>();
                                DataTable dtpromotionStatus = new DataTable();
                                dtpromotionStatus.Load(dataReader);
                                foreach (DataRow _row in dtpromotionStatus.Rows)
                                {
                                    PromotionExecutionStatus temp = new PromotionExecutionStatus();
                                    temp.StatusID = Convert.ToInt32(_row["StatusID"]);
                                    temp.StatusName = Convert.ToString(_row["StatusName"]);
                                    temp.IsActive = Convert.ToBoolean(_row["IsActive"]);
                                    promotionStatus.Add(temp);
                                }


                                returnVal.PromotionCategories = promotionCategory;
                                returnVal.PromotionRefusalReasons = promotionRefusalReason;
                                returnVal.PromotionExecutionStatus = promotionStatus;


                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {

            }
            return returnVal;
        }

        public static DPSG.Portal.BC.Types.RetailExecution.StoreExecutionData GetStoreExecutionDetailsByRouteNumber(string RouteID, DateTime? LastModifiedDate)
        {
            DPSG.Portal.BC.Types.RetailExecution.StoreExecutionData storeexecutiondata = new StoreExecutionData();
            try
            {
                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "Playbook.pGetPromotionExecutionStatus";

                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@routeNumber", Value = RouteID.ToString() });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@LastModifiedDate", Value = LastModifiedDate });


                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                //#region Promotion Data
                                // List<Promotion> promotions = new List<Promotion>(); // dbcontext.Translate<Promotion>(dataReader as DbDataReader).ToList();
                                //DataTable dtPromotion = new DataTable();
                                //dtPromotion.Load(dataReader);
                                //  List<RET
                                //  List<R
                                // List<StoreExecution>
                                List<StoreExecution> storeexecution = new List<StoreExecution>();
                                List<StoreExecutionDisplay> storeexecutiondisplay = new List<StoreExecutionDisplay>();

                                DataTable dtexecution = new DataTable();
                                dtexecution.Load(dataReader);

                                foreach (DataRow dr in dtexecution.Rows)
                                {
                                    // storeexecution strexec = new List<StoreExecution>();
                                    StoreExecution strexec = new StoreExecution();
                                    // DPSG.Portal.BC.Types.RetailExecution.StoreExecution strexec = new StoreExecution();
                                    strexec.ExecutionID = Convert.ToInt32(dr["ExecutionID"]);
                                    strexec.PromotionID = Convert.ToInt32(dr["PromotionID"]);
                                    strexec.CustomerNumber = Convert.ToString(dr["AccountID"]);
                                    strexec.StatusID = Convert.ToInt32(dr["ExecutionStatusID"]);
                                    strexec.StatusDate = dr["ExecutionDate"] == DBNull.Value ? "" : TimeZoneInfo.ConvertTimeToUtc(Convert.ToDateTime(dr["ExecutionDate"])).ToString(Constants.DATE_FORMAT);
                                    strexec.GSN = Convert.ToString(dr["GSN"] == DBNull.Value ? "" : dr["GSN"]);
                                    strexec.EmployeeID = Convert.ToInt32(dr["EmployeeID"]);
                                    strexec.EmployeeName = Convert.ToString(dr["EmployeeName"]);
                                    strexec.RouteNumber = Convert.ToString(dr["RouteID"]);
                                    strexec.ManagerNotes = Convert.ToString(dr["Comments"]);
                                    storeexecution.Add(strexec);

                                    //   DPSG.Portal.BC.Types.RetailExecution.StoreExecutionDisplay strexecdisplay = new StoreExecutionDisplay();
                                    StoreExecutionDisplay strexecdisplay = new StoreExecutionDisplay();
                                    strexecdisplay.ExecutionID = Convert.ToInt32(dr["ExecutionID"]);
                                    strexecdisplay.DisplayLocationID = Convert.ToInt32(dr["DisplayLocationID"]);
                                    strexecdisplay.DisplayTypeID = Convert.ToInt32(dr["DisplayTypeID"]);
                                    strexecdisplay.Notes = Convert.ToString(dr["Comments"]);
                                    strexecdisplay.TotalCases = Convert.ToInt32(dr["TotalCases"]);
                                    strexecdisplay.ReasonId = Convert.ToInt32(dr["RefusalReasonID"] == DBNull.Value ? 0 : dr["RefusalReasonID"]);
                                    //Convert.ToInt32(dr["RefusalReasonID"] == DBNull.Value ? 0 : dr["RefusalReasonID"]);
                                    //dr["RefusalReasonID"] == DBNull.Value ? "" : TimeZoneInfo.ConvertTimeToUtc(Convert.ToDateTime(dr["ExecutionDate"])).ToString(Constants.DATE_FORMAT);
                                    strexecdisplay.DisplayRemoveDate = dr["DisplayRemoveDate"] == DBNull.Value ? "" : TimeZoneInfo.ConvertTimeToUtc(Convert.ToDateTime(dr["DisplayRemoveDate"])).ToString(Constants.DATE_FORMAT);
                                    strexecdisplay.ImageURL = Convert.ToString(dr["ImageURL"] == DBNull.Value ? "" : dr["ImageURL"]);
                                    strexecdisplay.ImageName = Convert.ToString(dr["ImageName"] == DBNull.Value ? "" : dr["ImageName"]);
                                    strexecdisplay.Longitude = dr["Longitude"] != DBNull.Value ? Convert.ToDecimal(dr["Longitude"]) : 0;
                                    strexecdisplay.Latitude = dr["Latitude"] != DBNull.Value ? Convert.ToDecimal(dr["Latitude"]) : 0;
                                    storeexecutiondisplay.Add(strexecdisplay);
                                }

                                storeexecutiondata.StoreExecution = storeexecution;
                                storeexecutiondata.StoreExecutionDisplay = storeexecutiondisplay;

                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "DSPG.Portal.BC.DAL.GetPromotionsByRouteID");
                throw ex;
            }
            return storeexecutiondata;
        }

        public int UploadStoreExecutionDetails(StoreExecution input)
        {
            int executionID;

            try
            {
                StoreExecution execution = input;
                StoreExecutionDisplay display = input.StoreExecutionDisplay;

                using (BCDBModel dbcontext = new BCDBModel(DPSG.Portal.Framework.ConnectionStrings.PlaybookConnectionString))
                {
                    using (IDbConnection oaConnection = dbcontext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            // DPSG.Portal.BC.Common.ExceptionHelper.LogException("3 ", "DSPG.Portal.BC.DAL.UploadStoreExecutionDetails");

                            DbParameter[] parm = { 
                           (new OAParameter { ParameterName = "@CustomerNumber",       Value = execution.CustomerNumber }),
                           (new OAParameter { ParameterName = "@EmployeeID",       Value = execution.EmployeeID }),
                           (new OAParameter { ParameterName = "@EmployeeName",       Value = execution.EmployeeName }),
                           (new OAParameter { ParameterName = "@ExecutionID",       Value = execution.ExecutionID }),
                           (new OAParameter { ParameterName = "@GSN",       Value = execution.GSN }),
                           (new OAParameter { ParameterName = "@PromotionID",       Value = execution.PromotionID }),
                           (new OAParameter { ParameterName = "@RouteNumber",       Value = execution.RouteNumber }),
                           (new OAParameter { ParameterName = "@StatusDate",       Value = execution.StatusDate }),
                           (new OAParameter { ParameterName = "@StatusID",       Value = execution.StatusID }),
                           
                           (new OAParameter { ParameterName = "@DisplayLocationID",       Value = display.DisplayLocationID }),
                           (new OAParameter { ParameterName = "@DisplayRemoveDate",       Value = display.DisplayRemoveDate }),
                           (new OAParameter { ParameterName = "@DisplayTypeID",       Value = display.DisplayTypeID }),
                           (new OAParameter { ParameterName = "@Notes",       Value = display.Notes }),
                           (new OAParameter { ParameterName = "@ReasonId",       Value = display.ReasonId }),
                           (new OAParameter { ParameterName = "@TotalCases",       Value = display.TotalCases }),
                           (new OAParameter { ParameterName = "@Latitude",       Value = display.Latitude }),
                           (new OAParameter { ParameterName = "@Longitude",       Value = display.Longitude })};

                            executionID = dbcontext.ExecuteScalar<int>("Playbook.pInsertUpdateRetailExecutionDisplay", System.Data.CommandType.StoredProcedure, parm);
                            dbcontext.SaveChanges();
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                //DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "DSPG.Portal.BC.DAL.UploadStoreExecutionDetails");
                throw ex;
            }

            return executionID;
        }

    }
}
