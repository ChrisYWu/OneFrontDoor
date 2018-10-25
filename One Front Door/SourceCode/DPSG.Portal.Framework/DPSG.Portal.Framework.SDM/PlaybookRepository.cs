/// <summary>
/*  
    * Module Name         :DPSG.Portal.Framework.SDM.PlaybookReposotry.cs
    * Purpose             :To interact with SDM
    * Created Date        :4/13/2013
    * Created By          :Ranjeet Tiwari/Summit Kanchan
    * Last Modified Date  :4/15/2013 
    * Last Modified By    :Ranjeet Tiwari
    * Where To Use        :PlayBook
    * Dependancy          :
*/
/// </summary>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Portal.Framework.Types;
using DPSG.Portal.Framework.CommonUtils;
using System.Data.Common;
using Telerik.OpenAccess.Data.Common;
using DPSG.Portal.Framework.Types.Constants;
using System.Reflection;
using System.Data;
using Microsoft.SharePoint;
using Microsoft.SharePoint.Utilities;
using System.Configuration;
using System.IO;
using System.Collections;
using System.Data.SqlClient;
using ApplicationRights = DPSG.Portal.Framework.Types.ApplicationRights;
using System.Xml.Linq;


namespace DPSG.Portal.Framework.SDM
{
    public class PlaybookRepository
    {
        private static string GetConnectionString()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString;

            return connectionString;
        }

