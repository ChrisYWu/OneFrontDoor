using DPSG.Webapi.Merchandiser.DataServices;
using DPSG.Webapi.Merchandiser.Modal;
using DPSG.Webapi.Merchandiser.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Webapi.Merchandiser.BusinessServices
{
    public class RouteStoreAssignBS
    {
        public RSOutput GetRSDetailByWeekDayBS(RSInput rsInput)
        {
            RSOutput output = new RSOutput();
            try
            {
                RouteStoreAssignDS objDS = new RouteStoreAssignDS();
                output = objDS.GetRSDetailByWeekDayDS(rsInput);
            }
            catch (Exception e) { throw (e); }
            return output;
        }

        public StoreWeekDayOutput InsertStoreWeekday(StoreWeekDayInput sinput)
        {
            StoreWeekDayOutput output = new StoreWeekDayOutput();
            try
            {
                RouteStoreAssignDS objDS = new RouteStoreAssignDS();
                output = objDS.InsertStoreWeekday(sinput);
            }
            catch (Exception e) { throw (e); }
            return output;
        }

        public StoreContainer GetStoreListBS(int merchGroupId, int weekDay)
        {
            StoreContainer container = new StoreContainer();
            try
            {
                RouteStoreAssignDS objDS = new RouteStoreAssignDS();
                container = objDS.GetStoreListDS(merchGroupId, weekDay);
            }
            catch (Exception e) { throw (e); }

            return container;
        }

        public RoutesList GetRoutesBS(RouteInput rl)
        {
            RoutesList returnObj = new RoutesList();
            try
            {
                // Data service Inststance
                RouteStoreAssignDS objDS = new RouteStoreAssignDS();
                returnObj = objDS.GetRoutesDS(rl);

            }
            catch (Exception e) { throw (e); }
            return returnObj;
        }

        public StoreWeekDayOutput ReassignStorebyWeekDayBS(ReassignStoreInputData pinput)
        {
            StoreWeekDayOutput returnObj = new StoreWeekDayOutput();
            try
            {
                // Data service Inststance
                RouteStoreAssignDS objDS = new RouteStoreAssignDS();
                returnObj = objDS.ReassignStorebyWeekDayDS(pinput);

            }
            catch (Exception e) { throw (e); }
            return returnObj;
        }

        public StoreWeekDayOutput RemoveStoreByWeekDayBS(RemoveStoreInputData rc)
        {
            StoreWeekDayOutput returnObj = new StoreWeekDayOutput();
            try
            {
                // Data service Inststance
                RouteStoreAssignDS objDS = new RouteStoreAssignDS();
                returnObj = objDS.RemoveStoreByWeekDayDS(rc);

            }
            catch (Exception e) { throw (e); }
            return returnObj;
        }

        public StoreWeekDayOutput UpdateStoreSequenceBS(StoreResequenceInput rc)
        {
            StoreWeekDayOutput returnObj = new StoreWeekDayOutput();
            try
            {
                // Data service Inststance
                RouteStoreAssignDS objDS = new RouteStoreAssignDS();
                returnObj = objDS.UpdateStoreSequenceDS(rc);
            }
            catch (Exception e) { throw (e); }
            return returnObj;
        }


    }
}
