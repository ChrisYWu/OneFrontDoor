using DPSG.Portal.Merchandiser.WebAPI.Model;
using DPSG.Portal.Merchandiser.WebAPI.Model.Input;
using DPSG.Portal.Merchandiser.WebAPI.Model.Output;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Stripe.net;
using Stripe.Infrastructure;
using Stripe;

namespace DPSG.Portal.Merchandiser.WebAPI.DataService
{
    public class MerchDataService : MerchConnectionWrapper
    {
        #region All Merch HttpGet methods
        public List<Store> GetMerchStoresByBranch(string SAPBranchID, DateTime? LastUpdateTime)
        {
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@SAPBranchID", SAPBranchID),
                                         new SqlParameter("@LastUpdateTime", LastUpdateTime)
                                       };
                return this.ExecuteReader<Store>(Constant.StoredProcedureName.GetStoresBySAPBranchID, pars).ToList();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public MerchProfileRAW GetMerchProfileByGSN(string GSN)
        {
            MerchProfileRAW profile = new MerchProfileRAW();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@GSN", GSN)
                                       };

                MerchReader reader = this.ExecuteReader(Constant.StoredProcedureName.GetMerchProfileByGSN, pars);
                profile.MerchUserProfile = reader.GetResults<MerchProfile>().ToList().FirstOrDefault();
                profile.ImageDetail = reader.GetResults<ProfileImageDetail>().ToList().FirstOrDefault();

                //profile.MerchUserProfile = this.ExecuteReader<MerchProfile>(Constant.StoredProcedureName.GetMerchProfileByGSN, pars).ToList().FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }

            return profile;
        }

        public MerchPlanList GetMerchPlan(int MerchGroupID, string GSN, DateTime? StartDispatchDate, DateTime? LastScheduleDate, int? BatchID)
        {
            MerchPlanList container = new MerchPlanList();
            try
            {

                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@MerchGroupID", MerchGroupID),
                                        new SqlParameter("@GSN", GSN),
                                        new SqlParameter("@StartDispatchDate", StartDispatchDate),
                                        new SqlParameter("@LastScheduleDate", LastScheduleDate),
                                        new SqlParameter("@BatchID", BatchID)

                                       };
                MerchReader reader = this.ExecuteReader(Constant.StoredProcedureName.GetMerchPlan, pars);
                //container.PlanHeader = reader.GetResults<MerchPlan>().ToList();
                container.MerchPlans = reader.GetResults<MerchSchedule>().ToList();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }

