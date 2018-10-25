using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DPSG.Webapi.Merchandiser.Model;
using System.Data.SqlClient;
using DPSG.Webapi.Merchandiser.Modal;

namespace DPSG.Webapi.Merchandiser.DataServices
{
    public class PlanningDS : MerchandiserConnectionWrapper
    {
        public MerchBranchOutput GetMerchBranchesByGSNDS(MerchBranchInput branchInput)
        {
            try
            {

                List<MerchBranch> branchList = new List<MerchBranch>();
                List<MerchGroup> merchGroupList = new List<MerchGroup>();
                MerchBranchOutput obj = new MerchBranchOutput();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@GSN", branchInput.GSN)
                                         };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetMerchBranches, pars);

                if (reader != null)
                {
                    branchList = reader.GetResults<MerchBranch>().ToList();
                    merchGroupList = reader.GetResults<MerchGroup>().ToList();
                }
                obj.Branches = branchList;
                obj.MerchGroupList = merchGroupList;
                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public MerchGroupOutput InsertUpdateMerchGroupDetailsDS(MerchGroupInput pinput, string routesXML)
        {
            try
            {


                MerchGroupOutput obj = new MerchGroupOutput();
                obj.NewGroupID = 0;

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@SAPBranchID", pinput.SAPBranchID),
                                         new SqlParameter("@GroupID", pinput.MerchGroupID),
                                         new SqlParameter("@GroupName", pinput.GroupName),
                                         new SqlParameter("@DefaultOwnerGSN", pinput.DefaultOwnerGSN),
                                         new SqlParameter("@DefaultOwnerName", pinput.DefaultOwnerName),
                                         new SqlParameter("@GSN", pinput.GSN),
                                         new SqlParameter("@Routes",routesXML),
                                         new SqlParameter("@Mode", ""),
                                         new SqlParameter("@NewMerchGroupID",obj.NewGroupID){ Direction = System.Data.ParameterDirection.Output}

                                         };

                obj.Result = this.ExecuteNonQuery(Constants.Planning.StoredProcedures.InsertUpdateMerchGroup, pars);
                if (pinput.MerchGroupID == 0)
                    obj.NewGroupID = (int)pars[8].Value;

                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }


        public MerchGroupOutput DeleteMerchGroupDS(MerchGroupInput pinput)
        {
            try
            {


                MerchGroupOutput obj = new MerchGroupOutput();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@SAPBranchID", pinput.SAPBranchID),
                                         new SqlParameter("@GroupID", pinput.MerchGroupID)


                                         };

                obj.Result = this.ExecuteNonQuery(Constants.Planning.StoredProcedures.DeleteMerchGroup, pars);


                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }





        public MerchGroupCheckOutput ValidateForExistingMerchGroupDetailsDS(MerchGroupCheckInput pinput)
        {
            try
            {


                MerchGroupCheckOutput obj = new MerchGroupCheckOutput();
                obj.IsGroupNameExists = false;
                obj.IsRouteNameExists = false;


                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@SAPBranchID", pinput.SAPBranchID),
                                         new SqlParameter("@Name", pinput.Name),                                        
                                         new SqlParameter("@Mode", pinput.Mode),
                                         new SqlParameter("@IsGroupNameExists", obj.IsGroupNameExists){ Direction = System.Data.ParameterDirection.Output},
                                         new SqlParameter("@IsRouteNameExists", obj.IsRouteNameExists){ Direction = System.Data.ParameterDirection.Output}

                                         };

                obj.ReturnStatus = this.ExecuteNonQuery(Constants.Planning.StoredProcedures.CheckForGroupDetails, pars);
                if (pinput.Mode == "Group")
                    obj.IsGroupNameExists = (bool)pars[3].Value;

                if (pinput.Mode == "Route")
                    obj.IsRouteNameExists = (bool)pars[4].Value;

                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }


        public MerchGroups GetMerchGroupDetailsByBranchIDDS(MerchGroupsInput pinput)
        {
            try
            {


                MerchGroups obj = new MerchGroups();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@SAPBranchID", pinput.SAPBranchID)
                                         };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetMerchGroupDetailsByBranchID, pars);

