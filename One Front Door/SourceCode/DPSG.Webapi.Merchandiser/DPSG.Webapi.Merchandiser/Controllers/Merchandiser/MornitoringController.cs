
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using System.Web.Http.Cors;
using DPSG.Webapi.Merchandiser.Model;
using DPSG.Webapi.Merchandiser.BusinessServices;
using System.Web;



namespace DPSG.Webapi.Merchandiser.Controllers.Merchandiser
{
    public class MornitoringController : BaseController
    {

        [Route("api/Monitoring/GetMornitoringLanding")]
        [HttpGet]
        public IHttpActionResult GetMornitoringLanding(DateTime dispatchDate, int merchGroupID, string filterPhrase = "")
        {
            try
            {
                return MSNOk<MonitorLandingOutput>((new BusinessServices.MornitoringBS()).GetMornitoringLanding(merchGroupID, dispatchDate, filterPhrase));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }



        [Route("api/Monitoring/GetRouteMerchandiserByMerchGroupID")]
        [HttpGet]
        public IHttpActionResult GetRouteMerchandiserByMerchGroupID(int merchGroupID)
        {
            try
            {
                return MSNOk<PlanningRouteMerchandiserOutput>((new BusinessServices.MornitoringBS()).GetRouteMerchandiserByMerchGroupID(merchGroupID));

            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [Route("api/Monitoring/EditRouteMerchandiser")]
        [HttpGet]
        public IHttpActionResult EditRouteMerchandiser(int routeID, int dayOfWeek, string GSN, bool isForDelete)
        {
            try
            {
                return MSNOk<bool>((new BusinessServices.MornitoringBS()).EditRouteMerchandiser(routeID, dayOfWeek,GSN, isForDelete));

            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }

        [Route("api/Monitoring/GetMornitoringDetail")]
        [HttpGet]
        public IHttpActionResult GetMornitoringDetail(int merchStopID)
        {
            try
            {
                return MSNOk<MonitorDetailOutput>((new BusinessServices.MornitoringBS()).GetMornitoringDetail(merchStopID));
            }
            catch (Exception ex)
            {
                return MSNError(ex);
            }
        }
    }

}

