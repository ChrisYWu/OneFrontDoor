using DPSG.Portal.Merchandiser.WebAPI.Model.Input;
using DPSG.Portal.Merchandiser.WebAPI.Model.Output;
using System;
using System.Reflection;
using System.Web.Http;
using System.Web.Http.Description;

namespace DPSG.Portal.Merchandiser.WebAPI.Controllers
{
    public class StripeController : BaseController
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
        [ResponseType(typeof(Model.Output.StoreList))]
        public IHttpActionResult Charge(string SAPBranchID, DateTime? mdate = null)
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
        #endregion

        #region All Merch HttpPost methods

        [HttpPost]
        public IHttpActionResult ChargeSimple(StripeChargeRequest request)
        {
            var dataService = new DataService.MerchDataService();
            try
            {
                return WebAPISuccess(dataService.StripeSimpleCharge(request));
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
        public IHttpActionResult SubmitToken(string stripeToken, string stripeTokenType, string stripeEmail)
        {
            var submit = new StripeFormSubmit()
            {
                stripeToken = stripeToken,
                stripeTokenType = stripeTokenType,
                stripeEmail = stripeEmail
            };

            return WebAPISuccess(submit);
        }

        [HttpPost]
        public IHttpActionResult SubmitTokenPost(StripeFormSubmit submit)
        {
            StripeChargeRequest request = new StripeChargeRequest()
            {
                Amount = 1234,
                Currency = "usd",
                Description = "DPS Payments POC - from test web button click",
                Token = submit.stripeToken
            };

            var dataService = new DataService.MerchDataService();
            try
            {
                var v = dataService.StripeSimpleCharge(request);

                StripeFormSubmitWithResult result = new StripeFormSubmitWithResult(submit);

                result.result = "The amount is sccessfuly charged to the card, please check details at Stripe -> Dashboard -> Payments(https://dashboard.stripe.com/test/payments)";

                result.Id = v.Id;
                result.CreatedUTC = v.CreatedUTC;
                result.Status = v.Status;
                return WebAPISuccess(result);
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

    }
}
