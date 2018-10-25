
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Webapi.Merchandiser.Model;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.DataServices
{
    public class DispatchDS : MerchandiserConnectionWrapper
    {

        public async Task<DispatchRawDataOutput> GetDispatchesDS(int merchGroupId, DateTime dispatchDate, string lastModifiedBy, bool reset, int timeZoneOffsetToUTC)
        {
            try
            {
            
                List<DispatchRawData> output = new List<DispatchRawData>();

                DispatchRawDataOutput obj = new DispatchRawDataOutput();

                int? scheduleDateCount = 0;


                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@MerchGroupID", merchGroupId),
                                         new SqlParameter("@DispatchDate",dispatchDate),
                                         new SqlParameter("@GSN", lastModifiedBy),
                                         new SqlParameter("@TimeZoneOffsetToUTC", timeZoneOffsetToUTC),
                                         new SqlParameter("@Reset", reset)
                };
                SDMReader reader = await this.ExecuteReaderAsync(Constants.Dispatch.StoredProcedures.GetPreDispatch, pars);
                if (reader != null)
                {
                    output = reader.GetResults<DispatchRawData>().ToList();
                    scheduleDateCount = reader.GetResults<int?>().FirstOrDefault();
                }
                
                obj.DisplayTabularData = output;
                obj.ScheduleDateCount = scheduleDateCount;


                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public DispatchOutput InsertStorePredispatchDS(StorePredispatch sp)
        {
            try
            {
               
                this.CreateSession();
                DispatchOutput obj = new DispatchOutput();

                SqlParameter[] pars = {  new SqlParameter("@MerchGroupID", sp.MerchGroupID),
                                         new SqlParameter("@DispatchDate", sp.DispatchDate),
                                         new SqlParameter("@GSN", sp.GSN),
                                         new SqlParameter("@RouteID", sp.RouteID),
                                         new SqlParameter("@SAPAccountNumber", sp.SAPAccountNumber),
                                         new SqlParameter("@LastModifiedBy", sp.LastModifiedBy)
                };

                obj.Result = this.ExecuteNonQuery(Constants.Dispatch.StoredProcedures.InsertStorePredispatch, pars);
                return obj;

            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            { this.CloseSession(); }
        }

        public DispatchOutput UpdateSequenceDS(ResequenceInput sp)
        {
            try
            {
                DispatchOutput obj = new DispatchOutput();



                this.CreateSession();

                SqlParameter[] pars = {new SqlParameter("@DispatchDate", sp.DispatchDate),
                                         new SqlParameter("@RouteID", sp.RouteID),
                                         new SqlParameter("@MoveFromSequence", sp.MoveFrom),
                                         new SqlParameter("@MoveToSequence", sp.MoveTo),
                                         new SqlParameter("@LastModifiedBy", sp.LastModifiedBy) };
                obj.Result = this.ExecuteNonQuery(Constants.Dispatch.StoredProcedures.ReSequenceStore, pars);
                
                return obj;
                
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public DispatchOutput RemoveStoreDS(RemoveStoreInput sp)
        {
            try
            {
                DispatchOutput obj = new DispatchOutput();
                
                this.CreateSession();

                SqlParameter[] pars = {new SqlParameter("@DispatchDate", sp.DispatchDate),
                                         new SqlParameter("@RouteID", sp.RouteID),
                                         new SqlParameter("@Sequence", sp.Sequence),
                                         new SqlParameter("@LastModifiedBy", sp.LastModifiedBy) };
                obj.Result = this.ExecuteNonQuery(Constants.Dispatch.StoredProcedures.RemoveStoreFromPreDispatch, pars);

                return obj;

            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public async Task<RouteList> GetRoutesDS(RouteListExcludeCurrentInput rl)
        {
            try
            {
                RouteList output = new RouteList();

                this.CreateSession();

                SqlParameter[] pars = {     new SqlParameter("@MerchGroupID", rl.MerchGroupID),
                                            new SqlParameter("@DispatchDate", rl.DispatchDate),
                                            new SqlParameter("@RouteID", rl.RouteID)
                };

                SDMReader reader = await this.ExecuteReaderAsync(Constants.Dispatch.StoredProcedures.GetRoutesByDispatchDateGroupForReassign, pars);

                if (reader != null)
                {
                    output.Routes = reader.GetResults<Route>().ToList();
                }

                return output;


            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }
        public StoresContainer GetStoresDS(int merchGroupId, DateTime dispatchDate)
        {
            StoresContainer container = new StoresContainer();
            try
            {

                

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@MerchGroupID", merchGroupId),
                                         new SqlParameter("@DispatchDate",dispatchDate)};
                SDMReader reader = this.ExecuteReader(Constants.Dispatch.StoredProcedures.GetStores, pars);

                if (reader != null)
                {
                    container.UnassignedStores = reader.GetResults<Store>().ToList();
                    container.OtherStores = reader.GetResults<Store>().ToList();
                    container.AllStores = reader.GetResults<Store>().ToList();
                }

                


            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }

            return container;
        }

        public StoresContainer GetStoresUnassignedDS(int merchGroupId, DateTime dispatchDate)
        {
            StoresContainer container = new StoresContainer();
            try
            {



                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@MerchGroupID", merchGroupId),
                                         new SqlParameter("@DispatchDate",dispatchDate)};
                SDMReader reader = this.ExecuteReader(Constants.Dispatch.StoredProcedures.GetStoresUnassigned, pars);

                if (reader != null)
                {
                    container.UnassignedStores = reader.GetResults<Store>().ToList();
                }




            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }

            return container;
        }


        public MerchListContainer GetMerchListDS(int merchGroupId, DateTime dispatchDate)
        {
            MerchListContainer container = new MerchListContainer();
            try
            {



                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@MerchGroupID", merchGroupId),
                                         new SqlParameter("@DispatchDate",dispatchDate)};
                SDMReader reader = this.ExecuteReader(Constants.Dispatch.StoredProcedures.GetAvailableMerch, pars);

                if (reader != null)
                {
                    container.UnassignedMerchandiser = reader.GetResults<MerchandiserContainer>().ToList();
                    container.OtherUnassignedMerchandiser = reader.GetResults<MerchandiserContainer>().ToList();
                    
                }
                

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }

            return container;
        }

        public DispatchOutput ReassignMerchandiserDS(ReassignMerchInput sp)
        {
            try
            {
                DispatchOutput obj = new DispatchOutput();

                this.CreateSession();

                SqlParameter[] pars = {new SqlParameter("@MerchGroupID", sp.MerchGroupID),
                                       new SqlParameter("@DispatchDate", sp.DispatchDate),
                                       new SqlParameter("@GSN", sp.GSN),
                                       new SqlParameter("@RouteID", sp.RouteID),
                                       new SqlParameter("@LastModifiedBy", sp.LastModifiedBy) };
                obj.Result = this.ExecuteNonQuery(Constants.Dispatch.StoredProcedures.UpdateMerchRoutePredispatch, pars);

                return obj;

            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public DispatchReadyContainer DispatchReadyDS(DispatchInput sp)
        {

            DispatchReadyContainer container = new DispatchReadyContainer();

            try
            {

                this.CreateSession();

                SqlParameter[] pars = {new SqlParameter("@MerchGroupID", sp.MerchGroupID),
                                       new SqlParameter("@DispatchDate", sp.DispatchDate)
                                     };

                SDMReader reader = this.ExecuteReader(Constants.Dispatch.StoredProcedures.GetDispatchUpdates, pars);
                if (reader != null)
                {
                    container.DispatchReadyListItems = reader.GetResults<DispatchReady>().ToList();

                }



            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }

            return container;
        }

        public DispatchResultsContainer DispatchFinalDS(DispatchFinalInput sp)
        {

            DispatchResultsContainer container = new DispatchResultsContainer();
            
            try
            {

                this.CreateSession();

                SqlParameter[] pars = {new SqlParameter("@MerchGroupID", sp.MerchGroupID),
                                        new SqlParameter("@DispatchNote", sp.DispatchNote),
                                       new SqlParameter("@DispatchDate", sp.DispatchDate),
                                       new SqlParameter("@ReleaseBy", sp.ReleaseBy)
                                     };

                SDMReader reader = this.ExecuteReader(Constants.Dispatch.StoredProcedures.FinalDispatch, pars);
                if (reader != null)
                {
                    container.DispatchFinalResult = reader.GetResults<DispatchFinalResult>().ToList();
                }



            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }

            return container;
        }

        public DispatchHistoryContainer GetDispatchHistoryDS(RouteListInput rl)
        {
            DispatchHistoryContainer container = new DispatchHistoryContainer();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@MerchGroupID", rl.MerchGroupID),
                                         new SqlParameter("@DispatchDate",rl.DispatchDate)};
                SDMReader reader = this.ExecuteReader(Constants.Dispatch.StoredProcedures.GetDispatchHistory, pars);

                if (reader != null)
                {
                    container.DispatchHistory = reader.GetResults<DispatchHistory>().ToList();
                }

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }

            return container;
        }


        public async Task<ScheduleStatusOutput> GetScheduleStatusDS(int merchGroupId, DateTime dispatchDate)
        {
            try
            {

                ScheduleStatusOutput obj = new ScheduleStatusOutput();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@MerchGroupID", merchGroupId),
                                         new SqlParameter("@DispatchDate",dispatchDate)
                };
                SDMReader reader = await this.ExecuteReaderAsync(Constants.Dispatch.StoredProcedures.GetScheduleStatus, pars);
                if (reader != null)
                {
                    obj = reader.GetResults<ScheduleStatusOutput>().FirstOrDefault();
                }

                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

    }
}
