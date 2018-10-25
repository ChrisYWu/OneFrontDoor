using DPSG.Portal.Merchandiser.WebAPI.Model;
using DPSG.Portal.Merchandiser.WebAPI.Model.Input;
using DPSG.Portal.Merchandiser.WebAPI.Model.Output;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.DataService
{
    public class DisplayBuildDataService : MerchConnectionWrapper
    {
        #region All Merch HttpGet methods
        public MerchBuildMaster GetMerchBuildMaster(DateTime? LastModified)
        {
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@LastModified", LastModified),
                                       };

                MerchReader reader = this.ExecuteReader(Constant.StoredProcedureName.GetMerchBuildMaster, pars);

                MerchBuildMaster retval = new MerchBuildMaster();
                retval.DisplayBuildStatuses = reader.GetResults<DisplayBuildStatus>().ToList();
                retval.BuildRefusalReasons = reader.GetResults<BuildRefusalReason>().ToList();
                retval.DNSReasons = reader.GetResults<DNSReason>().ToList();

                return retval;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public DisplayBuildWithLatestStatusRaw GetDisplayBuildWithLatestStatus(string SAPAccountNumber, DateTime? DispatchDate, bool? IncludeBuiltOnes)
        {
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@SAPAccountNumber", SAPAccountNumber),
                                         new SqlParameter("@DispatchDate", DispatchDate),
                                         new SqlParameter("@IncludeBuiltOnes", IncludeBuiltOnes)
                                       };

                MerchReader reader = this.ExecuteReader(Constant.StoredProcedureName.GetDisplayBuildWithLatestStatus, pars);

                DisplayBuildWithLatestStatusRaw retval = new DisplayBuildWithLatestStatusRaw();

                retval.DisplayBuilds = reader.GetResults<DisplayBuildOutputRaw>().ToList();

                return retval;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public ContainerList GetAzureContainer(int containerID)
        {
            ContainerList retval = new ContainerList();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@ContainerID", containerID) };

                MerchReader reader = this.ExecuteReader(Constant.StoredProcedureName.GetAzureContainer, pars);

                retval.Containers = reader.GetResults<AzureContainer>().ToList();

                return retval;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public OutputBase ExtendContrainerReadSAS(int containerID, DateTime expiration, string readSAS)
        {
            OutputBase result = new OutputBase();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@ContainerID", containerID),
                                        new SqlParameter("@ReadSASExpiration", expiration),
                                        new SqlParameter("@ReadSAS", readSAS),
                                       };
                result.ResponseStatus = this.ExecuteNonQuery(Constant.StoredProcedureName.ExtendContainerReadSAS, pars);
                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public StringResponse GetAzureStorageConnection()
        {
            StringResponse result = new StringResponse();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = {};
                MerchReader reader = this.ExecuteReader(Constant.StoredProcedureName.GetAzureStorageConnection, pars);

                result.Response = reader.GetResults<String>().ToList()[0];

                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public OutputBase ExtendContrainerWriteSAS(int containerID, DateTime expiration, string writeSAS)
        {
            OutputBase result = new OutputBase();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@ContainerID", containerID),
                                        new SqlParameter("@WriteSASExpiration", expiration),
                                        new SqlParameter("@WriteSAS", writeSAS),
                                       };
                result.ResponseStatus = this.ExecuteNonQuery(Constant.StoredProcedureName.ExtendContainerWriteSAS, pars);
                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public DisplayBuildWithLatestStatusRaw GetDisplayBuildWithLatestStatusByRouteNumber(string RouteNumber, DateTime? LastModifiedDate = null)
        {
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@RouteNumber", RouteNumber)
                                       };

                MerchReader reader = this.ExecuteReader(Constant.StoredProcedureName.GetDisplayBuildWithLatestStatusByRouteID, pars);

                DisplayBuildWithLatestStatusRaw retval = new DisplayBuildWithLatestStatusRaw();
                retval.DisplayBuilds = reader.GetResults<DisplayBuildOutputRaw>().ToList();

                return retval;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }
        #endregion

        #region All Merch HttpPost methods
        public OutputBase InsertDisplayBuild(DisplayBuild displayBuild)
        {
            OutputBase result = new OutputBase();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@SAPAccountNumber", displayBuild.SAPAccountNumber),
                                        new SqlParameter("@GSN", displayBuild.GSN),
                                        new SqlParameter("@PromotionID", displayBuild.PromotionID),
                                        new SqlParameter("@RequiresDisplay", displayBuild.RequiresDisplay),
                                        new SqlParameter("@PromotionExecutionStatusID", displayBuild.PromotionExecutionStatusID),
                                        new SqlParameter("@DisplayLocationID", displayBuild.DisplayLocationID),
                                        new SqlParameter("@DisplayTypeID", displayBuild.DisplayTypeID),
                                        new SqlParameter("@ProposedStartDate", displayBuild.ProposedStartDate),
                                        new SqlParameter("@ProposedEndDate", displayBuild.ProposedEndDate),
                                        new SqlParameter("@BuildInstruction", displayBuild.BuildInstruction),
                                        new SqlParameter("@InstructionImageName", displayBuild.InstructionImageName),
                                        new SqlParameter("@RelativeURL", displayBuild.RelativeURL),
                                        new SqlParameter("@AbsoluteURL", displayBuild.AbsoluteURL),
                                        new SqlParameter("@StorageAccount", displayBuild.StorageAccount),
                                        new SqlParameter("@Container", displayBuild.Container),

                                       };
                result.ResponseStatus = this.ExecuteNonQuery(Constant.StoredProcedureName.InsertDisplayBuild, pars);
                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public OutputBase UpsertDisplayBuildExecution(DisplayBuildExecution displayBuildExecution)
        {
            OutputBase result = new OutputBase();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@SAPAccountNumber", displayBuildExecution.SAPAccountNumber),
                                        new SqlParameter("@GSN", displayBuildExecution.GSN),
                                        new SqlParameter("@PromotionID", displayBuildExecution.PromotionID),
                                        new SqlParameter("@DisplayBuildID", displayBuildExecution.DisplayBuildID),
                                        new SqlParameter("@BuildStatusID", displayBuildExecution.BuildStatusID),
                                        new SqlParameter("@DisplayLocationID", displayBuildExecution.DisplayLocationID),
                                        new SqlParameter("@DisplayTypeID", displayBuildExecution.DisplayTypeID),
                                        new SqlParameter("@BuildRefusalReasonID", displayBuildExecution.BuildRefusalReasonID),
                                        new SqlParameter("@ClientTime", displayBuildExecution.ClientTime),
                                        new SqlParameter("@ClientTimeZone", displayBuildExecution.ClientTimeZone),
                                        new SqlParameter("@ClientAppSource", displayBuildExecution.ClientAppSource),
                                        new SqlParameter("@Latitude", displayBuildExecution.Latitude),
                                        new SqlParameter("@Longitude", displayBuildExecution.Longitude),
                                        new SqlParameter("@BuildNote", displayBuildExecution.BuildNote),
                                        new SqlParameter("@ImageName", displayBuildExecution.ImageName),
                                        new SqlParameter("@RelativeURL", displayBuildExecution.RelativeURL),
                                        new SqlParameter("@AbsoluteURL", displayBuildExecution.AbsoluteURL),
                                        new SqlParameter("@StorageAccount", displayBuildExecution.StorageAccount),
                                        new SqlParameter("@Container", displayBuildExecution.Container),
                                       };
                result.ResponseStatus = this.ExecuteNonQuery(Constant.StoredProcedureName.UpsertBuildExecution, pars);
                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }
        #endregion

    }
}
