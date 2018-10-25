using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DPSG.Portal.BC.BAL;
using DPSG.Portal.BC.Common;
using System.Collections;
using DPSG.Portal.BC.Model;
using System.Net;
using System.IO;
using DPSG.Portal.Framework.CommonUtils;
using System.Text;
using System.Diagnostics;
using SDM = DPSG.Portal.BC.DAL;
using Newtonsoft.Json.Schema;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Configuration;

namespace DPSG.Portal.BC.Services.OperationContract.ServiceWrapper
{
    public class StoreTieIn
    {

        public static DPSG.Portal.BC.Services.DataContract.Account.AdHoc.AdHocResponseDetails UploadAdhocStoreAccount(string json)
        {
            // string JsonSchemaLicenseKey = Constants.JSONNET_SCHEMA_LICENSE; //ConfigurationManager.AppSettings["JsonNetSchemaLicense"];
            // License.RegisterLicense(JsonSchemaLicenseKey);
            //validates JSON Schema to ensure consistent JSON payload
            JSchemaGenerator generator = new JSchemaGenerator();
            JSchema schema = generator.Generate(typeof(DPSG.Portal.BC.Types.Account.AdHoc.AccountSchemaValidate));
            JObject jo = JObject.Parse(json);
            IList<string> messages;
            bool? valild = jo.IsValid(schema, out messages);

            if (valild == false)
            {
                throw new System.ArgumentException(string.Join(",", messages).ToString());
            }

            var obj = new BAL.StoreTieIn();
            var results = new DPSG.Portal.BC.Services.DataContract.Account.AdHoc.AdHocResponseDetails();

            IList<JToken> jsonData = jo["AdhocStoreAccounts"].Children().ToList();

            foreach (JToken item in jsonData)
            {
                DPSG.Portal.BC.Types.Account.AdHoc.Account adhocStore = JsonConvert.DeserializeObject<DPSG.Portal.BC.Types.Account.AdHoc.Account>(item.ToString());
                DPSG.Portal.BC.Types.Account.AdHoc.AccountResponseDetails data = obj.UploadAdhocStoreAccount(adhocStore);
                ((List<DPSG.Portal.BC.Types.Account.AdHoc.AccountResponse>)results.AdhocStoreAccounts).AddRange(data.AdhocStoreAccounts);

            }

            return results;
        }

