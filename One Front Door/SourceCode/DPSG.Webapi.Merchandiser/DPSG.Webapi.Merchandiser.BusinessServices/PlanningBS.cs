using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DPSG.Webapi.Merchandiser.DataServices;
using DPSG.Webapi.Merchandiser.Model;
using DPSG.Webapi.Merchandiser.Modal;

namespace DPSG.Webapi.Merchandiser.BusinessServices
{
    public class PlanningBS
    {
        public MerchBranchOutput GetMerchBranchesByGSNBS(MerchBranchInput branchInput)
        {
            // Data service Instance
            PlanningDS ds = new PlanningDS();
            return ds.GetMerchBranchesByGSNDS(branchInput);
        }

        public MerchGroupOutput InsertUpdateMerchGroupDetailsBS(MerchGroupInput pinput)
        {
            // Data service Instance
            PlanningDS ds = new PlanningDS();
            string xml = "";
            List<MerchGroupRoute> routes = new List<MerchGroupRoute>();
            routes = pinput.Routes;

            System.Xml.Linq.XElement[] elements = routes.Select(i => new System.Xml.Linq.XElement("Item",
                        GetMerchRouteXMLElements(i))).ToArray();
            System.Xml.Linq.XElement rootElement = new System.Xml.Linq.XElement("Routes", elements);
            xml = rootElement.ToString();


            return ds.InsertUpdateMerchGroupDetailsDS(pinput, xml);
        }

        public static List<System.Xml.Linq.XElement> GetMerchRouteXMLElements(MerchGroupRoute value)
        {
            List<System.Xml.Linq.XElement> objElements = new List<System.Xml.Linq.XElement>();

            objElements.Add(new System.Xml.Linq.XElement("RouteID", value.RouteID));
            objElements.Add(new System.Xml.Linq.XElement("RouteName", value.RouteName));
            objElements.Add(new System.Xml.Linq.XElement("IsRouteModified", value.IsRouteModified));
            objElements.Add(new System.Xml.Linq.XElement("IsRouteDeleted", value.IsRouteDeleted));

            return objElements;
        }

        public MerchGroupOutput DeleteMerchGroupBS(MerchGroupInput pinput)
        {
            // Data service Instance
            PlanningDS ds = new PlanningDS();
            return ds.DeleteMerchGroupDS(pinput);
        }

        public MerchGroupCheckOutput ValidateForExistingMerchGroupDetailsBS(MerchGroupCheckInput pinput)
        {
            // Data service Instance
            PlanningDS ds = new PlanningDS();
            return ds.ValidateForExistingMerchGroupDetailsDS(pinput);
        }

        public MerchGroups GetMerchGroupDetailsByBranchIDBS(MerchGroupsInput pinput)
        {
            // Data service Instance
            PlanningDS ds = new PlanningDS();
            return ds.GetMerchGroupDetailsByBranchIDDS(pinput);
        }

        public MerchGroupDetail GetMerchGroupDetailsByGroupIDBS(MerchGroupDetailInput pinput)
        {
            // Data service Instance
            PlanningDS ds = new PlanningDS();
            return ds.GetMerchGroupDetailsByGroupIDDS(pinput);
        }

        public UsersOutput GetUserDetailsBS(string name)
        {
            // Data service Instance
            PlanningDS ds = new PlanningDS();
            return ds.GetUserDetailsDS(name);
        }


        //Store Setup Methods


        public StoresOutput GetStoresByMerchGroupIDBS(StoreListInput pinput)
        {
            PlanningDS ds = new PlanningDS();
            return ds.GetStoresByMerchGroupIDDS(pinput);
        }

        public StoreSetupDetailContainer GetStoreDetailsBySAPAccountNumberBS(Int64 sapaccountNumber)
        {
            PlanningDS ds = new PlanningDS();
            return ds.GetStoreDetailsBySAPAccountNumberDS(sapaccountNumber);
        }


        public StoresOutput GetStoresLookUpBySAPBranchIDBS(StoreLookupInput pinput)
        {
            PlanningDS ds = new PlanningDS();
            return ds.GetStoresLookUpBySAPBranchIDDS(pinput);
        }

        public RouteOutput GetRoutesByMerchGroupIDBS(StoreListInput pinput)
        {
            PlanningDS ds = new PlanningDS();
            return ds.GetRoutesByMerchGroupIDDS(pinput);
        }

