using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Common;
using System.Collections;
using System.Data;
using DPSG.Portal.BC.Types;

namespace DPSG.Portal.BC.DAL
{
    public partial class BCRepository
    {

        public int UploadStoreCondition(StoreCondition sc)
        {
            int storeConditionID = 0;
            StoreCondition condition = null;
            using (SDMDataContext db = new SDMDataContext(
                System.Configuration.ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString))
            {
                condition = db.StoreConditions.Where(c => c.GSN == sc.GSN 
                    && c.ConditionDate == sc.ConditionDate 
                    && c.AccountId == sc.AccountId
                    && c.BottlerID == sc.BottlerID).FirstOrDefault();

               

                if (sc.StoreConditionID==0)
                {               
                    if (condition != null)
                    {
                        // Update existing 
                        condition.BCSystemID = sc.BCSystemID;
                        condition.Latitude = sc.Latitude;
                        condition.Longitude = sc.Longitude;
                        condition.StoreNote = sc.StoreNote;
                        condition.BottlerID = sc.BottlerID;
                        condition.CreatedBy = sc.CreatedBy;
                        condition.CreatedDate = sc.CreatedDate;
                        condition.ModifiedBy = sc.ModifiedBy;
                        condition.ModifiedDate = sc.ModifiedDate;
                        condition.IsActive = sc.IsActive;
                        condition.Name = sc.Name;
                        db.SubmitChanges();
                        storeConditionID = condition.StoreConditionID;
                    }
                    else
                    {
                        //Save the new store condtion
                        db.StoreConditions.InsertOnSubmit(sc);
                        db.SubmitChanges();
                        storeConditionID = sc.StoreConditionID;
                    }
                }

                else
                {
                    condition = db.StoreConditions.Where(c => c.StoreConditionID == sc.StoreConditionID).FirstOrDefault();
                   
                        // Update existing 
                        condition.BCSystemID = sc.BCSystemID;
                        condition.Latitude = sc.Latitude;
                        condition.Longitude = sc.Longitude;
                        condition.StoreNote = sc.StoreNote;
                        condition.BottlerID = sc.BottlerID;
                        condition.CreatedBy = sc.CreatedBy;
                        condition.CreatedDate = sc.CreatedDate;
                        condition.ModifiedBy = sc.ModifiedBy;
                        condition.ModifiedDate = sc.ModifiedDate;
                        condition.IsActive = sc.IsActive;
                        condition.Name = sc.Name;
                        db.SubmitChanges();
                        storeConditionID = sc.StoreConditionID;
                    
                }
            }

            return storeConditionID;
        }

        public void UploadBCPromoExecutions(int storeConditionID, List<DPSG.Portal.BC.DAL.PromotionExecution> execs)
        {
            using (SDMDataContext db = new SDMDataContext(
                System.Configuration.ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString))
            {
                db.PromotionExecutions.DeleteAllOnSubmit(db.PromotionExecutions.Where(c => c.StoreConditionID == storeConditionID));
                db.PromotionExecutions.InsertAllOnSubmit(execs);
                db.SubmitChanges();
            }
        }

        public void UploadNotes(int storeConditionID, List<DPSG.Portal.BC.DAL.StoreConditionNote> notes)
        {
            using (SDMDataContext db = new SDMDataContext(
                System.Configuration.ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString))
            {
                //var temp = db.StoreConditionNotes.Where(c => c.StoreConditionID == storeConditionID).ToList();

                //if (db.StoreConditionNotes.Where(c => c.StoreConditionID == storeConditionID).Count() > 0)
                //{
                db.StoreConditionNotes.DeleteAllOnSubmit(db.StoreConditionNotes.Where(c => c.StoreConditionID == storeConditionID));
                //}

                db.StoreConditionNotes.InsertAllOnSubmit(notes);
                db.SubmitChanges();
            }
        }

        public void UploadPriorityAnswers(int storeConditionID, List<DPSG.Portal.BC.DAL.PriorityStoreConditionExecution> priorities)
        {
            using (SDMDataContext db = new SDMDataContext(
                System.Configuration.ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString))
            {
                db.PriorityStoreConditionExecutions.DeleteAllOnSubmit(db.PriorityStoreConditionExecutions.Where(c => c.StoreConditionID == storeConditionID));
                db.PriorityStoreConditionExecutions.InsertAllOnSubmit(priorities);
                db.SubmitChanges();
            }
        }

        public void UploadStoreTieIN(int storeConditionID, List<StoreTieInRate> StoreTieInRate)
        {
            using (SDMDataContext db = new SDMDataContext(
                System.Configuration.ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString))
            {
                db.StoreTieInRates.DeleteAllOnSubmit(db.StoreTieInRates.Where(c => c.StoreConditionID == storeConditionID));
                db.StoreTieInRates.InsertAllOnSubmit(StoreTieInRate);
                db.SubmitChanges();
            }
        }

        public List<UploadedImage> GetNotesImagesToBeDeleted(int storeConditionID)
        {
            List<UploadedImage> retval = new List<UploadedImage>();
            using (SDMDataContext db = new SDMDataContext(
                System.Configuration.ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString))
            {

                retval = db.StoreConditionNotes.Where(c => c.StoreConditionID == storeConditionID)
                    .Select(c => new UploadedImage(){
                       FileUrl = c.ImageURL,
                       ID = c.ImageSharePointID
                    }).ToList();
            }

            return retval;
        }

        public List<UploadedImage> GetDisplayImagesToBeDeleted(int storeConditionID)
        {
            List<UploadedImage> retval = new List<UploadedImage>();
            using (SDMDataContext db = new SDMDataContext(
                System.Configuration.ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString))
            {

                retval = db.StoreConditionDisplays.Where(c => c.StoreConditionID == storeConditionID)
                    .Select(c => new UploadedImage()
                    {
                        FileUrl = c.DisplayImageURL,
                        ID = c.ImageSharePointID
                    }).ToList();
            }

            return retval;
        }

        public void UploadDisplayWithDetails(int storeConditionID, List<StoreConditionDisplay> lDisplay, List<StoreConditionDisplayDetail> lDisplayDetails)
        {
            using (SDMDataContext db = new SDMDataContext(
                System.Configuration.ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString))
            {

                List<String> imageUrlToBeDeleted = db.StoreConditionDisplays.Where(c => c.StoreConditionID == storeConditionID).Select(c => c.DisplayImageURL).ToList();

                db.StoreConditionDisplays.DeleteAllOnSubmit(
                    db.StoreConditionDisplays.Where(c => c.StoreConditionID == storeConditionID));
                
                db.SubmitChanges(); //Delete

                //Insert new ones
                foreach (var d in lDisplay)
                {
                    
                    var details = lDisplayDetails.
                        Where(c => c.ClientDisplayId == d.ClientDisplayID).ToList();
                    d.StoreConditionDisplayDetails.AddRange(details);
                    db.StoreConditionDisplays.InsertOnSubmit(d);
                }
                db.SubmitChanges();

            }
        }

        //public List<int> GetManagementPriorityIDsByBottler(int bottlerID)
        //{
        //    List<int> retval = new List<int>();
        //    using (SDMDataContext db = new SDMDataContext(
        //        System.Configuration.ConfigurationManager.ConnectionStrings["Portal_DataConnection"].ConnectionString))
        //    {
        //        retval = db.pGetManagementPriorityIDsForBottler(bottlerID).ToList().Select(c => c.PriorityID).ToList();
        //    }

        //    return retval;
        //}
    }
}