        public static DPSG.Portal.BC.Services.DataContract.Store.ConditionResponse UploadStoreData(DPSG.Portal.BC.Services.OperationContract.Base serviceBase, string JsonData)
        {

            BC.Common.ExceptionHelper.LogException("UploadStoreData Called", "");
            DPSG.Portal.BC.BAL.StoreTieIn objStore = new BAL.StoreTieIn();

            //StreamReader sr = new StreamReader(@"C:\NTest.txt");   //reading JSON String from Text file
            //JsonData = sr.ReadToEnd();
            //sr.Dispose();
            DPSG.Portal.BC.Services.DataContract.Store.UploadTieIn objlstStoredata = null;
            try
            {
                objlstStoredata = JSONSerelization.Deserialize<DPSG.Portal.BC.Services.DataContract.Store.UploadTieIn>(JsonData);  //for deserialization
            }
            catch (Exception ex)
            {
                BC.Common.ExceptionHelper.LogException(ex, "");
                BC.Common.ExceptionHelper.LogException("Error in Deserialize", "");
            }

            BC.Common.ExceptionHelper.LogException("SP Called", "");
            BC.Common.ExceptionHelper.LogException("ConditionId" + objlstStoredata.StoreCondition.ConditionID.ToString(), "");

            List<DPSG.Portal.BC.Services.DataContract.Store.Condition> conditions = new List<DataContract.Store.Condition>();
            conditions.Add(objlstStoredata.StoreCondition);

            DataContract.Store.ConditionResponse condtionresponse = null;
            int storeConditionID = 0;
            string userGSN = serviceBase.GSN;

            //1. StoreCondition
            List<SDM.StoreCondition> scs = TranslateCondition(conditions, userGSN);
            if (scs.Count > 0)
            {
                storeConditionID = objStore.UploadStoreCondition(scs[0]);
                condtionresponse = new DataContract.Store.ConditionResponse();
                condtionresponse.StoreConditionID = storeConditionID;
            }

            if (storeConditionID > 0)
            {
                //2. Display with Details
                List<SDM.StoreConditionDisplay> lDisplay = new List<SDM.StoreConditionDisplay>();
                List<SDM.StoreConditionDisplayDetail> lDisplayDetails = new List<SDM.StoreConditionDisplayDetail>();
                TranslateDisplayWithDetails(lDisplay, lDisplayDetails, objlstStoredata, storeConditionID, userGSN);
                //For previous display, MyDay should resend, otherwise the existing gets deleted.
                objStore.UploadStoreDisplayWithDetails(storeConditionID, lDisplay, lDisplayDetails);

                if (lDisplay.Count == 0)
                {
                    lDisplay.Add(new SDM.StoreConditionDisplay() { DisplayImageURL = "", ClientDisplayID = 0, StoreConditionDisplayID = 0, StoreConditionID = 0 });
                }

                condtionresponse.StoreConditionDisplays = lDisplay
                    .Select(c => new DataContract.Store.StoreConditionDisplay
                    {
                        ClientStoreConditionDisplayID = c.ClientDisplayID,
                        DisplayImageURL = c.DisplayImageURL,
                        StoreConditionDisplayID = c.StoreConditionDisplayID,
                        ImageName = string.IsNullOrEmpty(c.DisplayImageURL) ? String.Empty : c.DisplayImageURL.Split('/').Last()
                    }).ToList();

                //3. Store tie in rate
                List<SDM.StoreTieInRate> lTieInRate = TranslateTieInRate(objlstStoredata, storeConditionID, userGSN);
                objStore.UploadStoreTieIN(storeConditionID, lTieInRate);
                BC.Common.ExceptionHelper.LogException("Information: UploadStoreTieIN completed " + storeConditionID.ToString(), "");

                //4. Store Notes
                List<DPSG.Portal.BC.DAL.StoreConditionNote> notes = TranslateNotes(serviceBase, objlstStoredata, storeConditionID);
                if (notes.Count > 0)
                {
                    objStore.UploadStoreNotes(storeConditionID, notes);

                    if (notes.Count == 0)
                    {
                        notes.Add(new SDM.StoreConditionNote() { NoteID = 0, ImageURL = string.Empty, ClientNoteID = "0", StoreConditionID = storeConditionID, Note = string.Empty });
                    }

                    condtionresponse.StoreConditionNotes = notes
                        .Select(c => new DataContract.Store.StoreConditionNote()
                        {
                            ClientStoreConditionNoteID = c.ClientNoteID,
                            ImageName = c.ImageName,
                            NoteImageURL = c.ImageURL,
                            StoreConditionNoteID = c.NoteID
                        }).ToList();
                    BC.Common.ExceptionHelper.LogException("Information: StoreConditionNote found " + storeConditionID.ToString(), "");
                }

                BC.Common.ExceptionHelper.LogException("Information: UploadStoreNotes completed " + storeConditionID.ToString(), "");

                //5. BC Promotion Execution ---
                List<DPSG.Portal.BC.DAL.PromotionExecution> executions = TranslatePromotionExecution(objlstStoredata, userGSN, lDisplay, storeConditionID);
                //If not execution found, will delete the previous ones in the condition
                if (executions.Count > 0)
                {
                    objStore.UploadPromotionExecution(storeConditionID, executions);
                    condtionresponse.PromotionExecutions = executions
                        .Select(c => new DataContract.Store.PromotionExecution()
                        {
                            ClientPromotionExecutionID = c.ClientPromotionExecutionID,
                            ClientStoreConditionDisplayID = c.ClientDisplayID,
                            StoreConditionDisplayID = c.StoreConditionDisplayID,
                            PromotionExecutionID = c.ExecutionID,
                        }).ToList();
                    BC.Common.ExceptionHelper.LogException("Information: PromotionExecution found " + storeConditionID.ToString(), "");
                }
                BC.Common.ExceptionHelper.LogException("Information: UploadPromotionExecution completed " + storeConditionID.ToString(), "");

                //6. Priority Answers ---
                List<DPSG.Portal.BC.DAL.PriorityStoreConditionExecution> answers = TranslatePriorityAnswers(serviceBase, objlstStoredata, storeConditionID);
                if (answers.Count > 0)
                {
                    //The side effect of delete is there
                    objStore.UploadPriorityAnswers(storeConditionID, answers);
                    condtionresponse.PriorityExecutions = answers
                        .Select(c => new DataContract.Store.PriorityExecution
                        {
                            ClientPriorityExecutionID = c.ClientPriorityExecutionID,
                            PriorityExecutionID = c.PriorityExecutionID
                        }).ToList();
                    BC.Common.ExceptionHelper.LogException("Information: PriorityAnswers found " + storeConditionID.ToString(), "");
                }
                BC.Common.ExceptionHelper.LogException("Information: UploadPriorityAnswers completed " + storeConditionID.ToString(), "");

            }

            return condtionresponse;
        }

