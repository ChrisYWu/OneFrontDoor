using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Portal.BC.Model;
using System.Xml.Linq;

namespace DPSG.Portal.BC.Common
{
    public class ConvertXML
    {
        public string ReturnStoreConditionDisplayXml(List<StoreConditionDisplay> _lstStoreConditionDisp)
        {
            var xmlStrCondDisp = new XElement(Constants.STORECONDITIONDISPLAYS,
            from conditiondisp in _lstStoreConditionDisp
            select new XElement(Constants.STORECONDITIONDISPLAY,
                         new XElement(Constants.STORECONDITIONID, conditiondisp.StoreConditionID),
                           new XElement(Constants.DISPLAYLOCATIONID, conditiondisp.DisplayLocationID),
                           new XElement(Constants.PROMOTIONID, conditiondisp.PromotionID),
                           new XElement(Constants.DISPLAYLOCATIONNOTE, conditiondisp.DisplayLocationNote),
                           new XElement(Constants.DISPLAYTYPEID, conditiondisp.DisplayTypeID),
                           new XElement(Constants.OTHERNOTE, conditiondisp.OtherNote),
                           new XElement(Constants.DISPLAYIMAGEURL, conditiondisp.DisplayImageURL),
                           new XElement(Constants.GRIDX, conditiondisp.GridX),
                           new XElement(Constants.GRIDY, conditiondisp.GridY),
                           new XElement(Constants.XMLNODE_CREATEDBY, conditiondisp.CreatedBy),
                           new XElement(Constants.XMLNODE_CREATEDDATE, conditiondisp.CreatedDate),
                           new XElement(Constants.XMLNODE_MODIFIEDBY, conditiondisp.ModifiedBy),
                           new XElement(Constants.XMLNODE_MODIFIEDDATE, conditiondisp.ModifiedDate),
                           new XElement(Constants.XMLNODE_ISACTIVE, conditiondisp.IsActive),
                           new XElement(Constants.CLIENTDISPLAYID, conditiondisp.ClientDisplayID),
                           new XElement(Constants.REASONID, conditiondisp.ReasonID)
                           ));
            return xmlStrCondDisp.ToString();
        }

        public string ReturnStoreConditionDisplayDetailXML(List<Types.StoreConditionDisplayDetail> _lstStoreConditionDispDetail)
        {
            var xmlStrCondDispDtl = new XElement(Constants.STORECONDITIONDISPLAYDETAILS,
            from conditiondispDetail in _lstStoreConditionDispDetail
            select new XElement(Constants.STORECONDITIONDISPLAYDETAIL,
                         //new XElement("StoreConditionDisplayID", conditiondispDetail.StoreConditionDisplayID),
                           new XElement(Constants.SYSTEMPACKAGEID, conditiondispDetail.SystemPackageID),
                           new XElement(Constants.SYSTEMBRANDID, conditiondispDetail.SystemBrandID),
                           new XElement(Constants.XMLNODE_CREATEDBY, conditiondispDetail.CreatedBy),
                           new XElement(Constants.XMLNODE_CREATEDDATE, conditiondispDetail.CreatedDate),
                           new XElement(Constants.XMLNODE_MODIFIEDBY, conditiondispDetail.ModifiedBy),
                           new XElement(Constants.XMLNODE_MODIFIEDDATE, conditiondispDetail.ModifiedDate),
                           new XElement(Constants.XMLNODE_ISACTIVE, conditiondispDetail.IsActive),
                           new XElement(Constants.CLIENTDISPLAYID, conditiondispDetail.ClientDisplayId)
                           ));
            return xmlStrCondDispDtl.ToString();
        }


        public string ReturnStoreTieInRateXML(List<StoreTieInRate> lstStoreTieInRate)
        {
            var xmlStoreTieInRates = new XElement(Constants.STORETIEINRATES,
            from conditiondispDetail in lstStoreTieInRate
            select new XElement(Constants.STORETIEINRATE,
                        // new XElement("StoreConditionID", conditiondispDetail.StoreConditionID),
                           new XElement(Constants.SYSTEMBRANDID, conditiondispDetail.SystemBrandId),
                           new XElement(Constants.TIEINRATE, conditiondispDetail.TieInRate),
                           new XElement(Constants.XMLNODE_ISACTIVE, conditiondispDetail.IsActive),
                           new XElement(Constants.XMLNODE_CREATEDBY, conditiondispDetail.CreatedBy),
                           new XElement(Constants.XMLNODE_CREATEDDATE, conditiondispDetail.CreatedDate),
                           new XElement(Constants.XMLNODE_MODIFIEDBY, conditiondispDetail.ModifiedBy),
                           new XElement(Constants.XMLNODE_MODIFIEDDATE, conditiondispDetail.ModifiedDate),                             
                           new XElement(Constants.TOTALDISPLAYS, conditiondispDetail.TotalDisplays)
                           ));

            return xmlStoreTieInRates.ToString();
        }
    }
}
