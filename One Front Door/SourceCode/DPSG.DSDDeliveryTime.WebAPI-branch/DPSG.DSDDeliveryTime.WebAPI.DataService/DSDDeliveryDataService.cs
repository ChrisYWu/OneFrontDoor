using DPSG.DSDDeliveryTime.WebAPI.Model;
//using DPSG.DSDDeliveryTime.WebAPI.Model.Input;
using DPSG.DSDDeliveryTime.WebAPI.Model.Output;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DPSG.DSDDeliveryTime.WebAPI.DataService2;

namespace DPSG.DSDDeliveryTime.WebAPI.DataService
{
    public class DSDDeliveryDataService : DSDDeliveryConnectionWrapper
    {
        #region All HttpGet methods
        public List<DriverRoute> GetNonBreakRoutesForToday(bool inverse)
        {
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@Inverse", inverse) };
                return this.ExecuteReader<DriverRoute>(Constant.StoredProcedureName.GetNonBreakRouteForToday, pars).ToList();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public List<DeliveryStop> GetDeliveryPlan(string RouteNumber, string TimeZone, DateTime? DeliveryDate, bool IncludeBreakRoutes = false)
        {
            if (DeliveryDate == null)
            {
                DeliveryDate = DateTime.Today;
            }

            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@RouteNumber", RouteNumber),
                    new SqlParameter("@TimeZone", TimeZone),
                    new SqlParameter("@DeliveryDate", DeliveryDate),
                    new SqlParameter("@IncludeBreakRoutes", IncludeBreakRoutes) };
                return this.ExecuteReader<DeliveryStop>(Constant.StoredProcedureName.GetDriverDeliveryPlan, pars).ToList();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public List<DriverDelivery> GetDeliveryByRoute(string RouteNumber, DateTime? DeliveryDate)
        {
            if (DeliveryDate == null)
            {
                DeliveryDate = DateTime.Today;
            }

            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@RouteNumber", RouteNumber),
                    new SqlParameter("@DeliveryDate", DeliveryDate)};
                return this.ExecuteReader<DriverDelivery>(Constant.StoredProcedureName.GetDeliveryByRoute, pars).ToList();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public List<StoreDelivery> GetDeliveryByCustomerNumbers(DPSG.DSDDeliveryTime.WebAPI.Model.Input.CustomerNumberInput input)
        {
            if ( input.DeliveryDate == null)
            {
                input.DeliveryDate = DateTime.Today;
            }

            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@CustomerNumbers", input.CustomerNumbers),
                    new SqlParameter("@DeliveryDate", input.DeliveryDate)};
                return this.ExecuteReader<StoreDelivery>(Constant.StoredProcedureName.GetDeliveryByCustomerNumbers, pars).ToList();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }
        #endregion

        #region All HttpPost methods
        public void InsertWebAPILog(WebAPILog objServiceLog)
        {
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@ServiceName", objServiceLog.ServiceName),
                                        new SqlParameter("@OperationName", objServiceLog.OperationName),
                                        new SqlParameter("@ModifiedDate", objServiceLog.ModifiedDate),
                                        new SqlParameter("@GSN", objServiceLog.GSN),
                                        new SqlParameter("@Type", objServiceLog.Type),
                                        new SqlParameter("@Exception", objServiceLog.Exception),
                                        new SqlParameter("@GUID", objServiceLog.GUID),
                                        new SqlParameter("@ComputerName", objServiceLog.ComputerName),
                                        new SqlParameter("@UserAgent", objServiceLog.UserAgent)
                                       };
                int result = this.ExecuteNonQuery(Constant.StoredProcedureName.InsertWebAPILog, pars);

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally { this.CloseSession(); }
        }

        public OutputBase UpdateDeliveryTime(Model.Input.DeliveryTimeUpdates updates)
        {
            DateTime start = DateTime.Now;

            if (updates.RouteNumber == "110802201")
                updates.DeliveryDate = DateTime.Today;

            OutputBase result = new OutputBase();
            try
            {
                using (DeliveryDBContainer db = new DeliveryDBContainer())
                {
                    var del = db.Deliveries.Where(c => updates.DeliveryDate == c.DeliveryDate && updates.RouteNumber == c.RouteNumber);

                    DateTime read = DateTime.Now;
                    bool anyChangeMade = false;

                    foreach (var d in del)
                    {
                        var input = updates.DeliveryStops.SingleOrDefault(c => c.StopID == d.StopID && c.StopSequence == d.StopSequence);
                        if (input != null)
                        {
                            bool changemade = false;

                            if (input.ActualArrivalTime != null)
                            {
                                d.ActualArrivalTime = input.ActualArrivalTime;
                                d.ActualArrivalTimeZone = input.ActualArrivalTimeZone;
                                changemade = true;
                            }

                            if (input.ActualDepartureTime != null)
                            {
                                d.ActualDepartureTime = input.ActualDepartureTime;
                                d.ActualDepartureTimeZone = input.ActualDepartureTimeZone;
                                changemade = true;
                            }

                            if (input.EstimatedArrivalTime != null)
                            {
                                d.EstimatedArrivalTime = input.EstimatedArrivalTime;
                                d.EstimatedArrivalTimeZone = input.EstimatedArrivalTimeZone;
                                changemade = true;
                            }

                            if (changemade)
                            {
                                d.LastUpdatedTimeUTC = DateTime.UtcNow;
                                d.LastUpdatedDriverID = updates.DriverID;
                                d.LastUpdatedBy = updates.GSN;
                                anyChangeMade = true;
                            }
                        }
                    }
                    DateTime matching = DateTime.Now;

                    if (anyChangeMade)
                    {
                        db.SaveChanges();
                    }

                    DateTime end = DateTime.Now;
                    result.Information = "Total Processing Time = " + (end - start).TotalMilliseconds.ToString() + " milli seconds";
                    result.Information += Environment.NewLine;
                    result.Information += "Fetching Time = " + (read - start).TotalMilliseconds.ToString() + " milli seconds";
                    result.Information += Environment.NewLine;
                    result.Information += "Matching Time = " + (matching - read).TotalMilliseconds.ToString() + " milli seconds";
                    result.Information += Environment.NewLine;
                    result.Information += "Update Time = " + (end - matching).TotalMilliseconds.ToString() + " milli seconds";

                    return result;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public OutputBase ResetRoute(string RouteNumber, DateTime? DeliveryDate)
        {
            DateTime start = DateTime.Now;

            OutputBase result = new OutputBase();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@RouteNumber", RouteNumber),
                    new SqlParameter("@DeliveryDate", DeliveryDate)};

                this.ExecuteNonQuery(Constant.StoredProcedureName.ResetRoute, pars);
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