        private static List<SDM.PriorityStoreConditionExecution> TranslatePriorityAnswers(DPSG.Portal.BC.Services.OperationContract.Base serviceBase, DPSG.Portal.BC.Services.DataContract.Store.UploadTieIn objlstStoredata, int storeConditionID)
        {
            List<DPSG.Portal.BC.DAL.PriorityStoreConditionExecution> answers = new List<DAL.PriorityStoreConditionExecution>();

            if (objlstStoredata.StoreCondition.PriorityAnswers != null)
            {
                foreach (var v in objlstStoredata.StoreCondition.PriorityAnswers)
                {
                    DPSG.Portal.BC.DAL.PriorityStoreConditionExecution answer = new DAL.PriorityStoreConditionExecution();
                    answer.Created = DateTime.UtcNow;
                    answer.CreatedBy = serviceBase.GSN;
                    answer.LastModified = DateTime.UtcNow;
                    answer.LastModifiedBy = serviceBase.GSN;
                    answer.ManagementPriorityID = v.ManagementPriorityID;
                    answer.PriorityExecutionStatusID = v.PriorityExecutionStatusID;
                    answer.StoreConditionID = storeConditionID;
                    answer.ClientPriorityExecutionID = v.ClientPriorityExecutionID;

                    answers.Add(answer);
                }
            }

            return answers;
        }

        private static List<SDM.PromotionExecution> TranslatePromotionExecution(DPSG.Portal.BC.Services.DataContract.Store.UploadTieIn objlstStoredata,
            string userGSN,
            List<SDM.StoreConditionDisplay> lDisplays,
            int storeConditionID)
        {
            List<DPSG.Portal.BC.DAL.PromotionExecution> executions = new List<DAL.PromotionExecution>();
            if (objlstStoredata.StoreCondition.PromotionExecutions != null)
            {
                foreach (var v in objlstStoredata.StoreCondition.PromotionExecutions)
                {
                    DPSG.Portal.BC.DAL.PromotionExecution execution = new DAL.PromotionExecution();
                    execution.ClientDisplayID = v.ClientDisplayID;
                    execution.PromotionID = v.PromotionID;
                    execution.StoreConditionID = storeConditionID;
                    execution.PromotionExecutionStatusID = v.PromotionExecutionStatusID;
                    execution.Created = DateTime.UtcNow;
                    execution.LastModified = DateTime.UtcNow;
                    execution.CreatedBy = userGSN;
                    execution.LastModifiedBy = userGSN;
                    execution.ClientPromotionExecutionID = v.ClientPromotionExecutionID;
                    execution.Comments = v.Comments;

                    var display = lDisplays.SingleOrDefault(c => c.ClientDisplayID.ToString() == v.ClientDisplayID);

                    if (display != null)
                    {
                        execution.StoreConditionDisplayID = display.StoreConditionDisplayID;
                    }
                    else
                    {
                        execution.StoreConditionDisplayID = null;
                    }

                    executions.Add(execution);
                }
            }
            return executions;
        }

        private static List<SDM.StoreConditionNote> TranslateNotes(DPSG.Portal.BC.Services.OperationContract.Base serviceBase, DPSG.Portal.BC.Services.DataContract.Store.UploadTieIn objlstStoredata, int storeConditionID)
        {
            List<DPSG.Portal.BC.DAL.StoreConditionNote> notes = new List<DAL.StoreConditionNote>();
            try
            {
                if (objlstStoredata.StoreCondition != null && objlstStoredata.StoreCondition.StoreNotes != null)
                {
                    foreach (var v in objlstStoredata.StoreCondition.StoreNotes)
                    {
                        DPSG.Portal.BC.DAL.StoreConditionNote note = new DAL.StoreConditionNote();
                        note.Note = v.NoteDescription;
                        note.Created = DateTime.UtcNow;
                        note.CreatedBy = serviceBase.GSN;
                        note.LastModified = DateTime.UtcNow;
                        note.LastModifiedBy = serviceBase.GSN;
                        note.ImageBytes = v.ImageBytes;
                        note.ClientNoteID = v.ClientNoteID;
                        note.StoreConditionID = storeConditionID;

                        notes.Add(note);
                    }
                }
            }
            catch (Exception ex)
            {
                BC.Common.ExceptionHelper.LogException("Exception: Note couldn't be initialized. " + ex.Message, "");
            }
            return notes;
        }

