
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Webapi.Merchandiser.Model;
using DPSG.Webapi.Merchandiser.DataServices;
using DPSG.Webapi.Merchandiser.CommonUtils;
using System.Drawing;
using System.IO;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.BusinessServices.Dispatch
{
    public class DispatchBS
    {

        public async Task<DispatchAllListContainer> GetDispatchAllBS(DispatchInputUser dispatchInput)
        {
            DispatchAllListContainer obj = new DispatchAllListContainer();
            try
            {

                obj.Dispatches = await GetDispatchesBS(dispatchInput.MerchGroupID, dispatchInput.DispatchDate, dispatchInput.GSN, dispatchInput.Reset, dispatchInput.TimeZoneOffsetToUTC);
                obj.Stores = GetStoresBS(dispatchInput.MerchGroupID, dispatchInput.DispatchDate);
                RouteListInput rl = new RouteListInput();
                rl.DispatchDate = dispatchInput.DispatchDate;
                rl.MerchGroupID = dispatchInput.MerchGroupID;
                //obj.Routes = GetRoutesBS(rl);
                obj.Merchandisers = GetMerchListBS(rl);


            }
            catch (Exception e) { throw (e); }

            return obj;
        }

        public async Task<DispatchAllListContainer> GetDispatchAllSlicedBS(DispatchInputUser dispatchInput)
        {
            DispatchAllListContainer obj = new DispatchAllListContainer();
            try
            {

                obj.Dispatches = await GetDispatchesBS(dispatchInput.MerchGroupID, dispatchInput.DispatchDate, dispatchInput.GSN, dispatchInput.Reset, dispatchInput.TimeZoneOffsetToUTC);
                obj.Stores = GetStoresUnassignedBS(dispatchInput.MerchGroupID, dispatchInput.DispatchDate);
                RouteListInput rl = new RouteListInput();
                rl.DispatchDate = dispatchInput.DispatchDate;
                rl.MerchGroupID = dispatchInput.MerchGroupID;
                //obj.Routes = GetRoutesBS(rl);
                //obj.Merchandisers = GetMerchListBS(rl);


            }
            catch (Exception e) { throw (e); }

            return obj;
        }

        public async Task<MerchandisersContainer> GetDispatchesBS(int merchGroupId, DateTime dispatchDate, string lastModifiedBy, bool reset, int timeZoneOffsetToUTC)
        {
            // Data service Inststance
            DispatchDS dispatchDS = new DispatchDS();


            List<RouteTileContainer> objMercList = new List<RouteTileContainer>();


            List<DispatchRawData> result = new List<DispatchRawData>();
            DispatchRawDataOutput obj = new DispatchRawDataOutput();
            MerchandisersContainer output = new MerchandisersContainer();

            // get data from DB
            obj = await dispatchDS.GetDispatchesDS(merchGroupId, dispatchDate, lastModifiedBy, reset, timeZoneOffsetToUTC);

            result = obj.DisplayTabularData;


            output.ScheduleDateCount = obj.ScheduleDateCount;
            

            foreach (var v in result)
            {
                var v1 = objMercList.FirstOrDefault(c => c.RouteID == v.RouteID);
                if (v1 == null)
                {
                    v1 = new RouteTileContainer()
                    {
                        RouteID = v.RouteID,
                        RouteName = v.RouteName,
                        GSN = v.GSN,
                        FirstName = v.FirstName,
                        LastName = v.LastName,
                        AbsoluteURL = v.AbsoluteURL,
                        MerchGroupID = v.MerchGroupID,
                        DispatchDate = v.DispatchDate,
                        LastModifiedBy = v.LastModifiedBy,
                        Stores = new List<AccountsContainer>()
                    };
                    objMercList.Add(v1);
                }

                if (v.Sequence > 0 )
                {
                    v1.Stores.Add(new AccountsContainer()
                    {
                        AccountID = v.SAPAccountNumber,
                        AccountName = v.Accountname,
                        Sequence = v.Sequence,
                        DisplayTaskCount = v.DisplayTaskCount,
                        CheckInGSN = v.CheckInGSN,
                        ActualArrival = v.ActualArrival
                    });
                }

            }

            output.Routes = objMercList;
            return output;
        }

        public StoresContainer GetStoresBS(int merchGroupId, DateTime dispatchDate)
        {
            StoresContainer container = new StoresContainer();
            try
            {

                // Data service Inststance
                DispatchDS dispatchDS = new DispatchDS();


                container = dispatchDS.GetStoresDS(merchGroupId, dispatchDate);


            }
            catch (Exception e) { throw (e); }

            return container;
        }

        public StoresContainer GetStoresUnassignedBS(int merchGroupId, DateTime dispatchDate)
        {
            StoresContainer container = new StoresContainer();
            try
            {

                // Data service Inststance
                DispatchDS dispatchDS = new DispatchDS();


                container = dispatchDS.GetStoresUnassignedDS(merchGroupId, dispatchDate);


            }
            catch (Exception e) { throw (e); }

            return container;
        }

        public DispatchOutput InsertStorePredispatchBS(StorePredispatch sp)
        {
            DispatchOutput returnObj = new DispatchOutput();
            try
            {
                // Data service Inststance
                DispatchDS dispatchDS = new DispatchDS();
                returnObj = dispatchDS.InsertStorePredispatchDS(sp);

            }
            catch (Exception e) { throw (e); }
            return returnObj;
        }

        public DispatchOutput UpdateSequenceBS(ResequenceInput rc)
        {
            DispatchOutput returnObj = new DispatchOutput();
            try
            {
                // Data service Inststance
                DispatchDS dispatchDS = new DispatchDS();
                returnObj = dispatchDS.UpdateSequenceDS(rc);

            }
            catch (Exception e) { throw (e); }
            return returnObj;
        }

        public DispatchOutput RemoveStoreBS(RemoveStoreInput rc)
        {
            DispatchOutput returnObj = new DispatchOutput();
            try
            {
                // Data service Inststance
                DispatchDS dispatchDS = new DispatchDS();
                returnObj = dispatchDS.RemoveStoreDS(rc);

            }
            catch (Exception e) { throw (e); }
            return returnObj;
        }

        public async Task<RouteList> GetRoutesBS(RouteListExcludeCurrentInput rl)
        {
            RouteList returnObj = new RouteList();
            try
            {
                // Data service Inststance
                DispatchDS dispatchDS = new DispatchDS();
                returnObj = await dispatchDS.GetRoutesDS(rl);

            }
            catch (Exception e) { throw (e); }
            return returnObj;
        }

        public DispatchOutput ReassignStoreBS(ReassignStoreInput rc)
        {
            DispatchOutput returnObj = new DispatchOutput();
            try
            {
                StorePredispatch spd = new StorePredispatch();
                spd.DispatchDate = rc.DispatchDate;
                spd.GSN = rc.GSN;
                spd.LastModifiedBy = rc.LastModifiedBy;
                spd.MerchGroupID = rc.MerchGroupID;
                spd.RouteID = rc.TargetRouteID;
                spd.SAPAccountNumber = rc.SAPAccountNumber;

                returnObj = InsertStorePredispatchBS(spd);

                RemoveStoreInput rsi = new RemoveStoreInput();
                rsi.DispatchDate = rc.DispatchDate;
                rsi.LastModifiedBy = rc.LastModifiedBy;
                rsi.RouteID = rc.SourceRouteID;
                rsi.Sequence = rc.Sequence;

                returnObj = RemoveStoreBS(rsi);

            }
            catch (Exception e) { throw (e); }
            return returnObj;
        }


        public MerchListContainer GetMerchListBS(RouteListInput rl)
        {
            MerchListContainer returnObj = new MerchListContainer();
            try
            {
                // Data service Inststance
                DispatchDS dispatchDS = new DispatchDS();
                returnObj = dispatchDS.GetMerchListDS(rl.MerchGroupID, rl.DispatchDate);

            }
            catch (Exception e) { throw (e); }
            return returnObj;
        }

        public DispatchOutput ReassignMerchandiserBS(ReassignMerchInput rc)
        {
            DispatchOutput returnObj = new DispatchOutput();
            try
            {
                // Data service Inststance
                DispatchDS dispatchDS = new DispatchDS();
                returnObj = dispatchDS.ReassignMerchandiserDS(rc);

            }
            catch (Exception e) { throw (e); }
            return returnObj;
        }

        public DispatchReadyContainer DispatchReadyBS(DispatchInput di)
        {
            DispatchReadyContainer returnObj = new DispatchReadyContainer();
            try
            {
                // Data service Inststance
                DispatchDS dispatchDS = new DispatchDS();
                returnObj = dispatchDS.DispatchReadyDS(di);

            }
            catch (Exception e) { throw (e); }
            return returnObj;
        }

        public DispatchResultsContainer DispatchFinalBS(DispatchFinalInput di)
        {
            DispatchResultsContainer returnObj = new DispatchResultsContainer();
            try
            {
                // Data service Inststance
                DispatchDS dispatchDS = new DispatchDS();
                returnObj = dispatchDS.DispatchFinalDS(di);

            }
            catch (Exception e) { throw (e); }
            return returnObj;
        }

        public DispatchHistoryContainer GetDispatchHistoryBS(RouteListInput rl)
        {
            DispatchHistoryContainer returnObj = new DispatchHistoryContainer();
            try
            {
                // Data service Inststance
                DispatchDS dispatchDS = new DispatchDS();
                returnObj = dispatchDS.GetDispatchHistoryDS(rl);

            }
            catch (Exception e) { throw (e); }
            return returnObj;
        }

        public async Task<ScheduleStatusOutput> GetScheduleStatusBS(ScheduleStatusInput scheduleStatusInput)
        {
            ScheduleStatusOutput obj = new ScheduleStatusOutput();
            try
            {
                DispatchDS dispatchDS = new DispatchDS();
                obj = await dispatchDS.GetScheduleStatusDS(scheduleStatusInput.MerchGroupID, scheduleStatusInput.DispatchDate);

            }
            catch (Exception e) { throw (e); }

            return obj;
        }
    }
}
