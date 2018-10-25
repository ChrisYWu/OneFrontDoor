using DPSG.Portal.Merchandiser.WebAPI.Model.Input;
using DPSG.Portal.Merchandiser.WebAPI.Model.Output;
using System;
using System.Reflection;
using System.Web.Http;
using System.Web.Http.Description;
using Newtonsoft.Json;

namespace DPSG.Portal.Merchandiser.WebAPI.Controllers
{
    public class MerchController : BaseController
    {
        #region All Merch HttpGet methods

        [HttpGet]
        [ResponseType(typeof(Model.Output.StoreList))]
        public IHttpActionResult GetMerchandisableStoresByBranch(string SAPBranchID, DateTime? mdate = null)
        {
            var dataService = new DataService.MerchDataService();
            try
            {
               var ret = new Model.Output.StoreList();             
                ret.Stores = dataService.GetMerchStoresByBranch(SAPBranchID, mdate);
                return WebAPISuccess(ret);
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }
        
        [HttpGet]
        [ResponseType(typeof(Model.Output.MerchProfileOutput))]
        public IHttpActionResult GetMerchProfileByGSN(string GSN)
        {
            var dataService = new DataService.MerchDataService();
            try
            {
                var ret = new Model.Output.MerchProfileOutput();
                MerchProfileRAW mProfile = new MerchProfileRAW();               
                mProfile = dataService.GetMerchProfileByGSN(GSN);

                if (mProfile.ImageDetail != null)
                {
                    BlobWithAccess img = ImageHub.GetWritableImageURL(new ImageRequest()
                    {
                        AbsoluteURL = mProfile.ImageDetail.AbsoluteURL,
                        AccessLevel = mProfile.ImageDetail.AccessLevel,
                        AzureConnectionString = mProfile.ImageDetail.ConnectionString,
                        Container = mProfile.ImageDetail.Container,
                        RelativeURL = mProfile.ImageDetail.RelativeURL,
                        StorageAccount = mProfile.ImageDetail.StorageAccount
                    });
                    mProfile.MerchUserProfile.PictureURL = img.AbsoluteURL;
                    mProfile.MerchUserProfile.PictureSAS = img.SAS;
                }

                ret.MerchUserProfile = mProfile.MerchUserProfile;

                return WebAPISuccess(ret);
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpGet]
        [ResponseType(typeof(Model.Output.MerchScheduleList))]
        public IHttpActionResult GetMerchSchedule(int MerchGroupID, string GSN, DateTime? StartDispatchDate =null, DateTime? LastScheduleDate=null, int? BatchID=0)
        {
            var dataService = new DataService.MerchDataService();
            try
            {
                var ret = new Model.Output.MerchScheduleList();               
                ret = dataService.GetMerchSchedule(MerchGroupID, GSN, StartDispatchDate, LastScheduleDate, BatchID);
                return WebAPISuccess(ret);
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpGet]
        [ResponseType(typeof(Model.Output.MerchPlanList))]
        public IHttpActionResult GetMerchPlan(int MerchGroupID, string GSN, DateTime? StartDispatchDate = null, DateTime? LastScheduleDate = null, int? BatchID = 0)
        {
            var dataService = new DataService.MerchDataService();
            try
            {
                var ret = new Model.Output.MerchPlanList();
                ret = dataService.GetMerchPlan(MerchGroupID, GSN, StartDispatchDate, LastScheduleDate, BatchID);
                return WebAPISuccess(ret);
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpGet]
        [ResponseType(typeof(Model.Output.OutputBase))]
        public IHttpActionResult RegisterDPSAppleToken(string BundleID, string GSN, string AppleToken)
        {
            try
            {             
                var result = new OutputBase();
                return WebAPISuccess(result);
            }
            catch(Exception ex)
            {
                return WebAPIError(ex);
            }
        }

        [HttpGet]
        [ResponseType(typeof(Model.Output.MerchVisit))]
        public IHttpActionResult GetMerchStoreVisitDetailsByGSN(string GSN, DateTime? ScheduleDate = null)
        {
            var dataService = new DataService.MerchDataService();
            try
            {
                var merchVisits = new MerchVisit();                
                MerchVisitRaw visits = dataService.GetMerchStoreVisitDetailsByGSN(GSN, ScheduleDate);

                merchVisits.MerchVisitExecutions = visits.MerchVisitExecutions;
                merchVisits.MerchVisitPhotos = new System.Collections.Generic.List<MerchVisitPhoto>();
                foreach (var p in visits.MerchVisitPhotos)
                {
                    BlobWithAccess img = ImageHub.GetWritableImageURL(new ImageRequest()
                    {
                        AbsoluteURL = p.AbsoluteURL,
                        AccessLevel = p.AccessLevel,
                        AzureConnectionString = p.ConnectionString,
                        Container = p.Container,
                        RelativeURL = p.RelativeURL,
                        StorageAccount = p.StorageAccount
                    });

                    p.PictureURL = img.AbsoluteURL;
                    p.PictureSAS = img.SAS;

                    merchVisits.MerchVisitPhotos.Add(new MerchVisitPhoto()
                    {
                        Caption = p.Caption,
                        ClientPhotoID = p.ClientPhotoID,
                        DispatchDate = p.DispatchDate,
                        Extension = p.Extension,
                        GSN = p.GSN,
                        PictureName = p.PictureName,
                        PictureURL = p.PictureURL,
                        PictureSAS = p.PictureSAS,
                        SAPAccountNumber = p.SAPAccountNumber,
                        SizeInByte = p.SizeInByte
                    });
                }

                merchVisits.MerchVisitSignatures = new System.Collections.Generic.List<MerchVisitSignature>();
                foreach (var p in visits.MerchVisitSignatures)
                {
                    BlobWithAccess img = ImageHub.GetWritableImageURL(new ImageRequest()
                    {
                        AbsoluteURL = p.AbsoluteURL,
                        AccessLevel = p.AccessLevel,
                        AzureConnectionString = p.ConnectionString,
                        Container = p.Container,
                        RelativeURL = p.RelativeURL,
                        StorageAccount = p.StorageAccount
                    });
                    p.ImageURL = img.AbsoluteURL;
                    p.ImageSAS = img.SAS;

                    merchVisits.MerchVisitSignatures.Add(new MerchVisitSignature()
                    {
                        DispatchDate = p.DispatchDate,
                        SAPAccountNumber = p.SAPAccountNumber,
                        GSN = p.GSN,
                        ImageURL = p.ImageURL,
                        ImageSAS = p.ImageSAS,
                        ManagerName = p.ManagerName,
                        SignatureName = p.SignatureName
                    });
                }
                merchVisits.AdhocMileages = visits.AdhocMileages;
                merchVisits.MerchVisitDNS = visits.MerchVisitDNS;

                return WebAPISuccess(merchVisits);
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpGet]
        [ResponseType(typeof(Model.Output.StoreDeliveryList))]
        public IHttpActionResult GetMerchStoreDelivery(string SAPAccountNumber, bool IsDetailNeeded=true, DateTime? DeliveryDate = null)
        {
            if (String.IsNullOrWhiteSpace(SAPAccountNumber))
            {
                return WebAPISuccess(new StoreDeliveryList());
            }
            else
            {
                DateTime realDeliveryDate;
                if (DeliveryDate == null)
                {
                    DeliveryDate = DateTime.Parse(DateTime.Now.ToShortDateString());
                }
                realDeliveryDate = DateTime.Parse(DeliveryDate.Value.ToShortDateString());

                var dataService = new DataService.MerchDataService();
                try
                {
                    var storeDeliveries = new StoreDeliveryList();
                    storeDeliveries = dataService.GetMerchStoreDelivery(realDeliveryDate, SAPAccountNumber, IsDetailNeeded);

                    return WebAPISuccess(storeDeliveries);
                }
                catch (Exception ex)
                {
                    objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                    objWebAPILog.Exception = GetException(ex);
                    dataService.InsertWebAPILog(objWebAPILog);
                    return WebAPIError(ex);
                }
            }
        }

        [HttpGet]
        [ResponseType(typeof(Model.Output.MerchandisingList))]
        public IHttpActionResult GetMerchandisingDetails(string SAPAccountNumber, DateTime? OperationDate = null)
        {
            if (String.IsNullOrWhiteSpace(SAPAccountNumber))
            {
                return WebAPISuccess(new MerchandisingList());
            }
            else
            {
                DateTime realOperationDate;
                if (OperationDate == null)
                {
                    OperationDate = DateTime.Parse(DateTime.Now.ToShortDateString());
                }
                realOperationDate = DateTime.Parse(OperationDate.Value.ToShortDateString());

                var dataService = new DataService.MerchDataService();
                try
                {
                    var details = new MerchandisingList();
                    details = dataService.GetMerchandisingDetails(realOperationDate, SAPAccountNumber);

                    return WebAPISuccess(details);
                }
                catch (Exception ex)
                {
                    objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                    objWebAPILog.Exception = GetException(ex);
                    dataService.InsertWebAPILog(objWebAPILog);
                    return WebAPIError(ex);
                }
            }
        }

        [HttpGet]
        [ResponseType(typeof(Model.Output.ItemMaster))]
        public IHttpActionResult GetItemMaster(DateTime? mdate = null)
        {
            var dataService = new DataService.MerchDataService();
            try
            {
                var itemMasters = new ItemMasters();
                itemMasters.Items = dataService.GetItemMaster(mdate);

                return WebAPISuccess(itemMasters);
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }

        }
        #endregion

        #region All Merch HttpPost methods

        [HttpPost]
        public IHttpActionResult UploadMerchStopCheckIn(MerchStopCheckIn mStopCheckIn)
        {
            var dataService = new DataService.MerchDataService();
            try
            {
                if ((mStopCheckIn.UserMileage > 99999) || (mStopCheckIn.UserMileage < -99999))
                {
                    mStopCheckIn.UserMileage = 99999;
                }
                if ((mStopCheckIn.StandardMileage > 99999) || (mStopCheckIn.StandardMileage < -99999))
                {
                    mStopCheckIn.StandardMileage = 99999;
                }

                return WebAPISuccess(dataService.InsertMerchStopCheckIn(mStopCheckIn));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.Json = mStopCheckIn.Equals(null) ? string.Empty : JsonConvert.SerializeObject(mStopCheckIn, Formatting.None);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult GetMerchStoreDeliveryPost(StoreDeliveryInput obj)
        {
            if (obj.SAPAccountNumbers == null)
            {
                return WebAPISuccess(new StoreDeliveryList());
            }
            else
            {
                DateTime realDeliveryDate;
                if (obj.DeliveryDate == null)
                {
                    obj.DeliveryDate = DateTime.Parse(DateTime.Now.ToShortDateString());
                }
                realDeliveryDate = DateTime.Parse(obj.DeliveryDate.Value.ToShortDateString());

                var dataService = new DataService.MerchDataService();
                try
                {
                    var storeDeliveries = new StoreDeliveryList();
                    storeDeliveries = dataService.GetMerchStoreDelivery(realDeliveryDate, String.Join(",", obj.SAPAccountNumbers), obj.IsDetailNeeded);

                    return WebAPISuccess(storeDeliveries);
                }
                catch (Exception ex)
                {
                    objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                    objWebAPILog.Exception = GetException(ex);
                    dataService.InsertWebAPILog(objWebAPILog);
                    return WebAPIError(ex);
                }
            }
        }

        [HttpPost]
        public IHttpActionResult GetMerchandisingDetailsPost(MerchDetailsInput obj)
        {
            if (obj.SAPAccountNumbers == null)
            {
                return WebAPISuccess(new MerchandisingList());
            }
            else
            {
                DateTime realOperationDate;
                if (obj.OperationDate == null)
                {
                    obj.OperationDate = DateTime.Parse(DateTime.Now.ToShortDateString());
                }
                realOperationDate = DateTime.Parse(obj.OperationDate.Value.ToShortDateString());

                var dataService = new DataService.MerchDataService();
                try
                {
                    var details = new MerchandisingList();
                    details = dataService.GetMerchandisingDetails(realOperationDate, string.Join(",", obj.SAPAccountNumbers));

                    return WebAPISuccess(details);
                }
                catch (Exception ex)
                {
                    objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                    objWebAPILog.Exception = GetException(ex);
                    objWebAPILog.Json = obj.Equals(null) ? string.Empty : JsonConvert.SerializeObject(obj, Formatting.None);
                    dataService.InsertWebAPILog(objWebAPILog);
                    return WebAPIError(ex);
                }
            }
        }

        [HttpPost]
        public IHttpActionResult UploadMerchStopCheckOut(MerchStopCheckOut mStopCheckOut)
        {
            var dataService = new DataService.MerchDataService();
            try
            {                
                return WebAPISuccess(dataService.InsertMerchStopCheckOut(mStopCheckOut));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.Json = mStopCheckOut.Equals(null) ? string.Empty : JsonConvert.SerializeObject(mStopCheckOut, Formatting.None);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult UploadMerchStoreSignature(MerchStoreSignature mStoreSign)
        {
            var dataService = new DataService.MerchDataService();
            try
            {               
                return WebAPISuccess(dataService.InsertMerchStoreSignature(mStoreSign));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.Json = mStoreSign.Equals(null) ? string.Empty : JsonConvert.SerializeObject(mStoreSign, Formatting.None);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult UploadMerchStorePicture(MerchStorePicture mStorePic)
        {
            var dataService = new DataService.MerchDataService();
            try
            {               
                return WebAPISuccess(dataService.InsertMerchStorePicture(mStorePic));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.Json = mStorePic.Equals(null) ? string.Empty : JsonConvert.SerializeObject(mStorePic, Formatting.None);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult UploadMerchProfilePicture(MerchProfilePicture mProfilePic)
        {
            var dataService = new DataService.MerchDataService();
            try
            {
                return WebAPISuccess(dataService.InsertMerchProfilePicture(mProfilePic));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.Json = mProfilePic.Equals(null) ? string.Empty : JsonConvert.SerializeObject(mProfilePic, Formatting.None);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult UploadAdhocMileage(MerchAdhocMileage mAdhocMile)
        {
            var dataService = new DataService.MerchDataService();
            try
            {
                if (mAdhocMile.Description.Length > 200)
                {
                    mAdhocMile.Description = mAdhocMile.Description.Substring(0, 200);
                }

                if ((mAdhocMile.UserMileage > 99999) || (mAdhocMile.UserMileage < -99999))
                {
                    mAdhocMile.Description += " System Note: Mileage Out of Range:" + mAdhocMile.UserMileage.ToString();
                    mAdhocMile.UserMileage = 99999;
                }

                return WebAPISuccess(dataService.InsertAdhocMileage(mAdhocMile));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.Json = mAdhocMile.Equals(null) ? string.Empty : JsonConvert.SerializeObject(mAdhocMile, Formatting.None);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult UploadMerchStopDNS(MerchStopDNS mstop)
        {
            var dataService = new DataService.MerchDataService();
            try
            {
                return WebAPISuccess(dataService.InsertMerchStopDNS(mstop));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.Json = mstop.Equals(null) ? string.Empty : JsonConvert.SerializeObject(mstop, Formatting.None);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult UploadMerchPhoneNumber(MerchDetailInput mdetail)
        {
            var dataService = new DataService.MerchDataService();
            try
            {
                return WebAPISuccess(dataService.UpsertMerchPhoneNumber(mdetail));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.Json = mdetail.Equals(null) ? string.Empty : JsonConvert.SerializeObject(mdetail, Formatting.None);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult UploadAPNRegistration(APNRegistration reg)
        {
            var dataService = new DataService.MerchDataService();
            try
            {
                return WebAPISuccess(dataService.UploadAPNRegistration(reg));
            }
            catch (Exception ex)
            {
                objWebAPILog.OperationName = MethodBase.GetCurrentMethod().Name;
                objWebAPILog.Exception = GetException(ex);
                objWebAPILog.Json = reg.Equals(null) ? string.Empty : JsonConvert.SerializeObject(reg, Formatting.None);
                dataService.InsertWebAPILog(objWebAPILog);
                return WebAPIError(ex);
            }
        }

        #endregion

    }
}