        public StoreSetUpDetailOutput InsertUpdateStoreSetupDetailsBS(StoreSetUpDetailInput pinput)
        {
            PlanningDS ds = new PlanningDS();
            List<StoreSetupDOW> routes = new List<StoreSetupDOW>();
            routes = pinput.WeekDays;

            System.Xml.Linq.XElement[] elements = routes.Select(i => new System.Xml.Linq.XElement("Item",
                        GetWeekDayXMLElements(i))).ToArray();
            System.Xml.Linq.XElement rootElement = new System.Xml.Linq.XElement("StoreMerchNeed", elements);
            pinput.WeekDaysXML = rootElement.ToString();
            return ds.InsertUpdateStoreSetupDetailsDS(pinput);
        }

        public static List<System.Xml.Linq.XElement> GetWeekDayXMLElements(StoreSetupDOW value)
        {
            List<System.Xml.Linq.XElement> objElements = new List<System.Xml.Linq.XElement>();

            objElements.Add(new System.Xml.Linq.XElement("DayofWeek", value.Weeknumber));
            objElements.Add(new System.Xml.Linq.XElement("FirstPull", value.FirstPull));
            objElements.Add(new System.Xml.Linq.XElement("SecondPull", value.SecondPull));


            return objElements;
        }

        public StoreSetupContainer GetStoresSetupContainerBS(StoreListInput pinput)
        {
            PlanningDS ds = new PlanningDS();
            return ds.GetStoreSetUpContainerDS(pinput);
        }

        public MerchSetupContainer GetMerchSetupContainerBS(MerchListInput pinput)
        {
            PlanningDS ds = new PlanningDS();
            return ds.GetMerchSetupContainerDS(pinput);
        }

        public RouteDataContainer GetRoutesByDayBS(RoutesByDayInput pinput)
        {
            PlanningDS ds = new PlanningDS();
            return ds.GetRoutesByDayDS(pinput);
        }
        public MerchDetailContainer GetMerchDetailContainerByGSNBS(string GSN)
        {
            PlanningDS ds = new PlanningDS();
            return ds.GetMerchDetailContainerByGSNDS(GSN);
        }

        public RouteDataContainer GetAvailableDefaultRoutesBS(MerchListInput pinput)
        {
            PlanningDS ds = new PlanningDS();
            return ds.GetAvailableDefaultRoutesDS(pinput);
        }
        public MerchSetupDetailOutput InsertUpdateMerchSetupDetailBS(MerchSetupDetailInput pinput)
        {
            PlanningDS ds = new PlanningDS();
            string dayOfWeek = string.Empty;
            if (pinput.Mon)
                dayOfWeek = dayOfWeek + "," + 2 + "|" + pinput.MonRouteID;
            if (pinput.Tues)
                dayOfWeek = dayOfWeek + "," + 3 + "|" + pinput.TueRouteID;
            if (pinput.Wed)
                dayOfWeek = dayOfWeek + "," + 4 + "|" + pinput.WedRouteID;
            if (pinput.Thu)
                dayOfWeek = dayOfWeek + "," + 5 + "|" + pinput.ThuRouteID;
            if (pinput.Fri)
                dayOfWeek = dayOfWeek + "," + 6 + "|" + pinput.FriRouteID;
            if (pinput.Sat)
                dayOfWeek = dayOfWeek + "," + 7 + "|" + pinput.SatRouteID;
            if (pinput.Sun)
                dayOfWeek = dayOfWeek + "," + 1 + "|" + pinput.SunRouteID;

            dayOfWeek = dayOfWeek.Trim(',');

            return ds.InsertUpdateMerchSetupDetailDS(pinput, dayOfWeek);
        }

        public UsersOutput GetMerchUserDetailsBS(string name)
        {
            // Data service Instance
            PlanningDS ds = new PlanningDS();
            return ds.GetMerchUserDetailsDS(name);
        }


        public StoreDeleteOutput DeleteStoreBS(StoreDeleteInput store)
        {
            // Data service Instance
            PlanningDS ds = new PlanningDS();
            return ds.DeleteStoreDS(store);
        }

        public RouteDeleteOutput DeleteRouteBS(RouteDeleteInput route)
        {
            // Data service Instance
            PlanningDS ds = new PlanningDS();
            return ds.DeleteRouteDS(route);
        }

        public RemoveStoreWarning GetDeleteStoreWarningBS(StoreDeleteInput store)
        {
            // Data service Instance
            PlanningDS ds = new PlanningDS();
            return ds.DeleteStoreWarningDS(store);
        }

        public DeleteRouteWarning GetDeleteRouteWarningBS(RouteDeleteInput route)
        {
            // Data service Instance
            PlanningDS ds = new PlanningDS();
            return ds.DeleteRouteWarningDS(route);
        }

        public MerchDeleteOutput DeleteMerchBS(MerchDeleteInput merch)
        {
            // Data service Instance
            PlanningDS ds = new PlanningDS();
            return ds.DeleteMerchDS(merch);
        }

    }
}