            return container;
        }

        public MerchScheduleList GetMerchSchedule(int MerchGroupID, string GSN, DateTime? StartDispatchDate, DateTime? LastScheduleDate, int? BatchID)
        {
            MerchScheduleList container = new MerchScheduleList();
            try
            {

                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@MerchGroupID", MerchGroupID),
                                        new SqlParameter("@GSN", GSN),
                                        new SqlParameter("@StartDispatchDate", StartDispatchDate),
                                        new SqlParameter("@LastScheduleDate", LastScheduleDate),
                                        new SqlParameter("@BatchID", BatchID)

                                       };
                MerchReader reader = this.ExecuteReader(Constant.StoredProcedureName.GetMerchSchedule, pars);
                var scheduleStatus = reader.GetResults<ScheduleStatus>().ToList().FirstOrDefault();
                container.MerchSchedules = reader.GetResults<MerchSchedule>().ToList();
                container.BatchID = scheduleStatus.BatchID;
                container.UpdateStatus = scheduleStatus.UpdateStatus;
                container.Notes = scheduleStatus.Notes;

            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }

            return container;
        }

        public MerchVisitRaw GetMerchStoreVisitDetailsByGSN(string GSN, DateTime? DispatchDate = null)
        {
            MerchVisitRaw merchVisits = new MerchVisitRaw();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@GSN", GSN),
                                        new SqlParameter("@DispatchDate", DispatchDate)
                                       };
                MerchReader reader = this.ExecuteReader(Constant.StoredProcedureName.GetMerchStoreVisitDetailsByGSN, pars);

                merchVisits.MerchVisitExecutions = reader.GetResults<MerchVisitExecution>().ToList();
                merchVisits.MerchVisitPhotos = reader.GetResults<MerchVisitPhotoRaw>().ToList();
                merchVisits.MerchVisitSignatures = reader.GetResults<MerchVisitSignatureRaw>().ToList();
                merchVisits.AdhocMileages = reader.GetResults<AdhocMileage>().ToList();
                merchVisits.MerchVisitDNS = reader.GetResults<MerchVisitDNS>().ToList();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }

            return merchVisits;
        }

        public List<ItemMaster> GetItemMaster(DateTime? mdate = null)
        {
            List<ItemMaster> retval = new List<ItemMaster>();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@LastModified", mdate)
                                       };
                MerchReader reader = this.ExecuteReader(Constant.StoredProcedureName.GetItemMaster, pars);

                retval = reader.GetResults<ItemMaster>().ToList();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }

            return retval;
        }

        public StoreDeliveryList GetMerchStoreDelivery(DateTime DeliveryDate, string SAPAccountNumber, bool IsDetailNeeded)
        {
            StoreDeliveryList output = new StoreDeliveryList();
            List<StoreDelivery> objSD = new List<StoreDelivery>();
            List<StoreDeliveryItemRAW> objSDItems = new List<StoreDeliveryItemRAW>();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@DeliveryDate", DeliveryDate),
                                        new SqlParameter("@SAPAccountNumber", SAPAccountNumber),
                                        new SqlParameter("@IsDetailNeeded", IsDetailNeeded)
                                       };
                MerchReader reader = this.ExecuteReader(Constant.StoredProcedureName.GetMerchStoreDelivery, pars);

                objSD = reader.GetResults<StoreDelivery>().ToList();
                objSDItems = reader.GetResults<StoreDeliveryItemRAW>().ToList();

                if (objSD.Count > 0)
                {
                    foreach (var store in objSD)
                    {
                        store.Items = objSDItems.Where(c => c.SAPAccountNumber == store.SAPAccountNumber)
                                       .Select(c => new StoreDeliveryItem()
                                       {                                         
                                           SAPMaterialID = c.SAPMaterialID,
                                           Quantity = c.Quantity,                                         
                                           Delivered = c.Delivered
                                       }).ToList();                      

                    }
                }

                //// if we have records in Store DeliveryItems but not in Store delivery
                //var result = objSDItems.Where(p => !objSD.Any(p2 => p2.SAPAccountNumber == p.SAPAccountNumber));

                //if (result.ToList().Count > 0)
                //{
                //    StoreDelivery sd = new StoreDelivery();
                //    sd.Items = result.ToList();
                //    objSD.Add(sd);
                //}  

                output.StoreDeliveries = objSD;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }

            return output;

        }

        #endregion

        #region All Merch HttpPost methods
        public OutputBase InsertMerchStopCheckIn(MerchStopCheckIn mStopCheckIn)
        {
            OutputBase result = new OutputBase();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@DispatchDate", mStopCheckIn.ScheduleDate),
                                        new SqlParameter("@GSN", mStopCheckIn.GSN),
                                        new SqlParameter("@MerchGroupID", mStopCheckIn.MerchGroupID),
                                        new SqlParameter("@ClientSequence", mStopCheckIn.ClientSequence),
                                        new SqlParameter("@SameStoreSequence", mStopCheckIn.SameStoreSequence),
                                        new SqlParameter("@RouteID", mStopCheckIn.RouteID),
                                        new SqlParameter("@SAPAccountNumber", mStopCheckIn.SAPAccountNumber),
                                        new SqlParameter("@IsOffRouteStop", mStopCheckIn.IsOffRouteStop),
                                        new SqlParameter("@ClientCheckInTime", mStopCheckIn.ClientCheckInTime),
                                        new SqlParameter("@ClientCheckInTimeZone", mStopCheckIn.ClientCheckInTimeZone),
                                        new SqlParameter("@CheckInLatitude", mStopCheckIn.CheckInLatitude),
                                        new SqlParameter("@CheckInLongitude", mStopCheckIn.CheckInLongitude),
                                        new SqlParameter("@DriveTimeInMinutes", mStopCheckIn.DriveTimeInMinutes),
                                        new SqlParameter("@StandardMileage", mStopCheckIn.StandardMileage),
                                        new SqlParameter("@UserMileage", mStopCheckIn.UserMileage)
                                       };
                result.ResponseStatus = this.ExecuteNonQuery(Constant.StoredProcedureName.InsertMerchStopCheckIn, pars);
                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public DPSStripeCharge StripeSimpleCharge(StripeChargeRequest request)
        {
            DPSStripeCharge result = new DPSStripeCharge();
            try
            {
                // Set your secret key: remember to change this to your live secret key in production
                // See your keys here: https://dashboard.stripe.com/account/apikeys

                Stripe.StripeConfiguration.SetApiKey("sk_test_gDDB9Hyhkf9ePjs7gWXnqL9z");

                // Token is created using Stripe.js or Checkout!
                // Get the payment token submitted by the form:
                var token = request.Token;

                // Charge the user's card:
                var charges = new Stripe.StripeChargeService();
                var charge = charges.Create(new StripeChargeCreateOptions
                {
                    Amount = request.Amount,
                    Currency = "usd",
                    Description = request.Description,
                    SourceTokenOrExistingSourceId = token
                });

                result.ResponseStatus = 0;
                result.Id = charge.Id;
                result.Status = charge.Status;
                result.CreatedUTC = charge.Created;
                result.PaymentURL = "https://dashboard.stripe.com/test/payments";

                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public OutputBase InsertMerchStopCheckOut(MerchStopCheckOut mstopCheckOut)
        {
            OutputBase result = new OutputBase();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = {
                                        new SqlParameter("@DispatchDate", mstopCheckOut.ScheduleDate),
                                        new SqlParameter("@GSN", mstopCheckOut.GSN),                                     
                                        new SqlParameter("@ClientSequence", mstopCheckOut.ClientSequence),
                                        new SqlParameter("@SameStoreSequence", mstopCheckOut.SameStoreSequence),
                                        new SqlParameter("@MerchGroupID", mstopCheckOut.MerchGroupID),
                                        new SqlParameter("@SAPAccountNumber", mstopCheckOut.SAPAccountNumber),
                                        new SqlParameter("@ClientCheckOutTime", mstopCheckOut.ClientCheckOutTime),
                                        new SqlParameter("@ClientCheckOutTimeZone", mstopCheckOut.ClientCheckOutTimeZone),
                                        new SqlParameter("@CheckOutLatitude", mstopCheckOut.CheckOutLatitude),
                                        new SqlParameter("@CheckOutLongitude", mstopCheckOut.CheckOutLongitude),
                                        new SqlParameter("@CasesHandeled", mstopCheckOut.CasesHandeled),
                                        new SqlParameter("@CasesInBackroom", mstopCheckOut.CasesInBackroom),
                                        new SqlParameter("@Comments", mstopCheckOut.Comments),
                                        new SqlParameter("@AtAccountTimeInMinute", mstopCheckOut.AtAccountTimeInMinute)

                                       };
                result.ResponseStatus = this.ExecuteNonQuery(Constant.StoredProcedureName.InsertMerchStopCheckOut, pars);
                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public OutputBase InsertMerchStoreSignature(MerchStoreSignature mStoreSign)
        {
            OutputBase result = new OutputBase();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@DispatchDate", mStoreSign.ScheduleDate),
                                        new SqlParameter("@GSN", mStoreSign.GSN),
                                        new SqlParameter("@SAPAccountNumber", mStoreSign.SAPAccountNumber),
                                        new SqlParameter("@ManagerName", mStoreSign.ManagerName),
                                        new SqlParameter("@SignatureName", mStoreSign.SignatureName),
                                        new SqlParameter("@ClientTime", mStoreSign.ClientTime),
                                        new SqlParameter("@ClientTimeZone", mStoreSign.ClientTimeZone),
                                        new SqlParameter("@RelativeURL", mStoreSign.RelativeURL),
                                        new SqlParameter("@AbsoluteURL", mStoreSign.AbsoluteURL),
                                        new SqlParameter("@StorageAccount", mStoreSign.StorageAccount),
                                        new SqlParameter("@Container", mStoreSign.Container),
                                       };
                result.ResponseStatus = this.ExecuteNonQuery(Constant.StoredProcedureName.InsertMerchStoreSignature, pars);
                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public OutputBase InsertMerchStorePicture(MerchStorePicture mStorePic)
        {
            OutputBase result = new OutputBase();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@DispatchDate", mStorePic.ScheduleDate),
                                        new SqlParameter("@GSN", mStorePic.GSN),
                                        new SqlParameter("@SAPAccountNumber", mStorePic.SAPAccountNumber),
                                        new SqlParameter("@ClientPhotoID", mStorePic.ClientPhotoID),
                                        new SqlParameter("@Caption", mStorePic.Caption),
                                        new SqlParameter("@PictureName", mStorePic.PictureName),
                                        new SqlParameter("@SizeInByte", mStorePic.SizeInByte),
                                        new SqlParameter("@Extension", mStorePic.Extension),
                                        new SqlParameter("@ClientTime", mStorePic.ClientTime),
                                        new SqlParameter("@ClientTimeZone", mStorePic.ClientTimeZone),
                                        new SqlParameter("@RelativeURL", mStorePic.RelativeURL),
                                        new SqlParameter("@AbsoluteURL", mStorePic.AbsoluteURL),
                                        new SqlParameter("@StorageAccount", mStorePic.StorageAccount),
                                        new SqlParameter("@Container", mStorePic.Container),

                                       };
                result.ResponseStatus = this.ExecuteNonQuery(Constant.StoredProcedureName.InsertMerchStorePicture, pars);
                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public OutputBase InsertMerchProfilePicture(MerchProfilePicture mStorePic)
        {
            OutputBase result = new OutputBase();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@GSN", mStorePic.GSN),                                       
                                        new SqlParameter("@RelativeURL", mStorePic.RelativeURL),
                                        new SqlParameter("@AbsoluteURL", mStorePic.AbsoluteURL),
                                        new SqlParameter("@StorageAccount", mStorePic.StorageAccount),
                                        new SqlParameter("@Container", mStorePic.Container),
                                        new SqlParameter("@ClientTime", mStorePic.ClientTime),
                                        new SqlParameter("@ClientTimeZone", mStorePic.ClientTimeZone),
                                       };

                result.ResponseStatus = this.ExecuteNonQuery(Constant.StoredProcedureName.InsertMerchProfilePicture, pars);
                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public OutputBase InsertAdhocMileage(MerchAdhocMileage mAdhocMile)
        {
            OutputBase result = new OutputBase();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@DispatchDate", mAdhocMile.ScheduleDate),
                                        new SqlParameter("@GSN", mAdhocMile.GSN),
                                        new SqlParameter("@ClientMileageID", mAdhocMile.ClientMileageID),
                                        new SqlParameter("@UserMileage", mAdhocMile.UserMileage),
                                        new SqlParameter("@Description", mAdhocMile.Description),
                                        new SqlParameter("@MerchGroupID", mAdhocMile.MerchGroupID),
                                        new SqlParameter("@ClientTime", mAdhocMile.ClientTime),
                                        new SqlParameter("@ClientTimeZone", mAdhocMile.ClientTimeZone)
                                       };
                result.ResponseStatus = this.ExecuteNonQuery(Constant.StoredProcedureName.InsertAdhocMileage, pars);
                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public OutputBase InsertMerchStopDNS(MerchStopDNS mstopDNS)
        {
            OutputBase result = new OutputBase();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = {
                                        new SqlParameter("@DNSReasonID", mstopDNS.DNSReasonID),
                                        new SqlParameter("@DispatchDate", mstopDNS.DispatchDate),
                                        new SqlParameter("@GSN", mstopDNS.GSN),
                                        new SqlParameter("@MerchGroupID", mstopDNS.MerchGroupID),
                                        new SqlParameter("@RouteID", mstopDNS.RouteID),
                                        new SqlParameter("@ClientSequence", mstopDNS.ClientSequence),
                                        new SqlParameter("@SAPAccountNumber", mstopDNS.SAPAccountNumber),
                                        new SqlParameter("@IsOffRouteStop", mstopDNS.IsOffRouteStop),
                                        new SqlParameter("@SameStoreSequence", mstopDNS.SameStoreSequence),
                                        new SqlParameter("@DNSCheckInTime", mstopDNS.DNSCheckInTime),
                                        new SqlParameter("@DNSCheckInTimeZone", mstopDNS.DNSCheckInTimeZone),
                                        new SqlParameter("@DNSCheckInLatitude", mstopDNS.DNSCheckInLatitude),
                                        new SqlParameter("@DNSCheckInLongitude", mstopDNS.DNSCheckInLongitude)
                                       };
                result.ResponseStatus = this.ExecuteNonQuery(Constant.StoredProcedureName.InsertMerchStopDNS, pars);
                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public OutputBase UpsertMerchPhoneNumber(MerchDetailInput mdetail)
        {
            OutputBase result = new OutputBase();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@GSN", mdetail.GSN),
                                        new SqlParameter("@PhoneNumber", mdetail.PhoneNumber)
                                      
                                       };

                result.ResponseStatus = this.ExecuteNonQuery(Constant.StoredProcedureName.UpsertMerchPhoneNumber, pars);
                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

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

        #endregion

    }
}