                if (reader != null)
                {
                    obj.MerchGroupList = reader.GetResults<MerchGroup>().ToList();
                }

                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }


        public MerchGroupDetail GetMerchGroupDetailsByGroupIDDS(MerchGroupDetailInput pinput)
        {
            try
            {


                MerchGroupDetail obj = new MerchGroupDetail();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@SAPBranchID", pinput.SAPBranchID),
                                         new SqlParameter("@GroupID", pinput.MerchGroupID)
                                         };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetMerchGroupDetailsByGroupID, pars);

                if (reader != null)
                {
                    obj = reader.GetResults<MerchGroupDetail>().ToList().SingleOrDefault();
                    obj.Routes = reader.GetResults<MerchGroupRoute>().ToList();
                }

                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }


        public UsersOutput GetUserDetailsDS(string name)
        {
            try
            {


                UsersOutput obj = new UsersOutput();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@Name", name)
                                         };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetUserDetails, pars);

                if (reader != null)
                {
                    obj.Users = reader.GetResults<User>().ToList();
                }

                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        //Start of Store-SetUp Methods
        public StoresOutput GetStoresLookUpBySAPBranchIDDS(StoreLookupInput pinput)
        {
            try
            {


                StoresOutput obj = new StoresOutput();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@SAPBranchID", pinput.SAPBranchID),
                                         new SqlParameter("@MerchGroupID", pinput.MerchGroupID),
                                         new SqlParameter("@SearchName", pinput.SearchName)
                                         };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetStoresLookup, pars);

                if (reader != null)
                {
                    obj.Stores = reader.GetResults<StoreInfo>().ToList();
                }

                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }


        public StoresOutput GetStoresByMerchGroupIDDS(StoreListInput pinput)
        {
            try
            {


                StoresOutput obj = new StoresOutput();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@SAPBranchID", pinput.SAPBranchID),
                                        new SqlParameter("@MerchGroupID", pinput.MerchGroupID)
                                         };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetStoresByMerchGroupID, pars);

                if (reader != null)
                {
                    obj.Stores = reader.GetResults<StoreInfo>().ToList();
                }

                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public StoreSetupDetailContainer GetStoreDetailsBySAPAccountNumberDS(Int64 sapAccountNumber)
        {
            try
            {

                StoreSetupDetailContainer container = new StoreSetupDetailContainer();
                RouteInfo obj = new RouteInfo();
                StoreInfo info = new StoreInfo();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@SAPAccountNumber", sapAccountNumber)

                                         };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetStoreDetailsByAcctNumber, pars);

                if (reader != null)
                {

                    info = reader.GetResults<StoreInfo>().FirstOrDefault();
                    obj = reader.GetResults<RouteInfo>().FirstOrDefault();
                    container.WeekDays = reader.GetResults<StoreSetupDOW>().ToList();
                    container.StoreDetail = info;
                    container.Detail = obj;

                }

                return container;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }


        public RouteOutput GetRoutesByMerchGroupIDDS(StoreListInput pinput)
        {
            try
            {
                RouteOutput obj = new RouteOutput();
                this.CreateSession();
                SqlParameter[] pars = {   new SqlParameter("@SAPBranchID", pinput.SAPBranchID),
                                         new SqlParameter("@MerchGroupID", pinput.MerchGroupID) };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetRoutesByMerchGroup, pars);

                if (reader != null)
                {
                    obj.Routes = reader.GetResults<RouteInfo>().ToList();
                }

                return obj;
            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public StoreSetUpDetailOutput InsertUpdateStoreSetupDetailsDS(StoreSetUpDetailInput pinput)
        {
            try
            {
                StoreSetUpDetailOutput obj = new StoreSetUpDetailOutput();
                this.CreateSession();
                SqlParameter[] pars = {   new SqlParameter("@SAPBranchID", pinput.SAPBranchID),
                                         new SqlParameter("@MerchGroupID", pinput.MerchGroupID),
                                         new SqlParameter("@SAPAccountNumber", pinput.SAPAccountNumber),
                                         new SqlParameter("@DefaultRouteID", pinput.DefaultRouteID),
                                         new SqlParameter("@WeekDays", pinput.WeekDaysXML),
                                         new SqlParameter("@GSN", pinput.GSN)};


                obj.Result = this.ExecuteNonQuery(Constants.Planning.StoredProcedures.InsertStoreSetup, pars);

                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }


        public StoreSetupContainer GetStoreSetUpContainerDS(StoreListInput input)
        {
            try
            {

                StoreSetupContainer container = new StoreSetupContainer();
                RouteInfo obj = new RouteInfo();
                StoreInfo info = new StoreInfo();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@SAPBranchID", input.SAPBranchID),
                                        new SqlParameter("@MerchGroupID", input.MerchGroupID)

                                         };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetStoreSetupContainer, pars);

                if (reader != null)
                {
                    container.Stores = reader.GetResults<StoreInfo>().ToList();
                    container.Routes = reader.GetResults<RouteInfo>().ToList();

                    info = reader.GetResults<StoreInfo>().FirstOrDefault();

                    obj = reader.GetResults<RouteInfo>().FirstOrDefault();

                    container.WeekDays = reader.GetResults<StoreSetupDOW>().ToList();
                    container.StoreDetail = info;
                    container.RouteDetail = obj;

                }



                return container;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }


        public MerchSetupContainer GetMerchSetupContainerDS(MerchListInput minput)
        {
            try
            {
                MerchSetupContainer container = new MerchSetupContainer();
                

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@SAPBranchID", minput.SAPBranchID),
                                         new SqlParameter("@MerchGroupID", minput.MerchGroupID)
                                      };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetMerchSetupContainer, pars);

                if (reader != null)
                {
                    container.MerchUsers = reader.GetResults<MerchInfo>().ToList();
                    container.Routes = reader.GetResults<RouteData>().ToList();                  
                    container.MerchUser = reader.GetResults<MerchInfo>().FirstOrDefault();
                    container.Route = reader.GetResults<RouteData>().FirstOrDefault();
                    container.RoutesAll = reader.GetResults<RouteData>().ToList();
                }

                return container;
            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public RouteDataContainer GetRoutesByDayDS(RoutesByDayInput minput)
        {
            try
            {
                RouteDataContainer container = new RouteDataContainer();


                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@SAPBranchID", minput.SAPBranchID),
                                         new SqlParameter("@MerchGroupID", minput.MerchGroupID),
                                         new SqlParameter("@DayOfWeek", minput.DayOfWeek)
                                      };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetRoutesByDay, pars);

                if (reader != null)
                {
                    container.Routes = reader.GetResults<RouteData>().ToList();
                }

                return container;
            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public RouteDataContainer GetAvailableDefaultRoutesDS(MerchListInput minput)
        {
            try
            {
                RouteDataContainer container = new RouteDataContainer();


                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@SAPBranchID", minput.SAPBranchID),
                                         new SqlParameter("@MerchGroupID", minput.MerchGroupID)
                                      };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetAvailableDefaultRoutes, pars);

                if (reader != null)
                {
                    container.Routes = reader.GetResults<RouteData>().ToList();
                }

                return container;
            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public MerchDetailContainer GetMerchDetailContainerByGSNDS(string GSN)
        {
            try
            {
                MerchDetailContainer container = new MerchDetailContainer();
                MerchInfo userInfo = new MerchInfo();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@GSN", GSN)

                                      };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetMerchDetailContainerByGSN, pars);

                if (reader != null)
                {
                    container.MerchUser = reader.GetResults<MerchInfo>().FirstOrDefault();
                    container.Route = reader.GetResults<RouteData>().FirstOrDefault();
                }

                return container;
            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }

        }

      
        public MerchSetupDetailOutput InsertUpdateMerchSetupDetailDS(MerchSetupDetailInput pinput, string dayOfWeek)
        {
            try
            {
                MerchSetupDetailOutput obj = new MerchSetupDetailOutput();
                this.CreateSession();
                SqlParameter[] pars = {
                                        new SqlParameter("@GSN", pinput.GSN),
                                        new SqlParameter("@FirstName", pinput.FirstName),
                                        new SqlParameter("@LastName", pinput.LastName),                                        
                                        new SqlParameter("@DefaultRouteID", pinput.DefaultRouteID),
                                        new SqlParameter("@MerchGroupID", pinput.MerchGroupID),
                                        new SqlParameter("@Phone", pinput.Phone),
                                        new SqlParameter("@Mon", pinput.Mon),
                                        new SqlParameter("@Tues", pinput.Tues),
                                        new SqlParameter("@Wed", pinput.Wed),
                                        new SqlParameter("@Thu", pinput.Thu),
                                        new SqlParameter("@Fri", pinput.Fri),
                                        new SqlParameter("@Sat", pinput.Sat),
                                        new SqlParameter("@Sun", pinput.Sun),
                                        new SqlParameter("@DayOfWeek", dayOfWeek),
                                        new SqlParameter("@LastModifiedBy", pinput.LastModifiedBy)
                                    };


                obj.Result = this.ExecuteNonQuery(Constants.Planning.StoredProcedures.InsertUpdateMerchDetail, pars);

                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public UsersOutput GetMerchUserDetailsDS(string name)
        {
            try
            {
                UsersOutput obj = new UsersOutput();
                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@Name", name)
                                         };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetMerchUserDetails, pars);

                if (reader != null)
                {
                    obj.Users = reader.GetResults<User>().ToList();
                }

                return obj;

            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public StoreDeleteOutput DeleteStoreDS(StoreDeleteInput sinput)
        {
            try
            {
                StoreDeleteOutput obj = new StoreDeleteOutput();

                this.CreateSession();
                SqlParameter[] pars = {
                    new SqlParameter("@SAPAccountNumber", sinput.SAPAccountNumber),
                    new SqlParameter("@MerchGroupID", sinput.MerchGroupID),
                    new SqlParameter("@GSN", sinput.GSN),
                };

                obj.Result = this.ExecuteNonQuery(Constants.Planning.StoredProcedures.DeleteStore, pars);
                return obj;
            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public RouteDeleteOutput DeleteRouteDS(RouteDeleteInput sinput)
        {
            try
            {
                RouteDeleteOutput obj = new RouteDeleteOutput();

                this.CreateSession();
                SqlParameter[] pars = {
                    new SqlParameter("@RouteID", sinput.RouteID),
                    new SqlParameter("@MerchGroupID", sinput.MerchGroupID),
                    new SqlParameter("@GSN", sinput.GSN),
                };

                obj.Result = this.ExecuteNonQuery(Constants.Planning.StoredProcedures.DeleteRoute, pars);
                return obj;
            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public RemoveStoreWarning DeleteStoreWarningDS(StoreDeleteInput sinput)
        {
            try
            {
                RemoveStoreWarning obj = new RemoveStoreWarning();

                this.CreateSession();
                SqlParameter[] pars = {
                    new SqlParameter("@SAPAccountNumber", sinput.SAPAccountNumber),
                    new SqlParameter("@MerchGroupID", sinput.MerchGroupID)
                };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetStoreDeleteWarnings, pars);

                if (reader != null)
                {
                    obj.PlanChanges = reader.GetResults<ImpactedPlan>().ToList();
                    obj.DispatchChanges = reader.GetResults<ImpactedDipatch>().ToList();
                }

                return obj;
            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public DeleteRouteWarning DeleteRouteWarningDS(RouteDeleteInput sinput)
        {
            try
            {
                DeleteRouteWarning obj = new DeleteRouteWarning();

                this.CreateSession();
                SqlParameter[] pars = {
                    new SqlParameter("@RouteID", sinput.RouteID),
                    new SqlParameter("@MerchGroupID", sinput.MerchGroupID)
                };

                SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetRouteDeleteWarnings, pars);

                if (reader != null)
                {
                    obj.DispatchChanges = reader.GetResults<DeleteRouteDispatchImpact>().ToList();
                }

                return obj;
            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public MerchDeleteOutput DeleteMerchDS(MerchDeleteInput merch)
        {
            try
            {
                MerchDeleteOutput obj = new MerchDeleteOutput();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@GSN", merch.GSN)
                                         };

                obj.Result = this.ExecuteNonQuery(Constants.Planning.StoredProcedures.DeleteMerch, pars);
                return obj;
            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }
    }
}
