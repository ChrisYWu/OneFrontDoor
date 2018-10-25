
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Webapi.Merchandiser.Model;
using DPSG.Webapi.Merchandiser.DataServices;
using DPSG.Webapi.Merchandiser.CommonUtils;
using System.Drawing;
using System.IO;



namespace DPSG.Webapi.Merchandiser.BusinessServices
{
    public class MornitoringBS
    {
     
        public MonitorLandingOutput GetMornitoringLanding(int merchGroupId, DateTime dispatchDate, string filterPhrase)
        {
            // Data service Inststance
            MonitoringDS ds = new MonitoringDS();

            return ds.GetMonitorLanding(merchGroupId, dispatchDate, filterPhrase);
        }

        public MonitorDetailOutput GetMornitoringDetail(int merchStopID)
        {
            // Data service Inststance
            MonitoringDS ds = new MonitoringDS();

            return ds.GetMontinorDetail(merchStopID);
        }

        public PlanningRouteMerchandiserOutput GetRouteMerchandiserByMerchGroupID(int merchGroupId)
        {
            // Data service Inststance
            MonitoringDS ds = new MonitoringDS();

            return ds.GetRouteMerchandiserByMerchGroupID(merchGroupId);
        }

        public bool EditRouteMerchandiser(int routeID, int dayOfWeek, string GSN, bool isForDelete)
        {
            // Data service Inststance
            MonitoringDS ds = new MonitoringDS();

            return ds.EditRouteMerchandiser(routeID, dayOfWeek, GSN, isForDelete);
        }




    }



        

    }