        private static List<SDM.StoreTieInRate> TranslateTieInRate(DPSG.Portal.BC.Services.DataContract.Store.UploadTieIn objlstStoredata, int storeContionID, string userGSN)
        {
            List<SDM.StoreTieInRate> lTieInRate = new List<SDM.StoreTieInRate>();
            foreach (DataContract.Store.TieInRate t in objlstStoredata.StoreCondition.StoreTieInRates)
            {
                SDM.StoreTieInRate _storeTieIn = new SDM.StoreTieInRate();
                _storeTieIn.SystemBrandId = (int)t.SystemBrandId;
                _storeTieIn.TieInRate = t.SysTieInRate;
                _storeTieIn.TotalDisplays = t.TotalPOICount;
                _storeTieIn.CreatedBy = userGSN;
                _storeTieIn.CreatedDate = DateTime.UtcNow;
                _storeTieIn.ModifiedBy = userGSN;
                _storeTieIn.ModifiedDate = DateTime.UtcNow;
                _storeTieIn.IsActive = true;
                _storeTieIn.StoreConditionID = storeContionID;

                lTieInRate.Add(_storeTieIn);
            }
            return lTieInRate;
        }

        private static void TranslateDisplayWithDetails(List<SDM.StoreConditionDisplay> lDisplay, List<SDM.StoreConditionDisplayDetail> lDisplayDetails, DPSG.Portal.BC.Services.DataContract.Store.UploadTieIn objlstStoredata, int storeContionID, string userGSN)
        {
            // StoreConditionDisplay
            foreach (DataContract.Store.Display d in objlstStoredata.StoreCondition.StoreDisplays)
            {
                SDM.StoreConditionDisplay _storeConditiondisp = new SDM.StoreConditionDisplay();
                _storeConditiondisp.DisplayLocationID = d.DisplayLocationID;
                if (d.PromotionID == null || d.PromotionID == -1 || d.PromotionID == 0)
                {
                    _storeConditiondisp.PromotionID = null;
                }
                else
                {
                    _storeConditiondisp.PromotionID = d.PromotionID;
                }
                _storeConditiondisp.DisplayLocationNote = d.DisplayLocationNote;
                _storeConditiondisp.OtherNote = d.OtherNote;
                _storeConditiondisp.DisplayImageURL = "";
                _storeConditiondisp.ReasonID = Convert.ToInt32(d.ReasonID);
                _storeConditiondisp.DisplayTypeID = d.DisplayTypeID;
                _storeConditiondisp.ImageBytes = d.ImageBytes;
                _storeConditiondisp.GridX = d.GridX;
                _storeConditiondisp.GridY = d.GridY;
                _storeConditiondisp.ClientDisplayID = d.ClientDisplayID;
                _storeConditiondisp.CreatedBy = userGSN;
                _storeConditiondisp.CreatedDate = DateTime.Now;
                _storeConditiondisp.ModifiedBy = userGSN;
                _storeConditiondisp.ModifiedDate = DateTime.Now;
                _storeConditiondisp.IsActive = true;
                _storeConditiondisp.StoreConditionID = storeContionID;
                _storeConditiondisp.TieInFairShareStatusID = d.IsFairShare;
                _storeConditiondisp.DPTieInFlag = d.DPTieInFlag;

                lDisplay.Add(_storeConditiondisp);

                foreach (DataContract.Store.DisplayDetails ddl in d.StoreDisplayDetails)
                {
                    SDM.StoreConditionDisplayDetail _storeConditiondispdtl = new SDM.StoreConditionDisplayDetail();
                    _storeConditiondispdtl.SystemPackageID = ddl.SystemPackageID;
                    _storeConditiondispdtl.SystemBrandID = ddl.SystemBrandID;
                    _storeConditiondispdtl.CreatedBy = userGSN;
                    _storeConditiondispdtl.CreatedDate = DateTime.Now;
                    _storeConditiondispdtl.ModifiedBy = userGSN;
                    _storeConditiondispdtl.ModifiedDate = DateTime.Now;
                    _storeConditiondispdtl.IsActive = true;
                    _storeConditiondispdtl.ClientDisplayId = d.ClientDisplayID;


                    lDisplayDetails.Add(_storeConditiondispdtl);
                }
            }
        }

        private static List<SDM.StoreCondition> TranslateCondition(List<DPSG.Portal.BC.Services.DataContract.Store.Condition> conditions, string userGSN)
        {
            List<SDM.StoreCondition> retval = null;
            int value;

            // Store Condtion
            retval = conditions.Select(c => new SDM.StoreCondition()
            {
                AccountId = c.StoreID,
                ConditionDate = Convert.ToDateTime(c.ConditionDate),
                GSN = c.GSN,
                BCSystemID = c.SDMNodeID,
                Longitude = c.Longitude,
                Latitude = c.Latitude,
                StoreNote = c.StoreNote,
                BottlerID = c.BottlerID,
                CreatedBy = userGSN,
                CreatedDate = DateTime.Now,
                ModifiedBy = userGSN,
                ModifiedDate = DateTime.Now,
                IsActive = true,
                Name = c.Name,
                StoreConditionID = c.ConditionID//(int.TryParse(c.ConditionID.ToString(), out value))==true?c.ConditionID:0 

            }).ToList();

            return retval;
        }
    }
}