        /// <summary>
        /// this method to create/update/createDuplicate Promotion
        /// </summary>
        /// <param name="objPlaybookProc"></param>
        /// <param name="executionStatus"></param>
        /// <param name="message"></param>
        public void InsertUpdatePromotion(Promotion objPromotion, ref int? executionStatus, ref string message)
        {
            try
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    int? newPromotionId = default(int?);

                    int effectedRows = objPlaybookEntities.PInsertUpdatePromotion(
                        objPromotion.ProcMode,
                        objPromotion.PromotionId,
                       objPromotion.PromotionDescription,
                       objPromotion.PromotionName,
                       objPromotion.PromotionTypeID,
                       objPromotion.GEORelavency,
                       objPromotion.AccountInfo,
                       objPromotion.ChannelXML,
                       objPromotion.GEOState,
                      objPromotion.AccountId,
                      objPromotion.EDGEItemID,
                      objPromotion.IsLocalized,
                      objPromotion.PromotionTradeMarkID,
                      objPromotion.PromotionBrandID,
                      objPromotion.PromotionPackageID,
                      objPromotion.PromotionPrice,
                      objPromotion.PromotionCategoryId,
                      objPromotion.PromotionDisplayLocationId,
                      objPromotion.PromotionDisplayLocationOther,
                      objPromotion.DisplayRequirement,
                      objPromotion.PromotionStartDate,
                      objPromotion.PromotionEndDate,
                      objPromotion.PromotionStatus,
                      objPromotion.SystemName,
                      objPromotion.ParentPromotionId,
                      objPromotion.IsNewVersion,
                      objPromotion.ForecastVolume,
                      objPromotion.NationalDisplayTarget,
                      objPromotion.BottlerCommitment,
                      objPromotion.BranchId,
                      objPromotion.BUID,
                      objPromotion.RegionId,
                      objPromotion.CreatedBy,
                      objPromotion.ModifiedBy,
                      objPromotion.AccountImageName,

                      objPromotion.PromotionGroupID,
                      objPromotion.ProgramId,
                      objPromotion.BestBets,
                      objPromotion.EdgeComments,
                      objPromotion.IsNationalAccountPromotion,
                      objPromotion.PromotionDisplayStartDate,
                      objPromotion.PromotionDisplayEndDate,
                      objPromotion.PromotionPricingStartDate,
                      objPromotion.PromotionPricingEndDate,
                      objPromotion.VariableRPC,
                      objPromotion.Redemption,
                      objPromotion.FixedCost,
                      objPromotion.AccrualComments,
                      objPromotion.Unit,
                      objPromotion.Accounting,
                      objPromotion.IsSMA,
                      objPromotion.IsCostPerStore,
                      objPromotion.TPMNumberCASO,
                      objPromotion.TPMNumberPASO,
                      objPromotion.TPMNumberISO,
                      objPromotion.TPMNumberPB,
                      objPromotion.RoleName,
                      objPromotion.PromotionDisplayTypeId,
                      objPromotion.PersonaID,
                      objPromotion.COSTPerStore,
                        ref executionStatus,
                        ref message,
                        ref newPromotionId, objPromotion.InformationCategory
                        );


                    if (effectedRows > 0)
                    {
                        

                        objPlaybookEntities.SaveChanges();
                        if (objPromotion.ProcMode == DBConstants.DB_PROC_MODE_INSERT)
                        {
                            // As discussed with Margaret and Rajesh S,  Rank should not saved at the time of Promotion Create

                            objPromotion.PromotionId = newPromotionId;
                            //List<PBPromotionRank> objPromoRanklst = GetStartEndDates(objPromotion.ProcMode, objPromotion, newPromotionId);
                            //if (objPromoRanklst != null)
                            //    objPlaybookEntities.Add(objPromoRanklst);
                            //objPlaybookEntities.SaveChanges();
                            //objPromotion.PromotionId = newPromotionId;
                        }
                        else if (objPromotion.ProcMode == DBConstants.DB_PROC_MODE_UPDATE && objPromotion.IsPRankChanged)
                        {
                            var promoToDelete = objPlaybookEntities.PBPromotionRanks.Where(i => i.PromotionID == objPromotion.PromotionId);
                            if (promoToDelete != null && promoToDelete.Count() > 0)
                            {
                                objPlaybookEntities.Delete(promoToDelete);
                                objPlaybookEntities.SaveChanges();
                            }

                            List<PBPromotionRank> objPromoRanklst = GetStartEndDates(objPromotion.ProcMode, objPromotion, newPromotionId);
                            if (objPromoRanklst != null)
                                objPlaybookEntities.Add(objPromoRanklst);
                            objPlaybookEntities.SaveChanges();

                        }
                        
                        UpdateOtherPromotionDetails(objPromotion, objPlaybookEntities);
                        objPlaybookEntities.SaveChanges();

                        if ((bool)objPromotion.IsNationalAccountPromotion && objPromotion.PromotionStatus == DBConstants.DB_PROMOTION_STATUS_CANCELLED)
                        {
                            UpdateChildOnNAPromotionCancelled((int)objPromotion.PromotionId, objPromotion.ModifiedBy);
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
        }

        private void UpdateOtherPromotionDetails(Promotion objPromotion, PlaybookEntities objPlaybookEntities)
        {
            DbParameter[] parm = { (new OAParameter { ParameterName = "@PromotionID", Value = objPromotion.PromotionId}),
                                            (new OAParameter { ParameterName = "@OtherBrandPriced", Value = objPromotion.OtherBrandPrice }),
                                            (new OAParameter { ParameterName = "@SendBottlerAnnouncement", Value = objPromotion.SendBottlerAnnouncements })};
            int retVal = objPlaybookEntities.ExecuteNonQuery("[PlayBook].[pUpdateOtherPromotionDetails]", System.Data.CommandType.StoredProcedure, parm);
        }

        /// <summary>
        /// create multiple copies of promotion
        /// </summary>
        /// <param name="promotionId"></param>
        public void CreatePromotionCopies(int promotionId, string connectionStr = null)
        {
            try
            {
                using (PlaybookEntities objPlaybookEntities = !string.IsNullOrEmpty(connectionStr) ? new PlaybookEntities(connectionStr) : new PlaybookEntities())
                {
                    objPlaybookEntities.PCreatePromotionCopies(promotionId);
                    objPlaybookEntities.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
        }
        public void UpdatePromotionStatusForEdgePromotion(int promotionId, string status)
        {
            try
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    PBStatus objPBStatus = objPlaybookEntities.PBStatus.Where(i => i.StatusName.ToLower() == status.ToLower()).FirstOrDefault();
                    if (objPBStatus != null)
                    {
                        PBRetailPromotion objPBRetailPromotion = objPlaybookEntities.PBRetailPromotions.SingleOrDefault(i => i.PromotionID == promotionId);
                        if (objPBRetailPromotion != null)
                        {
                            objPBRetailPromotion.PromotionStatusID = objPBStatus.StatusID;
                            objPlaybookEntities.SaveChanges();

                        }
                    }

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
        }

        // Remove System/RTM
        //private void InsertUpdateAttachment(int promotionId, List<PromoAttachment> objPromoAttachmentlst, string mode, string folderurl, List<ProgramSystem> lstSystem)
        private void InsertUpdateAttachment(int promotionId, List<PromoAttachment> objPromoAttachmentlst, string mode, string folderurl)
        {
            using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
            {
                if (objPromoAttachmentlst != null)
                {
                    if (objPromoAttachmentlst != null && objPlaybookEntities != null)
                    {
                        if (mode == DBConstants.DB_PROC_MODE_INSERT)
                        {
                            var attachments = objPromoAttachmentlst.Select(i => new PBPromotionAttachment()
                            {
                                AttachmentName = i.Name,
                                PromotionID = promotionId,
                                //AttachmentTypeID = promotionCategaryType == CommonConstants.NON_PROMOTION_TYPE ? CommonConstants.NON_PROMO_CONTENT_ATTACHMENTTYPE_ID : i.TypeId,
                                AttachmentTypeID = i.TypeId,
                                AttachmentURL = (i.IsNew) ? folderurl : i.URL.Substring(0, i.URL.LastIndexOf('/')),
                                AttachmentDocumentID = i.AttachmentDocumentID,
                                AttachmentSize = i.AttachmentSize,
                                AttachmentDateModified = DateTime.Now
                            }
                                //SystemId = i.SystemId, 
                                //DisplaySystemIds = i.SystemDisplayNames }
                                );
                            objPlaybookEntities.Add(attachments);
                            objPlaybookEntities.SaveChanges();
                            //InsertAttachmentSystem(objPlaybookEntities, promotionId, lstSystem);
                        }
                        else if (mode == DBConstants.DB_PROC_MODE_UPDATE)
                        {
                            var filesDelete = objPlaybookEntities.PBPromotionAttachments.Where(i => i.PromotionID == promotionId);
                            if (filesDelete != null)
                            {
                                int[] attachmentSystemToDelete = filesDelete.Select(i => i.PromotionAttachmentID).ToArray();
                                try
                                {
                                    var systemToDelete = objPlaybookEntities.PBPromotionAttachmentSystems.Where(i => attachmentSystemToDelete.Contains((int)i.PromotionAttachmentID));
                                    if (systemToDelete != null)
                                    {
                                        objPlaybookEntities.Delete(systemToDelete);
                                        objPlaybookEntities.SaveChanges();
                                    }
                                }
                                catch (Exception ex)
                                {

                                }
                                objPlaybookEntities.Delete(filesDelete);
                                objPlaybookEntities.SaveChanges();

                            }
                        }
                    }
                }
                //UpdateAttachments(promotionId, objPromoAttachmentlst, mode, folderurl, lstSystem);
                UpdateAttachments(promotionId, objPromoAttachmentlst, mode, folderurl);

            }
        }

        public void InsertUpdateAttachment_New(int promotionId, string strToDeserialize, string mode)
        {
            try
            {
                List<PromoAttachment> objPromoAttachmentlst = null;
                if (!string.IsNullOrEmpty(strToDeserialize))
                    //    //&& (IsNewVersionPromotion.HasValue) ? (bool)IsNewVersionPromotion : false)
                    //    lstFiles = GetAttachmentByPromotionId((int)parentPromotionId, SPContext.Current.Web.ServerRelativeUrl, (int?)null);
                    //else
                    objPromoAttachmentlst = JSONSerelization.Deserialize<List<PromoAttachment>>(strToDeserialize);

                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    if (objPromoAttachmentlst != null)
                    {
                        if (objPromoAttachmentlst != null && objPlaybookEntities != null)
                        {
                            if (mode == DBConstants.DB_PROC_MODE_INSERT) //|| mode == DBConstants.DB_PROC_MODE_UPDATE
                            {
                                var attachments = objPromoAttachmentlst.Select(i => new PBPromotionAttachment()
                                {
                                    AttachmentName = i.Name,
                                    PromotionID = promotionId,
                                    AttachmentTypeID = i.TypeId,
                                    AttachmentURL = i.URL.Substring(0, i.URL.LastIndexOf('/')),
                                    AttachmentDocumentID = i.AttachmentDocumentID,
                                    AttachmentSize = i.AttachmentSize,
                                    AttachmentDateModified = DateTime.Now
                                    //SystemId = i.SystemId, 
                                    //DisplaySystemIds = i.SystemDisplayNames
                                }
                                    );
                                objPlaybookEntities.Add(attachments);
                                objPlaybookEntities.SaveChanges();
                                //InsertAttachmentSystem(objPlaybookEntities, promotionId, lstSystem);
                            }
                            else if (mode == DBConstants.DB_PROC_MODE_UPDATE)
                            {
                                var filesDelete = objPlaybookEntities.PBPromotionAttachments.Where(i => i.PromotionID == promotionId);
                                if (filesDelete != null)
                                {
                                    int[] attachmentSystemToDelete = filesDelete.Select(i => i.PromotionAttachmentID).ToArray();
                                    try
                                    {
                                        var systemToDelete = objPlaybookEntities.PBPromotionAttachmentSystems.Where(i => attachmentSystemToDelete.Contains((int)i.PromotionAttachmentID));
                                        if (systemToDelete != null)
                                        {
                                            objPlaybookEntities.Delete(systemToDelete);
                                            objPlaybookEntities.SaveChanges();
                                        }
                                    }
                                    catch (Exception ex)
                                    {

                                    }
                                    objPlaybookEntities.Delete(filesDelete);
                                    objPlaybookEntities.SaveChanges();

                                }

                                var attachments = objPromoAttachmentlst.Select(i => new PBPromotionAttachment()
                                {
                                    AttachmentName = i.Name,
                                    PromotionID = promotionId,
                                    //AttachmentTypeID = promotionCategaryType == CommonConstants.NON_PROMOTION_TYPE ? CommonConstants.NON_PROMO_CONTENT_ATTACHMENTTYPE_ID : i.TypeId,
                                    AttachmentTypeID = i.TypeId,
                                    AttachmentURL = i.URL.Substring(0, i.URL.LastIndexOf('/')),
                                    AttachmentDocumentID = i.AttachmentDocumentID,
                                    AttachmentSize = i.AttachmentSize,
                                    AttachmentDateModified = DateTime.Now
                                    //SystemId = i.SystemId, 
                                    //DisplaySystemIds = i.SystemDisplayNames
                                }
                                   );
                                objPlaybookEntities.Add(attachments);
                                objPlaybookEntities.SaveChanges();
                            }
                        }
                    }
                    //UpdateAttachments(promotionId, objPromoAttachmentlst, mode, folderurl, lstSystem);
                    //UpdateAttachments(promotionId, objPromoAttachmentlst, mode, folderurl);

                }
            }
            catch (Exception ex)
            {

            }

        }


        /* Remove System/RTM*/
        //private void UpdateAttachments(int promotionId, List<PromoAttachment> objPromoAttachmentlst, string mode, string folderurl, List<ProgramSystem> lstSystem)
        private void UpdateAttachments(int promotionId, List<PromoAttachment> objPromoAttachmentlst, string mode, string folderurl)
        {
            if (mode == DBConstants.DB_PROC_MODE_UPDATE)
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    if (objPromoAttachmentlst != null)
                    {
                        var attachments = objPromoAttachmentlst.Where(i => i.IsDeleted == false).Select(i => new PBPromotionAttachment()
                        {
                            AttachmentName = i.Name,
                            PromotionID = promotionId,
                            AttachmentTypeID = i.TypeId,
                            AttachmentURL = (i.IsNew) ? folderurl : i.URL.Substring(0, i.URL.LastIndexOf('/')),
                            AttachmentDocumentID = i.AttachmentDocumentID,
                            AttachmentSize = (i.Content != null) ? i.Content.Length : i.AttachmentSize,
                            AttachmentDateModified = DateTime.Now
                            //SystemId = i.SystemId, 
                            //DisplaySystemIds = i.SystemDisplayNames
                        });
                        objPlaybookEntities.Add(attachments);
                        objPlaybookEntities.SaveChanges();

                    }
                    /* Remove System/RTM
                    InsertAttachmentSystem(objPlaybookEntities, promotionId);
                     */
                }
            }
        }

        /* Remove System/RTM
        private void InsertAttachmentSystem(PlaybookEntities objDB, int promotionId, List<ProgramSystem> lstSystem)
        {

            var systemsToAdd = objDB.PBPromotionAttachments.Where(i => !string.IsNullOrEmpty(i.DisplaySystemIds) && i.PromotionID == promotionId);

            if (systemsToAdd.Count() > 0)
            {
                try
                {
                    // Remove System/RTM
                    //List<ProgramSystem> lstAllSystem = lstSystem;
                    List<PBPromotionAttachmentSystem> lsAttachmentSystem = new List<PBPromotionAttachmentSystem>();

                    foreach (var item in systemsToAdd)
                    {
                        string[] systems = item.DisplaySystemIds.Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
                        foreach (string system in systems)
                        {
                            lsAttachmentSystem.Add(new PBPromotionAttachmentSystem()
                            {
                                PromotionAttachmentID = item.PromotionAttachmentID,
                                // Remove System/RTM
                                //SystemId = lstAllSystem.Where(i => string.Compare(i.Name, system, true) == 0).Select(i => i.ID).First()
                            });
                        }
                    }
                    objDB.Add(lsAttachmentSystem);
                    objDB.SaveChanges();
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
            }
        }
         */

        private List<PBPromotionRank> GetStartEndDates(string mode, Promotion objPromotion, int? promotionId)
        {
            List<PBPromotionRank> objPromoRanklst = null;
            try
            {
                if (objPromotion.PromotionStartDate != null && objPromotion.PromotionEndDate != null)
                {
                    objPromoRanklst = new List<PBPromotionRank>();
                    DateTime? sBeginDate = objPromotion.PromotionStartDate;
                    DateTime? sEndDate = objPromotion.PromotionEndDate;//Given in input
                    DateTime weekStartDate;
                    DateTime weekEndDate;
                    DayOfWeek firstday = DayOfWeek.Monday;
                    weekStartDate = Convert.ToDateTime(sBeginDate);
                    do
                    {
                        while (weekStartDate.DayOfWeek != firstday)
                        {
                            weekStartDate = weekStartDate.AddDays(-1);
                        }
                        weekEndDate = weekStartDate.AddDays(6);
                        objPromoRanklst.Add(new PBPromotionRank() { PromotionWeekStart = weekStartDate, PromotionWeekEnd = weekEndDate, Rank = (objPromotion.PromotionRank != (int?)null) ? objPromotion.PromotionRank : DBConstants.DEFAULT_VALUE_RANK, PromotionID = objPromotion.PromotionId });
                        weekStartDate = weekEndDate.AddDays(1);
                    }
                    while ((sEndDate.Value.Subtract(weekEndDate)).Days > 0);
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objPromoRanklst;
        }

        /// <summary>
        /// get all promotion types for promotion
        /// </summary>
        /// <returns></returns>
        public List<PBPromotionType> GetPromotionType()
        {
            List<PBPromotionType> objlstPromotionTypes = null;
            try
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    objlstPromotionTypes = objPlaybookEntities.PBPromotionTypes.ToList();

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objlstPromotionTypes;
        }

        /// <summary>
        /// Get Promotion type based on Role
        /// </summary>
        /// <param name="objOnePortalRole"></param>
        /// <param name="IsViewMode"></param>
        /// <returns></returns>
        public List<PBPromotionType> GetPersonalizedType(bool IsViewMode)
        {
            List<PBPromotionType> lstPromotionType = GetPromotionType();
            //if (!IsViewMode)
            //{
            //    switch (objOnePortalRole)
            //    {
            //        //case OnePortalRole.AD:
            //        //case OnePortalRole.SEM:
            //        //case OnePortalRole.BM:
            //        //case OnePortalRole.DM:
            //        //    {
            //                //remove National and Region type
            //                lstPromotionType = lstPromotionType.Where(i => i.PromotionTypeID == (int)PromoType.Local).ToList();
            //               // break;
            //            //}
            //    }
            //}
            return lstPromotionType;
        }

        /// <summary>
        /// Get all promotion categories for promotion 
        /// </summary>
        /// <returns></returns>
        public List<PBPromotionCategory> GetPromotionCategory()
        {

            List<PBPromotionCategory> objlstPromotionCategories = null;
            try
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {

                    objlstPromotionCategories = objPlaybookEntities.PBPromotionCategories.Select(i => new PBPromotionCategory() { PromotionCategoryName = i.PromotionCategoryName, PromotionCategoryID = i.PromotionCategoryID, IsDeleted = i.IsDeleted })
                    .OrderBy(i => i.PromotionCategoryName).ToList();

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objlstPromotionCategories;
        }

        /// <summary>
        /// get all display locations of promotion
        /// </summary>
        /// <returns></returns>
        public List<PBDisplayLocation> GetPromotionDisplayLocations()
        {
            List<PBDisplayLocation> objlstPromotionDisplayLocation = null;
            try
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    objlstPromotionDisplayLocation = objPlaybookEntities.PBDisplayLocations.Select(i => new PBDisplayLocation() { DisplayLocationName = i.DisplayLocationName, DisplayLocationID = i.DisplayLocationID }).OrderBy(j => j.DisplayLocationName).ToList();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objlstPromotionDisplayLocation;
        }

        /// <summary>
        /// Get all Display Type from Shared.DisplayType table
        /// </summary>
        /// <returns></returns>
        public List<PBDisplayType> GetPromotionDisplayType()
        {
            List<PBDisplayType> objlstPromotionDisplayType = null;
            try
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    objlstPromotionDisplayType = objPlaybookEntities.PBDisplayTypes.Select(i => new PBDisplayType() { Description = i.Description, DisplayTypeId = i.DisplayTypeId }).OrderBy(j => j.Description).ToList();

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objlstPromotionDisplayType;
        }
        /// <summary>
        /// Get all promotion for particular promotion
        /// </summary>
        /// <param name="promotionId"></param>
        /// <returns></returns>
        public List<PromoAttachment> GetAttachmentByPromotionId(int promotionId, string webUrl, int? programId)
        {
            List<PromoAttachment> objlstPromotionAttachmentn = null;
            try
            {
                if (programId != null)
                {
                    objlstPromotionAttachmentn = GetAttachmentByProgramId(programId).ToList();
                }
                else
                {
                    using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                    {
                        objlstPromotionAttachmentn = (from attachment in objPlaybookEntities.PBPromotionAttachments
                                                      join attachmentType in objPlaybookEntities.PBAttachmentTypes
                                                       on attachment.AttachmentTypeID equals attachmentType.AttachmentTypeID
                                                      where attachment.PromotionID == promotionId
                                                      select new PromoAttachment()
                                                      {
                                                          Name = attachment.AttachmentName,
                                                          URL = SPUrlUtility.CombineUrl(attachment.AttachmentURL, attachment.AttachmentName),
                                                          ID = attachment.PromotionAttachmentID,
                                                          Type = attachmentType.AttachmentTypeName,
                                                          TypeId = (int)attachment.AttachmentTypeID,
                                                          AttachmentSize = (int)attachment.AttachmentSize,
                                                          AttachmentDocumentID = attachment.AttachmentDocumentID,
                                                          // SystemDisplayNames = attachment.DisplaySystemIds,
                                                          IsNew = false

                                                      }).ToList();

                    }
                }


            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objlstPromotionAttachmentn;
        }

        /// <summary>
        /// Get attachments by programID
        /// </summary>
        /// <param name="programId"></param>
        /// <returns></returns>
        public List<PromoAttachment> GetAttachmentByProgramId(int? programId)
        {
            List<PromoAttachment> objlstProgranAttachments = null;
            if (programId == null)
            {
                objlstProgranAttachments = new List<PromoAttachment>();
            }
            else
            {
                try
                {
                    using (PlaybookEntities objDB = new PlaybookEntities())
                    {
                        objlstProgranAttachments = (from attachment in objDB.PBProgramMilestoneAttachments
                                                    join prgrmMilestone in objDB.PBProgramMilestones
                                                     on new { attachment.ProgramID, attachment.MilestoneID } equals new { prgrmMilestone.ProgramID, prgrmMilestone.MilestoneID }
                                                    join attachmentType in objDB.PBAttachmentTypes
                                                    on attachment.AttachmentTypeID equals attachmentType.AttachmentTypeID
                                                    where attachment.ProgramID == programId && prgrmMilestone.CopyAttachment == true && attachment.ApprovalStatusID == 4
                                                    select new PromoAttachment()
                                                    {
                                                        Name = attachment.DocumentName,
                                                        URL = SPUrlUtility.CombineUrl(attachment.DocumentURL, attachment.DocumentName),
                                                        ID = attachment.MilestoneAttachmentID,
                                                        TypeId = (int)attachment.AttachmentTypeID,
                                                        Type = attachmentType.AttachmentTypeName,
                                                        SystemId = (attachment.SystemID != (int?)null) ? (int)attachment.SystemID : 0,
                                                        SystemDisplayNames = attachment.DisplaySystemNames,
                                                        AttachmentSize = !string.IsNullOrEmpty(attachment.DocumentSize) ? Convert.ToInt32(attachment.DocumentSize) : 0,
                                                        AttachmentDocumentID = attachment.DocumentID,
                                                        IsNew = false
                                                    }).ToList();

                    }
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
            }
            return objlstProgranAttachments;
        }

        /// <summary>
        /// To check that is there any local version exists fro this promotion.
        /// </summary>
        /// <param name="promotionId"></param>
        /// <returns></returns>
        public bool IsLocalVersionExist(int promotionId)
        {
            bool flag = false;
            try
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    var items = objPlaybookEntities.PBRetailPromotions.Where(i => i.ParentPromotionID == promotionId).ToList<PBRetailPromotion>();
                    if (items.Count() > 0)
                        flag = true;
                    else
                        flag = false;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return flag;
        }

        /// <summary>
        /// get particular promotion by id 
        /// </summary>
        /// <param name="promotionId"></param>
        /// <returns></returns>
        public Promotion GetPromotionById(int promotionId)
        {
            Promotion objPromotion = null;
            try
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    if (promotionId != 0)
                    {
                        objPromotion = (from promotion in objPlaybookEntities.PBRetailPromotions
                                        join location in objPlaybookEntities.PBPromotionDisplayLocations
                                        on promotion.PromotionID equals location.PromotionID
                                        join status in objPlaybookEntities.PBStatus
                                        on promotion.PromotionStatusID equals status.StatusID

                                        where promotion.PromotionID == promotionId
                                        select new Promotion()
                                        {
                                            //AccountId = GetRootAccountIDByPromotion(objPlaybookEntities, promotionId),
                                            //AccountInfo = GetAccountInfoByPromotionID(objPlaybookEntities, promotionId), //(account.LocalChainID != null) ? account.LocalChainID : (account.RegionalChainID != null) ? account.RegionalChainID : (account.NationalChainID != null) ? account.NationalChainID : (int?)null,
                                            PromotionId = promotion.PromotionID,
                                            PromotionName = promotion.PromotionName,
                                            PromotionDescription = promotion.PromotionDescription,
                                            PromotionCategoryId = promotion.PromotionCategoryID,
                                            PromotionDisplayLocationId = location.DisplayLocationID,
                                            PromotionPrice = promotion.PromotionPrice,
                                            PromotionPackages = promotion.PromotionPackages,
                                            PromotionRank = promotion.CreatedPromotionRank,
                                            ParentPromotionId = promotion.ParentPromotionID,
                                            PromotionTypeID = promotion.PromotionTypeID,
                                            PromotionGroupID = promotion.PromotionGroupID,
                                            PromotionEndDate = promotion.PromotionEndDate,
                                            EDGEItemID = promotion.EDGEItemID,
                                            IsLocalized = promotion.IsLocalized,
                                            PromotionStatus = status.StatusName,
                                            PromotionStartDate = promotion.PromotionStartDate,
                                            /*New Date Fields */
                                            PromotionDisplayStartDate = promotion.DisplayStartDate,
                                            PromotionDisplayEndDate = promotion.DisplayEndDate,
                                            PromotionPricingStartDate = promotion.PricingStartDate,
                                            PromotionPricingEndDate = promotion.PricingEndDate,
                                            /*End */
                                            ForecastVolume = promotion.ForecastVolume,
                                            NationalDisplayTarget = promotion.NationalDisplayTarget,
                                            BottlerCommitment = promotion.BottlerCommitment,
                                            PromotionDisplayLocationOther = location.PromotionDisplayLocationOther,
                                            DisplayRequirement = location.DisplayRequirement,
                                            BUID = promotion.PromotionBUID,
                                            ModifiedBy = promotion.ModifiedBy,
                                            PromotionModifiedDate = promotion.ModifiedDate.Value,
                                            ProgramId = promotion.ProgramId,
                                            BestBets = promotion.BestBets,
                                            EdgeComments = promotion.EdgeComments,
                                            IsNationalAccountPromotion = promotion.IsNationalAccount.HasValue ? promotion.IsNationalAccount.Value : false,
                                            IsSMA = promotion.IsSMA.HasValue ? promotion.IsSMA.Value : false,
                                            IsCostPerStore = promotion.IsCostPerStore.HasValue ? promotion.IsCostPerStore.Value : false,
                                            TPMNumberCASO = promotion.TPMCASO,
                                            TPMNumberPASO = promotion.TPMPASO,
                                            TPMNumberISO = promotion.TPMISO,
                                            TPMNumberPB = promotion.TPMPB,
                                            PromotionDisplayTypeId = promotion.DisplayTypeID,
                                            COSTPerStore = promotion.CostPerStore,
                                            InformationCategory = promotion.InformationCategory,
                                            VariableRPC = promotion.RPC,
                                            Redemption = promotion.Redemption,
                                            FixedCost = promotion.FixedCost,
                                            AccrualComments = promotion.AccrualComments,
                                            Unit=promotion.Unit,
                                            Accounting=promotion.Accounting

                                        }).FirstOrDefault();
                    }

                    if (objPromotion != null)
                    {
                        GetOtherPromotionDetails(objPlaybookEntities, objPromotion);
                        //objPromotion.IsBCPromotion = false;
                        GetGeoRelevancyByPromotionId(objPlaybookEntities, objPromotion);
                        if (objPromotion.PromotionGroupID == Convert.ToInt32(PromotionGroup.Account))
                            GetAccountInfoByPromotion(objPlaybookEntities, objPromotion);
                        else if (objPromotion.PromotionGroupID == Convert.ToInt32(PromotionGroup.Channel))
                            GetChannelInfoByPromotion(objPlaybookEntities, objPromotion);
                        //Fetch brand and package 
                        GetBrandAndPackageByPromotionId(objPromotion, objPlaybookEntities);

                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objPromotion;
        }

        private void GetOtherPromotionDetails(PlaybookEntities objPlaybookEntities, Promotion objPromotion)
        {
            DbParameter[] parm = { (new OAParameter { ParameterName = "@PromotionID", Value = objPromotion.PromotionId }) };
            IList<Promotion> promos = objPlaybookEntities.ExecuteQuery<Promotion>("Playbook.pGetOtherPromotionDetails", CommandType.StoredProcedure, parm);
            if (promos != null && promos.Count > 0)
            {
                objPromotion.OtherBrandPrice = promos[0].OtherBrandPrice;
                objPromotion.SendBottlerAnnouncements = promos[0].SendBottlerAnnouncements;
            }
        }

        private void GetChannelInfoByPromotion(PlaybookEntities objPlaybookEntities, Promotion objPromotion)
        {
            try
            {
                List<PBPromotionChannel> usrChannels = objPlaybookEntities.PBPromotionChannels.Where(i => i.PromotionID == objPromotion.PromotionId).ToList();


                //Get all the account for the current prmotion
                List<SelectedTreeItem> objTreeViewItems = new List<SelectedTreeItem>();

                List<int> sprIds = usrChannels.Select(i => Convert.ToInt32(i.SuperChannelID)).ToList();
                List<int> locIds = usrChannels.Select(i => Convert.ToInt32(i.ChannelID)).ToList();

                var allChannels = objPlaybookEntities.PBLocationChannels.Select(i => new { i.SuperChannelID, i.SAPSuperChannelID, i.SuperChannelName, i.ChannelID, i.ChannelName, i.SAPChannelID }).ToList();

                var allSuperChannels = (from allChannel in allChannels
                                        where sprIds.Contains(Convert.ToInt32(allChannel.SuperChannelID))
                                        select new { allChannel.SuperChannelID, allChannel.SAPSuperChannelID, allChannel.SuperChannelName }).Distinct();

                objTreeViewItems.AddRange(allSuperChannels.Select(i => new SelectedTreeItem() { ItemLevel = 0, Name = Convert.ToString(i.SuperChannelName), Type = ChannelType.SuperChannel.ToString(), Value = i.SuperChannelID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + ChannelType.SuperChannel.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPSuperChannelID }));


                var channels = (from allChannel in allChannels
                                where locIds.Contains(Convert.ToInt32(allChannel.ChannelID))
                                select new { allChannel.ChannelID, allChannel.ChannelName, allChannel.SAPChannelID, allChannel.SuperChannelID }).Distinct();
                objTreeViewItems.AddRange(channels.Select(i => new SelectedTreeItem() { Type = ChannelType.Channel.ToString(), ItemLevel = 1, Name = Convert.ToString(i.ChannelName), Value = i.ChannelID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + ChannelType.Channel.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPChannelID }));

                objPromotion.SelectedChannels = objTreeViewItems;
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
        }

        #region Section "Account"

        #region Public Methods

        /// <summary>
        /// Gets the List of Account Information of the corresponding account with all the child accounts
        /// </summary>
        /// <param name="AccountId"></param>
        /// <param name="SelectedAccountType"></param>
        /// <returns>List of AccountInfo</returns>
        public List<AccountInfo> GetAccountsInfoById(int AccountId, AccountType SelectedAccountType, List<GEOListItem> SelectedGeo)
        {
            List<CustomLocationChain> _loactionChain = null;
            List<AccountInfo> lstAccountsTreeView = null;
            bool _isDSDGeography = false;
            bool _isBCGeography = false;

            // This will create the cache from the mview.loactionchain which will increase the performance while retrieving the records.
            GetAccountInfoById(AccountId, SelectedAccountType);

            if (CacheHelper.GetCacheValue(CacheKeys.GET_RELATIONSHIP_FROM_LOCATION_CHAIN) != null)
            {
                _loactionChain = (List<CustomLocationChain>)CacheHelper.GetCacheValue(CacheKeys.GET_RELATIONSHIP_FROM_LOCATION_CHAIN);
            }

            #region Check if the Request is for BC or DSD- get the cache value accordingly. Note: Account only for 1 type (DSD/BC) will be returned

            if (SelectedGeo.Any(i => i.Type == PromoGeoType.System || i.Type == PromoGeoType.Zone || i.Type == PromoGeoType.Division || i.Type == PromoGeoType.BCRegion))
            {
                _isBCGeography = true;
            }
            else if (SelectedGeo.Any(i => i.Type == PromoGeoType.BU || i.Type == PromoGeoType.Region || i.Type == PromoGeoType.Branch || i.Type == PromoGeoType.Area))
            {
                _isDSDGeography = true;
            }

            #endregion

            #region Get the Valid account for the DSD Geography
            if (_loactionChain != null && _isDSDGeography)
            {
                var BU = SelectedGeo.Where(i => i.Type == PromoGeoType.BU).Select(i => i.ID.Split(CommonConstants.BC_LIST_ITEM_SEPERATOR.ToCharArray(), StringSplitOptions.RemoveEmptyEntries)[0]).ToArray();
                var Region = SelectedGeo.Where(i => i.Type == PromoGeoType.Region).Select(i => i.ID.Split(CommonConstants.BC_LIST_ITEM_SEPERATOR.ToCharArray(), StringSplitOptions.RemoveEmptyEntries)[0]).ToArray();
                var Branch = SelectedGeo.Where(i => i.Type == PromoGeoType.Branch).Select(i => i.ID.Split(CommonConstants.BC_LIST_ITEM_SEPERATOR.ToCharArray(), StringSplitOptions.RemoveEmptyEntries)[0]).ToArray();
                var Area = SelectedGeo.Where(i => i.Type == PromoGeoType.Area).Select(i => i.ID.Split(CommonConstants.BC_LIST_ITEM_SEPERATOR.ToCharArray(), StringSplitOptions.RemoveEmptyEntries)[0]).ToArray();
                List<CustomLocationChain> _lstDSD = new List<CustomLocationChain>();
                _lstDSD = _loactionChain.Where(i => i.BCRegionID < 0).ToList();

                switch (SelectedAccountType)
                {
                    case AccountType.Local:
                        {
                            lstAccountsTreeView = new List<AccountInfo>();

                            //Get the local account
                            lstAccountsTreeView = _lstDSD.Where(i => i.LocalChainID == AccountId)
                                                                                        .Select(i => new AccountInfo() { AccountID = i.LocalChainID, AccountName = i.LocalChainName, AccountType = Types.AccountType.Local, LocalChainID = i.LocalChainID, NationalChainID = i.NationalChainID, RegionalChainID = i.RegionalChainID, })
                                                                                        .DistinctBy(i => i.AccountName)
                                                                                        .ToList();
                        }
                        break;
                    case AccountType.Regional:
                        {
                            lstAccountsTreeView = new List<AccountInfo>();

                            //Get all the regional accounts with selected region ID
                            var allAccountswtGeo = _lstDSD.Where(i => i.RegionalChainID == AccountId).ToList();
                            var allAccounts = allAccountswtGeo.Where(i => BU.Contains(i.BUID.ToString()) || Region.Contains(i.RegionID.ToString()) || Branch.Contains(i.BranchID.ToString()) || Area.Contains(i.AreaID.ToString())).Select(i => new { i.LocalChainID, i.LocalChainName, i.RegionalChainName, i.RegionalChainID, i.NationalChainName, i.NationalChainID }).ToList();

                            // Add all the Regions to the list of TreeView Item
                            var regionalAccounts = allAccounts.Select(i => new { i.RegionalChainID, i.RegionalChainName, i.NationalChainID }).DistinctBy(i => i.RegionalChainName);
                            lstAccountsTreeView.AddRange(regionalAccounts.Select(i => new AccountInfo()
                            {
                                AccountID = i.RegionalChainID,
                                AccountName = i.RegionalChainName,
                                AccountType = Types.AccountType.Regional,
                                RegionalChainID = i.RegionalChainID,
                                NationalChainID = i.NationalChainID,

                            }));

                            //Get all the local account of the selected regions
                            var localAccounts = (from allAccount in allAccounts
                                                 join regionalaccount in regionalAccounts
                                                 on allAccount.RegionalChainID equals regionalaccount.RegionalChainID
                                                 select new { allAccount.LocalChainID, allAccount.LocalChainName, allAccount.RegionalChainID, allAccount.NationalChainID }).DistinctBy(i => i.LocalChainName);

                            lstAccountsTreeView.AddRange(localAccounts.Select(i => new AccountInfo()
                            {
                                AccountID = i.LocalChainID,
                                AccountName = i.LocalChainName,
                                AccountType = Types.AccountType.Local,
                                LocalChainID = i.LocalChainID,
                                RegionalChainID = i.RegionalChainID,
                                NationalChainID = i.NationalChainID
                            }));
                        }
                        break;
                    case AccountType.National:
                        {
                            lstAccountsTreeView = new List<AccountInfo>();

                            //Get all the national accounts of the seleted national account
                            var allAccountwtGeo = _lstDSD.Where(i => i.NationalChainID == AccountId).ToList();
                            var allAccounts = allAccountwtGeo.Where(i => BU.Contains(i.BUID.ToString()) || Region.Contains(i.RegionID.ToString()) || Branch.Contains(i.BranchID.ToString()) || Area.Contains(i.AreaID.ToString())).Select(i => new { i.LocalChainID, i.LocalChainName, i.RegionalChainName, i.RegionalChainID, i.NationalChainName, i.NationalChainID }).ToList();

                            var nationalAccounts = allAccounts.Select(i => new { i.NationalChainID, i.NationalChainName }).DistinctBy(i => i.NationalChainName);
                            lstAccountsTreeView.AddRange(nationalAccounts.Select(i => new AccountInfo()
                            {
                                AccountID = i.NationalChainID,
                                AccountName = i.NationalChainName,
                                AccountType = Types.AccountType.National,
                                NationalChainID = i.NationalChainID
                            }));

                            //Get all the regional account of the selected national accounts
                            var regionalAccounts = (from allAccount in allAccounts
                                                    join nationalaccount in nationalAccounts
                                                    on allAccount.NationalChainID equals nationalaccount.NationalChainID
                                                    select new { allAccount.RegionalChainID, allAccount.RegionalChainName, allAccount.NationalChainID }).DistinctBy(i => i.RegionalChainName);
                            lstAccountsTreeView.AddRange(regionalAccounts.Select(i => new AccountInfo()
                            {
                                AccountID = i.RegionalChainID,
                                AccountName = i.RegionalChainName,
                                AccountType = Types.AccountType.Regional,
                                NationalChainID = i.NationalChainID,
                                RegionalChainID = i.RegionalChainID
                            }));

                            //get all the local account of the selected regional accounts
                            var localAccounts = (from allAccount in allAccounts
                                                 join regionalaccount in regionalAccounts
                                                 on allAccount.RegionalChainID equals regionalaccount.RegionalChainID
                                                 select new { allAccount.LocalChainID, allAccount.LocalChainName, allAccount.RegionalChainID, allAccount.NationalChainID }).DistinctBy(i => i.LocalChainName);

                            lstAccountsTreeView.AddRange(localAccounts.Select(i => new AccountInfo()
                            {
                                AccountID = i.LocalChainID,
                                AccountName = i.LocalChainName,
                                AccountType = Types.AccountType.Local,
                                NationalChainID = i.NationalChainID,
                                RegionalChainID = i.RegionalChainID,
                                LocalChainID = i.LocalChainID
                            }));
                        }
                        break;
                }
            }
            #endregion

            #region Get the Valid account for the BC Geography
            if (_loactionChain != null && _isBCGeography)
            {
                List<int> _system = SelectedGeo.Where(i => i.Type == PromoGeoType.System).Select(i => Convert.ToInt32(i.ID.Split(CommonConstants.BC_LIST_ITEM_SEPERATOR.ToCharArray(), StringSplitOptions.RemoveEmptyEntries)[0])).ToList();
                List<int> _zone = SelectedGeo.Where(i => i.Type == PromoGeoType.Zone).Select(i => Convert.ToInt32(i.ID.Split(CommonConstants.BC_LIST_ITEM_SEPERATOR.ToCharArray(), StringSplitOptions.RemoveEmptyEntries)[0])).ToList();
                List<int> _division = SelectedGeo.Where(i => i.Type == PromoGeoType.Division).Select(i => Convert.ToInt32(i.ID.Split(CommonConstants.BC_LIST_ITEM_SEPERATOR.ToCharArray(), StringSplitOptions.RemoveEmptyEntries)[0])).ToList();
                List<int> _bCRegion = SelectedGeo.Where(i => i.Type == PromoGeoType.BCRegion).Select(i => Convert.ToInt32(i.ID.Split(CommonConstants.BC_LIST_ITEM_SEPERATOR.ToCharArray(), StringSplitOptions.RemoveEmptyEntries)[0])).ToList();
                List<CustomLocationChain> _lstBC = new List<CustomLocationChain>();
                _lstBC = _loactionChain.Where(i => i.BCRegionID > 0).ToList();

                #region Get the Region IDs for all the selcted System/Zone/Division IDs

                List<BCGeoRelevancy> lstGeo = GetBottlerSalesHierachy();
                _bCRegion.AddRange(lstGeo.Where(i => (i.BCSystemID.HasValue && _system.Contains(i.BCSystemID.Value)) || (i.ZoneID.HasValue && _zone.Contains(i.ZoneID.Value)) || (i.DivisionID.HasValue && _division.Contains(i.DivisionID.Value))).Select(i => i.RegionID.Value).ToList());

                _bCRegion = _bCRegion.DistinctBy(i => i).ToList();
                #endregion

                switch (SelectedAccountType)
                {
                    case AccountType.Local:
                        {
                            lstAccountsTreeView = new List<AccountInfo>();

                            //Get the local account
                            lstAccountsTreeView = _lstBC.Where(i => i.LocalChainID == AccountId)
                                                                                        .Select(i => new AccountInfo() { AccountID = i.LocalChainID, AccountName = i.LocalChainName, AccountType = Types.AccountType.Local, LocalChainID = i.LocalChainID, NationalChainID = i.NationalChainID, RegionalChainID = i.RegionalChainID, })
                                                                                        .DistinctBy(i => i.AccountName)
                                                                                        .ToList();
                        }
                        break;
                    case AccountType.Regional:
                        {
                            lstAccountsTreeView = new List<AccountInfo>();

                            //Get all the regional accounts with selected region ID
                            var allAccountswtGeo = _lstBC.Where(i => i.RegionalChainID == AccountId).ToList();
                            var allAccounts = allAccountswtGeo.Where(i => _bCRegion.Contains(i.BCRegionID)).Select(i => new { i.LocalChainID, i.LocalChainName, i.RegionalChainName, i.RegionalChainID, i.NationalChainName, i.NationalChainID }).ToList();

                            // Add all the Regions to the list of TreeView Item
                            var regionalAccounts = allAccounts.Select(i => new { i.RegionalChainID, i.RegionalChainName, i.NationalChainID }).DistinctBy(i => i.RegionalChainName);
                            lstAccountsTreeView.AddRange(regionalAccounts.Select(i => new AccountInfo()
                            {
                                AccountID = i.RegionalChainID,
                                AccountName = i.RegionalChainName,
                                AccountType = Types.AccountType.Regional,
                                RegionalChainID = i.RegionalChainID,
                                NationalChainID = i.NationalChainID,

                            }));

                            //Get all the local account of the selected regions
                            var localAccounts = (from allAccount in allAccounts
                                                 join regionalaccount in regionalAccounts
                                                 on allAccount.RegionalChainID equals regionalaccount.RegionalChainID
                                                 select new { allAccount.LocalChainID, allAccount.LocalChainName, allAccount.RegionalChainID, allAccount.NationalChainID }).DistinctBy(i => i.LocalChainName);

                            lstAccountsTreeView.AddRange(localAccounts.Select(i => new AccountInfo()
                            {
                                AccountID = i.LocalChainID,
                                AccountName = i.LocalChainName,
                                AccountType = Types.AccountType.Local,
                                LocalChainID = i.LocalChainID,
                                RegionalChainID = i.RegionalChainID,
                                NationalChainID = i.NationalChainID
                            }));
                        }
                        break;
                    case AccountType.National:
                        {
                            lstAccountsTreeView = new List<AccountInfo>();

                            //Get all the national accounts of the seleted national account
                            var allAccountwtGeo = _lstBC.Where(i => i.NationalChainID == AccountId).ToList();
                            var allAccounts = allAccountwtGeo.Where(i => _bCRegion.Contains(i.BCRegionID)).Select(i => new { i.LocalChainID, i.LocalChainName, i.RegionalChainName, i.RegionalChainID, i.NationalChainName, i.NationalChainID }).ToList();

                            var nationalAccounts = allAccounts.Select(i => new { i.NationalChainID, i.NationalChainName }).DistinctBy(i => i.NationalChainName);
                            lstAccountsTreeView.AddRange(nationalAccounts.Select(i => new AccountInfo()
                            {
                                AccountID = i.NationalChainID,
                                AccountName = i.NationalChainName,
                                AccountType = Types.AccountType.National,
                                NationalChainID = i.NationalChainID
                            }));

                            //Get all the regional account of the selected national accounts
                            var regionalAccounts = (from allAccount in allAccounts
                                                    join nationalaccount in nationalAccounts
                                                    on allAccount.NationalChainID equals nationalaccount.NationalChainID
                                                    select new { allAccount.RegionalChainID, allAccount.RegionalChainName, allAccount.NationalChainID }).DistinctBy(i => i.RegionalChainName);
                            lstAccountsTreeView.AddRange(regionalAccounts.Select(i => new AccountInfo()
                            {
                                AccountID = i.RegionalChainID,
                                AccountName = i.RegionalChainName,
                                AccountType = Types.AccountType.Regional,
                                NationalChainID = i.NationalChainID,
                                RegionalChainID = i.RegionalChainID
                            }));

                            //get all the local account of the selected regional accounts
                            var localAccounts = (from allAccount in allAccounts
                                                 join regionalaccount in regionalAccounts
                                                 on allAccount.RegionalChainID equals regionalaccount.RegionalChainID
                                                 select new { allAccount.LocalChainID, allAccount.LocalChainName, allAccount.RegionalChainID, allAccount.NationalChainID }).DistinctBy(i => i.LocalChainName);

                            lstAccountsTreeView.AddRange(localAccounts.Select(i => new AccountInfo()
                            {
                                AccountID = i.LocalChainID,
                                AccountName = i.LocalChainName,
                                AccountType = Types.AccountType.Local,
                                NationalChainID = i.NationalChainID,
                                RegionalChainID = i.RegionalChainID,
                                LocalChainID = i.LocalChainID
                            }));
                        }
                        break;
                }
            }
            #endregion

            return lstAccountsTreeView;
        }

        /// <summary>
        /// Gets the List of Account Information of the corresponding account with all the child accounts
        /// </summary>
        /// <param name="AccountId"></param>
        /// <param name="SelectedAccountType"></param>
        /// <returns>List of AccountInfo</returns>
        public List<AccountInfo> GetAccountsInfoById(int AccountId, AccountType SelectedAccountType)
        {
            List<CustomLocationChain> _loactionChain = null;
            List<AccountInfo> lstAccountsTreeView = null;

            // This will create the cache from the mview.loactionchain which will increase the performance while retrieving the records.
            GetAccountInfoById(AccountId, SelectedAccountType);

            if (CacheHelper.GetCacheValue(CacheKeys.GET_RELATIONSHIP_FROM_LOCATION_CHAIN) != null)
            {
                _loactionChain = (List<CustomLocationChain>)CacheHelper.GetCacheValue(CacheKeys.GET_RELATIONSHIP_FROM_LOCATION_CHAIN);
            }

            if (_loactionChain != null)
            {

                switch (SelectedAccountType)
                {
                    case AccountType.Local:
                        {
                            lstAccountsTreeView = new List<AccountInfo>();

                            //Get the local account
                            lstAccountsTreeView = _loactionChain.Where(i => i.LocalChainID == AccountId)
                                                                                        .Select(i => new AccountInfo() { AccountID = i.LocalChainID, AccountName = i.LocalChainName, AccountType = Types.AccountType.Local, LocalChainID = i.LocalChainID, NationalChainID = i.NationalChainID, RegionalChainID = i.RegionalChainID, })
                                                                                        .DistinctBy(i => i.AccountName)
                                                                                        .ToList();
                        }
                        break;
                    case AccountType.Regional:
                        {
                            lstAccountsTreeView = new List<AccountInfo>();

                            //Get all the regional accounts with selected region ID
                            var allAccounts = _loactionChain.Where(i => i.RegionalChainID == AccountId).Select(i => new { i.LocalChainID, i.LocalChainName, i.RegionalChainName, i.RegionalChainID, i.NationalChainName, i.NationalChainID }).ToList();

                            // Add all the Regions to the list of TreeView Item
                            var regionalAccounts = allAccounts.Select(i => new { i.RegionalChainID, i.RegionalChainName, i.NationalChainID }).DistinctBy(i => i.RegionalChainName);
                            lstAccountsTreeView.AddRange(regionalAccounts.Select(i => new AccountInfo()
                            {
                                AccountID = i.RegionalChainID,
                                AccountName = i.RegionalChainName,
                                AccountType = Types.AccountType.Regional,
                                RegionalChainID = i.RegionalChainID,
                                NationalChainID = i.NationalChainID
                            }));

                            //Get all the local account of the selected regions
                            var localAccounts = (from allAccount in allAccounts
                                                 join regionalaccount in regionalAccounts
                                                 on allAccount.RegionalChainID equals regionalaccount.RegionalChainID
                                                 select new { allAccount.LocalChainID, allAccount.LocalChainName, allAccount.RegionalChainID, allAccount.NationalChainID }).DistinctBy(i => i.LocalChainName);

                            lstAccountsTreeView.AddRange(localAccounts.Select(i => new AccountInfo()
                            {
                                AccountID = i.LocalChainID,
                                AccountName = i.LocalChainName,
                                AccountType = Types.AccountType.Local,
                                LocalChainID = i.LocalChainID,
                                RegionalChainID = i.RegionalChainID,
                                NationalChainID = i.NationalChainID
                            }));
                        }
                        break;
                    case AccountType.National:
                        {
                            lstAccountsTreeView = new List<AccountInfo>();

                            //Get all the national accounts of the seleted national account
                            var allAccounts = _loactionChain.Where(i => i.NationalChainID == AccountId).Select(i => new { i.LocalChainID, i.LocalChainName, i.RegionalChainName, i.RegionalChainID, i.NationalChainName, i.NationalChainID }).ToList();

                            var nationalAccounts = allAccounts.Select(i => new { i.NationalChainID, i.NationalChainName }).DistinctBy(i => i.NationalChainName);
                            lstAccountsTreeView.AddRange(nationalAccounts.Select(i => new AccountInfo()
                            {
                                AccountID = i.NationalChainID,
                                AccountName = i.NationalChainName,
                                AccountType = Types.AccountType.National,
                                NationalChainID = i.NationalChainID
                            }));

                            //Get all the regional account of the selected national accounts
                            var regionalAccounts = (from allAccount in allAccounts
                                                    join nationalaccount in nationalAccounts
                                                    on allAccount.NationalChainID equals nationalaccount.NationalChainID
                                                    select new { allAccount.RegionalChainID, allAccount.RegionalChainName, allAccount.NationalChainID }).DistinctBy(i => i.RegionalChainName);
                            lstAccountsTreeView.AddRange(regionalAccounts.Select(i => new AccountInfo()
                            {
                                AccountID = i.RegionalChainID,
                                AccountName = i.RegionalChainName,
                                AccountType = Types.AccountType.Regional,
                                NationalChainID = i.NationalChainID,
                                RegionalChainID = i.RegionalChainID
                            }));

                            //get all the local account of the selected regional accounts
                            var localAccounts = (from allAccount in allAccounts
                                                 join regionalaccount in regionalAccounts
                                                 on allAccount.RegionalChainID equals regionalaccount.RegionalChainID
                                                 select new { allAccount.LocalChainID, allAccount.LocalChainName, allAccount.RegionalChainID, allAccount.NationalChainID }).DistinctBy(i => i.LocalChainName);

                            lstAccountsTreeView.AddRange(localAccounts.Select(i => new AccountInfo()
                            {
                                AccountID = i.LocalChainID,
                                AccountName = i.LocalChainName,
                                AccountType = Types.AccountType.Local,
                                NationalChainID = i.NationalChainID,
                                RegionalChainID = i.RegionalChainID,
                                LocalChainID = i.LocalChainID
                            }));
                        }
                        break;
                }
            }

            return lstAccountsTreeView;
        }

        /// <summary>
        /// Gets the Account Info object for the corresponding account
        /// </summary>
        /// <param name="oAccount"></param>
        /// <param name="oAccountType"></param>
        /// <returns>AccountInfo object</returns>
        public AccountInfo GetAccountInfoById(int AccountId, AccountType oAccountType, bool GetParentId = true)
        {

            AccountInfo objAccountInfo = new AccountInfo();

            objAccountInfo.AccountID = AccountId;
            using (PlaybookEntities con = new PlaybookEntities())
            {
                switch (oAccountType)
                {
                    case AccountType.Local:
                        var lAct = con.PBLocalChains.Where(i => i.LocalChainID == AccountId).FirstOrDefault();
                        objAccountInfo.LocalChainID = AccountId;
                        objAccountInfo.RegionalChainID = (int)lAct.RegionalChainID;
                        objAccountInfo.AccountName = lAct.LocalChainName;
                        var pAct = con.PBRegionalChains.Where(i => i.RegionalChainID == objAccountInfo.RegionalChainID).FirstOrDefault();
                        objAccountInfo.NationalChainID = (int)pAct.NationalChainID;
                        break;
                    case AccountType.Regional:
                        var rAct = con.PBRegionalChains.Where(i => i.RegionalChainID == AccountId).FirstOrDefault();
                        objAccountInfo.RegionalChainID = AccountId;
                        objAccountInfo.NationalChainID = (int)rAct.NationalChainID;
                        objAccountInfo.AccountName = rAct.RegionalChainName;
                        break;
                    default:
                        var nAct = con.PBNationalChains.Where(i => i.NationalChainID == AccountId).FirstOrDefault();
                        objAccountInfo.NationalChainID = AccountId;
                        objAccountInfo.AccountName = nAct.NationalChainName;
                        break;
                }
            }

            objAccountInfo.AccountType = oAccountType;


            return objAccountInfo;
        }

        /// <summary>
        /// Fetch AccountName based on  promotion type and accountId
        /// </summary>
        /// <param name="accountId"></param>
        /// <param name="PromotionType"></param>
        /// <returns></returns>
        public string GetAccountName(int accountId, AccountType AccountType)
        {
            string _accountName = "";
            using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
            {
                switch (AccountType)
                {
                    case AccountType.Local:
                        _accountName = objPlaybookEntities.PBLocalChains.Where(i => i.LocalChainID == accountId).FirstOrDefault().LocalChainName;
                        break;
                    case AccountType.Regional:
                        _accountName = objPlaybookEntities.PBRegionalChains.Where(i => i.RegionalChainID == accountId).FirstOrDefault().RegionalChainName;
                        break;
                    default:
                        _accountName = objPlaybookEntities.PBNationalChains.Where(i => i.NationalChainID == accountId).FirstOrDefault().NationalChainName;
                        break;
                }
            }

            return _accountName;
        }

        public string GetNationalAccountName(int accountId, AccountType accountType)
        {
            string _accountName = String.Empty;
            using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
            {
                switch (accountType)
                {
                    case AccountType.Local:
                        _accountName = objPlaybookEntities.PBChainHiers.Where(i => i.LocalChainID == accountId).FirstOrDefault().NationalChainName;
                        break;
                    case AccountType.Regional:
                        _accountName = objPlaybookEntities.PBChainHiers.Where(i => i.RegionalChainID == accountId).FirstOrDefault().NationalChainName;
                        break;
                    default:
                        _accountName = objPlaybookEntities.PBChainHiers.Where(i => i.NationalChainID == accountId).FirstOrDefault().NationalChainName;
                        break;
                }
            }

            return _accountName;
        }

        /// <summary>
        /// Returns all accounts except "All Other" which are present in the MView.Location for National
        /// Returns all Accounts where National Account  = All Other for Regional
        /// Returns all Accounts where Regional Account  = All Other for Local
        /// </summary>
        /// <returns></returns>
        public List<AccountInfo> GetAllAccounts(PromoType Type)
        {
            List<int> _lstAccountID = null;
            List<AccountInfo> _allAccounts = new List<AccountInfo>();

            // Get the account type corresponding to the Promotion Type
            AccountType _accType = (AccountType)Enum.Parse(typeof(AccountType), Type.ToString());
            if (CacheHelper.GetCacheValue(CacheKeys.GET_RELATIONSHIP_FROM_LOCATION_CHAIN) == null)
                GetAccountRelationshipByAccountID(0, AccountType.National);


            List<CustomLocationChain> _locationChain = (List<CustomLocationChain>)CacheHelper.GetCacheValue(CacheKeys.GET_RELATIONSHIP_FROM_LOCATION_CHAIN);

            #region
            using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
            {
                switch (Type)
                {
                    case PromoType.National:
                        // 1. Get all the national Accounts other than the "All Other"
                        _lstAccountID = _locationChain.Where(i => i.NationalChainName != CommonConstants.PROMOTION_NATIONAL_ALL_OTHER)
                                                        .Select(i => i.NationalChainID)
                                                        .DistinctBy(i => i)
                                                        .ToList();
                        break;
                    case PromoType.Regional:
                        // 1. Get all the regional Accounts where national Account == "All Other" != Regional Account
                        _lstAccountID = _locationChain.Where(i => i.NationalChainName == CommonConstants.PROMOTION_NATIONAL_ALL_OTHER && i.RegionalChainName != CommonConstants.PROMOTION_REGIONAL_ALL_OTHER)
                                                        .Select(i => i.RegionalChainID)
                                                        .DistinctBy(i => i)
                                                        .ToList();
                        break;
                    case PromoType.Local:
                        // 1. Get all the local Accounts where regional Account == national Account == "All Other"
                        _lstAccountID = _locationChain.Where(i => i.NationalChainName == CommonConstants.PROMOTION_NATIONAL_ALL_OTHER && i.RegionalChainName == CommonConstants.PROMOTION_REGIONAL_ALL_OTHER)
                                                        .Select(i => i.LocalChainID)
                                                        .DistinctBy(i => i)
                                                        .ToList();
                        break;
                }
            }

            // Get Child accounts of each national account
            foreach (int id in _lstAccountID)
            {
                _allAccounts.AddRange(GetAccountsInfoById(id, _accType));
            }
            #endregion
            return _allAccounts;
        }

        public List<AccountInfo> GetAllAccounts()
        {

            List<AccountInfo> _allAccounts = new List<AccountInfo>();
            if (CacheHelper.GetCacheValue("MSN_ALL_ACCOUNTS") == null)
                GetAllAccount();

            _allAccounts = (List<AccountInfo>)CacheHelper.GetCacheValue("MSN_ALL_ACCOUNTS");

            return _allAccounts;
        }

        private List<AccountInfo> GetAllAccount()
        {
            List<AccountInfo> retval = null;
            using (PlaybookEntities entity = new PlaybookEntities())
            {

                try
                {
                    retval = entity.ExecuteQuery<AccountInfo>("[PlayBook].[pGetAllAccounts]", System.Data.CommandType.StoredProcedure).ToList<AccountInfo>();
                }
                catch { }
                CacheHelper.SetCacheValue("MSN_ALL_ACCOUNTS", retval);
                return retval;
            }
        }

        public List<TreeViewItem> GetAccountTree(int AccountId, AccountType? AccountType, string AccountTrueType)
        {
            List<TreeViewItem> retval = null;
            using (PlaybookEntities entity = new PlaybookEntities())
            {

                try
                {
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@AccountID", Value = AccountId }),
                                            (new OAParameter { ParameterName = "@AccountType", Value = AccountType.ToString() }),
                                            (new OAParameter { ParameterName = "@AccountTrueType", Value = AccountTrueType })};
                    retval = entity.ExecuteQuery<TreeViewItem>("[PlayBook].[pGetAccountTree]", System.Data.CommandType.StoredProcedure, parm).ToList<TreeViewItem>();
                }
                catch { }
                return retval;
            }
        }

        public List<TreeViewItem> GetAccountTreeBCSurvey(int AccountId, AccountType? AccountType, string AccountTrueType)
        {
            List<TreeViewItem> retval = null;
            using (PlaybookEntities entity = new PlaybookEntities())
            {

                try
                {
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@AccountID", Value = AccountId }),
                                            (new OAParameter { ParameterName = "@AccountType", Value = AccountType.ToString() }),
                                            (new OAParameter { ParameterName = "@AccountTrueType", Value = AccountTrueType })};
                    retval = entity.ExecuteQuery<TreeViewItem>("[Playbook].[pGetAccountTreeBCSurvey]", System.Data.CommandType.StoredProcedure, parm).ToList<TreeViewItem>();
                }
                catch { }
                return retval;
            }
        }
        #endregion

        #region Private Methods

        /// <summary>
        /// Get the Account Details of the Slected Account ID
        /// </summary>
        /// <param name="SelectedAccountId"></param>
        /// <param name="SelectedAccountType"></param>
        /// <returns></returns>
        private CustomLocationChain GetAccountRelationshipByAccountID(int SelectedAccountId, AccountType SelectedAccountType)
        {
            CustomLocationChain _selectedAccountDetails = null;
            List<CustomLocationChain> _locationChain = null;

            #region Set the cache if the cache is null
            try
            {
                if (SelectedAccountId == 0)
                {
                    using (PlaybookEntities entity = new PlaybookEntities())
                    {
                        DbParameter[] parm = { (new OAParameter { ParameterName = "@NationalChainID", Value = 0 }) };
                        List<CustomLocationChain> _data = entity.ExecuteQuery<CustomLocationChain>("[PlayBook].[pGetAccountRelationship]", System.Data.CommandType.StoredProcedure, parm).ToList<CustomLocationChain>();

                        _data = _data.OrderBy(i => i.NationalChainName).ToList();

                        if (CacheHelper.GetCacheValue(CacheKeys.GET_RELATIONSHIP_FROM_LOCATION_CHAIN) != null)
                        {
                            _locationChain = (List<CustomLocationChain>)CacheHelper.GetCacheValue(CacheKeys.GET_RELATIONSHIP_FROM_LOCATION_CHAIN);

                            //remove duplicacy while adding the new records
                            List<int> _nationalChainID = _locationChain.Select(i => i.NationalChainID).DistinctBy(i => i).ToList();
                            _locationChain.AddRange(_data.Where(i => !_nationalChainID.Contains(i.NationalChainID)).ToList());
                        }
                        else
                            _locationChain = _data;
                    }

                    CacheHelper.SetCacheValue(CacheKeys.GET_RELATIONSHIP_FROM_LOCATION_CHAIN, _locationChain, 24);
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            #endregion

            _selectedAccountDetails = GetLocationChainFromCache(SelectedAccountId, SelectedAccountType);

            #region if any account is still missing then this will add it to the cache
            try
            {
                if (_selectedAccountDetails == null)
                {
                    using (PlaybookEntities entity = new PlaybookEntities())
                    {
                        try
                        {
                            #region Get the Details of the Selected Account
                            int _nationalChainID = 0;
                            PBTLocationChain objLocationChain = null;
                            PBTRegionChain objTRegionChains = null;
                            switch (SelectedAccountType)
                            {
                                case AccountType.Local:
                                    objLocationChain = entity.PBTLocationChains.Where(i => i.LocalChainID == SelectedAccountId).FirstOrDefault();
                                    break;
                                case AccountType.Regional:
                                    objLocationChain = entity.PBTLocationChains.Where(i => i.RegionalChainID == SelectedAccountId).FirstOrDefault();
                                    break;
                                case AccountType.National:
                                    objLocationChain = entity.PBTLocationChains.Where(i => i.NationalChainID == SelectedAccountId).FirstOrDefault();
                                    break;
                            }

                            if (objLocationChain == null)
                            {
                                switch (SelectedAccountType)
                                {
                                    case AccountType.Local:
                                        objTRegionChains = entity.PBTRegionChains.Where(i => i.LocalChainID == SelectedAccountId).FirstOrDefault();
                                        break;
                                    case AccountType.Regional:
                                        objTRegionChains = entity.PBTRegionChains.Where(i => i.RegionalChainID == SelectedAccountId).FirstOrDefault();
                                        break;
                                    case AccountType.National:
                                        objTRegionChains = entity.PBTRegionChains.Where(i => i.NationalChainID == SelectedAccountId).FirstOrDefault();
                                        break;
                                }
                            }

                            _nationalChainID = objLocationChain == null ? objTRegionChains.NationalChainID : objLocationChain.NationalChainID;

                            #endregion

                            #region Set Cache Value


                            DbParameter[] parm = { (new OAParameter { ParameterName = "@NationalChainID", Value = _nationalChainID }) };
                            List<CustomLocationChain> _data = entity.ExecuteQuery<CustomLocationChain>("[PlayBook].[pGetAccountRelationship]", System.Data.CommandType.StoredProcedure, parm).ToList<CustomLocationChain>();

                            if (CacheHelper.GetCacheValue(CacheKeys.GET_RELATIONSHIP_FROM_LOCATION_CHAIN) != null)
                            {
                                _locationChain = (List<CustomLocationChain>)CacheHelper.GetCacheValue(CacheKeys.GET_RELATIONSHIP_FROM_LOCATION_CHAIN);
                                _locationChain.AddRange(_data);
                            }
                            else
                                _locationChain = _data;

                            CacheHelper.SetCacheValue(CacheKeys.GET_RELATIONSHIP_FROM_LOCATION_CHAIN, _locationChain, 24);

                            //Fill the return object from Cache
                            _selectedAccountDetails = GetLocationChainFromCache(SelectedAccountId, SelectedAccountType);
                            #endregion
                        }
                        catch { }
                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            #endregion

            return _selectedAccountDetails;
        }


        /// <summary>
        /// Gets the Location Chain From the Cache
        /// </summary>
        /// <param name="SelectedAccountId"></param>
        /// <param name="SelectedAccountType"></param>
        /// <param name="_selectedAccountDetails"></param>
        /// <returns></returns>
        private CustomLocationChain GetLocationChainFromCache(int SelectedAccountId, AccountType SelectedAccountType)
        {
            CustomLocationChain _selectedAccountDetails = null;

            try
            {

                if (CacheHelper.GetCacheValue(CacheKeys.GET_RELATIONSHIP_FROM_LOCATION_CHAIN) != null)
                {
                    List<CustomLocationChain> _locationChain = (List<CustomLocationChain>)CacheHelper.GetCacheValue(CacheKeys.GET_RELATIONSHIP_FROM_LOCATION_CHAIN);

                    switch (SelectedAccountType)
                    {
                        case AccountType.Local:
                            _selectedAccountDetails = _locationChain.Where(i => i.LocalChainID == SelectedAccountId).FirstOrDefault();
                            break;
                        case AccountType.Regional:
                            _selectedAccountDetails = _locationChain.Where(i => i.RegionalChainID == SelectedAccountId).FirstOrDefault();
                            break;
                        case AccountType.National:
                            _selectedAccountDetails = _locationChain.Where(i => i.NationalChainID == SelectedAccountId).FirstOrDefault();
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return _selectedAccountDetails;
        }

        /// <summary>
        /// Get the Account Info object by Promotion Object
        /// </summary>
        /// <param name="objPlaybookEntities"></param>
        /// <param name="objPromotion"></param>
        private void GetAccountInfoByPromotion(PlaybookEntities objPlaybookEntities, Promotion objPromotion)
        {
            try
            {
                List<AccountInfo> lstAccountInfo = new List<AccountInfo>();

                #region Implementation using the IsRoot logic --> NEED TO BE DELETED
                //Get the Root Account and its details
                //PBPromotionAccount _rootAccount = objPlaybookEntities.PBPromotionAccounts.Where(i => i.PromotionID == objPromotion.PromotionId && i.IsRoot == true).First();
                //objPromotion.AccountType = (_rootAccount.LocalChainID != null && _rootAccount.LocalChainID != 0 ? AccountType.Local : (_rootAccount.RegionalChainID != null && _rootAccount.RegionalChainID != 0 ? AccountType.Regional : AccountType.National));
                //objPromotion.AccountId = (_rootAccount.LocalChainID != null && _rootAccount.LocalChainID != 0 ? _rootAccount.LocalChainID : (_rootAccount.RegionalChainID != null && _rootAccount.RegionalChainID != 0 ? _rootAccount.RegionalChainID : _rootAccount.NationalChainID));

                //objPromotion.AccountName = GetAccountName(objPromotion.AccountId.Value, objPromotion.AccountType);

                ////Get all the account for the current prmotion
                //List<AccountInfo> objTreeViewItems = GetAccountsInfoById(objPromotion.AccountId.Value, objPromotion.AccountType);
                //int _accountCount = objPlaybookEntities.PBPromotionAccounts.Count(i => i.PromotionID == objPromotion.PromotionId);

                //if (_accountCount > 1)
                //{
                //    //If the root account is not the only account selected
                //    var selectedItems = objPlaybookEntities.PBPromotionAccounts.Where(i => i.PromotionID == objPromotion.PromotionId && i.IsRoot == false)
                //                                                                .Select(i => new { id = (i.LocalChainID != null && i.LocalChainID != 0 ? string.Concat(i.LocalChainID.Value.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR, PromoType.Local.ToString()) : (i.RegionalChainID != null && i.RegionalChainID != 0 ? string.Concat(i.RegionalChainID.Value.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR, PromoType.Regional.ToString()) : string.Concat(i.NationalChainID.Value.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR, PromoType.National.ToString()))) }).ToList();

                //    if (selectedItems != null && objTreeViewItems != null)
                //    {
                //        var items = (from item in selectedItems
                //                     join treeitem in objTreeViewItems
                //                     on item.id equals treeitem.TreeValue
                //                     select new SelectedTreeItem { Value = treeitem.TreeValue, Type = treeitem.AccountType.ToString(), Name = treeitem.AccountName, ItemLevel = GetAccountLevel(treeitem.AccountType) }).ToList();

                //        objPromotion.SelectedAccounts = items;
                //    }

                //}
                //else
                //{
                //    //If root account is the only accoun selected
                //    var selectedItems = objPlaybookEntities.PBPromotionAccounts.Where(i => i.PromotionID == objPromotion.PromotionId)
                //                                                                .Select(i => new { id = (i.LocalChainID != null && i.LocalChainID != 0 ? string.Concat(i.LocalChainID.Value.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR, PromoType.Local.ToString()) : (i.RegionalChainID != null && i.RegionalChainID != 0 ? string.Concat(i.RegionalChainID.Value.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR, PromoType.Regional.ToString()) : string.Concat(i.NationalChainID.Value.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR, PromoType.National.ToString()))) }).ToList();

                //    if (selectedItems != null && objTreeViewItems != null)
                //    {
                //        var items = (from item in selectedItems
                //                     join treeitem in objTreeViewItems
                //                     on item.id equals treeitem.TreeValue
                //                     select new SelectedTreeItem { Value = treeitem.TreeValue, Type = treeitem.AccountType.ToString(), Name = treeitem.AccountName, ItemLevel = GetAccountLevel(treeitem.AccountType) }).ToList();

                //        objPromotion.SelectedAccounts = items;
                //    }

                //}
                #endregion

                #region New implementation (IsRoot logic removed)

                // 1. Get all the accounts associated with the Promotion
                List<PBPromotionAccount> _lstSelectedAccounts = objPlaybookEntities.PBPromotionAccounts.Where(i => i.PromotionID == objPromotion.PromotionId).ToList();

                // 2. Create the Account Info object to retrieve all the necessary information
                foreach (PBPromotionAccount objAccount in _lstSelectedAccounts)
                {
                    AccountType _accType = GetAccountType(objAccount);
                    int _accountID = 0;

                    switch (_accType)
                    {
                        case AccountType.National:
                            _accountID = objAccount.NationalChainID.Value;
                            break;
                        case AccountType.Regional:
                            _accountID = objAccount.RegionalChainID.Value;
                            break;
                        case AccountType.Local:
                            _accountID = objAccount.LocalChainID.Value;
                            break;
                    }

                    lstAccountInfo.Add(GetAccountInfoById(_accountID, _accType));
                }

                objPromotion.SelectedAccounts = lstAccountInfo.Select(i => new SelectedTreeItem { Value = i.TreeValue, Type = i.AccountType.ToString(), Name = i.AccountName, ItemLevel = GetAccountLevel(i.AccountType) }).ToList();

                #endregion
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
        }

        /// <summary>
        /// Returns the Promtion Account type
        /// </summary>
        /// <param name="objAccount"></param>
        /// <returns></returns>
        private AccountType GetAccountType(PBPromotionAccount objAccount)
        {
            if (objAccount.LocalChainID.HasValue && objAccount.LocalChainID.Value > 0)
                return AccountType.Local;
            else if (objAccount.RegionalChainID.HasValue && objAccount.RegionalChainID.Value > 0)
                return AccountType.Regional;
            else
                return AccountType.National;
        }

        /// <summary>
        /// Gets the Tree Level of a Account in a tree view item
        /// </summary>
        /// <param name="Item"></param>
        /// <returns></returns>
        private int GetAccountLevel(AccountType Item)
        {
            int Itemlevel = 0;

            switch (Item)
            {
                case AccountType.National:
                    Itemlevel = 1;
                    break;
                case AccountType.Regional:
                    Itemlevel = 2;
                    break;
                case AccountType.Local:
                    Itemlevel = 3;
                    break;
            }
            return Itemlevel;
        }

        /// <summary>
        /// Get the Promotion Type By Tree Item Value
        /// </summary>
        /// <param name="Item"></param>
        /// <returns></returns>
        private string GetAccountType(string Item)
        {
            string strType = string.Empty;
            string[] strItems = Item.Split(CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR.ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
            if (strItems.Length > 1)
                strType = strItems[1];

            return strType;
        }

        /// <summary>
        /// Get all the accounts for the corresponding Promotion ID
        /// </summary>
        /// <param name="objPlaybookEntities"></param>
        /// <param name="promotionId"></param>
        /// <returns></returns>
        private string GetAccountInfoByPromotionID(PlaybookEntities objPlaybookEntities, int promotionId)
        {
            string strSelectedAccount = string.Empty;
            List<PBPromotionAccount> objAccounts = objPlaybookEntities.PBPromotionAccounts.Where(i => i.PromotionID == promotionId).ToList<PBPromotionAccount>();

            strSelectedAccount = string.Join(",", objAccounts.Select(i => (i.LocalChainID != 0 ? string.Concat(i.LocalChainID.Value.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR, PromoType.Local.ToString()) : (i.RegionalChainID != 0 ? string.Concat(i.RegionalChainID.Value.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR, PromoType.Regional.ToString()) : string.Concat(i.NationalChainID.Value.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR, PromoType.National.ToString())))).ToArray<string>());

            return strSelectedAccount.TrimStart(',');
        }

        /// <summary>
        /// Fetch AccountName based on  promotion type and accountId
        /// </summary>
        /// <param name="accountId"></param>
        /// <param name="PromotionType"></param>
        /// <returns></returns>
        private string GetAccountName(int accountId, int PromoTypeId)
        {
            string _accountName = string.Empty;
            AccountType _type = AccountType.National;



            using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
            {
                switch (PromoTypeId)
                {
                    case (int)PromoType.Local:
                        _accountName = objPlaybookEntities.PBLocalChains.Where(i => i.LocalChainID == accountId).FirstOrDefault().LocalChainName;
                        break;
                    case (int)PromoType.Regional:
                        _accountName = objPlaybookEntities.PBRegionalChains.Where(i => i.RegionalChainID == accountId).FirstOrDefault().RegionalChainName;
                        break;
                    default:
                        _accountName = objPlaybookEntities.PBNationalChains.Where(i => i.NationalChainID == accountId).FirstOrDefault().NationalChainName;
                        break;
                }
            }


            return _accountName;

        }

        #endregion

        #endregion


        private void GetGeoRelevancyByPromotionId(PlaybookEntities objPlaybookEntities, Promotion objPromotion)
        {
            try
            {
                string strSelectGeo = string.Empty;
                List<string> selectedItems = new List<string>();
                objPlaybookEntities.PBPromotionGeoRelevancies.Where(i => i.PromotionId == objPromotion.PromotionId).ToList().ForEach(i => { strSelectGeo = string.Concat(strSelectGeo, ",", AppendItemWithValidColumn(i)); });
                objPromotion.GEORelavencies = GetGEOSelection(strSelectGeo);
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
        }

        public string AppendItemWithValidColumn(PBPromotionGeoRelevancy objGEO)
        {
            string strValue = string.Empty;

            if (objGEO.BUID != (int?)null && objGEO.BUID != 0)
                strValue = string.Concat(objGEO.BUID, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.BU);

            else if (objGEO.RegionId != (int?)null && objGEO.RegionId != 0)
                strValue = string.Concat(objGEO.RegionId, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.Region);

            else if (objGEO.AreaId != (int?)null && objGEO.AreaId != 0)
                strValue = string.Concat(objGEO.AreaId, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.Area);

            else if (objGEO.BranchId != (int?)null && objGEO.BranchId != 0)
                strValue = string.Concat(objGEO.BranchId, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.Branch);

            else if (objGEO.SystemID != (int?)null && objGEO.SystemID != 0)
                strValue = string.Concat(objGEO.SystemID, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.System);

            else if (objGEO.ZoneID != (int?)null && objGEO.ZoneID != 0)
                strValue = string.Concat(objGEO.ZoneID, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.Zone);

            else if (objGEO.BCRegionID != (int?)null && objGEO.BCRegionID != 0)
                strValue = string.Concat(objGEO.BCRegionID, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.BCRegion);

            else if (objGEO.DivisionID != (int?)null && objGEO.DivisionID != 0)
                strValue = string.Concat(objGEO.DivisionID, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.Division);

            else if (objGEO.BottlerID != (int?)null && objGEO.BottlerID != 0)
                strValue = string.Concat(objGEO.BottlerID, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.Bottler);

            else if (objGEO.StateId != (int?)null && objGEO.StateId != 0)
                strValue = string.Concat(objGEO.StateId, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.State);
            return strValue;

        }
        public string GetType(string value)
        {
            string strType = string.Empty;
            string[] strItems = value.Split(CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR.ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
            if (strItems.Length > 1)
                strType = strItems[1];

            return strType;
        }
        private int GetItemLevel(string value)
        {
            int Itemlevel = 0;

            switch (GetType(value))
            {
                case CommonConstants.PROMOTION_GEO_TYPE_BU:
                    Itemlevel = 1;
                    break;
                case CommonConstants.PROMOTION_GEO_TYPE_REGIONAL:
                    Itemlevel = 2;
                    break;
                case CommonConstants.PROMOTION_GEO_TYPE_BRANCH:
                    Itemlevel = 3;
                    break;
            }
            return Itemlevel;
        }

        /// <summary>
        /// Get brands by promotionId
        /// </summary>
        /// <param name="promotionId"></param>
        /// <returns></returns>
        public List<KeyValuePair<string, string>> GetAllBrands(int promotionId)
        {
            List<KeyValuePair<string, string>> listofselectedBrands = null;
            try
            {

                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    listofselectedBrands = (from promoBrand in objPlaybookEntities.PBPromotionBrands
                                            join sapBrand in objPlaybookEntities.PBBrands
                                            on promoBrand.BrandID equals sapBrand.BrandID
                                            where promoBrand.PromotionID == promotionId
                                            select new KeyValuePair<string, string>(Convert.ToString(sapBrand.BrandID), sapBrand.BrandName)).ToList();

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return listofselectedBrands;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objPromotion"></param>
        /// <param name="objPlaybookEntities"></param>
        private void GetBrandAndPackageByPromotionId(Promotion objPromotion, PlaybookEntities objPlaybookEntities)
        {
            try
            {
                if (objPlaybookEntities != null)
                {
                    BrandPackageCategory objbrndpkgCategory = new BrandPackageCategory() { Brands = new List<PromoBrand>(), Packages = new List<PromoPackage>() };
                    int? promotionId = objPromotion.PromotionId;

                    //fetch trademarkIds for Promotion
                    var trademarks = (from promoBrand in objPlaybookEntities.PBPromotionBrands
                                      join dviewbrand in objPlaybookEntities.PBTradeMarks
                                      on promoBrand.TrademarkID equals dviewbrand.TradeMarkID
                                      where promoBrand.PromotionID == promotionId
                                      select new PromoBrand() { SAPBrandId = dviewbrand.SAPTradeMarkID, BrandId = promoBrand.TrademarkID, BrandName = dviewbrand.TradeMarkName, IsTradeMark = true }).Distinct().ToList();


                    //fetch brandIds for Promotion
                    var brands = (from promoBrand in objPlaybookEntities.PBPromotionBrands
                                  join dviewbrand in objPlaybookEntities.PBBrands
                                  on promoBrand.BrandID equals dviewbrand.BrandID
                                  where promoBrand.PromotionID == promotionId
                                  select new PromoBrand() { SAPBrandId = dviewbrand.SAPBrandID, BrandId = promoBrand.BrandID, BrandName = dviewbrand.BrandName, IsTradeMark = false }).Distinct().ToList();
                    if (brands != null || trademarks != null)
                    {
                        objbrndpkgCategory.Brands.AddRange(trademarks);
                        objbrndpkgCategory.Brands.AddRange(brands);
                    }
                    else
                        objbrndpkgCategory.Brands = new List<PromoBrand>();

                    //fetch Packages for Promotion

                    var packages = (from promoPackage in objPlaybookEntities.PBPromotionPackages
                                    join dviewpackage in objPlaybookEntities.PBPackages
                                    on promoPackage.PackageID equals dviewpackage.PackageID
                                    where promoPackage.PromotionID == promotionId
                                    select new PromoPackage() { PackageId = Convert.ToString(promoPackage.PackageID), PackageName = dviewpackage.PackageName }).Distinct().ToList();
                    if (packages != null)
                        objbrndpkgCategory.Packages.AddRange(packages);
                    else
                        objbrndpkgCategory.Packages = new List<PromoPackage>();

                    objPromotion.PromotionBrandsJSON = JSONSerelization.Serialize(objbrndpkgCategory);
                };
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
        }



        /// <summary>
        /// Fetch brands for auto complete in create Promotion Screen.
        /// Table Name:SAP.Brand
        /// </summary>
        /// <returns></returns>
        /// 
        public List<PromoBrand> GetAllPromotionBrands()//(OnePortalRoleScope scope, int buId, int regionId, int branchId)
        {
            List<PromoBrand> _lstBrands = null;
            try
            {

                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    _lstBrands = objPlaybookEntities.ExecuteQuery<PromoBrand>("Playbook.GetAllBrandsPackages", System.Data.CommandType.StoredProcedure).ToList<PromoBrand>();
                    if (_lstBrands != null)
                        _lstBrands = _lstBrands.DistinctBy(i => i.BrandName).OrderBy(i => i.BrandName).ToList();

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return _lstBrands;
        }






        /// <summary>
        /// Insert/Update/Delete Attachment
        /// </summary>
        /// <param name="strToDeserialize"></param>
        /// <param name="mode"></param>
        //public void ManageAttachments(string strToDeserialize, string mode, int promotionId, string libraryName, bool IsDuplicate, int? parentPromotionId, bool? IsNewVersionPromotion, List<ProgramSystem> lstSystem)
        public void ManageAttachments(string strToDeserialize, string mode, int promotionId, string libraryName, bool IsDuplicate, int? parentPromotionId, bool? IsNewVersionPromotion)
        {
            List<PromoAttachment> lstFiles = null;
            if (string.IsNullOrEmpty(strToDeserialize) && (IsNewVersionPromotion.HasValue) ? (bool)IsNewVersionPromotion : false)
                lstFiles = GetAttachmentByPromotionId((int)parentPromotionId, SPContext.Current.Web.ServerRelativeUrl, (int?)null);
            else
                lstFiles = JSONSerelization.Deserialize<List<PromoAttachment>>(strToDeserialize);

            string folderurl = string.Empty;
            string currentUser = SPContext.Current.Web.CurrentUser.ToString();
            string documentID = string.Empty;
            string baseUrl = ConfigurationManager.AppSettings[CommonConstants.PromotionSiteURL];


            SPSecurity.RunWithElevatedPrivileges(delegate()
            {
                using (SPSite spsite = new SPSite(baseUrl))
                {
                    using (SPWeb objWeb = spsite.OpenWeb())
                    {
                        int start = Convert.ToInt32(promotionId.ToString().Substring(0, 1));
                        int end = Convert.ToInt32(promotionId.ToString().Substring(1, promotionId.ToString().Length - 1));
                        if (objWeb != null)
                        {
                            objWeb.AllowUnsafeUpdates = true;
                            SPList dicLib = objWeb.Lists.TryGetList(libraryName);
                            if (dicLib != null)
                            {
                                folderurl = baseUrl + "/" + libraryName + "/" + start;
                                SPFolder ofolder = objWeb.GetFolder(folderurl);
                                if (!ofolder.Exists)
                                {
                                    SPListItem foldercoll = dicLib.Items.Add(dicLib.RootFolder.ServerRelativeUrl, SPFileSystemObjectType.Folder, start.ToString());
                                    foldercoll["PromotionID"] = promotionId;
                                    foldercoll["UploadedBy"] = currentUser;
                                    foldercoll.Update();
                                    SPListItem childfolder = dicLib.Items.Add(dicLib.RootFolder.ServerRelativeUrl + "/" + start.ToString(), SPFileSystemObjectType.Folder, end.ToString());
                                    childfolder["PromotionID"] = promotionId;
                                    childfolder["UploadedBy"] = currentUser;
                                    childfolder.Update();
                                    folderurl = childfolder.Url;
                                }
                                else
                                {
                                    SPFolder ofolderChild = objWeb.GetFolder(baseUrl + "/" + libraryName + "/" + start.ToString() + "/" + end.ToString());
                                    if (!ofolderChild.Exists)
                                    {
                                        SPListItem foldercoll = dicLib.Items.Add(dicLib.RootFolder.ServerRelativeUrl + "/" + start.ToString(), SPFileSystemObjectType.Folder, end.ToString());
                                        foldercoll["PromotionID"] = promotionId;
                                        foldercoll["UploadedBy"] = currentUser;
                                        foldercoll.Update();
                                        folderurl = foldercoll.Url;
                                    }
                                    else
                                        folderurl = ofolderChild.Url;

                                }
                                //create new version of file
                                if (IsNewVersionPromotion.HasValue ? (bool)IsNewVersionPromotion : false)
                                {
                                    foreach (PromoAttachment objAttachment in lstFiles.Where(i => i.IsNew == false))
                                    {
                                        try
                                        {
                                            SPFile objFile = objWeb.GetFile(objAttachment.URL);
                                            if (objFile != null)
                                                objAttachment.Content = objFile.OpenBinary();
                                            objAttachment.IsNew = true;
                                        }
                                        catch (Exception ex)
                                        {
                                            ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                                        }
                                    }
                                }
                                //files to delete
                                foreach (PromoAttachment file in lstFiles.Where(i => i.IsDeleted == true))
                                {
                                    try
                                    {
                                        string fileurl = baseUrl + "/" + folderurl + "/" + file.Name;
                                        SPFile fileToDelete = objWeb.GetFile(fileurl);
                                        if (fileToDelete != null)
                                        {
                                            fileToDelete.Delete();
                                            dicLib.Update();
                                        }
                                    }
                                    catch (Exception ex)
                                    {
                                        ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                                    }
                                }
                                foreach (PromoAttachment file in lstFiles.Where(i => i.IsNew == true))
                                {
                                    try
                                    {
                                        SPFile ofile = objWeb.Files.Add(baseUrl + "/" + folderurl + "/" + file.Name, file.Content, true);
                                        ofile.Item["PromotionID"] = promotionId;
                                        ofile.Item["UploadedBy"] = currentUser;
                                        file.AttachmentDocumentID = ofile.Item["_dlc_DocId"].ToString();
                                        ofile.Update();
                                        ofile.Item.Update();
                                    }
                                    catch (Exception ex)
                                    {
                                        ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                                    }
                                }
                                objWeb.Update();
                                objWeb.AllowUnsafeUpdates = false;

                            }

                        }
                        string fullurl = SPUrlUtility.CombineUrl(baseUrl, folderurl);
                        //insert update attachment in DB
                        //InsertUpdateAttachment(promotionId, lstFiles, mode, fullurl, lstSystem);
                        InsertUpdateAttachment(promotionId, lstFiles, mode, fullurl);
                    }
                }
            });

        }

        /// <summary>
        /// Gets the Attachments details to show on the Create promotion page
        /// </summary>
        /// <param name="PromotionID"></param>
        /// <returns></returns>
        public string GetAttachmentDetails(int PromotionID, List<PromoAttachment> _attachments)
        {
            string _detail = string.Empty;

            using (PlaybookEntities entity = new PlaybookEntities())
            {
                try
                {
                    //Get all the attachments for the corresponding Promotion ID
                    if (_attachments == null)
                        _attachments = entity.PBPromotionAttachments.Where(i => i.PromotionID == PromotionID).Select(i => new PromoAttachment()
                        {
                            AttachmentDocumentID = i.AttachmentDocumentID,
                            TypeId = (int)i.AttachmentTypeID,
                            SystemName = i.DisplaySystemIds,
                            ID = i.PromotionAttachmentID

                        }).ToList();

                    //Get all the unique ids associated with promotion
                    int[] _attachmentTypeIds = _attachments.Select(i => i.TypeId).DistinctBy(i => i).ToArray();

                    // Array of the attachments Type with details
                    string[] objAttachmentDetails = entity.PBAttachmentTypes.Where(i => _attachmentTypeIds.Contains(i.AttachmentTypeID))
                                                                                                                        .Select(i => i.AttachmentTypeName + " (" + (_attachments.Count(j => j.TypeId == i.AttachmentTypeID)).ToString() + ") ")
                                                                                                                        .ToArray();

                    _detail = string.Join(",", objAttachmentDetails);
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }

            }

            return _detail;
        }
        public List<int> GetAllBranchIDByPromoGEO(List<PromoGEO> lstPromoGEO)
        {
            List<int> lstBranchId = null;
            try
            {

                var BUID = lstPromoGEO.Where(i => i.BUID != (int?)null).Select(i => i.BUID).ToArray();
                var AreaId = lstPromoGEO.Where(i => i.AreaID != (int?)null).Select(i => i.AreaID).ToArray();
                var RegionID = lstPromoGEO.Where(i => i.RegionID != (int?)null).Select(i => i.RegionID).ToArray();
                var BranchId = lstPromoGEO.Where(i => i.BranchID != (int?)null).Select(i => i.BranchID).ToArray();
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    lstBranchId = objPlaybookEntities.PBLocationHiers.Where(i => BUID.Contains(i.BUID) || AreaId.Contains(i.AreaID) || RegionID.Contains(i.RegionID) || BranchId.Contains(i.BranchID)).DistinctBy(i => i.BranchID).Select(i => i.BranchID).ToList<int>();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return lstBranchId;
        }

        public List<LocationHier> GetLocationHier()
        {
            List<LocationHier> objlstLocationHier = null;
            if (CacheHelper.GetCacheValue(CommonConstants.PromotionGEORelevancyKey) != null)
                objlstLocationHier = CacheHelper.GetCacheValue(CommonConstants.PromotionGEORelevancyKey) as List<LocationHier>;
            else
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    objlstLocationHier = objPlaybookEntities.PBLocationHiers.Select(i => new LocationHier() { AreaID = i.AreaID, AreaName = i.AreaName, BranchID = i.BranchID, BranchName = i.BranchName, BUID = i.BUID, BUName = i.BUName, RegionID = i.RegionID, RegionName = i.RegionName, SAPAreaID = i.SAPAreaID, SAPBranchID = i.SAPBranchID, SAPBUID = i.SAPBUID, SAPRegionID = i.SAPRegionID, SPBranchName = i.SPBranchName, SPBUName = i.SPBUName, SPRegionName = i.SPRegionName }).ToList();
                    CacheHelper.SetCacheValue(CommonConstants.PromotionGEORelevancyKey, objlstLocationHier, 518400);
                }
            }
            return objlstLocationHier;
        }
        public List<TreeViewItem> GetGeoTreeView()
        {
            List<TreeViewItem> objGEOTreeViewlst = null;

            try
            {
                List<LocationHier> objlstLocationHier = GetLocationHier();
                if (objlstLocationHier != null)
                {

                    objGEOTreeViewlst = new List<TreeViewItem>();
                    objGEOTreeViewlst.Add(new TreeViewItem() { Id = -1, Text = CommonConstants.LocationHierarchyAllDSD, 
                            Value = string.Concat(-1, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, "All"),
                                                               SAPValue = string.Concat(-1, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, "All", CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, -1, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.LocationHierarchyAllDSD),
                            ParentId = 0 });

                    var nationLocations = objlstLocationHier.DistinctBy(i => i.BUID).ToList();
                    objGEOTreeViewlst.AddRange(nationLocations.Select(i => new TreeViewItem() { Id = i.BUID, Text = i.BUName, Value = string.Concat(i.BUID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BU), SAPValue = string.Concat(i.BUID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BU, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPBUID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.BUName), ParentId = -1 }));
                    var regionalLocations = (from item in objlstLocationHier
                                             join nationlocation in nationLocations
                                             on item.BUID equals nationlocation.BUID
                                             select new { item.RegionID, item.SAPRegionID, item.RegionName, item.BUID }).Distinct().ToList();
                    objGEOTreeViewlst.AddRange(regionalLocations.Select(i => new TreeViewItem() { Id = (i.RegionID + 10000), Value = string.Concat(i.RegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_REGIONAL), SAPValue = string.Concat(i.RegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_REGIONAL, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPRegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.RegionName), Text = i.RegionName, ParentId = i.BUID }));

                    var areaLocation = (from item in objlstLocationHier
                                        join regionalLocation in regionalLocations
                                         on item.RegionID equals regionalLocation.RegionID
                                        select new { item.AreaID, item.AreaName, item.RegionID, item.BUID, item.SAPAreaID }).Distinct().ToList();

                    objGEOTreeViewlst.AddRange(areaLocation.Select(i => new TreeViewItem() { Id = (i.AreaID + 20000), Value = string.Concat(i.AreaID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_AREA), SAPValue = string.Concat(i.AreaID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_AREA, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPAreaID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.AreaName), Text = i.AreaName, ParentId = (i.RegionID + 10000) }));

                    var localLocations = (from item in objlstLocationHier
                                          join regionalLocation in areaLocation
                                           on item.AreaID equals regionalLocation.AreaID
                                          select new { item.BranchID, item.BranchName, item.AreaID, item.BUID, item.SAPBranchID }).Distinct().ToList();

                    objGEOTreeViewlst.AddRange(localLocations.Select(i => new TreeViewItem() { Id = i.BranchID + 30000, Value = string.Concat(i.BranchID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BRANCH), SAPValue = string.Concat(i.BranchID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BRANCH, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPBranchID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.BranchName), Text = i.BranchName, ParentId = (i.AreaID + 20000) }));

                }

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }


            return objGEOTreeViewlst.OrderBy(i => i.Text).ToList();
        }

        #region Supply Chain Location
        public List<TreeViewItem> GetLocationTreeView()
        {
            List<TreeViewItem> objLocationTreeViewlst = null;
            try
            {
                List<LocationHier> objlstSupplyLocationHier = GetSupplyChainLocationHier();
                if (objlstSupplyLocationHier != null)
                {

                    objLocationTreeViewlst = new List<TreeViewItem>();
                    var nationLocations = objlstSupplyLocationHier.DistinctBy(i => i.BUID).ToList();
                    objLocationTreeViewlst.AddRange(nationLocations.Select(i => new TreeViewItem() { Id = i.BUID, Text = i.BUName, Value = string.Concat(i.BUID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BU), SAPValue = string.Concat(i.BUID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BU, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPBUID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.BUName), ParentId = 0 }));
                    var regionalLocations = (from item in objlstSupplyLocationHier
                                             join nationlocation in nationLocations
                                             on item.BUID equals nationlocation.BUID
                                             select new { item.RegionID, item.SAPRegionID, item.RegionName, item.BUID }).Distinct().ToList();

                    objLocationTreeViewlst.AddRange(regionalLocations.Select(i => new TreeViewItem() { Id = (i.RegionID + 10000), Value = string.Concat(i.RegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_REGIONAL), SAPValue = string.Concat(i.RegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_REGIONAL, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPRegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.RegionName), Text = i.RegionName, ParentId = i.BUID }));
                    var branchLocation = (from item in objlstSupplyLocationHier
                                          join regionalLocation in regionalLocations
                                           on item.RegionID equals regionalLocation.RegionID
                                          select new { item.BranchID, item.BranchName, item.RegionID, item.BUID, item.SAPAreaID }).Distinct().ToList();

                    objLocationTreeViewlst.AddRange(branchLocation.Select(i => new TreeViewItem() { Id = (i.BranchID + 20000), Value = string.Concat(i.BranchID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_AREA), SAPValue = string.Concat(i.BranchID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BRANCH, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPAreaID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.BranchName), Text = i.BranchName, ParentId = (i.RegionID + 10000) }));
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return objLocationTreeViewlst.OrderBy(i => i.Text).ToList();
        }

        public List<LocationHier> GetSupplyChainLocationHier()
        {
            List<LocationHier> objlstSupplyLocationHier = null;
            if (CacheHelper.GetCacheValue(CommonConstants.PromotionLocationSupplyRelevancyKey) != null)
                objlstSupplyLocationHier = CacheHelper.GetCacheValue(CommonConstants.PromotionLocationSupplyRelevancyKey) as List<LocationHier>;
            else
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    objlstSupplyLocationHier = objPlaybookEntities.PBLocationHiers.Select(i => new LocationHier() { BranchID = i.BranchID, BranchName = i.BranchName, BUID = i.BUID, BUName = i.BUName, RegionID = i.RegionID, RegionName = i.RegionName, SAPAreaID = i.SAPAreaID, SAPBranchID = i.SAPBranchID, SAPBUID = i.SAPBUID, SAPRegionID = i.SAPRegionID, SPBranchName = i.SPBranchName, SPBUName = i.SPBUName, SPRegionName = i.SPRegionName }).ToList();
                    CacheHelper.SetCacheValue(CommonConstants.PromotionLocationSupplyRelevancyKey, objlstSupplyLocationHier, 518400);
                }
            }
            return objlstSupplyLocationHier;
        }

        #endregion

        public List<TreeViewItem> GetGeoSurveyTreeView()
        {
            List<TreeViewItem> objGEOTreeViewlst = null;
            try
            {
                if (CacheHelper.GetCacheValue(CommonConstants.PromotionGEOSurveyRelevancyKey) != null)
                    objGEOTreeViewlst = CacheHelper.GetCacheValue(CommonConstants.PromotionGEOSurveyRelevancyKey) as List<TreeViewItem>;
                else
                {
                    using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                    {
                        List<PBLocationHier> objlstLocationHier = objPlaybookEntities.PBLocationHiers.ToList();
                        if (objlstLocationHier != null)
                        {

                            objGEOTreeViewlst = new List<TreeViewItem>();
                            objGEOTreeViewlst.Add(new TreeViewItem() { Id = 50000, Value = "DSD", SAPValue = string.Concat(0, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, "DSD", CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, "DSD", CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, "DSD"), Text = "DSD", ParentId = 0 });

                            var nationLocations = objlstLocationHier.DistinctBy(i => i.BUID).ToList();
                            objGEOTreeViewlst.AddRange(nationLocations.Select(i => new TreeViewItem() { Id = i.BUID, Text = i.BUName, Value = string.Concat(i.BUID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BU), SAPValue = string.Concat(i.BUID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BU, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPBUID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.BUName), ParentId = 50000 }));
                            var regionalLocations = (from item in objlstLocationHier
                                                     join nationlocation in nationLocations
                                                     on item.BUID equals nationlocation.BUID
                                                     select new { item.RegionID, item.SAPRegionID, item.RegionName, item.BUID }).Distinct().ToList();
                            objGEOTreeViewlst.AddRange(regionalLocations.Select(i => new TreeViewItem() { Id = (i.RegionID + 10000), Value = string.Concat(i.RegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_REGIONAL), SAPValue = string.Concat(i.RegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_REGIONAL, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPRegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.RegionName), Text = i.RegionName, ParentId = i.BUID }));

                            var areaLocation = (from item in objlstLocationHier
                                                join regionalLocation in regionalLocations
                                                 on item.RegionID equals regionalLocation.RegionID
                                                select new { item.AreaID, item.AreaName, item.RegionID, item.BUID, item.SAPAreaID }).Distinct().ToList();

                            objGEOTreeViewlst.AddRange(areaLocation.Select(i => new TreeViewItem() { Id = (i.AreaID + 20000), Value = string.Concat(i.AreaID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_AREA), SAPValue = string.Concat(i.AreaID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_AREA, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPAreaID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.AreaName), Text = i.AreaName, ParentId = (i.RegionID + 10000) }));

                            var localLocations = (from item in objlstLocationHier
                                                  join regionalLocation in areaLocation
                                                   on item.AreaID equals regionalLocation.AreaID
                                                  select new { item.BranchID, item.BranchName, item.AreaID, item.BUID, item.SAPBranchID }).Distinct().ToList();

                            objGEOTreeViewlst.AddRange(localLocations.Select(i => new TreeViewItem() { Id = i.BranchID + 30000, Value = string.Concat(i.BranchID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BRANCH), SAPValue = string.Concat(i.BranchID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BRANCH, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPBranchID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.BranchName), Text = i.BranchName, ParentId = (i.AreaID + 20000) }));
                            CacheHelper.SetCacheValue(CommonConstants.PromotionGEOSurveyRelevancyKey, objGEOTreeViewlst, 518400);
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }


            return objGEOTreeViewlst.OrderBy(i => i.Text).ToList();
        }
        private static int GetID(int p, int p_2)
        {
            for (int i = 0; i < p_2.ToString().Length; i++)
                p *= 10;
            return p_2 + p;
        }

        #region PromotionListView/TimeLineView


        public DataTable GetStoreExecutionDetailsByPromotionID(int promotionID, int branchID, int executionStatusID, string routeID, int refusalReasonID, string accountName, int currentPersonaID, string currentUser)
        {
            DataTable objTable = new DataTable();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString.ToString()))
            {
                connection.Open();
                SqlCommand DBCmd = new SqlCommand("[PlayBook].[pGetStoreExecutionDetailsByPromotionID]", connection);
                DBCmd.CommandType = CommandType.StoredProcedure;
                DBCmd.CommandTimeout = 50;
                DBCmd.Parameters.Add("@PromotionID", SqlDbType.Int, 10).Value = promotionID;
                DBCmd.Parameters.Add("@BranchID", SqlDbType.Int, 10).Value = branchID;
                DBCmd.Parameters.Add("@ExecutionStatusID", SqlDbType.Int, 10).Value = executionStatusID;
                DBCmd.Parameters.Add("@RouteID", SqlDbType.VarChar, 50).Value = routeID;
                DBCmd.Parameters.Add("@RefusalReasonID", SqlDbType.Int, 10).Value = refusalReasonID;
                DBCmd.Parameters.Add("@CurrentPersonaID", SqlDbType.Int, 10).Value = currentPersonaID;
                DBCmd.Parameters.Add("@CurrentUser", SqlDbType.VarChar, 25).Value = currentUser;
                DBCmd.Parameters.Add("@ChainName", SqlDbType.VarChar, 25).Value = accountName;

                SqlDataReader reader = null;
                try
                {
                    reader = DBCmd.ExecuteReader();
                    objTable.Load(reader);
                    return objTable;
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                    return objTable;
                }
            }
        }
        /// <summary>
        /// Returns all the promotions based on Date
        /// </summary>
        /// <param name="StartDate"></param>
        /// <param name="EndDate"></param>
        /// <returns></returns>
        public DataTable GetPromotionByDate(PromotionViewFilter objPromotionFilter, string RolledOutAccounts)
        {
            SqlConnection Conn;
            //List<Promotion> lstPromotion = new List<Promotion>();
            DataTable objDTPromotions = new DataTable();
            try
            {
                Conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString.ToString());
                Conn.Open();
                SqlCommand DBCmd = new SqlCommand("[PlayBook].[pGetPlayBookDetailsByDate]", Conn);
                DBCmd.CommandType = CommandType.StoredProcedure;
                DBCmd.Parameters.Add("@StartDate", SqlDbType.Date, 12).Value = objPromotionFilter.StartDate.Date;
                DBCmd.Parameters.Add("@EndDate", SqlDbType.Date, 12).Value = objPromotionFilter.EndDate.Date;
                DBCmd.Parameters.Add("@ViewNatProm", SqlDbType.Bit).Value = objPromotionFilter.ViewNAPromotions;
                DBCmd.Parameters.Add("@VIEW_DRAFT_NA", SqlDbType.Bit).Value = objPromotionFilter.ViewDraftNAPromotions;
                DBCmd.Parameters.Add("@RolledOutAccount", SqlDbType.VarChar).Value = RolledOutAccounts;
                DBCmd.Parameters.Add("@Branchid", SqlDbType.Int, 10).Value = objPromotionFilter.BranchID;
                DBCmd.Parameters.Add("@RegionID", SqlDbType.Int, 10).Value = objPromotionFilter.RegionID;
                DBCmd.Parameters.Add("@currentuser", SqlDbType.VarChar, 20).Value = objPromotionFilter.GSN;
                DBCmd.Parameters.Add("@EditPromotionNA", SqlDbType.VarChar, 20).Value = objPromotionFilter.UserAccess.Contains(ApplicationRights.PromotionActivity.EDIT_PROMOTIONS_NA);
                DBCmd.Parameters.Add("@EditPromotionDSD", SqlDbType.VarChar, 20).Value = objPromotionFilter.UserAccess.Contains(ApplicationRights.PromotionActivity.EDIT);
                DBCmd.Parameters.Add("@CurrentPersonaID", SqlDbType.Int, 10).Value = objPromotionFilter.CurrentPersonaID;

                SqlDataReader myDataReader;
                try
                {
                    myDataReader = DBCmd.ExecuteReader();

                    objDTPromotions.Load(myDataReader);

                    #region TO BE DELETED
                    //while (myDataReader.Read())
                    //{
                    //    Promotion newItem = new Promotion();
                    //    if (!DBNull.Value.Equals(myDataReader[0]))
                    //    {
                    //        newItem.PromotionId = Convert.ToInt32(myDataReader[0]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[1]))
                    //    {
                    //        newItem.PromotionStatusID = Convert.ToInt32(myDataReader[1]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[2]))
                    //    {
                    //        newItem.IsLocalized = Convert.ToBoolean(myDataReader[2]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[3]))
                    //    {
                    //        newItem.EDGEItemID = Convert.ToInt32(myDataReader[3]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[4]))
                    //    {
                    //        newItem.ParentPromotionId = Convert.ToInt32(myDataReader[4]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[5]))
                    //    {
                    //        newItem.CreatedBy = Convert.ToString(myDataReader[5]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[6]))
                    //    {
                    //        newItem.PromotionCreatedDate = Convert.ToDateTime(myDataReader[6]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[7]))
                    //    {
                    //        newItem.InformationCategory = Convert.ToString(myDataReader[7]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[8]))
                    //    {
                    //        newItem.PromotionDescription = Convert.ToString(myDataReader[8]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[9]))
                    //    {
                    //        newItem.IsNationalAccountPromotion = Convert.ToBoolean(myDataReader[9]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[10]))
                    //    {
                    //        newItem.PromotionRank = Convert.ToInt32(myDataReader[10]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[1]))
                    //    {
                    //        newItem.PromotionName = Convert.ToString(myDataReader[11]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[12]))
                    //    {
                    //        newItem.PromotionPrice = Convert.ToString(myDataReader[12]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[13]))
                    //    {
                    //        newItem.PromotionStartDate = Convert.ToDateTime(myDataReader[13]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[14]))
                    //    {
                    //        newItem.ProgramLastUpdated = Convert.ToDateTime(myDataReader[14]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[15]))
                    //    {
                    //        newItem.PromotionEndDate = Convert.ToDateTime(myDataReader[15]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[16]))
                    //    {
                    //        newItem.AccountImageName = Convert.ToString(myDataReader[16]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[17]))
                    //    {
                    //        newItem.ProgramId = Convert.ToInt32(myDataReader[17]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[18]))
                    //    {
                    //        newItem.ProgramStatusID = Convert.ToInt32(myDataReader[18]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[19]))
                    //    {
                    //        newItem.PromotionStatus = Convert.ToString(myDataReader[19]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[20]))
                    //    {
                    //        newItem.PromotionCategory = Convert.ToString(myDataReader[20]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[21]))
                    //    {
                    //        // newItem.PromotionCategoryFullName = Convert.ToString(myDataReader[21]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[22]))
                    //    {
                    //        newItem.PromotionGroupName = Convert.ToString(myDataReader[22]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[23]))
                    //    {
                    //        newItem.AttachmentsName = Convert.ToString(myDataReader[23]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[24]))
                    //    {
                    //        newItem.SystemName = Convert.ToString(myDataReader[24]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[25]))
                    //    {
                    //        newItem.PromotionBrands = Convert.ToString(myDataReader[25]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[26]))
                    //    {
                    //        newItem.PromotionPackages = Convert.ToString(myDataReader[26]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[27]))
                    //    {
                    //        newItem.AccountInfo = Convert.ToString(myDataReader[27]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[28]))
                    //    {
                    //        newItem.ParentEdgePromotionCancelled = Convert.ToBoolean(myDataReader[28]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[29]))
                    //    {
                    //        newItem.AccountName = Convert.ToString(myDataReader[29]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[30]))
                    //    {
                    //        newItem.AccountId = Convert.ToInt32(myDataReader[30]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[31]))
                    //    {
                    //        newItem.PromotionType = Convert.ToString(myDataReader[31]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[32]))
                    //    {
                    //        newItem.PromotionChannel = Convert.ToString(myDataReader[32]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[33]))
                    //    {
                    //        newItem.GEORelavency = Convert.ToString(myDataReader[33]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[34]))
                    //    {
                    //        newItem.IsMyAccount = Convert.ToBoolean(myDataReader[34]);
                    //    }


                    //    lstPromotion.Add(newItem);
                    //}
                    //myDataReader.Close();
                    #endregion
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
                finally
                {
                    Conn.Close();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objDTPromotions;
        }

        /// <summary>
        /// Returns all the promotions based on Date
        /// </summary>
        /// <param name="StartDate"></param>
        /// <param name="EndDate"></param>
        /// <returns></returns>
        public Dictionary<string, string> GetPromotionFilterValues(PromotionViewFilter objPromotionFilter, string RolledOutAccount, string FilterType)
        {
            Dictionary<string, string> _dictBottlers = new Dictionary<string, string>();
            SqlConnection Conn = null;

            try
            {
                Conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString.ToString());
                Conn.Open();
                SqlCommand DBCmd = new SqlCommand("[Playbook].[pGetPromotionFilter]", Conn);
                DBCmd.CommandType = CommandType.StoredProcedure;

                if (objPromotionFilter.PromotionStatusId != (int?)null)
                {
                    DBCmd.Parameters.Add("@StartDate", SqlDbType.Date, 12).Value = objPromotionFilter.SelectedDate;
                    DBCmd.Parameters.Add("@EndDate", SqlDbType.Date, 12).Value = objPromotionFilter.CalenderEndDate;
                }
                else
                {
                    DBCmd.Parameters.Add("@StartDate", SqlDbType.Date, 12).Value = objPromotionFilter.StartDate.Date;
                    DBCmd.Parameters.Add("@EndDate", SqlDbType.Date, 12).Value = objPromotionFilter.EndDate.Date;
                }

                DBCmd.Parameters.Add("@ViewNatProm", SqlDbType.Bit).Value = objPromotionFilter.ViewNAPromotions;
                DBCmd.Parameters.Add("@VIEW_DRAFT_NA", SqlDbType.Bit).Value = objPromotionFilter.ViewDraftNAPromotions;
                DBCmd.Parameters.Add("@RolledOutAccounts", SqlDbType.VarChar).Value = RolledOutAccount;
                DBCmd.Parameters.Add("@Branchid", SqlDbType.Int, 10).Value = objPromotionFilter.BranchID;
                DBCmd.Parameters.Add("@BCRegionId", SqlDbType.Int, 10).Value = objPromotionFilter.RegionID;
                DBCmd.Parameters.Add("@currentuser", SqlDbType.VarChar, 20).Value = objPromotionFilter.GSN;
                DBCmd.Parameters.Add("@FilterType", SqlDbType.VarChar, 50).Value = FilterType;
                DBCmd.Parameters.Add("@PromotionStatus", SqlDbType.Int, 10).Value = objPromotionFilter.PromotionStatusId;
                DBCmd.Parameters.Add("@CurrentPersonaID", SqlDbType.Int, 10).Value = objPromotionFilter.CurrentPersonaID;
                DBCmd.Parameters.Add("@TradeMarkId", SqlDbType.VarChar, -1).Value = objPromotionFilter.SelectedtrademarksID;
                DBCmd.Parameters.Add("@PackageId", SqlDbType.VarChar, -1).Value = objPromotionFilter.SelectedpackagesID;
                DBCmd.Parameters.Add("@ChainName", SqlDbType.VarChar, 50).Value = objPromotionFilter.SelectedAccount;

                SqlDataReader myDataReader;
                myDataReader = DBCmd.ExecuteReader();

                while (myDataReader.Read())
                {
                    string _key = Convert.ToString(myDataReader["Text"]);
                    string _value = Convert.ToString(myDataReader["Value"]);

                    if (!_dictBottlers.ContainsKey(_key))
                        _dictBottlers.Add(_key, _value);
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            finally
            {
                if (Conn != null)
                    Conn.Close();
            }

            return _dictBottlers;
        }


        /// <summary>
        /// This method is used to get Promotion Information from SP
        /// </summary>
        /// <param name="StartDate"></param>
        /// <param name="EndDate"></param>
        /// <param name="RoleScope"></param>
        /// <param name="GSN"></param>
        /// <param name="BUID"></param>
        /// <param name="AreaID"></param>
        /// <param name="BranchID"></param>
        /// <returns></returns>
        public ArrayList GetCalendarPromotionByDate(DateTime StartDate, DateTime EndDate, string GSN, int BranchID, int BCRegionId, bool ViewDraftNA, bool ViewNaPromotion, string RolledOutNationalAccounts, int CurrentPersonaID, string TrademarkId, string PackageId)
        {
            ArrayList lstsPromoData = new ArrayList();
            List<PromoAccount> lstAccount = new List<PromoAccount>();
            List<PromoChannel> lstChannel = new List<PromoChannel>();
            List<PromoBrand> lstBrand = new List<PromoBrand>();
            List<PromoPackageInfo> lstPackage = new List<PromoPackageInfo>();
            List<Promotion> lstPromotion = new List<Promotion>();
            List<ProgramSystem> lstSystem = new List<ProgramSystem>();
            List<Program> lstPrograms = new List<Program>();
            List<Bottlers> lstBottlers = new List<Bottlers>();


            SqlConnection Conn;
            try
            {
                //string _systemIds = string.Join(",", lstSystems.Select(i => i.ID.ToString()).ToArray());
                Conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString.ToString());
                Conn.Open();
                SqlCommand DBCmd = new SqlCommand("[PlayBook].[pGetPromotionDetailsForCalendar]", Conn);
                DBCmd.CommandType = CommandType.StoredProcedure;
                DBCmd.Parameters.Add("@StartDate", SqlDbType.Date).Value = StartDate.Date;
                DBCmd.Parameters.Add("@EndDate", SqlDbType.Date).Value = EndDate.Date;
                DBCmd.Parameters.Add("@currentuser", SqlDbType.VarChar).Value = GSN;
                DBCmd.Parameters.Add("@Branchid", SqlDbType.VarChar).Value = BranchID;
                DBCmd.Parameters.Add("@BCRegionId", SqlDbType.VarChar).Value = BCRegionId;
                DBCmd.Parameters.Add("@VIEW_DRAFT_NA", SqlDbType.Bit).Value = ViewDraftNA;
                DBCmd.Parameters.Add("@ViewNatProm", SqlDbType.Bit).Value = ViewNaPromotion;
                DBCmd.Parameters.Add("@RolledOutAccount", SqlDbType.VarChar).Value = RolledOutNationalAccounts;
                DBCmd.Parameters.Add("@CurrentPersonaID", SqlDbType.Int).Value = CurrentPersonaID;
                DBCmd.Parameters.Add("@TradeMarkId", SqlDbType.VarChar).Value = !string.IsNullOrEmpty(TrademarkId) ? TrademarkId : string.Empty;
                DBCmd.Parameters.Add("@PackageId", SqlDbType.VarChar).Value = !string.IsNullOrEmpty(PackageId) ? PackageId : string.Empty;

                SqlDataReader myDataReader;
                try
                {
                    myDataReader = DBCmd.ExecuteReader();
                    #region Account
                    while (myDataReader.Read())
                    {
                        PromoAccount newItem1 = new PromoAccount();

                        if (!DBNull.Value.Equals(myDataReader[0]))
                        {
                            newItem1.PromotionID = Convert.ToInt32(myDataReader[0]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[1]))
                        {
                            newItem1.LocalChainID = Convert.ToInt32(myDataReader[1]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[2]))
                        {
                            newItem1.RegionalChainID = Convert.ToInt32(myDataReader[2]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[3]))
                        {
                            newItem1.NationalChainID = Convert.ToInt32(myDataReader[3]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[4]))
                        {
                            newItem1.AccountName = Convert.ToString(myDataReader[4]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[5]))
                        {
                            newItem1.IsMyAccount = Convert.ToBoolean(myDataReader[5]);
                        }

                        lstAccount.Add(newItem1);
                    }
                    myDataReader.NextResult();
                    #endregion

                    #region Channel
                    while (myDataReader.Read())
                    {
                        PromoChannel newItem2 = new PromoChannel();
                        if (!DBNull.Value.Equals(myDataReader[0]))
                        {
                            newItem2.PromotionId = Convert.ToInt32(myDataReader[0]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[1]))
                        {
                            newItem2.SuperChannelId = Convert.ToInt32(myDataReader[1]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[2]))
                        {
                            newItem2.ChannelId = Convert.ToInt32(myDataReader[2]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[3]))
                        {
                            newItem2.ChannelName = Convert.ToString(myDataReader[3]);
                        }
                        lstChannel.Add(newItem2);
                    }
                    myDataReader.NextResult();
                    #endregion

                    #region Brands
                    //while (myDataReader.Read())
                    //{
                    //    PromoBrand newItem3 = new PromoBrand();
                    //    if (!DBNull.Value.Equals(myDataReader[0]))
                    //    {
                    //        newItem3.PromotionID = Convert.ToInt32(myDataReader[0]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[1]))
                    //    {
                    //        newItem3.TradeMarkID = Convert.ToInt32(myDataReader[1]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[2]))
                    //    {
                    //        newItem3.BrandId = Convert.ToInt32(myDataReader[2]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[3]))
                    //    {
                    //        newItem3.BrandName = Convert.ToString(myDataReader[3]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[4]))
                    //    {
                    //        newItem3.SAPBrandId = Convert.ToString(myDataReader[4]);
                    //    }
                    //    lstBrand.Add(newItem3);
                    //}
                    //myDataReader.NextResult();
                    #endregion

                    #region Package
                    //while (myDataReader.Read())
                    //{
                    //    PromoPackageInfo newItem4 = new PromoPackageInfo();
                    //    if (!DBNull.Value.Equals(myDataReader[0]))
                    //    {
                    //        newItem4.PromotionID = Convert.ToInt32(myDataReader[0]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[1]))
                    //    {
                    //        newItem4.PackageId = Convert.ToInt32(myDataReader[1]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[2]))
                    //    {
                    //        newItem4.PackageName = Convert.ToString(myDataReader[2]);
                    //    }
                    //    lstPackage.Add(newItem4);
                    //}
                    //myDataReader.NextResult();
                    #endregion

                    #region Promotion
                    while (myDataReader.Read())
                    {
                        Promotion newItem5 = new Promotion();
                        if (!DBNull.Value.Equals(myDataReader[0]))
                        {
                            newItem5.PromotionId = Convert.ToInt32(myDataReader[0]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[1]))
                        {
                            newItem5.PromotionName = Convert.ToString(myDataReader[1]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[2]))
                        {
                            newItem5.PromotionStartDate = Convert.ToDateTime(myDataReader[2]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[3]))
                        {
                            newItem5.PromotionEndDate = Convert.ToDateTime(myDataReader[3]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[4]))
                        {
                            newItem5.ProgramId = Convert.ToInt32(myDataReader[4]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[5]))
                        {
                            newItem5.IsNationalAccountPromotion = Convert.ToBoolean(myDataReader[5]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[6]))
                        {
                            newItem5.PromotionType = Convert.ToString(myDataReader[6]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[7]))
                        {
                            newItem5.PromotionGroupID = Convert.ToInt32(myDataReader[7]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[8]))
                        {
                            newItem5.CreatedBy = Convert.ToString(myDataReader[8]);
                        }
                        // For UserGroupName
                        if (!DBNull.Value.Equals(myDataReader[9]))
                        {
                            newItem5.UserGroupName = Convert.ToString(myDataReader[9]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[10]))
                        {
                            newItem5.IsMyAccount = Convert.ToBoolean(myDataReader[10]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[11]))
                        {
                            newItem5.IsMyChannel = Convert.ToBoolean(myDataReader[11]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[12]))
                        {
                            newItem5.InformationCategory = Convert.ToString(myDataReader[12]);
                        }

                        lstPromotion.Add(newItem5);
                    }
                    #endregion
                    myDataReader.NextResult();

                    #region Program
                    while (myDataReader.Read())
                    {
                        Program newItem7 = new Program();
                        if (!DBNull.Value.Equals(myDataReader[0]))
                        {
                            newItem7.PromotionID = Convert.ToInt32(myDataReader[0]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[1]))
                        {
                            newItem7.ProgramID = Convert.ToInt32(myDataReader[1]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[2]))
                        {
                            newItem7.ProgramName = Convert.ToString(myDataReader[2]);
                        }
                        lstPrograms.Add(newItem7);
                    }
                    #endregion
                    //myDataReader.NextResult();

                    #region Bottlers
                    //while (myDataReader.Read())
                    //{
                    //    Bottlers newItem8 = new Bottlers();
                    //    if (!DBNull.Value.Equals(myDataReader[0]))
                    //    {
                    //        newItem8.RowSeqNumber = Convert.ToInt32(myDataReader[0]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[1]))
                    //    {
                    //        newItem8.PromotionID = Convert.ToInt32(myDataReader[1]);
                    //        //newItem8.PromotionID = Convert.ToString(myDataReader[0]);
                    //    }
                    //    if (!DBNull.Value.Equals(myDataReader[2]))
                    //    {
                    //        newItem8.BottlerName = Convert.ToString(myDataReader[2]);
                    //    }
                    //    lstBottlers.Add(newItem8);
                    //}
                    #endregion

                    myDataReader.Close();
                    lstAccount.Sort((x, y) => string.Compare(x.AccountName, y.AccountName));
                    lstChannel.Sort((x, y) => string.Compare(x.ChannelName, y.ChannelName));
                    //lstBrand.Sort((x, y) => string.Compare(x.BrandName, y.BrandName));
                    //lstPackage.Sort((x, y) => string.Compare(x.PackageName, y.PackageName));
                    lstPromotion.Sort((x, y) => string.Compare(x.PromotionName, y.PromotionName));
                    //lstSystem.Sort((x, y) => string.Compare(x.Name, y.Name));
                    lstPrograms.Sort((x, y) => string.Compare(x.ProgramName, y.ProgramName));
                    //lstBottlers.Sort((x, y) => string.Compare(x.BottlerName, y.BottlerName));

                    lstsPromoData.Add(lstAccount);
                    lstsPromoData.Add(lstChannel);
                    lstsPromoData.Add(lstBrand);
                    lstsPromoData.Add(lstPackage);
                    lstsPromoData.Add(lstPromotion);
                    lstsPromoData.Add(lstBrand.DistinctBy(x => x.BrandName).ToList());
                    lstsPromoData.Add(lstPackage.DistinctBy(x => x.PackageName).ToList());
                    lstsPromoData.Add(lstSystem);
                    lstsPromoData.Add(lstPrograms);
                    lstsPromoData.Add(lstBottlers);
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
                Conn.Close();
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return lstsPromoData;
        }

        /// <summary>
        /// Return all permotion based on date
        /// </summary>
        /// <param name="StartDate"></param>
        /// <param name="EndDate"></param>
        /// <param name="RoleScope"></param>
        /// <param name="BUID"></param>
        /// <param name="AreaID"></param>
        /// <param name="BranchID"></param>
        /// <param name="GSN"></param>
        /// <returns></returns>
        //public List<Promotion> GetPromotionForExportToExcel_ORG(DateTime StartDate, DateTime EndDate, string accountFilter, string channelFilter, string SystemFilter, string BranchID, string GSN, bool IsMyAccount, bool IsMyChannel, bool ViewDraftNA, bool ViewNaPromotion, string RolledOutNationalAccounts)
        //{
        //    List<Promotion> lstPromotion = null;
        //    using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
        //    {
        //        DbParameter[] parm = { (new OAParameter { ParameterName = "@StartDate", Value = StartDate.Date }), 
        //                               (new OAParameter { ParameterName = "@EndDate", Value = EndDate.Date }),
        //                               (new OAParameter { ParameterName = "@Branchid", Value = BranchID }),
        //                               (new OAParameter { ParameterName = "@currentuser", Value = GSN }),
        //                               (new OAParameter { ParameterName = "@SystemID", Value = SystemFilter }),
        //                               (new OAParameter { ParameterName = "@AccountID", Value = accountFilter }),
        //                               (new OAParameter { ParameterName = "@ChannelID", Value =channelFilter }),
        //                               (new OAParameter { ParameterName = "@IsMyAccount", Value =IsMyAccount }),
        //                               (new OAParameter { ParameterName = "@IsMyChannel", Value =IsMyChannel }),
        //                               (new OAParameter { ParameterName = "@VIEW_DRAFT_NA", Value =ViewDraftNA }),
        //                               (new OAParameter { ParameterName = "@ViewNatProm", Value =ViewNaPromotion }),
        //                               (new OAParameter { ParameterName = "@RolledOutAccounts", Value =RolledOutNationalAccounts })

        //                             };
        //        lstPromotion = objPlaybookEntities.ExecuteQuery<Promotion>(DBConstants.DB_PROC_TO_EXPORT_EXCEL, System.Data.CommandType.StoredProcedure, parm).ToList<Promotion>();
        //        return lstPromotion;
        //    }
        //}

        public List<Promotion> GetPromotionForExportToExcel(DateTime StartDate, DateTime EndDate, string accountFilter, string channelFilter, string BranchID, bool IsMyAccount, bool IsMyChannel, string RolledOutNationalAccounts, string RegionIds, bool AllAccount, bool AllChannel, string GSN, int CurrentPersonaID)
        {
            SqlConnection Conn;
            List<Promotion> lstPromotion = new List<Promotion>();
            try
            {
                Conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString.ToString());
                Conn.Open();
                SqlCommand DBCmd = new SqlCommand(DBConstants.DB_PROC_TO_EXPORT_EXCEL, Conn);
                DBCmd.CommandType = CommandType.StoredProcedure;
                DBCmd.Parameters.Add("@StartDate", SqlDbType.Date).Value = StartDate.Date;
                DBCmd.Parameters.Add("@EndDate", SqlDbType.Date).Value = EndDate.Date;
                DBCmd.Parameters.Add("@Branchid", SqlDbType.VarChar).Value = BranchID;

                DBCmd.Parameters.Add("@AccountID", SqlDbType.VarChar).Value = accountFilter;
                DBCmd.Parameters.Add("@ChannelID", SqlDbType.VarChar).Value = channelFilter;
                DBCmd.Parameters.Add("@IsMyAccount", SqlDbType.Bit).Value = IsMyAccount;
                DBCmd.Parameters.Add("@IsMyChannel", SqlDbType.Bit).Value = IsMyChannel;

                DBCmd.Parameters.Add("@RolledOutAccounts", SqlDbType.VarChar).Value = RolledOutNationalAccounts;
                DBCmd.Parameters.Add("@BCRegionIds", SqlDbType.VarChar).Value = RegionIds;
                DBCmd.Parameters.Add("@AllAccount", SqlDbType.Bit).Value = AllAccount;
                DBCmd.Parameters.Add("@AllChannel", SqlDbType.Bit).Value = AllChannel;
                DBCmd.Parameters.Add("@CurrentUser", SqlDbType.VarChar).Value = GSN;
                DBCmd.Parameters.Add("@CurrentPersonaID", SqlDbType.Int).Value = CurrentPersonaID;
                SqlDataReader myDataReader;
                try
                {
                    myDataReader = DBCmd.ExecuteReader();
                    while (myDataReader.Read())
                    {
                        try
                        {

                            Promotion newItem = new Promotion();


                            if (!DBNull.Value.Equals(myDataReader[0]))
                            {
                                newItem.PromotionType = Convert.ToString(myDataReader[0]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[1]))
                            {
                                newItem.PromotionRank = Convert.ToInt32(myDataReader[1]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[2]))
                            {
                                newItem.AccountName = Convert.ToString(myDataReader[2]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[3]))
                            {
                                newItem.PromotionCategory = Convert.ToString(myDataReader[3]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[4]))
                            {
                                newItem.PromotionName = Convert.ToString(myDataReader[4]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[5]))
                            {
                                newItem.PromotionPackages = Convert.ToString(myDataReader[5]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[6]))
                            {
                                newItem.PromotionBrands = Convert.ToString(myDataReader[6]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[7]))
                            {
                                newItem.PromotionId = Convert.ToInt32(myDataReader[7]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[8]))
                            {
                                newItem.PromotionPrice = Convert.ToString(myDataReader[8]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[9]))
                            {
                                newItem.BottlerCommitment = Convert.ToString(myDataReader[9]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[10]))
                            {
                                newItem.PromotionStartDate = Convert.ToDateTime(myDataReader[10]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[11]))
                            {
                                newItem.PromotionEndDate = Convert.ToDateTime(myDataReader[11]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[12]))
                            {
                                newItem.PromotionDescription = Convert.ToString(myDataReader[12]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[13]))
                            {
                                newItem.PromotionGroupID = Convert.ToInt32(myDataReader[13]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[14]))
                            {
                                newItem.PromotionTypeID = Convert.ToInt32(myDataReader[14]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[15]))
                            {
                                newItem.PromotionDisplayStartDate = Convert.ToDateTime(myDataReader[15]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[16]))
                            {
                                newItem.PromotionDisplayEndDate = Convert.ToDateTime(myDataReader[16]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[17]))
                            {
                                newItem.PromotionPricingStartDate = Convert.ToDateTime(myDataReader[17]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[18]))
                            {
                                newItem.PromotionPricingEndDate = Convert.ToDateTime(myDataReader[18]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[19]))
                            {
                                newItem.DisplaylocationName = Convert.ToString(myDataReader[19]);
                            }

                            if (!DBNull.Value.Equals(myDataReader[20]))
                            {
                                newItem.PromotionDisplayLocationOther = Convert.ToString(myDataReader[20]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[21]))
                            {
                                newItem.TPMPromotionNumber = Convert.ToString(myDataReader[21]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[22]))
                            {
                                newItem.ForecastVolume = Convert.ToString(myDataReader[22]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[23]))
                            {
                                newItem.GEORelavency = Convert.ToString(myDataReader[23]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[24]))
                            {
                                newItem.AttachmentURL = Convert.ToString(myDataReader[24]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[25]))
                            {
                                newItem.CreatedBy = Convert.ToString(myDataReader[25]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[26]))
                            {
                                newItem.DisplayRequirement = Convert.ToString(myDataReader[26]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[27]))
                            {
                                newItem.COSTPerStore = Convert.ToString(myDataReader[27]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[28]))
                            {
                                newItem.DisplayType = Convert.ToString(myDataReader[28]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[29]))
                            {
                                newItem.ModifiedBy = Convert.ToString(myDataReader[29]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[30]))
                            {
                                newItem.SystemName = Convert.ToString(myDataReader[30]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[31]))
                            {
                                newItem.PromotionModifiedDate = Convert.ToDateTime(myDataReader[31]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[32]))
                            {
                                newItem.Redemption = (int?)myDataReader[32];
                            }
                            if (!DBNull.Value.Equals(myDataReader[33]))
                            {
                                newItem.FixedCost = Convert.ToString(myDataReader[33]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[34]))
                            {
                                newItem.AccrualComments = Convert.ToString(myDataReader[34]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[35]))
                            {
                                newItem.VariableRPC = Convert.ToString(myDataReader[35]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[36]))
                            {
                                newItem.Unit = Convert.ToString(myDataReader[36]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[37]))
                            {
                                newItem.Accounting = Convert.ToString(myDataReader[37]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[38]))
                            {
                                newItem.OtherBrandPrice = Convert.ToString(myDataReader[38]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[39]))
                            {
                                newItem.SendBottlerAnnouncements = Convert.ToBoolean(myDataReader[39]);
                            }
                            if (!DBNull.Value.Equals(myDataReader[40]))
                            {
                                newItem.PromotionCreatedDate = Convert.ToDateTime(myDataReader[40]);
                            }

                            lstPromotion.Add(newItem);
                        }
                        catch (Exception ex)
                        {
                            ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                        }
                    }
                    myDataReader.Close();
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
                Conn.Close();
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return lstPromotion;
        }

        /// <summary>
        /// Updates the Promotions ranks for bulk edit
        /// </summary>
        /// <param name="Ranks"></param>
        /// <param name="PromotionIDs"></param>
        /// <param name="SelectedWeekStartDate"></param>
        /// <returns></returns>
        public bool UpdatePrmotionRanksByID(string Ranks, string PromotionIDs, DateTime SelectedWeekStartDate)
        {
            using (PlaybookEntities cntxt = new PlaybookEntities())
            {
                DbParameter[] parm = {  (new OAParameter { ParameterName = "@Ranks", Value = Ranks }), 
                                        (new OAParameter { ParameterName = "@PromotionIDs", Value = PromotionIDs }), 
                                        (new OAParameter { ParameterName = "@StartDate", Value = SelectedWeekStartDate.Date }) };

                try
                {
                    int rowsEffected = cntxt.ExecuteNonQuery("[PlayBook].[pUpdatePromotionRankByID]", CommandType.StoredProcedure, parm);

                    cntxt.SaveChanges();
                    return true;
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                    return false;
                }
            }
        }

        /// <summary>
        /// Update the Promotion properties based on promotion ID
        /// PromotionName, PromotionPrice, StartDate, EndDate, Ranking
        /// </summary>
        /// <param name="objPromotion"></param>
        /// <returns></returns>
        public bool UpdatePrmotionStatusByID(int PromotionID, int PromtoionStatusId, string GSN)
        {
            try
            {
                using (PlaybookEntities cntxt = new PlaybookEntities())
                {
                    PBRetailPromotion _promotion = cntxt.PBRetailPromotions.First(i => i.PromotionID == PromotionID);

                    PBStatus _promoStatus = cntxt.PBStatus.First(j => j.StatusID == PromtoionStatusId);
                    _promotion.PromotionStatusID = _promoStatus.StatusID;
                    _promotion.ModifiedDate = DateTime.UtcNow;
                    _promotion.ModifiedBy = GSN;
                    _promotion.StatusModifiedDate = DateTime.UtcNow;

                    cntxt.SaveChanges();

                    if ((bool)_promotion.IsNationalAccount && PromtoionStatusId == 3)
                        UpdateChildOnNAPromotionCancelled(PromotionID, GSN);
                }


                return true;
            }
            catch (Exception ex)
            {
                //Log Error
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                return false;
            }
        }

        /// <summary>
        /// Updates the NA Promotion childs on cancellation
        /// </summary>
        /// <param name="PromotionID"></param>
        /// <param name="GSN"></param>
        /// <returns></returns>
        public bool UpdateChildOnNAPromotionCancelled(int PromotionID, string GSN)
        {
            try
            {
                using (PlaybookEntities cntxt = new PlaybookEntities())
                {
                    List<PBRetailPromotion> _promotion = cntxt.PBRetailPromotions.Where(i => i.EDGEItemID == PromotionID && i.ParentPromotionID == (int?)null).ToList();
                    foreach (PBRetailPromotion objPromotion in _promotion)
                    {
                        objPromotion.PromotionStatusID = 3;
                        objPromotion.ModifiedDate = DateTime.UtcNow;
                        objPromotion.ModifiedBy = GSN;
                        objPromotion.StatusModifiedDate = DateTime.UtcNow;
                    }
                    cntxt.SaveChanges();
                    if (_promotion.Count > 0)
                    {
                        try
                        {
                            var childPromotions = (from retail in cntxt.PBRetailPromotions join promotion in _promotion on retail.ParentPromotionID equals promotion.PromotionID select retail).ToList();
                            if (childPromotions.Count > 0)
                            {
                                childPromotions.ForEach(i => { i.PromotionStatusID = 1; i.StatusModifiedDate = DateTime.UtcNow; });
                                cntxt.SaveChanges();

                            }
                        }
                        catch (Exception ex)
                        {
                            ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                        }
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                //Log Error
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                return false;
            }
        }

        #endregion

        //public List<Promotion> GetPromotionByProgram_ORG(PromotionViewFilter objPromotionFilter, string RolledOutNationalAccounts)
        //{
        //    List<Promotion> lstPromotion = null;

        //    using (PlaybookEntities entity = new PlaybookEntities())
        //    {
        //        DbParameter[] parm = { (new OAParameter { ParameterName = "@Branchid", Value = objPromotionFilter.BranchID }),
        //                               (new OAParameter { ParameterName = "@currentuser", Value = objPromotionFilter.GSN }),
        //                               (new OAParameter { ParameterName = "@Programid", Value = objPromotionFilter.ProgramID }),
        //                             (new OAParameter { ParameterName = "@ViewNatProm", Value = objPromotionFilter.ViewNAPromotions }),
        //                             (new OAParameter { ParameterName = "@VIEW_DRAFT_NA", Value = objPromotionFilter.ViewDraftNAPromotions }),
        //                             (new OAParameter { ParameterName = "@RegionID", Value = objPromotionFilter.RegionID }),
        //                             (new OAParameter { ParameterName = "@CurrentPersonaID", Value = objPromotionFilter.CurrentPersonaID }),
        //                                (new OAParameter { ParameterName = "@RolledOutNationalAccounts", Value = RolledOutNationalAccounts })};

        //        try
        //        {
        //            lstPromotion = entity.ExecuteQuery<Promotion>("[Program].[pGetPromotionsByProgramID]", System.Data.CommandType.StoredProcedure, parm).ToList<Promotion>();
        //        }
        //        catch (Exception ex)
        //        {
        //            ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
        //        }
        //        return lstPromotion;
        //    }
        //}

        public DataTable GetPromotionByProgram(PromotionViewFilter objPromotionFilter, string RolledOutNationalAccounts)
        {
            SqlConnection Conn;
            //List<Promotion> lstPromotion = new List<Promotion>();
            DataTable objDTPromotions = new DataTable();
            try
            {
                Conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString.ToString());
                Conn.Open();
                SqlCommand DBCmd = new SqlCommand("[Program].[pGetPromotionsByProgramID]", Conn);
                DBCmd.CommandType = CommandType.StoredProcedure;
                DBCmd.Parameters.Add("@Branchid", SqlDbType.Int, 12).Value = objPromotionFilter.BranchID;
                DBCmd.Parameters.Add("@currentuser", SqlDbType.VarChar, 20).Value = objPromotionFilter.GSN;
                DBCmd.Parameters.Add("@Programid", SqlDbType.Int, 10).Value = objPromotionFilter.ProgramID;
                DBCmd.Parameters.Add("@ViewNatProm", SqlDbType.Bit).Value = objPromotionFilter.ViewNAPromotions;
                DBCmd.Parameters.Add("@VIEW_DRAFT_NA", SqlDbType.Bit).Value = objPromotionFilter.ViewDraftNAPromotions;
                DBCmd.Parameters.Add("@RegionID", SqlDbType.Int, 10).Value = objPromotionFilter.RegionID;
                DBCmd.Parameters.Add("@CurrentPersonaID", SqlDbType.Int, 10).Value = objPromotionFilter.CurrentPersonaID;
                DBCmd.Parameters.Add("@RolledOutNationalAccounts", SqlDbType.VarChar, 20).Value = RolledOutNationalAccounts;


                SqlDataReader myDataReader;
                try
                {
                    myDataReader = DBCmd.ExecuteReader();

                    objDTPromotions.Load(myDataReader);
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
                finally
                {
                    Conn.Close();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objDTPromotions;
        }

        public List<PromoAccount> GetPromotionAccountbyIds(int[] promoid)
        {

            List<PromoAccount> objlstPBPromotionAccount = null;
            using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
            {
                objlstPBPromotionAccount = new List<PromoAccount>();
                PromoAccount objPromoAccount = new PromoAccount();
                var allAccounts = objPlaybookEntities.PBChainHiers.ToList();
                for (int i = 0; i < promoid.Length; i++)
                {
                    //var items = objPlaybookEntities.PBPromotionAccounts.Where(j => j.PromotionID == promoid[i]).Select(j => new PromoAccount() { LocalChainID = j.LocalChainID, RegionalChainID = j.RegionalChainID, NationalChainID = j.NationalChainID, PromotionID = j.PromotionID, IsRoot = j.IsRoot }).ToList();
                    var items = objPlaybookEntities.PBPromotionAccounts.Where(j => j.PromotionID == promoid[i]).Select(j => new PromoAccount() { LocalChainID = j.LocalChainID, RegionalChainID = j.RegionalChainID, NationalChainID = j.NationalChainID, PromotionID = j.PromotionID }).ToList();
                    foreach (var item in items)
                    {
                        string accounName = string.Empty;
                        if (item.NationalChainID != (int?)null && item.NationalChainID != 0)
                            item.NationalChainName = allAccounts.Where(j => j.NationalChainID == item.NationalChainID).Select(j => j.NationalChainName).FirstOrDefault();
                        else if (item.RegionalChainID != (int?)null && item.RegionalChainID != 0)
                            item.RegionalChainName = allAccounts.Where(j => j.RegionalChainID == item.RegionalChainID).Select(j => j.RegionalChainName).FirstOrDefault();
                        else if (item.LocalChainID != (int?)null && item.LocalChainID != 0)
                            item.LocalChainName = allAccounts.Where(j => j.LocalChainID == item.LocalChainID).Select(j => j.LocalChainName).FirstOrDefault();

                    }
                    objlstPBPromotionAccount.AddRange(items);
                }
            }
            return objlstPBPromotionAccount;
        }


        public List<PromoChannel> GetPromotionChannelbyIds(int[] promoid)
        {

            List<PromoChannel> objlstPBPromotionAccount = null;
            using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
            {
                objlstPBPromotionAccount = new List<PromoChannel>();
                var allChannels = objPlaybookEntities.PBChannelHiers.ToList();
                for (int i = 0; i < promoid.Length; i++)
                {
                    var items = objPlaybookEntities.PBPromotionChannels.Where(j => j.PromotionID == promoid[i]).Select(j => new PromoChannel() { PromotionId = (int)j.PromotionID, ChannelId = j.ChannelID, SuperChannelId = j.SuperChannelID }).ToList();
                    foreach (var item in items)
                    {
                        string accounName = string.Empty;
                        if (item.SuperChannelId != (int?)null && item.SuperChannelId != 0)
                            item.SuperChannelName = allChannels.Where(j => j.SuperChannelID == item.SuperChannelId).Select(j => j.SuperChannelName).FirstOrDefault();
                        else if (item.ChannelId != (int?)null && item.ChannelId != 0)
                            item.ChannelName = allChannels.Where(j => j.ChannelID == item.ChannelId).Select(j => j.ChannelName).FirstOrDefault();

                    }
                    objlstPBPromotionAccount.AddRange(items);
                }
            }
            return objlstPBPromotionAccount;
        }


        public List<PromoSystem> GetPromotionSystembyIds(int[] promoid, List<ProgramSystem> lstSystems)
        {

            List<PromoSystem> objlstPromoSystem = null;
            using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
            {
                objlstPromoSystem = new List<PromoSystem>();
                var allSystem = lstSystems; //objPlaybookEntities.PBSystems.ToList();
                for (int i = 0; i < promoid.Length; i++)
                {
                    var items = objPlaybookEntities.PBPromotionSystems.Where(j => j.PromotionID == promoid[i]).Select(j => new PromoSystem() { PromotionId = (int)j.PromotionID, SystemId = j.SystemID }).ToList();
                    foreach (var item in items)
                    {
                        string accounName = string.Empty;
                        if (item.SystemId != (int?)null && item.SystemId != 0)
                            item.SystemName = allSystem.Where(j => j.ID == item.SystemId).First().Name;
                    }
                    objlstPromoSystem.AddRange(items);
                }
            }
            return objlstPromoSystem;
        }
        #region Latest Promotion

        /// <summary>
        /// Gets the Latest promotions based on the user last login
        /// </summary>
        /// <param name="RoleScope"></param>
        /// <param name="BUID"></param>
        /// <param name="AreaID"></param>
        /// <param name="BranchID"></param>
        /// <param name="GSN"></param>
        /// <returns></returns>
        /// we have added two additional perameter VIEW_DRAFT_NA and ViewNatProm and RoleSystemId for SRE Implementation--------Sunil
        public List<Promotion> GetLatestPromotions(int BranchID, int RegionID, string GSN, DateTime LastLoginTime, bool VIEW_DRAFT_NA, bool ViewNatProm, string RolledOutNationaAccount)
        {
            List<Promotion> lstPromotion = new List<Promotion>();

            using (PlaybookEntities cntxt = new PlaybookEntities())
            {
                DbParameter[] parm = { (new OAParameter { ParameterName = "@LastLogin", Value = LastLoginTime }),
                                       (new OAParameter { ParameterName = "@currentuser", Value = GSN }),
                                       (new OAParameter { ParameterName = "@Branchid", Value = BranchID }),
                                        (new OAParameter { ParameterName = "@Regionid", Value = RegionID }),
                                      (new OAParameter { ParameterName = "@VIEW_DRAFT_NA", Value = VIEW_DRAFT_NA }),
                                      (new OAParameter { ParameterName = "@ViewNatProm", Value = ViewNatProm }),
                                      //(new OAParameter { ParameterName = "@RoleSystemID", Value = RoleSystemId }),
                                      (new OAParameter { ParameterName = "@RolledOutAccount", Value = RolledOutNationaAccount })};
                try
                {
                    lstPromotion = cntxt.ExecuteQuery<Promotion>("[PlayBook].[pGetLatestPromotions]", System.Data.CommandType.StoredProcedure, parm).ToList<Promotion>();
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
                return lstPromotion;
            }
        }

        #endregion

        /// <summary>
        /// Get All brands by Promotionid
        /// </summary>
        /// <param name="promotionId"></param>
        /// <returns></returns>
        public List<PBPromotionBrand> GetBrandsByPromotionId(int promotionId)
        {
            List<PBPromotionBrand> objlstPromoBrands = null;
            try
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    var allbrands = from o in objPlaybookEntities.PBPromotionBrands
                                    where o.PromotionID == promotionId
                                    select new PBPromotionBrand
                                    {
                                        BrandID = o.BrandID
                                    };
                    objlstPromoBrands = allbrands.Distinct().ToList();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objlstPromoBrands;
        }

        /// <summary>
        /// Get All Packages by PromotionId
        /// </summary>
        /// <param name="promotionId"></param>
        /// <returns></returns>
        public List<PBPromotionPackage> GetPackagesByPromotionId(int promotionId)
        {

            List<PBPromotionPackage> objlstPromoPackages = null;
            try
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    var allpackages = from o in objPlaybookEntities.PBPromotionPackages
                                      where o.PromotionID == promotionId
                                      select new PBPromotionPackage
                                      {
                                          PackageTypeID = o.PackageTypeID
                                      };
                    objlstPromoPackages = allpackages.Distinct().ToList();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objlstPromoPackages;
        }

        /// <summary>
        /// Get All Categories for brand and package
        /// </summary>
        /// <returns></returns>
        public List<BrandPackageCategory> GetPackageCategory()
        {

            List<BrandPackageCategory> objlstPackageCategories = null;
            try
            {
                if (CacheHelper.GetCacheValue(CommonConstants.ManageBrandPackageCategory) != null)
                    objlstPackageCategories = CacheHelper.GetCacheValue(CommonConstants.ManageBrandPackageCategory) as List<BrandPackageCategory>;
                else
                {

                    using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                    {
                        objlstPackageCategories = new List<BrandPackageCategory>();
                        var allCategories = (from o in objPlaybookEntities.PBCategories
                                             select new BrandPackageCategory
                                             {
                                                 CategoryId = o.CategoryID,
                                                 CategoryName = o.CategoryName
                                             }).Distinct().ToList();

                        int maxCategoryId = allCategories.Max(p => p.CategoryId);
                        var allCoreCategories = (from c in objPlaybookEntities.PBCustomCategory1
                                                 select new BrandPackageCategory
                                                 {
                                                     CategoryId = 0,
                                                     CategoryName = c.CategoryGroupName,
                                                 }).DistinctBy(i => i.CategoryName).OrderBy(i => i.CategoryName).ToList();
                        for (int i = 0; i < allCoreCategories.Count; i++)
                        {
                            maxCategoryId += 1;
                            allCoreCategories[i].CategoryId = maxCategoryId;
                        }

                        objlstPackageCategories.AddRange(allCoreCategories);
                        objlstPackageCategories.AddRange(allCategories);
                        CacheHelper.SetCacheValue(CommonConstants.ManageBrandPackageCategory, objlstPackageCategories);

                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objlstPackageCategories;
        }

        /// <summary>
        /// Get All Categories for brand and package
        /// </summary>
        /// <returns></returns>
        public List<BrandPackageCategory> GetPackageCategoryForProgram()
        {

            List<BrandPackageCategory> objlstPackageCategories = null;
            try
            {
                if (CacheHelper.GetCacheValue(CommonConstants.ManageBrandPackageCategory) != null)
                    objlstPackageCategories = CacheHelper.GetCacheValue(CommonConstants.ManageBrandPackageCategory) as List<BrandPackageCategory>;
                else
                {

                    using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                    {
                        objlstPackageCategories = new List<BrandPackageCategory>();
                        var allCategories = (from o in objPlaybookEntities.PBCategories
                                             select new BrandPackageCategory
                                             {
                                                 CategoryId = o.CategoryID,
                                                 CategoryName = o.CategoryName
                                             }).Distinct().ToList();

                        int maxCategoryId = allCategories.Max(p => p.CategoryId);
                        var allCoreCategories = (from c in objPlaybookEntities.PBCustomCategory1
                                                 select new BrandPackageCategory
                                                 {
                                                     CategoryId = 0,
                                                     CategoryName = c.CategoryGroupName,
                                                 }).DistinctBy(i => i.CategoryName).OrderBy(i => i.CategoryName).ToList();
                        for (int i = 0; i < allCoreCategories.Count; i++)
                        {
                            maxCategoryId += 1;
                            allCoreCategories[i].CategoryId = maxCategoryId;
                        }

                        objlstPackageCategories.AddRange(allCoreCategories);
                        objlstPackageCategories.AddRange(allCategories);
                        CacheHelper.SetCacheValue(CommonConstants.ManageBrandPackageCategory, objlstPackageCategories);

                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objlstPackageCategories;
        }
        /// <summary>
        /// Get core brands of core categories like core 4,core 5,Ten
        /// </summary>
        /// <param name="CategoryName"></param>
        /// <param name="accountid"></param>
        /// <param name="promotionType"></param>
        /// <param name="scope"></param>
        /// <param name="buId"></param>
        /// <param name="regionId"></param>
        /// <param name="branchId"></param>
        /// <returns></returns>
        public List<PromoBrand> GetCoreBrandsByAccountId(string CategoryName, int buId, int regionId, int branchId)
        {
            List<PromoBrand> objBrandslst = null;
            try
            {

                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {

                    if (CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_5 || CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_4)
                    {
                        objBrandslst = (from bc in objPlaybookEntities.PBCategoryBrandPackages
                                        join cc in objPlaybookEntities.PBCustomCategory1
                                        on bc.TradeMarkID equals cc.TradeMarkID
                                        where cc.CategoryGroupName == CategoryName
                                        select new PromoBrand() { IsTradeMark = true, SAPBrandId = bc.SAPTradeMarkID + ',' + bc.TradeMarkID, BrandId = Convert.ToInt32(cc.TradeMarkID), BrandName = bc.TradeMarkName }).ToList();
                        #region Scope
                        //switch (scope)
                        //{
                        //    case OnePortalRoleScope.BU:

                        //        objBrandslst = (from bc in objPlaybookEntities.PBBranchBrandCategories
                        //                        join cc in objPlaybookEntities.PBCustomCategories
                        //                        on bc.TradeMarkID equals cc.TradeMarkID
                        //                        where cc.CategoryGroupName == CategoryName && bc.BUID == buId
                        //                        select new PromoBrand() { BrandId = Convert.ToInt32(cc.TradeMarkID), BrandName = bc.TradeMarkName }).ToList();

                        //        break;

                        //    case OnePortalRoleScope.Region:

                        //        objBrandslst = (from bc in objPlaybookEntities.PBBranchBrandCategories
                        //                        join cc in objPlaybookEntities.PBCustomCategories
                        //                        on bc.TradeMarkID equals cc.TradeMarkID
                        //                        where cc.CategoryGroupName == CategoryName && bc.RegionID == regionId
                        //                        select new PromoBrand() { BrandId = Convert.ToInt32(cc.TradeMarkID), BrandName = bc.TradeMarkName }).ToList();
                        //        break;
                        //    case OnePortalRoleScope.Branch:

                        //        objBrandslst = (from bc in objPlaybookEntities.PBBranchBrandCategories
                        //                        join cc in objPlaybookEntities.PBCustomCategories
                        //                        on bc.TradeMarkID equals cc.TradeMarkID
                        //                        where cc.CategoryGroupName == CategoryName && bc.BranchID == branchId
                        //                        select new PromoBrand() { BrandId = Convert.ToInt32(cc.TradeMarkID), BrandName = bc.TradeMarkName }).ToList();

                        //        break;

                        //}
                        #endregion
                    }
                    else if (CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_TEN
                        || CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_DRPEPPER
                        || CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_SCHWEPPES
                        || CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_CANADA_DRY)
                    {
                        objBrandslst = (from bc in objPlaybookEntities.PBCategoryBrandPackages
                                        join cc in objPlaybookEntities.PBCustomCategory1
                                        on bc.BrandID equals cc.BrandID
                                        where cc.CategoryGroupName == CategoryName
                                        select new PromoBrand() { IsTradeMark = false, SAPBrandId = bc.SAPBrandID + ',' + cc.BrandID, BrandId = Convert.ToInt32(cc.BrandID), BrandName = bc.BrandName }).ToList();
                        #region Scope

                        //switch (scope)
                        //{
                        //    case OnePortalRoleScope.BU:


                        //        objBrandslst = (from bc in objPlaybookEntities.PBBranchBrandCategories
                        //                        join cc in objPlaybookEntities.PBCustomCategories
                        //                        on bc.BrandID equals cc.BrandID
                        //                        where cc.CategoryGroupName == CategoryName && bc.BUID == buId
                        //                        select new PromoBrand() { BrandId = Convert.ToInt32(cc.BrandID), BrandName = bc.BrandName }).ToList();

                        //        break;

                        //    case OnePortalRoleScope.Region:
                        //        objBrandslst = (from bc in objPlaybookEntities.PBBranchBrandCategories
                        //                        join cc in objPlaybookEntities.PBCustomCategories
                        //                        on bc.BrandID equals cc.BrandID
                        //                        where cc.CategoryGroupName == CategoryName && bc.RegionID == regionId
                        //                        select new PromoBrand() { BrandId = Convert.ToInt32(cc.BrandID), BrandName = bc.BrandName }).ToList();

                        //        break;
                        //    case OnePortalRoleScope.Branch:

                        //        objBrandslst = (from bc in objPlaybookEntities.PBBranchBrandCategories
                        //                        join cc in objPlaybookEntities.PBCustomCategories
                        //                        on bc.BrandID equals cc.BrandID
                        //                        where cc.CategoryGroupName == CategoryName && bc.BranchID == branchId
                        //                        select new PromoBrand() { BrandId = Convert.ToInt32(cc.BrandID), BrandName = bc.BrandName }).ToList();

                        //        break;

                        //}

                        #endregion
                    }
                    //else if (CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_DRPEPPER)
                    //{

                    //    //switch (scope)
                    //    //{
                    //    //    case OnePortalRoleScope.BU:


                    //    //        objBrandslst = (from bc in objPlaybookEntities.PBBranchBrandCategories
                    //    //                        join cc in objPlaybookEntities.PBCustomCategories
                    //    //                        on bc.BrandID equals cc.BrandID
                    //    //                        where cc.CategoryGroupName == CategoryName && bc.BUID == buId
                    //    //                        select new PromoBrand() { BrandId = Convert.ToInt32(cc.BrandID), BrandName = bc.BrandName }).ToList();

                    //    //        break;

                    //    //    case OnePortalRoleScope.Region:
                    //    //        objBrandslst = (from bc in objPlaybookEntities.PBBranchBrandCategories
                    //    //                        join cc in objPlaybookEntities.PBCustomCategories
                    //    //                        on bc.BrandID equals cc.BrandID
                    //    //                        where cc.CategoryGroupName == CategoryName && bc.RegionID == regionId
                    //    //                        select new PromoBrand() { BrandId = Convert.ToInt32(cc.BrandID), BrandName = bc.BrandName }).ToList();

                    //    //        break;
                    //    //    case OnePortalRoleScope.Branch:

                    //    //        objBrandslst = (from bc in objPlaybookEntities.PBBranchBrandCategories
                    //    //                        join cc in objPlaybookEntities.PBCustomCategories
                    //    //                        on bc.BrandID equals cc.BrandID
                    //    //                        where cc.CategoryGroupName == CategoryName && bc.BranchID == branchId
                    //    //                        select new PromoBrand() { BrandId = Convert.ToInt32(cc.BrandID), BrandName = bc.BrandName }).ToList();

                    //    //        break;

                    //    //}
                    //}

                    objBrandslst = objBrandslst.DistinctBy(i => i.BrandName).OrderBy(i => i.BrandName).ToList();

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return objBrandslst;
        }

        /// <summary>
        /// Get packages of particular category
        /// </summary>
        /// <param name="categoryId"></param>
        /// <param name="promotionType"></param>
        /// <param name="accountId"></param>
        /// <param name="scope"></param>
        /// <param name="buId"></param>
        /// <param name="regionId"></param>
        /// <param name="branchId"></param>
        /// <returns></returns>
        public List<PromoPackage> GetPackagesByPackageCategoryId(int? categoryId, string CategoryName, int buId, int regionId, int branchId)
        {
            List<PromoPackage> lstPackages = null;
            try
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    if (CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_5 || CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_4
                        || CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_TEN
                        || CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_DRPEPPER
                        || CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_SCHWEPPES
                        || CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_CANADA_DRY)
                        lstPackages = GetAllPackages().Where(i => string.Compare(i.CategoryName, CategoryName, true) == 0).ToList();
                    else
                        lstPackages = GetAllPackages().Where(i => i.CategoryId == categoryId).ToList();

                    lstPackages = lstPackages.DistinctBy(i => i.PackageName).OrderBy(i => i.PackageName).ToList();

                }

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return lstPackages;
        }


        /// <summary>
        /// get Packages of All category
        /// </summary>
        public List<PromoPackage> GetAllPackages()
        {
            string pkgKey = "PromotionActivities.Packages.AllUsers.{8CBDF758-42BC-4235-897F-FD54EF9139E2}";
            List<PromoPackage> lstPackages = new List<PromoPackage>();
            if (CacheHelper.GetCacheValue(pkgKey) != null)
            {
                lstPackages = CacheHelper.GetCacheValue(pkgKey) as List<PromoPackage>;
            }
            else
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {

                    lstPackages.AddRange(objPlaybookEntities.PBCustomCategoryPackages
                                      .Select(i => new PromoPackage()
                                      {
                                          PackageId = Convert.ToString(i.PackageID),
                                          PackageName = i.PackageName,
                                          CategoryName = i.CategoryGroupName
                                      }).ToList());

                    lstPackages.AddRange((from o in objPlaybookEntities.PBCategoryBrandPackages
                                          join cat in objPlaybookEntities.PBCustomCategories
                                          on o.InternalCategoryID equals cat.CategoryID
                                          select new PromoPackage
                                          {
                                              PackageId = Convert.ToString(o.PackageID),
                                              PackageName = o.PackageName,
                                              CategoryId = o.InternalCategoryID
                                          }).ToList());
                }
                CacheHelper.SetCacheValue(pkgKey, lstPackages, 24);
            }
            return lstPackages.OrderBy(i => i.PackageName).ToList();

        }
        /// <summary>
        /// Fetch brands for auto complete in create Promotion Screen.
        /// Table Name:SAP.Brand
        /// </summary>
        /// <returns></returns>
        ///  

        public List<PromoBrand> GetBrandsByPackageCategoryId(string CategoryName, int? categoryId, int buId, int regionId, int branchId)
        {
            List<PromoBrand> objlstPromoBrand = null;
            try
            {
                if (CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_5 || CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_4
                    || CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_TEN
                    || CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_DRPEPPER
                    || CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_SCHWEPPES
                    || CategoryName.ToUpper() == DBConstants.DB_CUSTOM_CATEGORY_CORE_CANADA_DRY)
                    objlstPromoBrand = GetCoreBrandsByAccountId(CategoryName, buId, regionId, branchId);
                else
                {

                    using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                    {
                        objlstPromoBrand = (from o in objPlaybookEntities.PBCategoryBrandPackages
                                            where o.InternalCategoryID == categoryId
                                            select new PromoBrand
                                            {
                                                BrandId = o.TradeMarkID,
                                                BrandName = o.TradeMarkName,
                                                SAPBrandId = o.SAPTradeMarkID + ',' + o.TradeMarkID,
                                                IsTradeMark = true

                                            }).ToList();
                        #region Scope


                        //switch (scope)
                        //{
                        //    case OnePortalRoleScope.BU:

                        //        objlstPromoBrand = (from o in objPlaybookEntities.PBBranchBrandCategories
                        //                            where o.InternalCategoryID == categoryId && o.BUID == buId
                        //                            select new PromoBrand
                        //                            {
                        //                                BrandId = o.TradeMarkID,
                        //                                BrandName = o.TradeMarkName
                        //                            }).ToList();

                        //        break;

                        //    case OnePortalRoleScope.Region:

                        //        objlstPromoBrand = (from o in objPlaybookEntities.PBBranchBrandCategories
                        //                            where o.InternalCategoryID == categoryId && o.RegionID == regionId
                        //                            select new PromoBrand
                        //                            {
                        //                                BrandId = o.TradeMarkID,
                        //                                BrandName = o.TradeMarkName
                        //                            }).ToList();

                        //        break;

                        //    case OnePortalRoleScope.Branch:

                        //        objlstPromoBrand = (from o in objPlaybookEntities.PBBranchBrandCategories
                        //                            where o.InternalCategoryID == categoryId && o.BranchID == branchId
                        //                            select new PromoBrand
                        //                            {
                        //                                BrandId = o.TradeMarkID,
                        //                                BrandName = o.TradeMarkName
                        //                            }).ToList();

                        //        break;

                        //}
                        #endregion
                        objlstPromoBrand = objlstPromoBrand.DistinctBy(I => I.BrandName).ToList();
                    }
                    objlstPromoBrand = objlstPromoBrand.OrderBy(i => i.BrandName).ToList();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objlstPromoBrand;
        }

        /// <summary>
        /// Get all promotion categories for promotion 
        /// </summary>
        /// <returns></returns>
        public List<PBAttachmentType> GetAttachmentType()
        {

            List<PBAttachmentType> objlstAttachmentTypes = null;
            try
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    objlstAttachmentTypes = objPlaybookEntities.PBAttachmentTypes.OrderBy(i => i.AttachmentTypeName).ToList();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objlstAttachmentTypes;
        }

        #region Deleting Edge Promotion

        public List<Promotion> DeleteEdgePromotion(DateTime LastRunTime, string ConnecionString)
        {
            List<Promotion> objPromoItems = new List<Promotion>();

            try
            {
                using (PlaybookEntities entity = new PlaybookEntities(ConnecionString))
                {
                    List<PBRPLItem> ListRPLItems = (from t in entity.PBRPLItems
                                                    where t.DeletedDate != null && t.DeletedDate >= LastRunTime
                                                    select t).ToList<PBRPLItem>();

                    //Update Promotion Status to Cancel
                    PBStatus _promoStatusCancel = entity.PBStatus.First(j => j.StatusID == 3);

                    //Iterate over all the deleted items
                    foreach (PBRPLItem item in ListRPLItems)
                    {
                        int? contentID = Convert.ToInt32(item.ContentID);

                        //Get all the promotions created with the Content ID
                        List<PBRetailPromotion> _retailPromotionColl = entity.PBRetailPromotions.Where(i => i.EDGEItemID == contentID).ToList<PBRetailPromotion>();

                        //   Iterate over each promotion and change the following 
                        //1. Change the status to Cancelled
                        //2. Update the Modified Date
                        //3. Fill the necessary info req to sent mail
                        foreach (PBRetailPromotion _retailPromotion in _retailPromotionColl)
                        {
                            //Cancel the promotion that are from edge and leave their child
                            if (_retailPromotion.ParentPromotionID == null)
                                _retailPromotion.PromotionStatusID = _promoStatusCancel.StatusID;

                            _retailPromotion.ModifiedDate = DateTime.UtcNow;
                            _retailPromotion.PromotionDescription = _retailPromotion.ParentPromotionID == null ? _retailPromotion.PromotionDescription + ". This Promotion has been deleted" : _retailPromotion.PromotionDescription;

                            //If promotion is a child promtoion then save the details to send mail
                            if (_retailPromotion.ParentPromotionID != null)
                            {
                                Promotion objPromo = new Promotion();
                                objPromo.CreatedBy = _retailPromotion.CreatedBy;
                                objPromo.PromotionName = _retailPromotion.PromotionName;
                                objPromoItems.Add(objPromo);
                            }
                        }
                    }
                    entity.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return objPromoItems;
        }

        #endregion


        /// <summary>
        /// This method can be used to get the preferences from playbook.userpreferences
        /// it is assumend that only single row can exisist for a given GSN
        /// </summary>
        /// <param name="gsn"></param>
        /// <returns></returns>
        public PromotionPreferences GetPreferences(string gsn)
        {
            PromotionPreferences preferences = null;
            try
            {
                using (PlaybookEntities cntx = new PlaybookEntities())
                {
                    preferences = (from pref in cntx.PBUserPreferences
                                   where pref.GSN == gsn && pref.IsOverridden == true
                                   select new PromotionPreferences
                                   {
                                       GSN = pref.GSN,
                                       NationalAccount = pref.NationalAccounts,
                                       IsOverridden = pref.IsOverridden,
                                       Branch = pref.Branchs,
                                       RegionalAccount = pref.RegionalAccounts,
                                       BusinessUnit = pref.BusinessUnits,
                                       LocalAccount = pref.LocalAccounts,
                                       Region = pref.Regions,
                                       Area = pref.Area,
                                       Channel = pref.Channel,
                                       SuperChannel = pref.SuperChannel,
                                   }).ToList<PromotionPreferences>().FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return preferences;
        }

        public bool InsertUpdatePreferences(PromotionPreferences pref)
        {
            bool status = false;
            try
            {
                string GSN = pref.GSN;
                using (PlaybookEntities cntx = new PlaybookEntities())
                {
                    PBUserPreference existing = (from p in cntx.PBUserPreferences
                                                 where p.GSN == pref.GSN
                                                 select p).ToList<PBUserPreference>().FirstOrDefault();
                    if (existing == null)
                    {
                        //Insert as no record exists in table
                        PBUserPreference newPref = new PBUserPreference()
                        {
                            Branchs = pref.Branch,
                            Area = pref.Area,
                            Regions = pref.Region,
                            BusinessUnits = pref.BusinessUnit,
                            GSN = pref.GSN,
                            IsOverridden = pref.IsOverridden,
                            LocalAccounts = pref.LocalAccount,
                            RegionalAccounts = pref.RegionalAccount,
                            NationalAccounts = pref.NationalAccount,
                            Channel = pref.Channel,
                            SuperChannel = pref.SuperChannel
                        };
                        cntx.Add(newPref);
                        cntx.SaveChanges();
                    }
                    else
                    {
                        //Update the existing record
                        existing.GSN = pref.GSN;
                        existing.IsOverridden = pref.IsOverridden;
                        existing.NationalAccounts = pref.NationalAccount;
                        existing.RegionalAccounts = pref.RegionalAccount;
                        existing.LocalAccounts = pref.LocalAccount;
                        existing.BusinessUnits = pref.BusinessUnit;
                        existing.Branchs = pref.Branch;
                        existing.Area = pref.Area;
                        existing.Regions = pref.Region;
                        existing.Channel = pref.Channel;
                        existing.SuperChannel = pref.SuperChannel;
                        cntx.SaveChanges();
                    }
                    AddUserLocations(pref, cntx);
                }

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return status;
        }
        public bool AddUserLocations(PromotionPreferences pref, PlaybookEntities objPlaybookEntities)
        {
            try
            {
                try
                {
                    var itemsToDelete = objPlaybookEntities.PBUserGeographics.Where(i => i.GSN.ToUpper() == pref.GSN.ToUpper()).ToList();
                    objPlaybookEntities.Delete(itemsToDelete);
                    objPlaybookEntities.SaveChanges();
                }
                catch (Exception ex)
                { }

                List<PBUserGeographic> lstUserGeographic = new List<PBUserGeographic>();
                // ClearUserLocation(GSN);
                if (pref.BusinessUnit != null)
                    lstUserGeographic.AddRange(JSONSerelization.Deserialize<List<DPSG.Portal.Framework.Types.BusinessUnit>>(pref.BusinessUnit).Select(i => new PBUserGeographic() { BUID = i.buId, GSN = pref.GSN }).ToList());

                if (pref.Region != null)
                    lstUserGeographic.AddRange(JSONSerelization.Deserialize<List<DPSG.Portal.Framework.Types.Region>>(pref.Region).Select(i => new PBUserGeographic() { RegionID = i.regionId, GSN = pref.GSN }).ToList());

                if (pref.Area != null)
                    lstUserGeographic.AddRange(JSONSerelization.Deserialize<List<DPSG.Portal.Framework.Types.Area>>(pref.Area).Select(i => new PBUserGeographic() { AreaID = i.AreaId, GSN = pref.GSN }).ToList());

                if (pref.Branch != null)
                    lstUserGeographic.AddRange(JSONSerelization.Deserialize<List<DPSG.Portal.Framework.Types.Branch>>(pref.Branch).Select(i => new PBUserGeographic() { BranchID = i.branchId, GSN = pref.GSN }).ToList());

                objPlaybookEntities.Add(lstUserGeographic);
                objPlaybookEntities.SaveChanges();

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException("ERROR: ADDING USER Locations IN SDM IN USERPROFILEREPOSITORY CLASS FOR USER:", ex);
            }
            return true;
        }
        public List<TreeViewItem> GetChannelTreeView()
        {
            try
            {
                List<TreeViewItem> lstAccountsTreeView = new List<TreeViewItem>();

                if (CacheHelper.GetCacheValue(CacheKeys.AllChannelsCacheKey) != null)
                {
                    lstAccountsTreeView = (List<TreeViewItem>)CacheHelper.GetCacheValue(CacheKeys.AllChannelsCacheKey);
                }
                else
                {
                    using (PlaybookEntities cntx = new PlaybookEntities())
                    {
                        var allChannels = cntx.PBLocationChannels.Select(i => new { i.SuperChannelID, i.SAPSuperChannelID, i.SuperChannelName, i.ChannelID, i.ChannelName, i.SAPChannelID }).ToList();

                        var allSuperChannels = allChannels.Select(i => new { i.SuperChannelID, i.SAPSuperChannelID, i.SuperChannelName }).Distinct();

                        lstAccountsTreeView.AddRange(allSuperChannels.Select(i => new TreeViewItem() { Id = Convert.ToInt32(i.SuperChannelID), ParentId = 0, Text = Convert.ToString(i.SuperChannelName), Value = i.SuperChannelID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + ChannelType.SuperChannel.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPSuperChannelID }));


                        var channels = (from allChannel in allChannels
                                        join superChannel in allSuperChannels
                                        on allChannel.SuperChannelID equals superChannel.SuperChannelID
                                        select new { allChannel.ChannelID, allChannel.ChannelName, allChannel.SAPChannelID, allChannel.SuperChannelID }).Distinct();
                        lstAccountsTreeView.AddRange(channels.Select(i => new TreeViewItem() { Id = GetID(Convert.ToInt32(i.SuperChannelID), i.ChannelID), ParentId = Convert.ToInt32(i.SuperChannelID), Text = Convert.ToString(i.ChannelName), Value = i.ChannelID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + ChannelType.Channel.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPChannelID }));

                        lstAccountsTreeView.Sort((x, y) => string.Compare(x.Text, y.Text));
                        CacheHelper.SetCacheValue(CacheKeys.AllChannelsCacheKey, lstAccountsTreeView, 43200); //caching for 1 month
                    }
                }
                return lstAccountsTreeView;
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return null;
        }

        public List<TreeViewItem> GetUserPrefChannelTreeView(UserChannels usrChannels)
        {
            try
            {
                List<TreeViewItem> lstUsrPrefChannels = new List<TreeViewItem>();

                using (PlaybookEntities cntx = new PlaybookEntities())
                {
                    List<int> sprIds = usrChannels.SuperChannel.Select(i => Convert.ToInt32(i.ChannelId)).ToList();
                    List<int> locIds = usrChannels.Channel.Select(i => Convert.ToInt32(i.ChannelId)).ToList();

                    var allChannels = cntx.PBLocationChannels.Select(i => new { i.SuperChannelID, i.SAPSuperChannelID, i.SuperChannelName, i.ChannelID, i.ChannelName, i.SAPChannelID }).ToList();

                    var allSuperChannels = (from allChannel in allChannels
                                            where sprIds.Contains(Convert.ToInt32(allChannel.SuperChannelID))
                                            || locIds.Contains(Convert.ToInt32(allChannel.ChannelID))
                                            select new { allChannel.SuperChannelID, allChannel.SAPSuperChannelID, allChannel.SuperChannelName }).Distinct();

                    lstUsrPrefChannels.AddRange(allSuperChannels.Select(i => new TreeViewItem() { Id = Convert.ToInt32(i.SuperChannelID), ParentId = 0, Text = Convert.ToString(i.SuperChannelName), Value = i.SuperChannelID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + ChannelType.SuperChannel.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPSuperChannelID }));


                    var channels = (from allChannel in allChannels
                                    join superChannel in allSuperChannels
                                    on allChannel.SuperChannelID equals superChannel.SuperChannelID
                                    select new { allChannel.ChannelID, allChannel.ChannelName, allChannel.SAPChannelID, allChannel.SuperChannelID }).Distinct();
                    lstUsrPrefChannels.AddRange(channels.Select(i => new TreeViewItem() { Id = GetID(Convert.ToInt32(i.SuperChannelID), i.ChannelID), ParentId = Convert.ToInt32(i.SuperChannelID), Text = Convert.ToString(i.ChannelName), Value = i.ChannelID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + ChannelType.Channel.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SAPChannelID }));

                    lstUsrPrefChannels.Sort((x, y) => string.Compare(x.Text, y.Text));
                }

                return lstUsrPrefChannels;
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return null;
        }

        /// <summary>
        /// get particular promotion by id 
        /// </summary>
        /// <param name="promotionId"></param>
        /// <returns></returns>
        public ArrayList GetCalendarPromotionById(int promotionId)
        {

            Promotion objPromotion = null;
            ArrayList lstsPromoData = new ArrayList();
            try
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    if (promotionId != 0)
                    {
                        objPromotion = (from promotion in objPlaybookEntities.PBRetailPromotions
                                        join location in objPlaybookEntities.PBPromotionDisplayLocations
                                        on promotion.PromotionID equals location.PromotionID
                                        join status in objPlaybookEntities.PBStatus
                                        on promotion.PromotionStatusID equals status.StatusID
                                        join displayloaction in objPlaybookEntities.PBDisplayLocations
                                        on location.DisplayLocationID equals displayloaction.DisplayLocationID
                                        where promotion.PromotionID == promotionId
                                        select new Promotion()
                                        {
                                            //AccountId = GetRootAccountIDByPromotion(objPlaybookEntities, promotionId),
                                            //AccountInfo = GetAccountInfoByPromotionID(objPlaybookEntities, promotionId), //(account.LocalChainID != null) ? account.LocalChainID : (account.RegionalChainID != null) ? account.RegionalChainID : (account.NationalChainID != null) ? account.NationalChainID : (int?)null,
                                            AccountImageName = promotion.AccountImageName,
                                            PromotionId = promotion.PromotionID,
                                            PromotionName = promotion.PromotionName,
                                            PromotionDescription = promotion.PromotionDescription,
                                            PromotionCategoryId = promotion.PromotionCategoryID,
                                            PromotionDisplayLocationId = location.DisplayLocationID,
                                            DisplaylocationName = displayloaction.DisplayLocationName,
                                            PromotionPrice = promotion.PromotionPrice,
                                            PromotionPackages = promotion.PromotionPackages,
                                            PromotionRank = promotion.CreatedPromotionRank,
                                            ParentPromotionId = promotion.ParentPromotionID,
                                            PromotionTypeID = promotion.PromotionTypeID,
                                            PromotionGroupID = promotion.PromotionGroupID,
                                            PromotionEndDate = promotion.PromotionEndDate,
                                            EDGEItemID = promotion.EDGEItemID,
                                            IsLocalized = promotion.IsLocalized,
                                            PromotionStatus = status.StatusName,
                                            PromotionStartDate = promotion.PromotionStartDate,
                                            ForecastVolume = promotion.ForecastVolume,
                                            PromotionDisplayLocationOther = location.PromotionDisplayLocationOther,
                                            BUID = promotion.PromotionBUID,
                                            ModifiedBy = promotion.ModifiedBy,
                                            PromotionModifiedDate = promotion.ModifiedDate.Value,
                                            GEORelavency = promotion.GEOInfo,
                                        }).FirstOrDefault();

                        /*  if (objPromotion.PromotionGroupID == Convert.ToInt32(PromotionGroup.Account))
                            GetAccountInfoByPromotion(objPlaybookEntities, objPromotion);
                        else if (objPromotion.PromotionGroupID == Convert.ToInt32(PromotionGroup.Channel))
                            GetChannelInfoByPromotion(objPlaybookEntities, objPromotion);*/

                        lstsPromoData.Add(objPromotion);

                        Promotion objPromo = new Promotion();
                        objPromo.PromotionId = promotionId;

                        /* if (objPromotion.PromotionGroupID == Convert.ToInt32(PromotionGroup.Account))
                             GetAccountInfoByPromotion(objPlaybookEntities, objPromotion);
                         else if (objPromotion.PromotionGroupID == Convert.ToInt32(PromotionGroup.Channel))
                             GetChannelInfoByPromotion(objPlaybookEntities, objPromotion);*/

                        GetGeoRelevancyByPromotionId(objPlaybookEntities, objPromo);

                        lstsPromoData.Add(objPromo);


                        List<PromoAttachment> listAttachment = GetAttachmentByPromotionId(promotionId, string.Empty, null);
                        lstsPromoData.Add(listAttachment);

                        ArrayList lstBrandCategory = GetCategoryByPromotionId(promotionId);
                        lstsPromoData.AddRange(lstBrandCategory);
                    }


                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return lstsPromoData;
        }



        /// <summary>
        /// 
        /// </summary>
        /// <param name="promotionId"></param>
        /// <returns></returns>
        public ArrayList GetCategoryByPromotionId(int promotionId)
        {
            ArrayList lstBrandCategory = new ArrayList();

            try
            {
                using (PlaybookEntities dbContext = new PlaybookEntities())
                {
                    using (IDbConnection oaConnection = dbContext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[PlayBook].[pGetBrandCategoryByPromotionId]";

                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@PromotionId", Value = promotionId });


                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                List<string> lstCategory = dbContext.Translate<string>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                lstBrandCategory.Add(lstCategory);

                                List<string> lstChannelName = dbContext.Translate<string>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                lstBrandCategory.Add(lstChannelName);

                                List<string> lstAccountName = dbContext.Translate<string>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                lstBrandCategory.Add(lstAccountName);
                            }

                        }

                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return lstBrandCategory;
        }

        /// <summary>
        /// Get Results from DB
        /// </summary>
        /// <returns></returns>
        public ArrayList GetPromotionDetailsByID(int promotionId)
        {
            ArrayList objArrayList = new ArrayList();
            try
            {
                using (PlaybookEntities dbContext = new PlaybookEntities())
                {

                    using (IDbConnection oaConnection = dbContext.Connection)
                    {
                        using (IDbCommand oaCommand = oaConnection.CreateCommand())
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = "[PlayBook].[pGetPromotionDetailsByID]";

                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@PromotionID", Value = promotionId });


                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                List<Promotion> objPromotion = dbContext.Translate<Promotion>(dataReader as DbDataReader).ToList();
                                dataReader.NextResult();
                                objArrayList.AddRange(objPromotion);
                            }

                        }

                    }
                }

                /*  objPromoList = objPromoList.Select(i =>
                       {
                           i.AccountInfo = string.IsNullOrEmpty(i.AccountInfo) ? i.AccountInfo : "| " + i.AccountInfo.Trim() + " |";
                           i.PromotionChannel = string.IsNullOrEmpty(i.PromotionChannel) ? i.PromotionChannel : "| " + i.PromotionChannel.Trim() + " |";
                           i.GEORelavency = string.IsNullOrEmpty(i.GEORelavency) ? i.GEORelavency : "| " + i.GEORelavency.Trim() + " |";
                           return i;
                       }) .ToList();*/

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                objArrayList = new ArrayList();
            }

            return objArrayList;
        }

        ///<summary>
        ///Get Promotion By Filtered Values
        /// </summary>
        public string GetPromotionByFilteredValues_ORG(string _account, string _channel, string _brandName, string _packageNAme, string _bottler)
        {
            string PIds = "";
            try
            {
                using (PlaybookEntities pb = new PlaybookEntities())
                {

                    string paramAccount = "", paramChannel = "", parambrand = "", parampackage = "", parambottler = "";

                    if (_account.Trim() != "My Account" && _account != "All Account")
                        paramAccount = _account;

                    if (_channel.Trim() != "My Channel" && _channel != "All Channel")
                        paramChannel = _channel;

                    if (_brandName.Trim() != "All Brands" && !string.IsNullOrEmpty(_brandName))
                        parambrand = _brandName;

                    if (_packageNAme.Trim() != "All Packages" && !string.IsNullOrEmpty(_packageNAme))
                        parampackage = _packageNAme;

                    if (_bottler.Trim() != "All Bottlers" && !string.IsNullOrEmpty(_bottler))
                        parambottler = _bottler;


                    if (parambrand + parampackage + parambottler + paramAccount + paramChannel != ""
                        )
                    {
                        System.Data.Common.DbParameter[] parm = { (new Telerik.OpenAccess.Data.Common.OAParameter{ ParameterName = "@Brand", Value = parambrand }),
                                            (new Telerik.OpenAccess.Data.Common.OAParameter { ParameterName = "@Package", Value = parampackage }),
                                            (new Telerik.OpenAccess.Data.Common.OAParameter { ParameterName = "@Channel", Value = paramChannel }),
                                            (new Telerik.OpenAccess.Data.Common.OAParameter { ParameterName = "@Bottler", Value = parambottler }),
                                            (new Telerik.OpenAccess.Data.Common.OAParameter { ParameterName = "@Account", Value = paramAccount })};

                        PIds = pb.ExecuteScalar<string>("[PlayBook].[pGetFilteredPromotionId]", System.Data.CommandType.StoredProcedure, parm);
                    }
                }
                return PIds;
            }
            catch (Exception ex)
            {
            }
            return PIds;
        }
        public string GetPromotionIDsByFilteredValues(PromotionViewFilter objPromotioFilterValues)
        {
            string _pIds = string.Empty;
            try
            {
                using (PlaybookEntities pb = new PlaybookEntities())
                {

                    System.Data.Common.DbParameter[] parm = { (new Telerik.OpenAccess.Data.Common.OAParameter{ ParameterName = "@Brand", Value = objPromotioFilterValues.SelectedBrand.Trim() }),
                                            (new Telerik.OpenAccess.Data.Common.OAParameter { ParameterName = "@Package", Value = objPromotioFilterValues.SelectedPackage.Trim() }),
                                            (new Telerik.OpenAccess.Data.Common.OAParameter { ParameterName = "@Channel", Value = objPromotioFilterValues.SelectedChannel.Trim() }),
                                            (new Telerik.OpenAccess.Data.Common.OAParameter { ParameterName = "@Bottler", Value = objPromotioFilterValues.SelectedBottler.Trim() }),
                                            //(new Telerik.OpenAccess.Data.Common.OAParameter { ParameterName = "@SearchText", Value = objPromotioFilterValues.SearchText.Trim() }),//This param is removed for Supply Chain Prod Move
                                            (new Telerik.OpenAccess.Data.Common.OAParameter { ParameterName = "@Account", Value = objPromotioFilterValues.SelectedAccount.Trim() })};

                    _pIds = pb.ExecuteScalar<string>("[PlayBook].[pGetFilteredPromotionId]", System.Data.CommandType.StoredProcedure, parm);

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return string.IsNullOrEmpty(_pIds) ? _pIds : _pIds.Trim(',');
        }

        ///<summary>
        ///Get Promotion By Filtered Values for SC
        /// </summary>

        public string GetSCPromotionByFilteredValues(string _account, string _channel, string _brandName, string _packageNAme, string _bottler)
        {
            string PIds = "";
            try
            {
                using (PlaybookEntities pb = new PlaybookEntities())
                {

                    string paramAccount = "", paramChannel = "", parambrand = "", parampackage = "", parambottler = "";

                    if (_account.Trim() != "My Accounts" && _account != "All Accounts")
                        paramAccount = _account;

                    if (_channel.Trim() != "My Channels" && _channel != "All Channels")
                        paramChannel = _channel;

                    if (_brandName.Trim() != "All Brands" && !string.IsNullOrEmpty(_brandName))
                        parambrand = _brandName;

                    if (_packageNAme.Trim() != "All Packages" && !string.IsNullOrEmpty(_packageNAme))
                        parampackage = _packageNAme;

                    if (_bottler.Trim() != "All Bottlers" && !string.IsNullOrEmpty(_bottler))
                        parambottler = _bottler;


                    if (parambrand + parampackage + parambottler + paramAccount + paramChannel != ""
                        )
                    {
                        System.Data.Common.DbParameter[] parm = { (new Telerik.OpenAccess.Data.Common.OAParameter{ ParameterName = "@Brand", Value = parambrand }),
                                            (new Telerik.OpenAccess.Data.Common.OAParameter { ParameterName = "@Package", Value = parampackage }),
                                            (new Telerik.OpenAccess.Data.Common.OAParameter { ParameterName = "@Channel", Value = paramChannel }),
                                            (new Telerik.OpenAccess.Data.Common.OAParameter { ParameterName = "@Bottler", Value = parambottler }),
                                            (new Telerik.OpenAccess.Data.Common.OAParameter { ParameterName = "@Account", Value = paramAccount })};

                        PIds = pb.ExecuteScalar<string>("[SupplyChain].[pGetCalFilteredPromotionId]", System.Data.CommandType.StoredProcedure, parm);
                    }
                }
                return PIds;
            }
            catch (Exception ex)
            {
            }
            return PIds;
        }

        // Get Package Name based on Package Ids
        public string GetSCPackageNamebyIds(string PackageIds)
        {
            string PackageName = "";
            try
            {
                using (PlaybookEntities pb = new PlaybookEntities())
                {
                    System.Data.Common.DbParameter[] parm = { (new Telerik.OpenAccess.Data.Common.OAParameter { ParameterName = "@PackageIds", Value = PackageIds }) };

                    PackageName = pb.ExecuteScalar<string>("[SupplyChain].[pGetPackageName]", System.Data.CommandType.StoredProcedure, parm);
                }
                return PackageName;
            }
            catch (Exception ex)
            {
            }
            return PackageName;
        }

        // Get TradeMarks Name based on TradeMarks Ids
        public string GetSCTradeMarkNamebyIds(string TradeMarksId)
        {
            string TradeMarksName = "";
            try
            {
                using (PlaybookEntities pb = new PlaybookEntities())
                {
                    System.Data.Common.DbParameter[] parm = { (new Telerik.OpenAccess.Data.Common.OAParameter { ParameterName = "@TradeMarksId", Value = TradeMarksId }) };

                    TradeMarksName = pb.ExecuteScalar<string>("[SupplyChain].[pGetTradeMarkName]", System.Data.CommandType.StoredProcedure, parm);
                }
                return TradeMarksName;
            }
            catch (Exception ex)
            {
            }
            return TradeMarksName;
        }

        public string GetBranchNamebyIds(int ID)
        {
            string _branchName = string.Empty;
            try
            {
                using (PlaybookEntities pb = new PlaybookEntities())
                {
                    System.Data.Common.DbParameter[] parm = { (new Telerik.OpenAccess.Data.Common.OAParameter { ParameterName = "@branchId", Value = ID }) };

                    _branchName = pb.ExecuteScalar<string>("[SupplyChain].[pGetBranchNamebyId]", System.Data.CommandType.StoredProcedure, parm);
                }
                return _branchName;
            }
            catch (Exception ex)
            {
            }
            return _branchName;
        }

        #region Program related methods for promotion

        /// <summary>
        /// Get program list for selected account
        /// </summary>
        /// <param name="accountId"></param>
        /// <returns></returns>
        public List<Program> GetProgramsByAccount(int accountId, AccountType _accountType)
        {
            List<Program> lstProgram = new List<Program>();

            try
            {
                using (PlaybookEntities dbContext = new PlaybookEntities())
                {
                    switch (_accountType)
                    {
                        case AccountType.Local:
                            {
                                lstProgram = (from program in dbContext.PBPrograms
                                              join programAcc in dbContext.PBProgramAccounts
                                              on program.ProgramID equals programAcc.ProgramID
                                              where programAcc.LocalAccountID == accountId
                                              select new Program
                                              {
                                                  ProgramID = program.ProgramID,
                                                  ProgramName = program.ProgramName,
                                                  StartDate = program.StartDate,
                                                  EndDate = program.EndDate
                                              }).ToList<Program>();
                                break;
                            }

                        case AccountType.Regional:
                            {
                                lstProgram = (from program in dbContext.PBPrograms
                                              join programAcc in dbContext.PBProgramAccounts
                                              on program.ProgramID equals programAcc.ProgramID
                                              where programAcc.RegionalAccountID == accountId
                                              select new Program
                                              {
                                                  ProgramID = program.ProgramID,
                                                  ProgramName = program.ProgramName,
                                                  StartDate = program.StartDate,
                                                  EndDate = program.EndDate
                                              }).ToList<Program>();
                                break;
                            }
                        case AccountType.National:
                            {
                                lstProgram = (from program in dbContext.PBPrograms
                                              join programAcc in dbContext.PBProgramAccounts
                                              on program.ProgramID equals programAcc.ProgramID
                                              where programAcc.NationalAccountID == accountId
                                              select new Program
                                              {
                                                  ProgramID = program.ProgramID,
                                                  ProgramName = program.ProgramName,
                                                  StartDate = program.StartDate,
                                                  EndDate = program.EndDate
                                              }).ToList<Program>();
                                break;
                            }
                    }
                }
            }
            catch (Exception ex)
            {

                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return lstProgram;
        }

        //public List<Program> GetProgramsByAccount(List<string> Accounts, List<int> Systems, bool ViewDraftProgram = false)
        public List<Program> GetProgramsByAccount(List<string> Accounts, bool ViewDraftProgram = false)
        {
            List<Program> lstProgram = new List<Program>();
            //if (Systems.Count > 0 && Accounts.Count > 0)
            if (Accounts.Count > 0)
            {
                List<AccountInfo> accounts = new List<AccountInfo>();

                //Get all the child accounts of the selected account
                Accounts.ForEach(i => accounts.Add(GetAccountInfoById(Convert.ToInt32(i.Split("^".ToCharArray(), StringSplitOptions.RemoveEmptyEntries)[0]),
                    (AccountType)Enum.Parse(typeof(AccountType), i.Split("^".ToCharArray(), StringSplitOptions.RemoveEmptyEntries)[1]))));

                accounts = GetAccountsWithOnlyParent(accounts);

                accounts = accounts.DistinctBy(i => i.TreeValue).ToList();

                List<int> nationalAccount = accounts.Where(i => i.AccountType == AccountType.National).Select(i => i.NationalChainID).ToList();
                List<int> regionalAccount = accounts.Where(i => i.AccountType == AccountType.Regional).Select(i => i.RegionalChainID).ToList();
                List<int> localAccount = accounts.Where(i => i.AccountType == AccountType.Local).Select(i => i.LocalChainID).ToList();

                try
                {
                    using (PlaybookEntities dbContext = new PlaybookEntities())
                    {
                        List<int> programIdWithoutSystem = (from pa in dbContext.PBProgramAccounts
                                                            // join progSystem in dbContext.PBProgramSystems on pa.ProgramID equals progSystem.ProgramID
                                                            where ((nationalAccount.Contains(pa.NationalAccountID.Value)
                                                            || regionalAccount.Contains(pa.RegionalAccountID.Value)
                                                            || localAccount.Contains(pa.LocalAccountID.Value)))
                                                            select pa.ProgramID).ToList();
                        /* Remove System/RTM */
                        //List<int> programIds = CheckProgramSystem(dbContext, programIdWithoutSystem, Systems);
                        if (ViewDraftProgram)
                        {
                            lstProgram = (from program in dbContext.PBPrograms
                                          join programId in programIdWithoutSystem on program.ProgramID equals programId
                                          where (program.StatusID == 4 || program.StatusID == 3 || program.StatusID == 12)
                                          select new Program
                                          {
                                              ProgramID = program.ProgramID,
                                              ProgramName = program.ProgramName,
                                              StartDate = program.StartDate,
                                              EndDate = program.EndDate
                                          }).DistinctBy(i => i.ProgramID).ToList<Program>();
                        }
                        else
                        {
                            lstProgram = (from program in dbContext.PBPrograms
                                          join programId in programIdWithoutSystem on program.ProgramID equals programId
                                          where program.StatusID == 4
                                          select new Program
                                          {
                                              ProgramID = program.ProgramID,
                                              ProgramName = program.ProgramName,
                                              StartDate = program.StartDate,
                                              EndDate = program.EndDate
                                          }).DistinctBy(i => i.ProgramID).ToList<Program>();
                        }

                    }

                }
                catch (Exception ex)
                {

                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
            }
            return lstProgram.OrderBy(i => i.ProgramName).ToList();
        }

        private List<int> CheckProgramSystem(PlaybookEntities dbContext, List<int> programIds, List<int> systems)
        {
            List<int> lstValidProgramIds = new List<int>();
            try
            {
                var programSystems = (from system in dbContext.PBProgramSystems where programIds.Contains(system.ProgramID) select new ProgramSystem() { ProgramId = system.ProgramID, ID = system.SystemID }).ToList();
                foreach (int programId in programIds)
                {
                    var SystemProgramId = programSystems.Where(i => i.ProgramId == programId).Select(i => i.ID).ToArray<int>();
                    if (systems.All(i => SystemProgramId.Contains(i)))
                        lstValidProgramIds.Add(programId);

                }

            }
            catch (Exception ex)
            {

                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);

            }
            return lstValidProgramIds;
        }

        /// <summary>
        /// Recursive method to add only the parent of the accounts in the account list
        /// </summary>
        /// <param name="accounts"></param>
        /// <returns></returns>
        public List<AccountInfo> GetAccountsWithOnlyParent(List<AccountInfo> accounts)
        {
            int count = accounts.Count;

            //Get "only the parent" account for the selected accounts 
            List<string> treevalues = accounts.Where(i => i.AccountType != AccountType.National)
                                    .Where(i => !accounts.Any(k => i.ParentTreeValue == k.TreeValue))
                                    .Select(i => i.ParentTreeValue)
                                    .ToList();

            treevalues.ForEach(i => accounts.Add(GetAccountInfoById(Convert.ToInt32(i.Split('^')[0]),
                (AccountType)Enum.Parse(typeof(AccountType), i.Split('^')[1]))));

            if (count != accounts.Count)
            {
                GetAccountsWithOnlyParent(accounts);
            }

            return accounts;
        }

        /// <summary>
        /// Get program brands based on programid.
        /// </summary>
        /// <param name="programId"></param>
        /// <returns></returns>
        public List<PromoBrand> GetBrandsByProgramId(int programId)
        {
            List<PromoBrand> lstBrandsTrademarks = new List<PromoBrand>();

            try
            {
                using (PlaybookEntities dbContext = new PlaybookEntities())
                {
                    var lstProgramTrademarks = (from tradmarks in dbContext.PBProgramTrademarks
                                                join tradmakrMaster in dbContext.PBTradeMarks
                                                on tradmarks.TrademarkID equals tradmakrMaster.TradeMarkID
                                                where tradmarks.ProgramID == programId && tradmarks.TrademarkID != (int?)null
                                                select new PromoBrand
                                                {
                                                    IsTradeMark = true,
                                                    BrandName = tradmakrMaster.TradeMarkName,
                                                    TradeMarkID = tradmarks.TrademarkID,
                                                    SAPBrandId = tradmakrMaster.SAPTradeMarkID + ',' + tradmarks.TrademarkID

                                                }).ToList<PromoBrand>();

                    var lstProgramBrands = (from ProgBrand in dbContext.PBProgramTrademarks
                                            join brandMaster in dbContext.PBBrands
                                            on ProgBrand.BrandId equals brandMaster.BrandID
                                            where ProgBrand.ProgramID == programId && ProgBrand.BrandId != (int?)null
                                            select new PromoBrand
                                            {
                                                IsTradeMark = false,
                                                BrandName = brandMaster.BrandName,
                                                BrandId = ProgBrand.BrandId,
                                                SAPBrandId = brandMaster.SAPBrandID + ',' + ProgBrand.BrandId
                                            }).ToList<PromoBrand>();

                    lstBrandsTrademarks.AddRange(lstProgramTrademarks);
                    lstBrandsTrademarks.AddRange(lstProgramBrands);
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return lstBrandsTrademarks;
        }

        public List<PromoPackage> GetPkgByProgramId(int porgramId)
        {
            List<PromoPackage> promoPkg = new List<PromoPackage>();

            try
            {
                using (PlaybookEntities dbContext = new PlaybookEntities())
                {
                    promoPkg = (from pkgs in dbContext.PBProgramPackages
                                join program in dbContext.PBPrograms on pkgs.ProgramID equals program.ProgramID
                                join pkgMaster in dbContext.PBPackages on pkgs.PackageID equals pkgMaster.PackageID
                                where program.ProgramID == porgramId
                                select new PromoPackage
                                {
                                    Checked = true,
                                    PackageId = pkgs.PackageID.ToString(),
                                    PackageName = pkgMaster.PackageName
                                }).DistinctBy(i => i.PackageId).ToList<PromoPackage>();

                }

            }
            catch (Exception ex)
            {

                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return promoPkg;
        }

        public string GetBUForNAPromotion()
        {
            using (PlaybookEntities dbContext = new PlaybookEntities())
            {
                return String.Join(",", (from bu in dbContext.PBBusinessUnits select bu.BUID + CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR + "BU").ToArray<String>());
            }
        }

        public List<AccountInfo> GetAllAccountByProgramID(int ProgramId)
        {
            List<AccountInfo> _lst = new List<AccountInfo>();
            List<AccountInfo> _temp = new List<AccountInfo>();

            try
            {
                using (PlaybookEntities dbContext = new PlaybookEntities())
                {
                    List<PBProgramAccount> _account = dbContext.PBProgramAccounts.Where(i => i.ProgramID == ProgramId).ToList();

                    _account.ForEach(i => _lst.AddRange(GetAccountsInfoById((i.LocalAccountID != null ? i.LocalAccountID.Value : i.RegionalAccountID != null ? i.RegionalAccountID.Value : i.NationalAccountID.Value), (i.LocalAccountID != null ? AccountType.Local : i.RegionalAccountID != null ? AccountType.Regional : AccountType.National))));
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return _lst;
        }

        public List<AccountInfo> GetAccountByProgramID(int ProgramId)
        {
            List<AccountInfo> _lst = new List<AccountInfo>();
            List<AccountInfo> _temp = new List<AccountInfo>();

            try
            {
                using (PlaybookEntities dbContext = new PlaybookEntities())
                {
                    List<PBProgramAccount> _account = dbContext.PBProgramAccounts.Where(i => i.ProgramID == ProgramId).ToList();

                    _account.ForEach(i => _lst.Add(GetAccountInfoById((i.LocalAccountID != null ? i.LocalAccountID.Value : i.RegionalAccountID != null ? i.RegionalAccountID.Value : i.NationalAccountID.Value), (i.LocalAccountID != null ? AccountType.Local : i.RegionalAccountID != null ? AccountType.Regional : AccountType.National))));
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return _lst;
        }

        public Program GetProgramById(int ProgramID)
        {
            Program _prog = new Program();
            try
            {
                using (PlaybookEntities dbContext = new PlaybookEntities())
                {
                    _prog = dbContext.PBPrograms.Where(i => i.ProgramID == ProgramID)
                                            .Select(i => new Program()
                                            {
                                                ProgramName = i.ProgramName,
                                                ProgramID = i.ProgramID,
                                                StartDate = i.StartDate,
                                                EndDate = i.EndDate,
                                                ProgramStatus = ((ProgramStatus)i.StatusID).ToString()
                                            }).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return _prog;
        }

        public List<ProgramSystem> GetSystemsIDByProgramId(int ProgramId)
        {
            List<ProgramSystem> _progSys = new List<ProgramSystem>();
            try
            {
                using (PlaybookEntities dbContext = new PlaybookEntities())
                {
                    _progSys = dbContext.PBProgramSystems.Where(i => i.ProgramID == ProgramId).Select(i => new ProgramSystem() { ID = i.SystemID }).ToList();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return _progSys;
        }

        public DateTime GetProgramLastLoggedInTime(string GSN)
        {
            DateTime _loggedInTime = DateTime.Now;
            try
            {
                using (PlaybookEntities dbContext = new PlaybookEntities())
                {
                    PBUserInformation _userInfo = dbContext.PBUserInformations.Where(i => i.GSN == GSN).FirstOrDefault();

                    _loggedInTime = (_userInfo != null && _userInfo.LastLoginTime.HasValue) ? _userInfo.ProgramLastLoginTime.Value : DateTime.Now;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return _loggedInTime;
        }

        #endregion

        /// <summary>
        /// get tree view for BU restructure utility
        /// </summary>
        /// <returns></returns>
        public List<TreeViewItem> GetGeoTreeViewForWinForms()
        {
            List<TreeViewItem> objGEOTreeViewlst = null;
            try
            {

                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    List<PBLocationHier> objlstLocationHier = objPlaybookEntities.PBLocationHiers.ToList();
                    if (objlstLocationHier != null)
                    {

                        objGEOTreeViewlst = new List<TreeViewItem>();
                        var nationLocations = objlstLocationHier.DistinctBy(i => i.BUID).ToList();
                        objGEOTreeViewlst.AddRange(nationLocations.Select(i => new TreeViewItem() { Id = i.BUID, Text = i.BUName, Value = string.Concat(i.BUID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BU), SAPValue = string.Concat(i.BUID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BU, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPBUID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.BUName), ParentId = 0 }));
                        var regionalLocations = (from item in objlstLocationHier
                                                 join nationlocation in nationLocations
                                                 on item.BUID equals nationlocation.BUID
                                                 select new { item.RegionID, item.SAPRegionID, item.RegionName, item.BUID }).Distinct().ToList();
                        objGEOTreeViewlst.AddRange(regionalLocations.Select(i => new TreeViewItem() { Id = (i.RegionID + 10000), Value = string.Concat(i.RegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_REGIONAL), SAPValue = string.Concat(i.RegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_REGIONAL, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPRegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.RegionName), Text = i.RegionName, ParentId = i.BUID }));

                        var areaLocation = (from item in objlstLocationHier
                                            join regionalLocation in regionalLocations
                                             on item.RegionID equals regionalLocation.RegionID
                                            select new { item.AreaID, item.AreaName, item.RegionID, item.BUID, item.SAPAreaID }).Distinct().ToList();

                        objGEOTreeViewlst.AddRange(areaLocation.Select(i => new TreeViewItem() { Id = (i.AreaID + 20000), Value = string.Concat(i.AreaID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_AREA), SAPValue = string.Concat(i.AreaID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_AREA, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPAreaID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.AreaName), Text = i.AreaName, ParentId = (i.RegionID + 10000) }));

                        var localLocations = (from item in objlstLocationHier
                                              join regionalLocation in areaLocation
                                               on item.AreaID equals regionalLocation.AreaID
                                              select new { item.BranchID, item.BranchName, item.AreaID, item.BUID, item.SAPBranchID }).Distinct().ToList();

                        objGEOTreeViewlst.AddRange(localLocations.Select(i => new TreeViewItem() { Id = i.BranchID + 30000, Value = string.Concat(i.BranchID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BRANCH), SAPValue = string.Concat(i.BranchID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BRANCH, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPBranchID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.BranchName), Text = i.BranchName, ParentId = (i.AreaID + 20000) }));

                    }

                }

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }


            return objGEOTreeViewlst.OrderBy(i => i.Text).ToList();
        }

        /// <summary>
        /// Gets the Edge Extract
        /// </summary>       
        public List<Types.Playbook.EdgeExtract> GetEdgeExtract()
        {
            using (PlaybookEntities entity = new PlaybookEntities())
            {
                List<Types.Playbook.EdgeExtract> _edgedata = null;
                try
                {
                    //    DbParameter[] parm = { (new OAParameter { ParameterName = "@NationalChainID", Value = _nationalChainID }) };
                    _edgedata = entity.ExecuteQuery<Types.Playbook.EdgeExtract>("[PlayBook].[pGetPromotionsForEdgeExtract]", System.Data.CommandType.StoredProcedure).ToList<Types.Playbook.EdgeExtract>();
                }
                catch { }
                return _edgedata;
            }
        }

        /// <summary>
        /// Gets the Edge Extract
        /// </summary>       
        public DataTable GetEdgeExtractDT()
        {
            DataTable dt = new DataTable();
            using (PlaybookEntities entity = new PlaybookEntities())
            {
                using (OAConnection connection = entity.Connection)
                {
                    using (OACommand command = connection.CreateCommand())
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.CommandText = "[PlayBook].[pGetPromotionsForEdgeExtract]";
                        using (OADataReader dataReader = command.ExecuteReader())
                        {
                            if (dataReader.HasRows)
                            {
                                dt.Load(dataReader);
                            }
                        }
                    }
                }
                entity.SaveChanges();
            }
            return dt;
        }

        //public string DefaultRoleSystem(int roleid)
        //{
        //    using (PlaybookEntities db = new PlaybookEntities())
        //    {
        //        return (from rs in db.PBRoleSystems
        //                join sys in db.PBSystems on rs.SystemID equals sys.SystemID
        //                where rs.RoleID == roleid && rs.DefaultValue == true
        //                select (sys.SystemName)).FirstOrDefault();
        //    }
        //}
        #region Export Promotion



        public Dictionary<string, object> GetAccountsAndChannelByFilter_ORG(DateTime startDate, DateTime endDate, string branchId, string systemId, bool ViewDraftNAPromotion, bool ViewNAPromotion, string gsn, string RolledOutAccounts, int CurrentPersonaID)
        {
            Dictionary<string, object> lstAccountChannel = new Dictionary<string, object>();
            using (PlaybookEntities dbContext = new PlaybookEntities())
            {
                using (IDbConnection oaConnection = dbContext.Connection)
                {
                    using (IDbCommand oaCommand = oaConnection.CreateCommand())
                    {
                        try
                        {
                            oaCommand.CommandType = CommandType.StoredProcedure;
                            oaCommand.CommandText = DBConstants.DB_PROC_TO_EXPORT_PROMOTION_FILTER;
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@StartDate", Value = startDate.Date });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@EndDate", Value = endDate.Date });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@SystemIds", Value = systemId });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@BranchId", Value = branchId });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@CurrentUser", Value = gsn });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@VIEW_DRAFT_NA", Value = ViewDraftNAPromotion });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@ViewNatProm", Value = ViewNAPromotion });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@CurrentPersonaID", Value = CurrentPersonaID });
                            oaCommand.Parameters.Add(new OAParameter { ParameterName = "@RolledOutAccounts", Value = RolledOutAccounts });


                            using (IDataReader dataReader = oaCommand.ExecuteReader())
                            {
                                List<PromoAccount> lstAccount = dbContext.Translate<PromoAccount>(dataReader as DbDataReader).ToList();
                                lstAccount.Sort((x, y) => string.Compare(x.AccountName, y.AccountName));
                                dataReader.NextResult();

                                List<PromoChannel> lstChannel = dbContext.Translate<PromoChannel>(dataReader as DbDataReader).ToList();
                                lstChannel.Sort((x, y) => string.Compare(x.ChannelName, y.ChannelName));
                                // dataReader.NextResult();

                                lstAccountChannel.Add(CommonConstants.EXPORT_PROMOTION_LIST_ACCOUNT, lstAccount);
                                lstAccountChannel.Add(CommonConstants.EXPORT_PROMOTION_LIST_CHANNEL, lstChannel);

                            }


                        }
                        catch (Exception ex)
                        {
                            ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                        }
                        finally
                        {
                            string input = " Export To Excel -->Input : " + startDate.ToString() + "|" + endDate.ToString() + "|" + systemId + "|" + branchId + "|" + gsn + "|" + ViewDraftNAPromotion + "|" + ViewNAPromotion + "|" + RolledOutAccounts + "||| Output : " + lstAccountChannel.ToString();
                            ExceptionHelper.LogException(input, new Exception());
                        }
                    }
                }
            }
            return lstAccountChannel;

        }

        public Dictionary<string, object> GetAccountsAndChannelByFilter(DateTime startDate, DateTime endDate, string branchId, bool ViewDraftNAPromotion, bool ViewNAPromotion, string gsn, string RolledOutAccounts, int PersonaId, string RegionId)
        {
            Dictionary<string, object> lstAccountChannel = new Dictionary<string, object>();
            List<PromoAccount> lstAccount = new List<PromoAccount>();
            List<PromoChannel> lstChannel = new List<PromoChannel>();
            SqlConnection Conn;
            try
            {
                Conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString.ToString());
                Conn.Open();
                SqlCommand DBCmd = new SqlCommand(DBConstants.DB_PROC_TO_EXPORT_PROMOTION_FILTER, Conn);
                DBCmd.CommandType = CommandType.StoredProcedure;
                DBCmd.Parameters.Add("@StartDate", SqlDbType.Date).Value = startDate.Date;
                DBCmd.Parameters.Add("@EndDate", SqlDbType.Date).Value = endDate.Date;
                //DBCmd.Parameters.Add("@SystemIds", SqlDbType.VarChar).Value = systemId;
                DBCmd.Parameters.Add("@Branchid", SqlDbType.VarChar).Value = branchId;
                DBCmd.Parameters.Add("@currentuser", SqlDbType.VarChar).Value = gsn;
                DBCmd.Parameters.Add("@VIEW_DRAFT_NA", SqlDbType.Bit).Value = ViewDraftNAPromotion;
                DBCmd.Parameters.Add("@ViewNatProm", SqlDbType.Bit).Value = ViewNAPromotion;
                DBCmd.Parameters.Add("@RolledOutAccounts", SqlDbType.VarChar).Value = RolledOutAccounts;
                DBCmd.Parameters.Add("@CurrentPersonaID", SqlDbType.Int).Value = PersonaId;
                DBCmd.Parameters.Add("@RegionID", SqlDbType.VarChar).Value = RegionId;

                SqlDataReader myDataReader;
                try
                {
                    myDataReader = DBCmd.ExecuteReader();
                    while (myDataReader.Read())
                    {
                        PromoAccount newItem1 = new PromoAccount();

                        if (!DBNull.Value.Equals(myDataReader[0]))
                        {
                            newItem1.LocalChainName = Convert.ToString(myDataReader[0]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[1]))
                        {
                            newItem1.LocalChainID = Convert.ToInt32(myDataReader[1]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[2]))
                        {
                            newItem1.RegionalChainName = Convert.ToString(myDataReader[2]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[3]))
                        {
                            newItem1.RegionalChainID = Convert.ToInt32(myDataReader[3]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[4]))
                        {
                            newItem1.NationalChainName = Convert.ToString(myDataReader[4]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[5]))
                        {
                            newItem1.NationalChainID = Convert.ToInt32(myDataReader[5]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[6]))
                        {
                            newItem1.CreatedBy = Convert.ToString(myDataReader[6]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[7]))
                        {
                            newItem1.PromotionTypeID = Convert.ToInt32(myDataReader[7]);
                        }
                        lstAccount.Add(newItem1);

                    }
                    myDataReader.NextResult();
                    while (myDataReader.Read())
                    {
                        PromoChannel newItem2 = new PromoChannel();
                        if (!DBNull.Value.Equals(myDataReader[0]))
                        {
                            newItem2.SuperChannelId = Convert.ToInt32(myDataReader[0]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[1]))
                        {
                            newItem2.SuperChannelName = Convert.ToString(myDataReader[1]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[2]))
                        {
                            newItem2.ChannelId = Convert.ToInt32(myDataReader[2]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[3]))
                        {
                            newItem2.ChannelName = Convert.ToString(myDataReader[3]);
                        }
                        if (!DBNull.Value.Equals(myDataReader[4]))
                        {
                            newItem2.CreatedBy = Convert.ToString(myDataReader[4]);
                        }
                        lstChannel.Add(newItem2);
                    }
                    myDataReader.Close();
                    lstAccount.Sort((x, y) => string.Compare(x.AccountName, y.AccountName));
                    lstChannel.Sort((x, y) => string.Compare(x.ChannelName, y.ChannelName));

                    lstAccountChannel.Add(CommonConstants.EXPORT_PROMOTION_LIST_ACCOUNT, lstAccount);
                    lstAccountChannel.Add(CommonConstants.EXPORT_PROMOTION_LIST_CHANNEL, lstChannel);
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
                Conn.Close();
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return lstAccountChannel;
        }


        public List<PromoAccount> GetAccountHierarchy(List<PromoAccount> lstPromoAccount)
        {
            List<PromoAccount> lstAccounts = null;
            if (lstPromoAccount != null)
            {
                try
                {
                    int[] nationalChain = lstPromoAccount.Where(i => i.NationalChainID != (int?)null).Select(i => (int)i.NationalChainID).ToArray();
                    int[] regionChain = lstPromoAccount.Where(i => i.RegionalChainID != (int?)null).Select(i => (int)i.RegionalChainID).ToArray();
                    int[] localChain = lstPromoAccount.Where(i => i.LocalChainID != (int?)null).Select(i => (int)i.LocalChainID).ToArray();
                    using (PlaybookEntities objDB = new PlaybookEntities())
                    {
                        lstAccounts = (from account in objDB.PBChainHiers
                                       where (nationalChain.Contains(account.NationalChainID) || regionChain.Contains(account.RegionalChainID) || localChain.Contains(account.LocalChainID))
                                       select new PromoAccount() { NationalChainID = account.NationalChainID, NationalChainName = account.NationalChainName, RegionalChainID = account.RegionalChainID, RegionalChainName = account.RegionalChainName, LocalChainID = account.LocalChainID, LocalChainName = account.LocalChainName }).ToList();
                    }
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
            }

            return lstAccounts;
        }


        public List<TreeViewItem> GetExportPrefChannelTreeView(UserChannels usrChannels)
        {
            List<TreeViewItem> lstUsrPrefChannels = new List<TreeViewItem>();
            try
            {


                using (PlaybookEntities cntx = new PlaybookEntities())
                {
                    List<int> sprIds = usrChannels.SuperChannel.Select(i => Convert.ToInt32(i.ChannelId)).ToList();
                    List<int> locIds = usrChannels.Channel.Select(i => Convert.ToInt32(i.ChannelId)).ToList();

                    var allChannels = cntx.PBLocationChannels.Select(i => new { i.SuperChannelID, i.SAPSuperChannelID, i.SuperChannelName, i.ChannelID, i.ChannelName, i.SAPChannelID }).ToList();

                    var allSuperChannels = (from allChannel in allChannels
                                            where sprIds.Contains(Convert.ToInt32(allChannel.SuperChannelID))
                                            || locIds.Contains(Convert.ToInt32(allChannel.ChannelID))
                                            select new { allChannel.SuperChannelID, allChannel.SAPSuperChannelID, allChannel.SuperChannelName }).Distinct();

                    lstUsrPrefChannels.AddRange(allSuperChannels.Select(i => new TreeViewItem() { Id = Convert.ToInt32(i.SuperChannelID), ParentId = 0, Text = Convert.ToString(i.SuperChannelName), Value = i.SuperChannelID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + ChannelType.SuperChannel.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.SuperChannelName }));


                    var channels = (from allChannel in allChannels
                                    join superChannel in allSuperChannels
                                    on allChannel.SuperChannelID equals superChannel.SuperChannelID
                                    select new { allChannel.ChannelID, allChannel.ChannelName, allChannel.SAPChannelID, allChannel.SuperChannelID }).Distinct();
                    lstUsrPrefChannels.AddRange(channels.Select(i => new TreeViewItem() { Id = GetID(Convert.ToInt32(i.SuperChannelID), i.ChannelID), ParentId = Convert.ToInt32(i.SuperChannelID), Text = Convert.ToString(i.ChannelName), Value = i.ChannelID + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + ChannelType.Channel.ToString() + CommonConstants.PROMOTION_ACCOUNT_TREE_VIEW_SEPERATOR + i.ChannelName }));

                    lstUsrPrefChannels.Sort((x, y) => string.Compare(x.Text, y.Text));
                }

                return lstUsrPrefChannels;
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return lstUsrPrefChannels;
        }


        public string GetAllChildBranch(string BUID, string regionId, string AreaId, string branchId)
        {
            string branchIds = string.Empty;
            using (PlaybookEntities entity = new PlaybookEntities())
            {
                DbParameter[] parm = { (new OAParameter { ParameterName = "@BUID", Value =BUID  }), 
                                       (new OAParameter { ParameterName = "@regionId", Value = regionId }),
                                       (new OAParameter { ParameterName = "@AreaId", Value = AreaId }) ,
                                       (new OAParameter { ParameterName = "@branchId", Value = branchId}) };

                try
                {
                    List<string> lstBranch = entity.ExecuteQuery<string>("Playbook.GetAllChildBranchIds", System.Data.CommandType.StoredProcedure, parm).ToList<string>();
                    if (lstBranch != null && lstBranch.Count > 0)
                    {
                        branchIds = string.Join(",", lstBranch.ToArray());
                    }
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }

            }

            return branchIds;

        }
        public string GetAllChildRegionIds(string SystemID, string ZoneID, string DivisionId, string BCRegionId)
        {
            string BottlerIds = string.Empty;
            using (PlaybookEntities entity = new PlaybookEntities())
            {
                DbParameter[] parm = { (new OAParameter { ParameterName = "@SystemId", Value =SystemID  }), 
                                       (new OAParameter { ParameterName = "@ZoneID", Value = ZoneID }),
                                       (new OAParameter { ParameterName = "@DivisionID", Value = DivisionId }) ,
                                       (new OAParameter { ParameterName = "@BCRegionID", Value = BCRegionId})};
                //(new OAParameter { ParameterName = "@BottlerID", Value = BottlerId}) };

                try
                {
                    List<string> lstBottler = entity.ExecuteQuery<string>("playbook.GetAllChildRegionIds", System.Data.CommandType.StoredProcedure, parm).ToList<string>();
                    if (lstBottler != null && lstBottler.Count > 0)
                    {
                        BottlerIds = string.Join(",", lstBottler.ToArray());
                    }
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }

            }

            return BottlerIds;

        }
        #endregion


        #region BC
        public List<BCGeoRelevancy> GetBottlerSalesHierachy()
        {
            List<BCGeoRelevancy> objlstBCGeoRelevancy = null;

            if (CacheHelper.GetCacheValue(CommonConstants.PromotionBCGEORelevancyKey) != null)
                objlstBCGeoRelevancy = CacheHelper.GetCacheValue(CommonConstants.PromotionBCGEORelevancyKey) as List<BCGeoRelevancy>;
            else
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    objlstBCGeoRelevancy = (from bottler in objPlaybookEntities.PBVBottlerSalesHiers join sys in objPlaybookEntities.PBSystems on bottler.SystemID equals sys.BCSystemId where sys.BCSystemId != (int?)null select new BCGeoRelevancy() { DivisionID = bottler.DivisionID, DivisionName = bottler.DivisionName, RegionID = bottler.RegionID, RegionName = bottler.RegionName, BCSystemID = sys.BCSystemId, SystemID = sys.SystemID, SystemName = sys.SystemName, ZoneID = bottler.ZoneID, ZoneName = bottler.ZoneName }).ToList();
                    CacheHelper.SetCacheValue(CommonConstants.PromotionBCGEORelevancyKey, objlstBCGeoRelevancy, 24);
                }
            }

            return objlstBCGeoRelevancy;
        }

        public List<TreeViewItem> GetBCTreeView(string ApplicableSystems)
        {
            List<TreeViewItem> objBCGEOTreeViewlst = null;
            try
            {
                string[] systemIDS = ApplicableSystems.Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
                List<BCGeoRelevancy> objlstBCGeoRelevancy = GetBottlerSalesHierachy().Where(i => systemIDS.Contains(Convert.ToString(i.SystemID))).ToList();
                if (objlstBCGeoRelevancy != null)
                {
                    objBCGEOTreeViewlst = new List<TreeViewItem>();

                    var bcsystem = objlstBCGeoRelevancy.DistinctBy(i => i.BCSystemID).ToList();
                    int parent = 0;

                    if (bcsystem.Count > 1)
                    {
                        objBCGEOTreeViewlst.Add(new TreeViewItem() { Id = -1, Text = "All BC", Value = string.Concat(-1, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, "All"), SAPValue = string.Concat(-1, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, "All", CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, -1, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, "All BC"), ParentId = 0 });
                        parent = -1;
                    }

                    objBCGEOTreeViewlst.AddRange(bcsystem.Select(i => new TreeViewItem() { Id = (int)i.BCSystemID, Text = i.SystemName, Value = string.Concat(i.BCSystemID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_SYSTEM), SAPValue = string.Concat(i.BCSystemID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_SYSTEM, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.BCSystemID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SystemName), ParentId = parent }));

                    var bczone = (from item in objlstBCGeoRelevancy
                                  join system in bcsystem
                                  on item.BCSystemID equals system.BCSystemID
                                  select new { item.ZoneID, item.ZoneName, SystemID = item.BCSystemID }).Distinct().ToList();

                    objBCGEOTreeViewlst.AddRange(bczone.Select(i => new TreeViewItem() { Id = ((int)i.ZoneID + 10000), Value = string.Concat(i.ZoneID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_ZONE), SAPValue = string.Concat(i.ZoneID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_ZONE, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.ZoneID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.ZoneName), Text = i.ZoneName, ParentId = (int)i.SystemID }));

                    var bcdivision = (from item in objlstBCGeoRelevancy
                                      join zone in bczone
                                        on item.ZoneID equals zone.ZoneID
                                      select new { item.DivisionID, item.DivisionName, item.ZoneID, SystemID = item.BCSystemID }).Distinct().ToList();

                    objBCGEOTreeViewlst.AddRange(bcdivision.Select(i => new TreeViewItem() { Id = ((int)i.DivisionID + 20000), Value = string.Concat(i.DivisionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_DIVISION), SAPValue = string.Concat(i.DivisionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_DIVISION, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.DivisionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.DivisionName), Text = i.DivisionName, ParentId = ((int)i.ZoneID + 10000) }));

                    var bcregion = (from item in objlstBCGeoRelevancy
                                    join division in bcdivision
                                     on item.DivisionID equals division.DivisionID
                                    select new { item.RegionID, item.RegionName, item.DivisionID, SystemID = item.BCSystemID }).Distinct().ToList();

                    objBCGEOTreeViewlst.AddRange(bcregion.Select(i => new TreeViewItem() { Id = (int)i.RegionID + 30000, Value = string.Concat(i.RegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_REGION), SAPValue = string.Concat(i.RegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_REGION, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.RegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.RegionName), Text = i.RegionName, ParentId = ((int)i.DivisionID + 20000) }));


                }

            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return objBCGEOTreeViewlst.OrderBy(i => i.Text).ToList();
        }

        /// <summary>
        /// get bottlers by Region IDs
        /// </summary>
        /// <param name="regionIds"></param>
        /// <returns></returns>
        public List<BCGeoRelevancy> GetBottlersByRegionIds(string regionIds)
        {
            List<BCGeoRelevancy> lstBottler = new List<BCGeoRelevancy>();
            try
            {
                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@regionIds", Value = regionIds }) };
                    lstBottler = objPlaybookEntities.ExecuteQuery<BCGeoRelevancy>("Playbook.pGetBottlerByRegionIds", System.Data.CommandType.StoredProcedure, parm).ToList<BCGeoRelevancy>();

                }
            }
            catch (Exception ex)
            {

            }
            return lstBottler;
        }
        /// <summary>
        /// get bottlers by Region IDs
        /// </summary>
        /// <param name="regionIds"></param>
        /// <returns></returns>
        public List<BCStateRegion> GetBCStates()
        {
            List<BCStateRegion> lstStates = new List<BCStateRegion>();
            try
            {
                if (CacheHelper.GetCacheValue(CommonConstants.PromotionBCGEOStatesRelevancyKey) != null)
                    lstStates = CacheHelper.GetCacheValue(CommonConstants.PromotionBCGEOStatesRelevancyKey) as List<BCStateRegion>;
                else
                {
                    using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                    {
                        lstStates = objPlaybookEntities.ExecuteQuery<BCStateRegion>("Playbook.GetRegionState", System.Data.CommandType.StoredProcedure, null).ToList<BCStateRegion>();

                    }
                    CacheHelper.SetCacheValue(CommonConstants.PromotionBCGEOStatesRelevancyKey, lstStates, 518400);
                }
            }
            catch (Exception ex)
            {

            }
            return lstStates;
        }


        public void InsertBCGEORelevancy(string GEOXMl, bool IsBCPromotion)
        {
            try
            {

                using (PlaybookEntities db = new PlaybookEntities())
                {
                    DbParameter[] parm = {(new OAParameter { ParameterName = "@GeoXMl", Value = GEOXMl }),
                                          (new OAParameter { ParameterName = "@IsBCPromotion", Value = IsBCPromotion }),
                                          };
                    db.ExecuteNonQuery("Playbook.InsertUpdateGEORelevancy", System.Data.CommandType.StoredProcedure, parm);

                    db.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
        }

        /// <summary>
        /// get selected ItemGEO
        /// </summary>
        /// <param name="GEOXMl"></param>
        /// <param name="IsBCPromotion"></param>
        public List<BCGeoRelevancy> GetSelectedGEODetail(string GEOXMl)
        {
            List<BCGeoRelevancy> lstSelectedGEO = new List<BCGeoRelevancy>();
            try
            {

                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    DbParameter[] parm = {(new OAParameter { ParameterName = "@GeoXMl", Value = GEOXMl })
                                         // (new OAParameter { ParameterName = "@IsBCPromotion", Value = IsBCPromotion }),
                                          };
                    lstSelectedGEO = objPlaybookEntities.ExecuteQuery<BCGeoRelevancy>("Playbook.pGetGEOMySelectionHier", System.Data.CommandType.StoredProcedure, parm).ToList<BCGeoRelevancy>();


                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return lstSelectedGEO;
        }

        public List<BCGeoRelevancy> GetValidGEORelevancy(string GEOXml, int ParentPromotionID, int PromotionID, out bool InvalidLocalized, out bool RelevancyChanged, out bool InvalidRelevancy, string SystemNames
            , out string InvalidStateNames) //Commenting the parm as it was giving build error.
        {
            InvalidStateNames = "";
            List<BCGeoRelevancy> lstValidGEO = new List<BCGeoRelevancy>();
            try
            {

                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {

                    DbParameter[] parm = {(new OAParameter { ParameterName = "@GeoRelevancy", Value = GEOXml }),
                                          (new OAParameter { ParameterName = "@ParentPromotionID", Value=ParentPromotionID}),
                                          (new OAParameter { ParameterName = "@PromotionID",   Value=PromotionID}),
                                          (new OAParameter { ParameterName = "@RelevancyChanged", DbType=System.Data.DbType.Boolean, Direction= ParameterDirection.Output}),
                                          (new OAParameter { ParameterName = "@InvalidLocalizedGEO", DbType=System.Data.DbType.Boolean, Direction= ParameterDirection.Output}),
                                          (new OAParameter { ParameterName = "@InvalidRelevancy",  DbType=System.Data.DbType.Boolean,  Direction=ParameterDirection.Output}),
                                          (new OAParameter { ParameterName = "@SystemID",  Value=SystemNames}),
                                          (new OAParameter { ParameterName = "@InvalidStateNames",  DbType=System.Data.DbType.String, Size=2000, Direction=ParameterDirection.Output})
                                          
                                          };
                    lstValidGEO = objPlaybookEntities.ExecuteQuery<BCGeoRelevancy>("[Playbook].[pRollUpGeoRelevancy]", System.Data.CommandType.StoredProcedure, parm).ToList<BCGeoRelevancy>();
                    RelevancyChanged = Convert.ToBoolean(parm[3].Value);
                    InvalidLocalized = Convert.ToBoolean(parm[4].Value);
                    InvalidRelevancy = Convert.ToBoolean(parm[5].Value);
                    InvalidStateNames = Convert.ToString(parm[7].Value);
                }
            }
            catch (Exception ex)
            {
                InvalidRelevancy = RelevancyChanged = InvalidLocalized = false;
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return lstValidGEO;
        }
        #region XML UTILITY

        public List<GEOListItem> GetGEOSelection(string selectedItemIds)
        {
            List<GEOListItem> lstItems = new List<GEOListItem>();
            string selectedXML = GetSelectedItemsXML(selectedItemIds);
            if (!string.IsNullOrEmpty(selectedXML))
            {
                List<BCGeoRelevancy> objlstGeoItems = GetSelectedGEODetail(selectedXML);
                if (objlstGeoItems != null)
                {

                    lstItems.AddRange(objlstGeoItems.Where(i => i.BCSystemID != (int?)null).Select(i => new GEOListItem() { Type = PromoGeoType.System, ID = string.Concat(i.BCSystemID, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.System), Text = i.SystemName }).ToList());
                    lstItems.AddRange(objlstGeoItems.Where(i => i.ZoneID != (int?)null).Select(i => new GEOListItem() { Type = PromoGeoType.Zone, ID = string.Concat(i.ZoneID, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.Zone), Text = i.ZoneName }).ToList());
                    lstItems.AddRange(objlstGeoItems.Where(i => i.DivisionID != (int?)null).Select(i => new GEOListItem() { Type = PromoGeoType.Division, ID = string.Concat(i.DivisionID, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.Division), Text = i.DivisionName }).ToList());
                    lstItems.AddRange(objlstGeoItems.Where(i => i.BCRegionID != (int?)null).Select(i => new GEOListItem() { Type = PromoGeoType.BCRegion, ID = string.Concat(i.BCRegionID, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.BCRegion), Text = i.RegionName }).ToList());
                    lstItems.AddRange(objlstGeoItems.Where(i => i.BottlerID != (int?)null).Select(i => new GEOListItem() { Type = PromoGeoType.Bottler, ID = string.Concat(i.BottlerID, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.Bottler), Text = i.BottlerName }).ToList());
                    lstItems.AddRange(objlstGeoItems.Where(i => i.BUID != (int?)null).Select(i => new GEOListItem() { Type = PromoGeoType.BU, ID = string.Concat(i.BUID, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.BU), Text = i.BUName }).ToList());
                    lstItems.AddRange(objlstGeoItems.Where(i => i.RegionID != (int?)null).Select(i => new GEOListItem() { Type = PromoGeoType.Region, ID = string.Concat(i.RegionID, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.Region), Text = i.RegionName }).ToList());
                    lstItems.AddRange(objlstGeoItems.Where(i => i.AreaID != (int?)null).Select(i => new GEOListItem() { Type = PromoGeoType.Area, ID = string.Concat(i.AreaID, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.Area), Text = i.AreaName }).ToList());
                    lstItems.AddRange(objlstGeoItems.Where(i => i.BranchID != (int?)null).Select(i => new GEOListItem() { Type = PromoGeoType.Branch, ID = string.Concat(i.BranchID, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.Branch), Text = i.BranchName }).ToList());
                }




            }
            #region GEO States

            string[] states = selectedItemIds.Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries).Where(i => (PromoGeoType)Enum.Parse(typeof(PromoGeoType), (i.Split(CommonConstants.BC_LIST_ITEM_SEPERATOR.ToCharArray(), StringSplitOptions.RemoveEmptyEntries)[1])) == PromoGeoType.State).ToArray();
            if (states != null && states.Length > 0)
            {
                List<BCStateRegion> objGEOStates = GetBCStates();
                List<GEOListItem> lstGeoItem = (from geostate in objGEOStates join state in states on string.Concat(geostate.StateID, CommonConstants.BC_LIST_ITEM_SEPERATOR, (int)PromoGeoType.State) equals state select new GEOListItem() { ID = state, Text = geostate.StateName, Type = PromoGeoType.State }).ToList();
                if (lstGeoItem != null)
                    lstItems.AddRange(lstGeoItem);

            }
            #endregion
            return lstItems;
        }
        private string GetSelectedItemsXML(string selectedGEOIds)
        {
            string xml = string.Empty;
            List<GEOListItem> objGeolstItems = new List<GEOListItem>();
            if (!string.IsNullOrEmpty(selectedGEOIds))
            {


                XElement[] elements = selectedGEOIds.Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries).Select(i => new XElement("Item",
                                GetGeoXMLElements(i))).ToArray();
                XElement rootElement = new XElement("GEO", elements);
                xml = rootElement.ToString();
            }
            return xml;
        }
        public List<XElement> GetGeoXMLElements(string value)
        {
            List<XElement> objElements = new List<XElement>();
            if (!string.IsNullOrEmpty(value))
            {

                objElements.Add(new XElement("SystemID", GetElementValue(value, PromoGeoType.System)));
                objElements.Add(new XElement("ZoneID", GetElementValue(value, PromoGeoType.Zone)));
                objElements.Add(new XElement("DivisionID", GetElementValue(value, PromoGeoType.Division)));
                objElements.Add(new XElement("BCRegionID", GetElementValue(value, PromoGeoType.BCRegion)));
                objElements.Add(new XElement("BottlerID", GetElementValue(value, PromoGeoType.Bottler)));
                objElements.Add(new XElement("BUID", GetElementValue(value, PromoGeoType.BU)));
                objElements.Add(new XElement("AreaID", GetElementValue(value, PromoGeoType.Area)));
                objElements.Add(new XElement("RegionID", GetElementValue(value, PromoGeoType.Region)));
                objElements.Add(new XElement("BranchID", GetElementValue(value, PromoGeoType.Branch)));


            }
            return objElements;
        }
        private string GetElementValue(string value, PromoGeoType type)
        {
            string strTemp = string.Empty;

            string[] strvalues = value.Split(CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR.ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
            if (strvalues.Length > 1)
                if (!string.IsNullOrEmpty(value) && (PromoGeoType)Enum.Parse(typeof(PromoGeoType), strvalues[1]) == type)
                    strTemp = strvalues[0];

            return strTemp;
        }
        #endregion
        #endregion
        #region MassUpload methods

        public void InsertExcelData(string PromotionXMl, string GSN, bool IsNAAdmin, string RoleName, int PersonaID, bool IsNationalAccountPromotion)
        {
            try
            {
                using (PlaybookEntities db = new PlaybookEntities())
                {
                    DbParameter[] parm = {(new OAParameter { ParameterName = "@PromotionXML", Value = PromotionXMl }),
                                          (new OAParameter { ParameterName = "@GSN", Value = GSN }),
                                          (new OAParameter { ParameterName = "@IsNAAdmin", Value = IsNAAdmin }),
                                          (new OAParameter { ParameterName = "@RoleName", Value = RoleName }),
                                          (new OAParameter { ParameterName = "@PersonaID", Value = PersonaID }),
                                          (new OAParameter { ParameterName = "@IsNationalAccountPromotion", Value = IsNationalAccountPromotion }),
                                          };
                    db.ExecuteNonQuery("[PlayBook].[pInsertUpdateStgMassUpload]", System.Data.CommandType.StoredProcedure, parm);

                    db.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
        }

        /// <summary>
        /// Cancelled Mass upload Promotion by GSN
        /// </summary>
        /// <param name="GSN"></param>
        public void SubmitPromotionByGSN(string GSN)
        {
            try
            {
                using (PlaybookEntities objDB = new PlaybookEntities())
                {
                    var itemsToUpdate = objDB.PBMassUploadPromotions.Where(i => i.Submitted == false && i.Cancelled == false && string.Compare(i.CreatedBy, GSN, true) == 0).ToList();
                    foreach (var item in itemsToUpdate)
                        item.Submitted = true;
                    objDB.SaveChanges();

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
        }
        /// <summary>
        /// Mass upload Promotion Audit Log by GSN
        /// </summary>
        /// <param name="GSN"></param>
        public void MassUploadPromoAuditLog(string connectionStr, string GSN, int PromotionCount)
        {
            try
            {
                using (PlaybookEntities objDB = new PlaybookEntities(connectionStr))
                {
                    objDB.Add(new PBMassUploadPromoAudit() { PromotionCount = PromotionCount, GSNID = GSN, PromotionUploadDate = DateTime.UtcNow });
                    objDB.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

        }
        /// <summary>
        /// Cancelled Mass upload Promotion by GSN
        /// </summary>
        /// <param name="GSN"></param>
        public void CancelPromotionByGSN(string GSN)
        {
            try
            {
                using (PlaybookEntities objDB = new PlaybookEntities())
                {
                    var itemsToUpdate = objDB.PBMassUploadPromotions.Where(i => i.Submitted == false && string.Compare(i.CreatedBy, GSN, true) == 0).ToList();
                    foreach (var item in itemsToUpdate)
                        item.Cancelled = true;
                    objDB.SaveChanges();

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
        }

        /// <summary>
        /// Get mass upload promotion by GSN
        /// </summary>
        /// <param name="GSN"></param>
        /// <returns></returns>
        public List<MassUploadPromo> RetrunMassUploadData(string GSN)
        {
            List<MassUploadPromo> lstPromo = new List<MassUploadPromo>();
            try
            {
                using (PlaybookEntities objDB = new PlaybookEntities())
                {
                    lstPromo = objDB.PBMassUploadPromotions.Where(i => i.Submitted == false && i.Cancelled == false && i.CreatedBy == GSN).Select
                        (i => new MassUploadPromo
                        {
                            ID = i.ID,
                            Row_Number = i.RowNumber,
                            Promotion_Name = i.PromotionName,
                            Comments = i.Comments,
                            //System_RTM = i.SystemRTM, // Removed for BC2 by saurabh
                            Select_National_Chain_Account = i.NationalChainAccount,
                            Accounts = i.Accounts,
                            Brands = i.Brands,
                            Packages = i.Packages,
                            Retail_Price = i.RetailPrice,
                            Invoice_Price = i.InvoicePrice,
                            Category = i.Category,
                            Display_Location = i.DisplayLocation,
                            Other_Display_Location = i.OtherDisplayLocation,
                            Start_Date = !string.IsNullOrEmpty(i.StartDate) ? (i.StartDate == CommonConstants.MASS_UPLOAD_EXCEL_SHEET_DEFAULT_DATE) ? string.Empty : i.StartDate : string.Empty,
                            End_Date = !string.IsNullOrEmpty(i.EndDate) ? (i.EndDate == CommonConstants.MASS_UPLOAD_EXCEL_SHEET_DEFAULT_DATE) ? string.Empty : i.EndDate : string.Empty,
                            Forecast_Volume = i.ForecastVolume,
                            National_Display_Target = i.NationalDisplayTarget,
                            AccountImageName = i.AccountImageName,
                            Status = i.PromotionStatus,
                            ErrorDescription = i.ErrorDescription,
                            // New fields added for BC2 by saurabh
                            Geo_Relevancy = i.GeoRelevancy,
                            Display_Requirement = i.DisplayRequirement,
                            Display_Start_Date = !string.IsNullOrEmpty(i.DisplayStartDate) ? (i.DisplayStartDate == CommonConstants.MASS_UPLOAD_EXCEL_SHEET_DEFAULT_DATE) ? string.Empty : i.DisplayStartDate : string.Empty,
                            Display_End_Date = !string.IsNullOrEmpty(i.DisplayEndDate) ? (i.DisplayEndDate == CommonConstants.MASS_UPLOAD_EXCEL_SHEET_DEFAULT_DATE) ? string.Empty : i.DisplayEndDate : string.Empty,
                            Pricing_Start_Date = !string.IsNullOrEmpty(i.PricingStartDate) ? (i.PricingStartDate == CommonConstants.MASS_UPLOAD_EXCEL_SHEET_DEFAULT_DATE) ? string.Empty : i.PricingStartDate : string.Empty,
                            Pricing_End_Date = !string.IsNullOrEmpty(i.PricingEndDate) ? (i.PricingEndDate == CommonConstants.MASS_UPLOAD_EXCEL_SHEET_DEFAULT_DATE) ? string.Empty : i.PricingEndDate : string.Empty,
                            SMA_Required = i.SMARequired,
                            Cost_Per_Store = i.CostPerStore,
                            TPM_Promotion_Number_CASO = i.TPMPromotionNumberCASO,
                            TPM_Promotion_Number_PASO = i.TPMPromotionNumberPASO,
                            TPM_Promotion_Number_ISO = i.TPMPromotionNumberISO,
                            TPM_Promotion_Number_PB = i.TPMPromotionNumberPB,
                            Cost_Info = i.CostInfo,
                            Display_Type = i.DisplayType,
                            AccrualComments = i.AccrualComments,
                            VariableRPC = i.RPC,
                            FixedCost = i.FixedCost,
                            Redemption = i.Redemption,
                             Accounting=i.Accounting,
                             Unit=i.Unit                 
                           
                        }).ToList();
                    GetMassAttachments(lstPromo);
                    return lstPromo;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                return null;
            }
        }

        public List<MassUploadPromo> RetrunMassUploadDataByGSN(string GSN)
        {
            List<MassUploadPromo> lstPromo = new List<MassUploadPromo>();
            try
            {

                using (PlaybookEntities objDB = new PlaybookEntities(GetConnectionString()))
                {
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@GSN", Value = GSN }) };
                    lstPromo = objDB.ExecuteQuery<MassUploadPromo>("[Playbook].[pGetMassUploadDataByGSN]", System.Data.CommandType.StoredProcedure, parm).ToList();
                    lstPromo = lstPromo.Select
                      (i => new MassUploadPromo {
                          ID = i.ID,
                          Row_Number = i.Row_Number,
                          Promotion_Name = i.Promotion_Name,
                          Comments = i.Comments,                         
                          Select_National_Chain_Account = i.Select_National_Chain_Account,
                          Accounts = i.Accounts,
                          Brands = i.Brands,
                          Packages = i.Packages,
                          Retail_Price = i.Retail_Price,
                          Invoice_Price = i.Invoice_Price,
                          Category = i.Category,
                          Display_Location = i.Display_Location,
                          Other_Display_Location = i.Other_Display_Location,
                          Start_Date = !string.IsNullOrEmpty(i.Start_Date) ? (i.Start_Date == CommonConstants.MASS_UPLOAD_EXCEL_SHEET_DEFAULT_DATE) ? string.Empty : i.Start_Date : string.Empty,
                          End_Date = !string.IsNullOrEmpty(i.End_Date) ? (i.End_Date == CommonConstants.MASS_UPLOAD_EXCEL_SHEET_DEFAULT_DATE) ? string.Empty : i.End_Date : string.Empty,
                          Forecast_Volume = i.Forecast_Volume,
                          National_Display_Target = i.National_Display_Target,
                          AccountImageName = i.AccountImageName,
                          Status = i.Status,
                          ErrorDescription = i.ErrorDescription,
                        
                          Geo_Relevancy = i.Geo_Relevancy,
                          Display_Requirement = i.Display_Requirement,
                          Display_Start_Date = !string.IsNullOrEmpty(i.Display_Start_Date) ? (i.Display_Start_Date == CommonConstants.MASS_UPLOAD_EXCEL_SHEET_DEFAULT_DATE) ? string.Empty : i.Display_Start_Date : string.Empty,
                          Display_End_Date = !string.IsNullOrEmpty(i.Display_End_Date) ? (i.Display_End_Date == CommonConstants.MASS_UPLOAD_EXCEL_SHEET_DEFAULT_DATE) ? string.Empty : i.Display_End_Date : string.Empty,
                          Pricing_Start_Date = !string.IsNullOrEmpty(i.Pricing_Start_Date) ? (i.Pricing_Start_Date == CommonConstants.MASS_UPLOAD_EXCEL_SHEET_DEFAULT_DATE) ? string.Empty : i.Pricing_Start_Date : string.Empty,
                          Pricing_End_Date = !string.IsNullOrEmpty(i.Pricing_End_Date) ? (i.Pricing_End_Date == CommonConstants.MASS_UPLOAD_EXCEL_SHEET_DEFAULT_DATE) ? string.Empty : i.Pricing_End_Date : string.Empty,
                          SMA_Required = i.SMA_Required,
                          Cost_Per_Store = i.Cost_Per_Store,
                          TPM_Promotion_Number_CASO = i.TPM_Promotion_Number_CASO,
                          TPM_Promotion_Number_PASO = i.TPM_Promotion_Number_PASO,
                          TPM_Promotion_Number_ISO = i.TPM_Promotion_Number_ISO,
                          TPM_Promotion_Number_PB = i.TPM_Promotion_Number_PB,
                          Cost_Info = i.Cost_Info,
                          Display_Type = i.Display_Type,
                          AccrualComments = i.AccrualComments,
                          VariableRPC = i.VariableRPC,
                          FixedCost = i.FixedCost,
                          Redemption = i.Redemption,
                          Accounting = i.Accounting,
                          Unit = i.Unit ,
                          RegionalChain = i.RegionalChain,
                          LocalChain = i.LocalChain,
                          DPSGHierarchyLevel1 = i.DPSGHierarchyLevel1,
                          DPSGHierarchyLevel2 = i.DPSGHierarchyLevel2,
                          DPSGHierarchyLevel3 = i.DPSGHierarchyLevel3,
                          OtherBrand = i.OtherBrand,
                          SendBottlerAnnouncement = i.SendBottlerAnnouncement
                      }).ToList();
                    GetMassAttachments(lstPromo);
                    return lstPromo;
                }

               
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                return null;
            }
         
        }


        private void GetMassAttachments(List<MassUploadPromo> lstPromo)
        {
            using (PlaybookEntities objDB = new PlaybookEntities())
            {
                var attachemnts = (from promo in lstPromo
                                   join attach in objDB.PBStgMassUploadAttachments
                                   on promo.ID equals attach.StgPromotionID
                                   join attachType in objDB.PBAttachmentTypes on attach.AttachmentTypeID equals attachType.AttachmentTypeID
                                   select new PromoAttachment() { ID = attach.StgPromotionID, URL = SPUrlUtility.CombineUrl(attach.AttachmentURL, attach.AttachmentName), Name = attach.AttachmentName, SystemDisplayNames = attach.DisplaySystem, Type = attachType.AttachmentTypeName }).ToList();
                if (attachemnts != null && attachemnts.Count > 0)
                {
                    foreach (MassUploadPromo objPromo in lstPromo)
                        objPromo.Attachments = attachemnts.Where(i => i.ID == objPromo.ID).ToList();

                }

            }



        }
        public bool CheckConflictForMassPromo(string GSN, out string createdDate)
        {
            try
            {
                using (PlaybookEntities db = new PlaybookEntities())
                {
                    var objMassPromo = db.PBMassUploadPromotions.Where(i => i.Submitted == false && i.Cancelled == false && i.CreatedBy == GSN).FirstOrDefault();
                    if (objMassPromo != null)
                    {
                        createdDate = (objMassPromo.CreatedDate.HasValue) ? objMassPromo.CreatedDate.Value.ToShortDateString() : string.Empty;
                        return true;
                    }
                    else
                    {
                        createdDate = string.Empty;
                        return false;
                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                createdDate = string.Empty;
                return false;
            }
        }

        #region TimerJob


        public MassUploadPromo ProcessMassuploadPromo(int PromoId, string RoleName, int PersonaId, bool IsNationalAccountPromotion, string connectionStr)
        {
            MassUploadPromo objPromo = new MassUploadPromo();
            try
            {

                using (PlaybookEntities db = new PlaybookEntities(connectionStr))
                {
                    DbParameter[] parm = { (new OAParameter { ParameterName = "@PromoId", Value = PromoId,  DbType= DbType.Int32 }),
                                            (new OAParameter { ParameterName = "@RoleName", Value = RoleName,  DbType= DbType.String}),
                                            (new OAParameter { ParameterName = "@PersonaId", Value = PersonaId,  DbType= DbType.Int32 }),
                                            (new OAParameter { ParameterName = "@IsNationalAccountPromotion", Value = IsNationalAccountPromotion,  DbType= DbType.Boolean }),
                                         (new OAParameter { ParameterName = "@Status", Value = PromoId, Direction= ParameterDirection.Output , DbType= DbType.Int32}),
                                         (new OAParameter { ParameterName = "@Message", Value = PromoId, Direction= ParameterDirection.Output, DbType= DbType.String }),
                                         (new OAParameter { ParameterName = "@NewPromoId", Value = PromoId, Direction= ParameterDirection.Output , DbType= DbType.Int32})
                                         };

                    db.ExecuteNonQuery("Playbook.pParseStgPromotion", CommandType.StoredProcedure, parm);
                    objPromo.Succeed = (Convert.ToInt32(parm[4].Value) == 1) ? true : false;
                    objPromo.ErrorDescription = Convert.ToString(parm[5].Value);
                    objPromo.PromotionID = Convert.ToInt32(parm[6].Value);
                    db.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                objPromo.Succeed = false;
                objPromo.ErrorDescription = ex.Message;
            }
            return objPromo;
        }

        public List<MassUploadPromo> GetAllMassPromoToProcess(string connectionStr)
        {

            List<MassUploadPromo> lstMassUploadPromo = new List<MassUploadPromo>();
            try
            {
                using (PlaybookEntities objDB = new PlaybookEntities(connectionStr))
                {
                    lstMassUploadPromo = objDB.PBMassUploadPromotions.Where(i => i.Submitted == true).Select(i => new MassUploadPromo()
                    {
                        ID = i.ID,
                        Promotion_Name = i.PromotionName,
                        CreatedBy = i.CreatedBy,
                        PersonaID = (int)i.PersonaID,
                        RoleName = i.RoleName,
                        IsNationalAccountPromotion = (bool)i.IsNationalAccountPromotion


                    }).ToList();

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return lstMassUploadPromo;
        }
        /// <summary>
        /// Update processed status by PromotionId
        /// </summary>
        /// <param name="promotionId"></param>
        /// <param name="readyToDelete"></param>
        /// <returns></returns>
        public bool UpdateProcessedRecord(int promotionId, bool readyToDelete, string connectionStr)
        {
            try
            {
                using (PlaybookEntities objDB = new PlaybookEntities(connectionStr))
                {
                    var itemToUpdate = objDB.PBMassUploadPromotions.Where(i => i.ID == promotionId).FirstOrDefault();
                    if (itemToUpdate != null)
                    {
                        itemToUpdate.Processed = true;
                        itemToUpdate.ReadyToDelete = readyToDelete;
                        objDB.SaveChanges();
                    }
                    return true;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                return false;
            }


        }

        /// <summary>
        /// Delete all Promotion and Attachments
        /// </summary>
        /// <returns></returns>
        public bool DeleteProcessedRecords(string connectionStr, string siteURL)
        {
            try
            {
                using (PlaybookEntities objDB = new PlaybookEntities(connectionStr))
                {
                    var itemToDelete = objDB.PBMassUploadPromotions.Where(i => i.Processed == true).ToList();

                    if (itemToDelete != null)
                    {
                        //delete attachments
                        DeletePromoAttachments(itemToDelete.Select(i => i.ID).Distinct().ToArray(), false, connectionStr, siteURL);
                        objDB.Delete(itemToDelete);
                        objDB.SaveChanges();
                    }
                    return true;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                return false;
            }


        }





        /// <summary>
        /// Update processed status by PromotionId
        /// </summary>
        /// <param name="promotionId"></param>
        /// <param name="readyToDelete"></param>
        /// <returns></returns>
        public bool DeleteCancelledRecords(string connectionStr, string siteURL)
        {
            try
            {
                using (PlaybookEntities objDB = new PlaybookEntities(connectionStr))
                {
                    var itemToDelete = objDB.PBMassUploadPromotions.Where(i => i.Cancelled == true).ToList();
                    if (itemToDelete != null && itemToDelete.Count > 0)
                    {
                        //delete attachements from library and DB
                        DeletePromoAttachments(itemToDelete.Select(i => i.ID).Distinct().ToArray(), true, connectionStr, siteURL);
                        //delete cancelled promtions
                        objDB.Delete(itemToDelete);
                        objDB.SaveChanges();

                    }
                    return true;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                return false;
            }


        }

        private void DeletePromoAttachments(int[] promoIds, bool DeleteAttachemnt, string connectionStr, string siteURL)
        {
            List<string> fileurls = new List<string>();
            using (PlaybookEntities objDB = new PlaybookEntities(connectionStr))
            {
                foreach (int promoId in promoIds)
                {
                    var attachmentstoDelete = objDB.PBStgMassUploadAttachments.Where(i => i.StgPromotionID == promoId).ToList();
                    if (attachmentstoDelete != null && attachmentstoDelete.Count > 0)
                    {
                        fileurls.AddRange(attachmentstoDelete.Select(i => new { URL = SPUrlUtility.CombineUrl(i.AttachmentURL, i.AttachmentName) }).Select(i => i.URL).ToList<string>());
                        try
                        {
                            objDB.Delete(attachmentstoDelete);
                            objDB.SaveChanges();
                        }
                        catch (Exception ex)
                        {
                            ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                        }
                    }
                }
            }
            if (DeleteAttachemnt)
            {
                if (fileurls != null && fileurls.Count > 0)
                {
                    try
                    {


                        SPSecurity.RunWithElevatedPrivileges(delegate()
                        {
                            using (SPSite spsite = new SPSite(siteURL))
                            {
                                using (SPWeb objWeb = spsite.OpenWeb())
                                {
                                    objWeb.AllowUnsafeUpdates = true;
                                    SPList docLib = objWeb.Lists.TryGetList(CommonConstants.PROMOTION_LIBRARY_NAME);
                                    if (docLib != null)
                                    {

                                        foreach (string fileurl in fileurls)
                                        {
                                            try
                                            {
                                                SPFile objFile = objWeb.GetFile(fileurl);
                                                if (objFile != null)
                                                    objFile.Delete();
                                                docLib.Update();
                                            }
                                            catch (Exception ex)
                                            {

                                            }
                                        }
                                    }
                                    objWeb.AllowUnsafeUpdates = false;
                                }
                            }
                        });
                    }
                    catch (Exception ex)
                    {
                        ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                    }
                }
            }
        }
        #endregion


        #region Mass Upload Attachments

        public bool InsertUpdateMassUploadAttachment(ref List<PromoAttachment> _attachments, int _promoId)
        {


            foreach (PromoAttachment attachment in _attachments.Where(i => i.IsNew == true))
            {
                //Insert in sharepoint library
                attachment.URL = InsertDeleteInSPLibrary(attachment, _promoId);
            }
            DeleteMassUploadAttachment(_promoId);
            using (PlaybookEntities objEntity = new PlaybookEntities())
            {
                objEntity.Add(_attachments.Where(i => i.IsNew == true).Select(attachment => new PBStgMassUploadAttachment()
                {
                    AttachmentName = attachment.Name,
                    StgPromotionID = _promoId,
                    AttachmentDateModified = DateTime.UtcNow,
                    AttachmentURL = attachment.URL,

                    AttachmentSize = attachment.AttachmentSize,
                    AttachmentDocumentID = attachment.AttachmentDocumentID,
                    AttachmentTypeID = attachment.TypeId,
                }).ToList());
                objEntity.SaveChanges();


            }

            return true;
        }

        private void DeleteMassUploadAttachment(int promotionId)
        {
            using (PlaybookEntities objEntity = new PlaybookEntities())
            {
                try
                {
                    objEntity.Delete(objEntity.PBStgMassUploadAttachments.Where(i => i.StgPromotionID == promotionId).ToList());
                    objEntity.SaveChanges();
                }
                catch (Exception ex)
                { }
            }
        }

        public bool DeleteStagingPromotions(string gsn)
        {
            bool isDelete = false;
            using (PlaybookEntities objEntity = new PlaybookEntities())
            {
                try
                {
                    var lstItems = objEntity.PBMassUploadPromotions.Where(i => i.CreatedBy == gsn).ToList();
                    if (lstItems.Count > 0)
                    {
                        objEntity.Delete(lstItems);
                        objEntity.SaveChanges();
                        isDelete = true;
                    }
                }
                catch (Exception ex)
                { }
            }
            return isDelete;
        }

        //Insert attachment in document library
        private string InsertDeleteInSPLibrary(PromoAttachment _attachment, int _promtionId)
        {
            string fullurl = string.Empty;
            string folderurl = string.Empty;
            string documentID = string.Empty;
            try
            {
                string currentUser = SPContext.Current.Web.CurrentUser.ToString();
                string baseUrl = ConfigurationManager.AppSettings[CommonConstants.PromotionSiteURL];
                string libraryName = CommonConstants.PROMOTION_LIBRARY_NAME;

                //Run with elevated code
                SPSecurity.RunWithElevatedPrivileges(delegate()
                {
                    using (SPSite spsite = new SPSite(baseUrl))
                    {
                        using (SPWeb objWeb = spsite.OpenWeb())
                        {
                            int start = Convert.ToInt32(_promtionId.ToString().Substring(0, 1));
                            int end = Convert.ToInt32(_promtionId.ToString().Substring(1, _promtionId.ToString().Length - 1));
                            if (objWeb != null)
                            {

                                objWeb.AllowUnsafeUpdates = true;
                                SPList dicLib = objWeb.Lists.TryGetList(libraryName);
                                if (dicLib != null)
                                {
                                    folderurl = baseUrl + "/" + libraryName + "/" + start;
                                    SPFolder ofolder = objWeb.GetFolder(folderurl);
                                    if (!ofolder.Exists)
                                    {
                                        SPListItem foldercoll = dicLib.Items.Add(dicLib.RootFolder.ServerRelativeUrl, SPFileSystemObjectType.Folder, start.ToString());
                                        foldercoll["PromotionID"] = _promtionId;
                                        foldercoll["UploadedBy"] = currentUser;
                                        foldercoll.Update();
                                        SPListItem childfolder = dicLib.Items.Add(dicLib.RootFolder.ServerRelativeUrl + "/" + start.ToString(), SPFileSystemObjectType.Folder, end.ToString());
                                        childfolder["PromotionID"] = _promtionId;
                                        childfolder["UploadedBy"] = currentUser;
                                        childfolder.Update();
                                        folderurl = childfolder.Url;
                                    }
                                    else
                                    {
                                        try
                                        {
                                            SPFolder ofolderChild = objWeb.GetFolder(baseUrl + "/" + libraryName + "/" + start.ToString() + "/" + end.ToString());
                                            if (!ofolderChild.Exists)
                                            {
                                                //SPListItem foldercoll = dicLib.Items.Add(baseUrl + "/" + libraryName + "/" + start.ToString(), SPFileSystemObjectType.Folder, end.ToString());
                                                //foldercoll["PromotionID"] = _promtionId;
                                                //foldercoll["UploadedBy"] = currentUser;
                                                //dicLib.Update();
                                                //folderurl = foldercoll.Url;
                                                objWeb.GetFolder(folderurl).SubFolders.Add(ofolderChild.Url);
                                                folderurl = ofolderChild.Url;
                                            }
                                            else
                                                folderurl = ofolderChild.Url;
                                        }
                                        catch (Exception ex)
                                        { }
                                    }
                                    //files to delete
                                    if (_attachment.IsDeleted)
                                    {
                                        try
                                        {
                                            string fileurl = baseUrl + "/" + folderurl + "/" + _attachment.Name;
                                            SPFile fileToDelete = objWeb.GetFile(fileurl);
                                            if (fileToDelete != null)
                                            {
                                                fileToDelete.Delete();
                                                dicLib.Update();
                                            }
                                        }
                                        catch (Exception ex)
                                        {
                                            ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                                        }
                                    }
                                    //file is new to be inserted in library
                                    if (_attachment.IsNew)
                                    {
                                        try
                                        {
                                            SPFile ofile = objWeb.Files.Add(baseUrl + "/" + folderurl + "/" + _attachment.Name, _attachment.Content, true);
                                            ofile.Item["PromotionID"] = _promtionId;
                                            ofile.Item["UploadedBy"] = currentUser;
                                            _attachment.AttachmentDocumentID = ofile.Item["_dlc_DocId"].ToString();
                                            ofile.Update();
                                            ofile.Item.Update();
                                        }
                                        catch (Exception ex)
                                        {
                                            ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                                        }
                                    }
                                    objWeb.Update();
                                    objWeb.AllowUnsafeUpdates = false;

                                }
                            }

                        }
                    }
                    fullurl = SPUrlUtility.CombineUrl(baseUrl, folderurl);
                });
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return fullurl;

        }


        public List<PromoAttachment> GetMassUploadAttachmentsByStgPromoId(int _stgPromotionId)
        {
            List<PromoAttachment> lstPromoAttachments = null;

            try
            {
                using (PlaybookEntities objDB = new PlaybookEntities())
                {
                    lstPromoAttachments = (from attachment in objDB.PBStgMassUploadAttachments
                                           join attachmentType in objDB.PBAttachmentTypes
                                           on attachment.AttachmentTypeID equals attachmentType.AttachmentTypeID
                                           where attachment.StgPromotionID == _stgPromotionId
                                           select new PromoAttachment()
                                           {
                                               Name = attachment.AttachmentName,
                                               URL = attachment.AttachmentURL,
                                               ID = attachment.AttachmentID,
                                               TypeId = (int)attachment.AttachmentTypeID,
                                               Type = attachmentType.AttachmentTypeName,
                                               SystemDisplayNames = attachment.DisplaySystem,
                                               AttachmentSize = !string.IsNullOrEmpty(attachment.AttachmentSize.ToString()) ? Convert.ToInt32(attachment.AttachmentSize) : 0,
                                               AttachmentDocumentID = attachment.AttachmentDocumentID,
                                               IsNew = false
                                           }).ToList();

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }

            return lstPromoAttachments;
        }

        #endregion

        #endregion

        /// <summary>
        /// Method to get the GEO location department wise for survey
        /// </summary>
        /// <param name="DSDDeptID"></param>
        /// <returns></returns>
        public List<TreeViewItem> GetGeoTreeViewSurveyDeptWise(int DSDDeptID)
        {
            List<TreeViewItem> objGEOTreeViewlst = null;
            try
            {

                using (PlaybookEntities objPlaybookEntities = new PlaybookEntities())
                {
                    List<PBLocationHier> objlstLocationHier = objPlaybookEntities.PBLocationHiers.ToList();
                    if (objlstLocationHier != null)
                    {

                        objGEOTreeViewlst = new List<TreeViewItem>();
                        var nationLocations = objlstLocationHier.DistinctBy(i => i.BUID).ToList();
                        objGEOTreeViewlst.AddRange(nationLocations.Select(i => new TreeViewItem() { Id = i.BUID, Text = i.BUName, Value = string.Concat(i.BUID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BU), SAPValue = string.Concat(i.BUID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BU, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPBUID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.BUName), ParentId = DSDDeptID }));
                        var regionalLocations = (from item in objlstLocationHier
                                                 join nationlocation in nationLocations
                                                 on item.BUID equals nationlocation.BUID
                                                 select new { item.RegionID, item.SAPRegionID, item.RegionName, item.BUID }).Distinct().ToList();
                        objGEOTreeViewlst.AddRange(regionalLocations.Select(i => new TreeViewItem() { Id = (i.RegionID + 10000), Value = string.Concat(i.RegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_REGIONAL), SAPValue = string.Concat(i.RegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_REGIONAL, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPRegionID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.RegionName), Text = i.RegionName, ParentId = i.BUID }));

                        var areaLocation = (from item in objlstLocationHier
                                            join regionalLocation in regionalLocations
                                             on item.RegionID equals regionalLocation.RegionID
                                            select new { item.AreaID, item.AreaName, item.RegionID, item.BUID, item.SAPAreaID }).Distinct().ToList();

                        objGEOTreeViewlst.AddRange(areaLocation.Select(i => new TreeViewItem() { Id = (i.AreaID + 20000), Value = string.Concat(i.AreaID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_AREA), SAPValue = string.Concat(i.AreaID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_AREA, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPAreaID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.AreaName), Text = i.AreaName, ParentId = (i.RegionID + 10000) }));

                        var localLocations = (from item in objlstLocationHier
                                              join regionalLocation in areaLocation
                                               on item.AreaID equals regionalLocation.AreaID
                                              select new { item.BranchID, item.BranchName, item.AreaID, item.BUID, item.SAPBranchID }).Distinct().ToList();

                        objGEOTreeViewlst.AddRange(localLocations.Select(i => new TreeViewItem() { Id = i.BranchID + 30000, Value = string.Concat(i.BranchID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BRANCH), SAPValue = string.Concat(i.BranchID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, CommonConstants.PROMOTION_GEO_TYPE_BRANCH, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.SAPBranchID, CommonConstants.PROMOTION_GEO_TREE_VIEW_SEPERATOR, i.BranchName), Text = i.BranchName, ParentId = (i.AreaID + 20000) }));

                    }


                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }


            return objGEOTreeViewlst.OrderBy(i => i.Text).ToList();
        }

        /// <summary>
        /// Returns the Persona iD for the current promotion
        /// </summary>
        /// <param name="PromotionID"></param>
        /// <returns></returns>
        public int GetPromotionPersonaID(int PromotionID)
        {
            using (PlaybookEntities entity = new PlaybookEntities())
            {
                int? _personaID = 0;
                try
                {
                    _personaID = entity.PBRetailPromotions.First(i => i.PromotionID == PromotionID).PersonaID;
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }

                return _personaID.HasValue ? _personaID.Value : 0;
            }
        }

        public int GetPromotionPersonaID(int PromotionID, ref bool IsNationalAccountPromotion)
        {
            IsNationalAccountPromotion = false;
            using (PlaybookEntities entity = new PlaybookEntities())
            {
                int? _personaID = 0;
                try
                {
                    PBRetailPromotion promotion = entity.PBRetailPromotions.First(i => i.PromotionID == PromotionID);
                    _personaID = promotion.PersonaID;
                    if (promotion.IsNationalAccount.HasValue)
                        IsNationalAccountPromotion = Convert.ToBoolean(promotion.IsNationalAccount);
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }

                return _personaID.HasValue ? _personaID.Value : 0;
            }
        }

        #region Retail Execution

        public DataTable GetRetailExecutionData(PromotionViewFilter objPromotionFilter)
        {
            SqlConnection Conn;
            DataTable objDTPromotions = new DataTable();
            try
            {
                Conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString.ToString());
                Conn.Open();
                SqlCommand DBCmd = new SqlCommand("Playbook.pGetPromotionExecutionDetails", Conn);
                DBCmd.CommandType = CommandType.StoredProcedure;
                DBCmd.Parameters.Add("@StartDate", SqlDbType.Date, 12).Value = objPromotionFilter.StartDate;// Convert.ToDateTime("2014-01-01").Date;
                DBCmd.Parameters.Add("@EndDate", SqlDbType.Date, 12).Value = objPromotionFilter.EndDate; //Convert.ToDateTime("2014 - 12 - 31").Date;
                DBCmd.Parameters.Add("@Branchid", SqlDbType.Int, 10).Value = objPromotionFilter.BranchID;// 84;
                DBCmd.Parameters.Add("@CurrentPersonaID", SqlDbType.Int, 10).Value = objPromotionFilter.CurrentPersonaID;// 5;
                DBCmd.Parameters.Add("@currentuser", SqlDbType.VarChar, 20).Value = objPromotionFilter.GSN;// "BUGTES001";
                DBCmd.Parameters.Add("@AreaID", SqlDbType.Int, 10).Value = objPromotionFilter.AreaID;
                DBCmd.Parameters.Add("@BUID", SqlDbType.Int, 10).Value = objPromotionFilter.BUID;
                DBCmd.Parameters.Add("@RegionID", SqlDbType.Int, 10).Value = objPromotionFilter.RegionID;
                DBCmd.Parameters.Add("@ChainName", SqlDbType.VarChar, 50).Value = objPromotionFilter.SelectedAccount;
                DBCmd.Parameters.Add("@ChannelName", SqlDbType.VarChar, 100).Value = objPromotionFilter.SelectedChannel;
                DBCmd.Parameters.Add("@RouteID", SqlDbType.Int, 10).Value = objPromotionFilter.SelectedRouteID;
                DBCmd.Parameters.Add("@MyRoute", SqlDbType.Bit, 1).Value = objPromotionFilter.IsMyRoute;

                SqlDataReader myDataReader;
                try
                {
                    myDataReader = DBCmd.ExecuteReader();

                    objDTPromotions.Load(myDataReader);
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
                finally
                {
                    Conn.Close();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objDTPromotions;
        }

        public DataTable GetTopChains(int BUID, int RegionID, int AreaID, int BranchID)
        {
            List<UserAccounts> lstAccounts = new List<UserAccounts>();
            SqlConnection Conn;
            DataTable objDTChain = new DataTable();
            try
            {
                Conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString.ToString());
                Conn.Open();
                SqlCommand DBCmd = new SqlCommand("Playbook.pGetTopChainByBU", Conn);
                DBCmd.CommandType = CommandType.StoredProcedure;
                DBCmd.Parameters.Add("@BUID", SqlDbType.Int, 10).Value = BUID;// 84;
                DBCmd.Parameters.Add("@RegionID", SqlDbType.Int, 10).Value = RegionID;// 84;
                DBCmd.Parameters.Add("@AreaID", SqlDbType.Int, 10).Value = AreaID;// 84;
                DBCmd.Parameters.Add("@BranchID", SqlDbType.Int, 10).Value = BranchID;// 84;

                SqlDataReader myDataReader;
                try
                {
                    myDataReader = DBCmd.ExecuteReader();
                    objDTChain.Load(myDataReader);
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
                finally
                {
                    Conn.Close();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objDTChain;
        }

        public DataTable GetPromotionGeoFilter(List<string> BehaviorMembers, int BranchID)
        {
            List<UserAccounts> lstAccounts = new List<UserAccounts>();
            string _GEOtype = BehaviorMembers.Count > 0 ? BehaviorMembers[0] : "BU";
            SqlConnection Conn = null;
            DataTable objDTGeo = new DataTable();
            try
            {
                Conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString.ToString());
                Conn.Open();
                SqlCommand DBCmd = new SqlCommand("Playbook.pGetGeoFilterByBranchID", Conn);
                DBCmd.CommandType = CommandType.StoredProcedure;
                DBCmd.Parameters.Add("@BranchID", SqlDbType.Int, 10).Value = BranchID;// 84;
                DBCmd.Parameters.Add("@GEOType", SqlDbType.VarChar, 20).Value = _GEOtype;// 84;

                SqlDataReader myDataReader;

                myDataReader = DBCmd.ExecuteReader();
                objDTGeo.Load(myDataReader);
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            finally
            {
                if (Conn != null)
                    Conn.Close();
            }
            return objDTGeo;
        }

        /// <summary>
        /// To Get the Promotion Execution Refusal count Data 
        /// </summary>
        /// <param name="objPromotionFilter"></param>
        /// <param name="promotionId"></param>
        /// <returns></returns>
        public DataTable GetPromotionExecutionRefusalDetails(PromotionViewFilter objPromotionFilter, int promotionId)
        {
            SqlConnection Conn;
            DataTable objDTPromotions = new DataTable();
            try
            {
                Conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString.ToString());
                Conn.Open();
                SqlCommand DBCmd = new SqlCommand("Playbook.pGetPromotionExecutionRefusalDetails", Conn);
                DBCmd.CommandType = CommandType.StoredProcedure;
                DBCmd.Parameters.Add("@PromotionID", SqlDbType.Int, 10).Value = promotionId;
                DBCmd.Parameters.Add("@Branchid", SqlDbType.Int, 10).Value = objPromotionFilter.BranchID;
                DBCmd.Parameters.Add("@CurrentPersonaID", SqlDbType.Int, 10).Value = objPromotionFilter.CurrentPersonaID;
                DBCmd.Parameters.Add("@currentuser", SqlDbType.VarChar, 20).Value = objPromotionFilter.GSN;
                DBCmd.Parameters.Add("@AreaID", SqlDbType.Int, 10).Value = objPromotionFilter.AreaID;
                DBCmd.Parameters.Add("@BUID", SqlDbType.Int, 10).Value = objPromotionFilter.BUID;
                DBCmd.Parameters.Add("@RegionID", SqlDbType.Int, 10).Value = objPromotionFilter.RegionID;
                DBCmd.Parameters.Add("@NationalChainID", SqlDbType.Int, 10).Value = objPromotionFilter.SelectedNationalAccountID;
                DBCmd.Parameters.Add("@RegionalChainID", SqlDbType.Int, 10).Value = objPromotionFilter.SelectedRegionalAccountID;
                DBCmd.Parameters.Add("@LocalChainID", SqlDbType.Int, 10).Value = objPromotionFilter.SelectedLocalAccountID;
                DBCmd.Parameters.Add("@RouteID", SqlDbType.Int, 10).Value = objPromotionFilter.SelectedRouteID;
                DBCmd.Parameters.Add("@MyRoute", SqlDbType.Bit, 1).Value = objPromotionFilter.IsMyRoute;

                SqlDataReader myDataReader;
                try
                {
                    myDataReader = DBCmd.ExecuteReader();

                    objDTPromotions.Load(myDataReader);
                }
                catch (Exception ex)
                {
                    ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
                }
                finally
                {
                    Conn.Close();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return objDTPromotions;
        }
        #endregion

        #region Supply Chain
        public string GetPackageNamebyId(string packid)
        {
            string _strPackages = string.Empty;
            try
            {
                using (PlaybookEntities dbContext = new PlaybookEntities())
                {
                    var _packageidAry = packid.Trim(",".ToCharArray()).Split(',');
                    var packageNameList = (from a in dbContext.PBPackages
                                           where _packageidAry.Contains(a.PackageID.ToString())
                                           select a).ToList();
                    _strPackages = string.Join(",", packageNameList.OrderBy(i => i.PackageName).Select(j => j.PackageName).ToArray());
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return _strPackages;
        }

        public string GetTrademarkNamebyId(string trademarkid)
        {
            string _strTrademarks = string.Empty;
            try
            {
                using (PlaybookEntities dbContext = new PlaybookEntities())
                {
                    string[] _trademarkidAry = trademarkid.Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
                    if (_trademarkidAry.Length > 0)
                        _strTrademarks = string.Join(",", (from a in dbContext.PBTradeMarks
                                                           where _trademarkidAry.Contains(a.TradeMarkID.ToString())
                                                           select a.TradeMarkName).ToArray());

                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return _strTrademarks;
        }

        public string GetBranchNamebyId(int branchid)
        {
            string _strbranch = string.Empty;
            try
            {
                using (PlaybookEntities dbContext = new PlaybookEntities())
                {
                    _strbranch = dbContext.PBTLocationChains.Where(i => i.BranchID == branchid).Select(i => i.BranchName).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                ExceptionHelper.LogException(MethodBase.GetCurrentMethod().Name, ex);
            }
            return _strbranch;
        }

        #endregion
    }

}
