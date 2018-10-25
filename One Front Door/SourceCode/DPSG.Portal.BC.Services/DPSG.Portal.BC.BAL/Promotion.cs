using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Reflection;
using DPSG.Portal.BC.Common;
using DPSG.Portal.BC.Types.Promotion;
using System.Collections;

namespace DPSG.Portal.BC.BAL
{
    public class Promotion : Base
    {
        public static PromotionData  GetPromotionsByRegionID(int BCRegionID, DateTime? ModifiedDate)
        {
            return DPSG.Portal.BC.DAL.BCRepository.GetPromotionsByRegionID(BCRegionID, ModifiedDate);
        }

        public static int[] GetPromotionsIDsByBottler(int BottlerID)
        {
            return DPSG.Portal.BC.DAL.BCRepository.GetPromotionsIDsByBottler(BottlerID);
        }

        public PromotionData GetPromotionsByRouteID(string routeID, DateTime? modifiedDate)
        {
            
            var results = new Types.Promotion.PromotionData();
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                results = oBCRepository.GetPromotionsByRouteID(routeID, modifiedDate);
                //objServiceLog.Exception = "";
                // oBCRepository.InsertWebServiceLog(objServiceLog);
            }
            catch (Exception ex)
            {
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }

            return results;

        }

        public static OtherPromoData GetOtherPromoMaster (DateTime? ModifiedDate)
        {
            return DPSG.Portal.BC.DAL.BCRepository.GetOtherPromoMaster(ModifiedDate);
        }

        public static ArrayList GetDocumentsByRouteNumber(string RouteNumber)
        {
            return DPSG.Portal.BC.DAL.BCRepository.GetDocumentsByRouteNumber(RouteNumber);
        }
    }
}
