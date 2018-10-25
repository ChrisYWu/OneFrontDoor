using DPSG.Webapi.Merchandiser.Modal;
using DPSG.Webapi.Merchandiser.Model;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.DataServices
{
   public class RouteStoreAssignDS : MerchandiserConnectionWrapper
    {
        public RSOutput GetRSDetailByWeekDayDS(RSInput rsInput)
        {
            try
            {
                RSOutput returnObj = new RSOutput();
                List<RouteStoreRawData> rsList = new List<RouteStoreRawData>();
                List<RouteTile> objMercList = new List<RouteTile>();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@MerchGroupID", rsInput.MerchGroupID),
                                         new SqlParameter("@WeekDay",rsInput.WeekDay)
                                      };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetRouteStoreDetailByWeekDay, pars);

                if (reader != null)
                {
                    rsList = reader.GetResults<RouteStoreRawData>().ToList();
                    foreach (var v in rsList)
                    {
                        var v1 = objMercList.FirstOrDefault(c => c.RouteID == v.RouteID);
                        if (v1 == null)
                        {
                            v1 = new RouteTile()
                            {
                                RouteID = v.RouteID,
                                RouteName = v.RouteName,
                                MerchGroupID = v.MerchGroupID,
                                Stores = new List<Account>()
                            };
                            objMercList.Add(v1);
                        }
                        v1.Stores.Add(new Account()
                        {
                            AccountID = v.SAPAccountNumber,
                            AccountName = v.Accountname,
                            Sequence = v.Sequence
                        });
                    }
                    returnObj.RoutesTile = objMercList;

                    returnObj.Routes = reader.GetResults<RouteDetail>().ToList();
                    returnObj.UnassignedStores = reader.GetResults<Store>().ToList();
                    returnObj.AllStores = reader.GetResults<Store>().ToList();
                }
                
                return returnObj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public StoreWeekDayOutput InsertStoreWeekday(StoreWeekDayInput sinput)
        {
            try
            {

                this.CreateSession();
                StoreWeekDayOutput obj = new StoreWeekDayOutput();

                SqlParameter[] pars = {  new SqlParameter("@MerchGroupID", sinput.MerchGroupID),
                                         new SqlParameter("@Weekday", sinput.Weekday),
                                         new SqlParameter("@RouteID", sinput.RouteID),
                                         new SqlParameter("@SAPAccountNumber", sinput.SAPAccountNumber),
                                         new SqlParameter("@LastModifiedBy", sinput.LastModifiedBy)
                };

                obj.Result = this.ExecuteNonQuery(Constants.Planning.StoredProcedures.InsertStoreWeekday, pars);
                return obj;

            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            { this.CloseSession(); }

        }

        public StoreContainer GetStoreListDS(int merchGroupId, int weekDay)
        {
            StoreContainer container = new StoreContainer();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@MerchGroupID", merchGroupId),
                                         new SqlParameter("@WeekDay",weekDay)};
                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetStoresForAssignment, pars);

                if (reader != null)
                {
                    container.UnassignedStores = reader.GetResults<Store>().ToList();                    
                    container.AllStores = reader.GetResults<Store>().ToList();
                }
            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }

            return container;
        }

        public RoutesList GetRoutesDS(RouteInput rl)
        {
            try
            {
                RoutesList output = new RoutesList();

                this.CreateSession();

                SqlParameter[] pars = {     new SqlParameter("@MerchGroupID", rl.MerchGroupID),
                                            new SqlParameter("@WeekDay", rl.WeekDay)};

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetRoutesByWeekDay, pars);

                if (reader != null)
                {
                    output.Routes = reader.GetResults<RouteDetail>().ToList();
                }

                return output;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public StoreWeekDayOutput ReassignStorebyWeekDayDS(ReassignStoreInputData pinput)
        {
            try
            {
                this.CreateSession();
                StoreWeekDayOutput obj = new StoreWeekDayOutput();

                SqlParameter[] pars = {  new SqlParameter("@MerchGroupID", pinput.MerchGroupID),
                                         new SqlParameter("@WeekDay", pinput.WeekDay),
                                         new SqlParameter("@TargetRouteID", pinput.TargetRouteID),
                                         new SqlParameter("@SourceRouteID", pinput.SourceRouteID),
                                         new SqlParameter("@SAPAccountNumber", pinput.SAPAccountNumber),
                                         new SqlParameter("@LastModifiedBy", pinput.LastModifiedBy),
                                         new SqlParameter("@Sequence", pinput.Sequence)
                };

                obj.Result = this.ExecuteNonQuery(Constants.Planning.StoredProcedures.ReassignStorebyWeekDay, pars);
                return obj;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            { this.CloseSession(); }
        }

        public StoreWeekDayOutput RemoveStoreByWeekDayDS(RemoveStoreInputData input)
        {
            try
            {
                StoreWeekDayOutput obj = new StoreWeekDayOutput();

                this.CreateSession();

                SqlParameter[] pars = {
                                         new SqlParameter("@WeekDay", input.WeekDay),
                                         new SqlParameter("@RouteID", input.RouteID),
                                         new SqlParameter("@Sequence", input.Sequence),
                                         new SqlParameter("@LastModifiedBy", input.LastModifiedBy) };
                obj.Result = this.ExecuteNonQuery(Constants.Planning.StoredProcedures.RemoveStoreByWeekDay, pars);

                return obj;

            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public StoreWeekDayOutput UpdateStoreSequenceDS(StoreResequenceInput input)
        {
            try
            {
                StoreWeekDayOutput obj = new StoreWeekDayOutput();
                this.CreateSession();

                SqlParameter[] pars = {new SqlParameter("@WeekDay", input.WeekDay),
                                         new SqlParameter("@RouteID", input.RouteID),
                                         new SqlParameter("@MoveFromSequence", input.MoveFrom),
                                         new SqlParameter("@MoveToSequence", input.MoveTo),
                                         new SqlParameter("@LastModifiedBy", input.LastModifiedBy) };
                obj.Result = this.ExecuteNonQuery(Constants.Planning.StoredProcedures.UpdateStoreSequence, pars);

                return obj;

            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }
    }
}
