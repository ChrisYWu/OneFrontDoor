using DPSG.DSDDeliveryService.MyDay.WebAPI.Model;
using DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Input;
using DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Output;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.DataService
{
    public class DeliveryDataService : MerchConnectionWrapper
    {
        #region All Merch HttpGet methods
        public MasterLists GetMaster()
        {
            MasterLists output = new MasterLists();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { };
                MerchReader reader = this.ExecuteReader(StoredProcedureName.GetMaster, pars);

                output.FarawayReasons = reader.GetResults<FarawayReason>().ToList();
                output.ResequenceReasons = reader.GetResults<ResequenceReason>().ToList();
                return output;

            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public DeliveryManifest GetDeliveryManifest(int RouteID, DateTime? DeliveryDateUTC = null)
        {
            DeliveryManifest output = new DeliveryManifest();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@RouteID", RouteID),
                                        new SqlParameter("@DeliveryDateUTC", DeliveryDateUTC),
                                        };
                MerchReader reader = this.ExecuteReader(StoredProcedureName.GetDeliveryManifest, pars);

                var v = reader.GetResults<ManifestHeader>().ToList();
                if (v.Count == 1)
                {
                    output.Header = v[0];
                }
                else
                {
                    output.Header = null;
                }
                output.Stops = reader.GetResults<DeliveryStop>().ToList();
                return output;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }


        #endregion

        #region Post
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
                                        new SqlParameter("@CorrelationID", objServiceLog.CorrelationID),
                                        new SqlParameter("@GUID", objServiceLog.GUID),
                                        new SqlParameter("@ComputerName", objServiceLog.ComputerName),
                                        new SqlParameter("@UserAgent", objServiceLog.UserAgent),
                                        new SqlParameter("@Json", objServiceLog.Json)
                                       };
                int result = this.ExecuteNonQuery(StoredProcedureName.InsertWebAPILog, pars);

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally { this.CloseSession(); }
        }

        public OutputBase UploadRouteCheckout(RouteCheckout routeCheckOut)
        {
            OutputBase result = new OutputBase();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@RouteID", routeCheckOut.RouteID),
                                        new SqlParameter("@DeliveryDateUTC", routeCheckOut.DeliveryDateUTC),
                                        new SqlParameter("@ActualStartTime", routeCheckOut.ActualStartTime),
                                        new SqlParameter("@ActualStartGSN", routeCheckOut.ActualStartGSN),
                                        new SqlParameter("@FirstName", routeCheckOut.FirstName),
                                        new SqlParameter("@LastName", routeCheckOut.LastName),
                                        new SqlParameter("@PhoneNumber", routeCheckOut.PhoneNumber),
                                        new SqlParameter("@Latitude", routeCheckOut.Latitude),
                                        new SqlParameter("@Longitude", routeCheckOut.Longitude),
                                        new SqlParameter("@LastModifiedUTC", routeCheckOut.LastModifiedUTC)
                                       };
                result.ResponseStatus = this.ExecuteNonQuery(StoredProcedureName.UploadRouteCheckout, pars);
                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public OutputBase InsertMeshMyDayLog(MyDayLog log)
        {
            OutputBase result = new OutputBase();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@WebEndPoint", log.WebEndPoint),
                                        new SqlParameter("@CorrelationID", log.CorrelationID),
                                        new SqlParameter("@StoredProc", log.StoredProc),
                                        new SqlParameter("@GetParameters", log.GetParameters),
                                        new SqlParameter("@PostJson", log.PostJson),
                                        new SqlParameter("@GSN", log.GSN),
                                        new SqlParameter("@DeliveryDateUTC", log.DeliveryDateUTC),
                                        new SqlParameter("@RouteID", log.RouteID)
                                       };
                result.ResponseStatus = this.ExecuteNonQuery(StoredProcedureName.InsertMeshMyDayLog, pars);
                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public OutputBase DeleteStop(int deliveryStopID)
        {
            try
            {
                this.CreateSession();
                return DeleteOneStop(deliveryStopID);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        private OutputBase DeleteOneStop(int deliveryStopID)
        {
            OutputBase result = new OutputBase();

            SqlParameter[] pars = { new SqlParameter("@DeliveryStopID", deliveryStopID) };
            result.ResponseStatus = this.ExecuteNonQuery(StoredProcedureName.DeleteStop, pars);
            return result;
        }

        public DeliveryStopAdded UploadAddedStop(AddedStop obj)
        {
            try
            {
                this.CreateSession();
                return AddOneStop(obj);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally { this.CloseSession(); }
        }

        private DeliveryStopAdded AddOneStop(AddedStop obj)
        {
            SqlParameter[] pars = { new SqlParameter("@RouteID", obj.RouteID),
                                        new SqlParameter("@Servicetime", obj.Servicetime),
                                        new SqlParameter("@DeliveryDateUTC", obj.DeliveryDateUTC),
                                        new SqlParameter("@StopType", obj.StopType),
                                        new SqlParameter("@SAPAccountNumber", obj.SAPAccountNumber),
                                        new SqlParameter("@Quantity", obj.Quantity),
                                        new SqlParameter("@LastModifiedBy", obj.LastModifiedBy),
                                        new SqlParameter("@LastModifiedUTC", obj.LastModifiedUTC)
                                       };

            MerchReader reader = this.ExecuteReader(StoredProcedureName.UploadAddedStop, pars);
            var v = reader.GetResults<DeliveryStopAdded>().ToList();
            if (v.Count == 1)
            {
                v[0].ResponseStatus = 1;
                return v[0];
            }
            else
            {
                return new DeliveryStopAdded();
            }
        }

        public DeliveryStopsAdded UploadAddedStops(AddedStops obj)
        {
            DeliveryStopsAdded retval = new DeliveryStopsAdded();
            retval.Stops = new List<DeliveryStopAdded>();

            try
            {
                foreach (var v in obj.Stops)
                {
                    this.CreateSession();
                    retval.Stops.Add(AddOneStop(v));
                    this.CloseSessionOnly();
                }
                return retval;
            }
            catch (Exception ex)
            {
                this.CreateSession();
                foreach (var v in retval.Stops)
                {
                    DeleteOneStop(v.DeliveryStopID);
                }
                throw ex;
            }
            finally { this.CloseSession(); }
        }

        public OutputBase UploadEstimatedArrivals(UpdatedArrival obj)
        {
            OutputBase result = new OutputBase();

            try
            {
                this.CreateSession();
                System.Data.DataTable estimates = new System.Data.DataTable();
                estimates.Columns.Add(new System.Data.DataColumn("DeliveryStopID", typeof(System.Int64)));
                estimates.Columns.Add(new System.Data.DataColumn("Sequence", typeof(System.Int32)));
                estimates.Columns.Add(new System.Data.DataColumn("EstimatedArrivalTime", typeof(System.DateTime)));

                foreach (var vs in obj.Stops)
                {
                    estimates.Rows.Add(vs.DeliveryStopID, vs.Sequence, vs.EstimatedArrivalTime);
                }

                SqlParameter tvpParam = new SqlParameter("@Estimates", estimates);
                tvpParam.SqlDbType = System.Data.SqlDbType.Structured;
                tvpParam.TypeName = "Mesh.tEstimatedArrivals";

                SqlParameter[] pars = { tvpParam,
                                        new SqlParameter("@LastModifiedBy", obj.LastModifiedBy),
                                        new SqlParameter("@LastModifiedUTC", obj.LastModifiedUTC)
                                       };

                result.ResponseStatus = this.ExecuteNonQuery(StoredProcedureName.UpdateEstimatedArrivals, pars);

                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally { this.CloseSession(); }
        }

        public OutputBase CheckInDeliveryStop(StopCheckIn obj)
        {
            OutputBase result = new OutputBase();

            try
            {
                this.CreateSession();
                System.Data.DataTable estimates = new System.Data.DataTable();
                estimates.Columns.Add(new System.Data.DataColumn("DeliveryStopID", typeof(System.Int64)));
                estimates.Columns.Add(new System.Data.DataColumn("Sequence", typeof(System.Int32)));
                estimates.Columns.Add(new System.Data.DataColumn("EstimatedArrivalTime", typeof(System.DateTime)));

                foreach (var vs in obj.Stops)
                {
                    estimates.Rows.Add(vs.DeliveryStopID, vs.Sequence, vs.EstimatedArrivalTime);
                }

                SqlParameter tvpParam = new SqlParameter("@Estimates", estimates);
                tvpParam.SqlDbType = System.Data.SqlDbType.Structured;
                tvpParam.TypeName = "Mesh.tEstimatedArrivals";

                SqlParameter[] pars = { tvpParam,
                                        new SqlParameter("@CurrentDeliveryStopID", obj.CurrentDeliveryStopID),
                                        new SqlParameter("@CheckInTime", obj.CheckInTime),
                                        new SqlParameter("@ArrivalTime", obj.ArrivalTime),
                                        new SqlParameter("@CheckInFarAwayReasonID", obj.CheckInFarAwayReasonID),
                                        new SqlParameter("@CheckInDistance", obj.CheckInDistance),
                                        new SqlParameter("@CheckInLatitude", obj.CheckInLatitude),
                                        new SqlParameter("@CheckInLongitude", obj.CheckInLongitude),
                                        new SqlParameter("@LastModifiedBy", obj.LastModifiedBy),
                                        new SqlParameter("@LastModifiedUTC", obj.LastModifiedUTC)
                                       };

                result.ResponseStatus = this.ExecuteNonQuery(StoredProcedureName.CheckInDeliveryStop, pars);

                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally { this.CloseSession(); }
        }

        public OutputBase CheckOutDeliveryStop(StopCheckOut obj)
        {
            OutputBase result = new OutputBase();

            try
            {
                this.CreateSession();
                System.Data.DataTable estimates = new System.Data.DataTable();
                estimates.Columns.Add(new System.Data.DataColumn("DeliveryStopID", typeof(System.Int64)));
                estimates.Columns.Add(new System.Data.DataColumn("Sequence", typeof(System.Int32)));
                estimates.Columns.Add(new System.Data.DataColumn("EstimatedArrivalTime", typeof(System.DateTime)));

                foreach (var vs in obj.Stops)
                {
                    estimates.Rows.Add(vs.DeliveryStopID, vs.Sequence, vs.EstimatedArrivalTime);
                }

                SqlParameter tvpParam = new SqlParameter("@Estimates", estimates);
                tvpParam.SqlDbType = System.Data.SqlDbType.Structured;
                tvpParam.TypeName = "Mesh.tEstimatedArrivals";

                SqlParameter[] pars = { tvpParam,
                                        new SqlParameter("@Voided", obj.Voided),
                                        new SqlParameter("@CurrentDeliveryStopID", obj.CurrentDeliveryStopID),
                                        new SqlParameter("@CheckOutTime", obj.CheckOutTime),
                                        new SqlParameter("@DepartureTime", obj.DepartureTime),
                                        new SqlParameter("@CheckOutLatitude", obj.CheckOutLatitude),
                                        new SqlParameter("@CheckOutLongitude", obj.CheckOutLongitude),
                                        new SqlParameter("@LastModifiedBy", obj.LastModifiedBy),
                                        new SqlParameter("@LastModifiedUTC", obj.LastModifiedUTC)
                                       };

                result.ResponseStatus = this.ExecuteNonQuery(StoredProcedureName.CheckOutDeliveryStop, pars);

                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally { this.CloseSession(); }
        }

        public OutputBase UploadStopsDNS(StopDNS obj)
        {
            OutputBase result = new OutputBase();

            try
            {
                this.CreateSession();

                SqlParameter[] pars = {
                                        new SqlParameter("@DeliveryStopID", obj.DeliveryStopID),
                                        new SqlParameter("@DNSReasonCode", obj.DNSReasonCode),
                                        new SqlParameter("@DNSReason", obj.DNSReason),
                                        new SqlParameter("@LastModifiedBy", obj.LastModifiedBy),
                                        new SqlParameter("@LastModifiedUTC", obj.LastModifiedUTC)
                                       };

                result.ResponseStatus = this.ExecuteNonQuery(StoredProcedureName.UploadStopsDNS, pars);

                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally { this.CloseSession(); }
        }

        public OutputBase CancelStopsDNS(StopDNSCancel obj)
        {
            OutputBase result = new OutputBase();

            try
            {
                this.CreateSession();

                SqlParameter[] pars = {
                                        new SqlParameter("@DeliveryStopID", obj.DeliveryStopID),
                                        new SqlParameter("@LastModifiedBy", obj.LastModifiedBy),
                                        new SqlParameter("@LastModifiedUTC", obj.LastModifiedUTC)
                                       };

                result.ResponseStatus = this.ExecuteNonQuery(StoredProcedureName.CancelStopsDNS, pars);

                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally { this.CloseSession(); }
        }

        public OutputBase UploadNewSequence(UpdatedSequence obj)
        {
            OutputBase result = new OutputBase();

            try
            {
                this.CreateSession();
                System.Data.DataTable estimates = new System.Data.DataTable();
                estimates.Columns.Add(new System.Data.DataColumn("DeliveryStopID", typeof(System.Int64)));
                estimates.Columns.Add(new System.Data.DataColumn("Sequence", typeof(System.Int32)));
                estimates.Columns.Add(new System.Data.DataColumn("EstimatedArrivalTime", typeof(System.DateTime)));

                foreach (var vs in obj.Stops)
                {
                    estimates.Rows.Add(vs.DeliveryStopID, vs.Sequence, vs.EstimatedArrivalTime);
                }

                SqlParameter tvpParam = new SqlParameter("@Estimates", estimates);
                tvpParam.SqlDbType = System.Data.SqlDbType.Structured;
                tvpParam.TypeName = "Mesh.tEstimatedArrivals";

                SqlParameter[] pars = { tvpParam,
                                        new SqlParameter("@AddtionalReason", obj.AddtionalReason),
                                        new SqlParameter("@ResequenceReasonIDs", obj.CommaSeperatedResequenceReasonIDs),
                                        new SqlParameter("@RouteID", obj.RouteID),
                                        new SqlParameter("@DeliveryDateUTC", obj.DeliveryDateUTC),
                                        new SqlParameter("@LastModifiedBy", obj.LastModifiedBy),
                                        new SqlParameter("@LastModifiedUTC", obj.LastModifiedUTC)
                                       };

                result.ResponseStatus = this.ExecuteNonQuery(StoredProcedureName.UploadNewSequence, pars);

                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally { this.CloseSession(); }
        }

        public OutputBase UploadInvoice(Invoice obj)
        {
            OutputBase result = new OutputBase();

            try
            {
                this.CreateSession();
                System.Data.DataTable estimates = new System.Data.DataTable();
                estimates.Columns.Add(new System.Data.DataColumn("RMInvoiceID", typeof(System.Int64)));
                estimates.Columns.Add(new System.Data.DataColumn("ItemNumber", typeof(System.Int32)));
                estimates.Columns.Add(new System.Data.DataColumn("Quantity", typeof(System.Int32)));

                foreach (var vs in obj.Items)
                {
                    estimates.Rows.Add(vs.RMInvoiceID, vs.ItemNumber, vs.Quantity);
                }

                SqlParameter tvpParam = new SqlParameter("@Items", estimates);
                tvpParam.SqlDbType = System.Data.SqlDbType.Structured;
                tvpParam.TypeName = "Mesh.tInvoiceItems";


                //-----------------------
                System.Data.DataTable headers = new System.Data.DataTable();
                headers.Columns.Add(new System.Data.DataColumn("DeliveryDateUTC", typeof(System.DateTime)));
                headers.Columns.Add(new System.Data.DataColumn("RMInvoiceID", typeof(System.Int64)));
                headers.Columns.Add(new System.Data.DataColumn("RMOrderID", typeof(System.Int64)));
                headers.Columns.Add(new System.Data.DataColumn("SAPBranchID", typeof(System.Int32)));
                headers.Columns.Add(new System.Data.DataColumn("SAPAccountNumber", typeof(System.Int32)));

                foreach (var vs in obj.Headers)
                {
                    headers.Rows.Add(vs.DeliveryDateUTC, vs.RMInvoiceID, vs.RMOrderID, vs.SAPBranchID, vs.SAPAccountNumber);
                }

                SqlParameter tvpParamHeaders = new SqlParameter("@Headers", headers);
                tvpParamHeaders.SqlDbType = System.Data.SqlDbType.Structured;
                tvpParamHeaders.TypeName = "Mesh.tInvoiceHeaders";


                SqlParameter[] pars = { tvpParamHeaders, tvpParam,
                                        new SqlParameter("@LastModifiedBy", obj.LastModifiedBy),
                                        new SqlParameter("@LastModifiedUTC", obj.LastModifiedUTC)
                                       };

                result.ResponseStatus = this.ExecuteNonQuery(StoredProcedureName.UploadInvoice, pars);

                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally { this.CloseSession(); }
        }

        #endregion

    }
}
