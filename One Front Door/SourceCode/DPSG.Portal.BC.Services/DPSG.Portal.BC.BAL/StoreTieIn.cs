using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Portal.BC.Model;
using Microsoft.SharePoint.Client;
using DPSG.Portal.BC.BAL.DwsSoapClientRef;
using System.Security.Principal;
using System.Diagnostics;
using System.ServiceModel;
using DPSG.Portal.BC.BAL.CopyFileServiceRef;
using System.Configuration;
using System.Web.Configuration;
using DPSG.Portal.BC.BAL.ImageClientRef;
using DPSG.Portal.BC.Common;
using System.Reflection;
using System.Xml;
using System.Xml.Linq;
using System.Collections;
using DPSG.Portal.BC.DAL;

namespace DPSG.Portal.BC.BAL
{
    public class StoreTieIn : Base
    {
        #region Properties
        private ImagingReference.Imaging ImagWebService
        {
            get
            {
                ImagingReference.Imaging imgws = new ImagingReference.Imaging();
                imgws.Credentials = System.Net.CredentialCache.DefaultCredentials;
                string _SiteURL = WebConfigurationManager.AppSettings["SiteURL"].ToString();
                imgws.Url = _SiteURL + "_vti_bin/Imaging.asmx";
                return imgws;
            }
        }

        private ListService.Lists listWebService
        {
            get
            {
                ListService.Lists listWebService = new ListService.Lists();
                listWebService.Credentials = System.Net.CredentialCache.DefaultCredentials;
                string _SiteURL = WebConfigurationManager.AppSettings["SiteURL"].ToString();
                listWebService.Url = _SiteURL + "_vti_bin/Lists.asmx";

                return listWebService;
            }
        }

        private string _ImgLibName = WebConfigurationManager.AppSettings["ImageLibraryNm"];
        private string _SiteURL = WebConfigurationManager.AppSettings["SiteURL"];
        private string _fileExtension = WebConfigurationManager.AppSettings["fileExtension"];
        private string _SiteName = WebConfigurationManager.AppSettings["SiteName"];
        private string logFileName = WebConfigurationManager.AppSettings["LogFileName"];
        private string copyStoreTieInImage = WebConfigurationManager.AppSettings["CopyStoreTieInImage"];

        public StoreTieIn()
        {
            string _ImgLibName = WebConfigurationManager.AppSettings["ImageLibraryNm"].ToString();
            string _SiteURL = WebConfigurationManager.AppSettings["SiteURL"].ToString();
            string _fileExtension = WebConfigurationManager.AppSettings["fileExtension"].ToString();
            string _SiteName = WebConfigurationManager.AppSettings["SiteName"].ToString();
            string logFileName = WebConfigurationManager.AppSettings["LogFileName"];
            string copyStoreTieInImage = WebConfigurationManager.AppSettings["CopyStoreTieInImage"];
        }

        #endregion


        public int UploadStoreCondition(DAL.StoreCondition storeCondition)
        {
            int storeConditionID = -1;
            try
            {
                storeConditionID = oBCRepository.UploadStoreCondition(storeCondition);
                BC.Common.ExceptionHelper.LogException(string.Format("New store condtions saved for condition ID : {0}", storeConditionID.ToString()), string.Empty);
                return storeConditionID;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public DPSG.Portal.BC.Types.Account.AdHoc.AccountResponseDetails UploadAdhocStoreAccount(DPSG.Portal.BC.Types.Account.AdHoc.Account adhocStore)
        {
            var results = new DPSG.Portal.BC.Types.Account.AdHoc.AccountResponseDetails();
            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            try
            {
                results = oBCRepository.UploadAdhocStoreAccount(adhocStore);
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

        public void UploadStoreNotes(int storeConditionID, List<DAL.StoreConditionNote> notes)
        {
            try
            {
                var imagesToBeDeleted = oBCRepository.GetNotesImagesToBeDeleted(storeConditionID);

                SaveNoteImage(storeConditionID, notes);
                oBCRepository.UploadNotes(storeConditionID, notes);
                DeleteAllOphanedImages(imagesToBeDeleted);

                BC.Common.ExceptionHelper.LogException(string.Format("{0} New store notes saved for condition {1}", notes.Count().ToString(), storeConditionID.ToString()), string.Empty);
            }
            catch (Exception)
            {                
                throw;
            }
        }

        public void UploadPromotionExecution(int storeConditionID, List<DAL.PromotionExecution> executions)
        {
            try
            {
                oBCRepository.UploadBCPromoExecutions(storeConditionID, executions);
                BC.Common.ExceptionHelper.LogException(string.Format("{0} New store promotion execution status saved for condition {1}", executions.Count().ToString(), storeConditionID.ToString()), string.Empty);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void UploadPriorityAnswers(int storeConditionID, List<DAL.PriorityStoreConditionExecution> answers)
        {
            try
            {
                oBCRepository.UploadPriorityAnswers(storeConditionID, answers);
                BC.Common.ExceptionHelper.LogException(string.Format("{0} New priority question answers saved for condition {1}", answers.Count().ToString(), storeConditionID.ToString()), string.Empty);
            }
            catch (Exception)
            {
                throw;
            }
        }
        
        public void UploadStoreDisplayWithDetails(int storeConditionID, List<DAL.StoreConditionDisplay> lDisplay, List<DAL.StoreConditionDisplayDetail> lDisplayDetails)
        {
            try
            {
                var imagesToBeDeleted = oBCRepository.GetDisplayImagesToBeDeleted(storeConditionID);

                SaveDisplayImage(storeConditionID, lDisplay);
                oBCRepository.UploadDisplayWithDetails(storeConditionID, lDisplay, lDisplayDetails);
                imagesToBeDeleted = imagesToBeDeleted.Where(c => !String.IsNullOrWhiteSpace(c.FileUrl)).ToList();
                DeleteAllOphanedImages(imagesToBeDeleted);
                BC.Common.ExceptionHelper.LogException(string.Format("{0} New displays saved for condition {1}", lDisplay.Count().ToString(), storeConditionID.ToString()), string.Empty);
            }
            catch (Exception)
            {
                throw;
            }
        }

        private void DeleteAllOphanedImages(List<UploadedImage> imagesToBeDeleted)
        {
            foreach (var v in imagesToBeDeleted)
            {
                if (!string.IsNullOrWhiteSpace(v.ID))
                {
                    DeleteImageByName(_ImgLibName, v.FileUrl, v.ID);
                }
            }
        }

        public void UploadStoreTieIN(int storeConditionID, List<DAL.StoreTieInRate> lTieInRate)
        {
            try
            {
                oBCRepository.UploadStoreTieIN(storeConditionID, lTieInRate);
                BC.Common.ExceptionHelper.LogException(string.Format("{0} Store TieIn saved for condition {1}", lTieInRate.Count().ToString(), storeConditionID.ToString()), string.Empty);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void SaveDisplayImage(int storeConditionID, List<DAL.StoreConditionDisplay> displays)
        {
            BC.Common.ExceptionHelper.LogException("InStoretieimage - displayimage", "");

            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            BC.Common.ExceptionHelper.LogException("3", "");
            try
            {
                //Creating folder for images
                string folderUrl = "";
                folderUrl = GetDestinationFolder(storeConditionID);

                string[] _arrfolderurl = folderUrl.Split('/');
                BC.Common.ExceptionHelper.LogException("4", "");

                foreach (DAL.StoreConditionDisplay dis in displays)
                {
                    string imageByte = dis.ImageBytes;
                    string fileNamePrefix = string.Empty;
                    string imageClientID = dis.ClientDisplayID.ToString();

                    if (string.IsNullOrEmpty(imageByte))
                    {
                        dis.DisplayImageURL = string.Empty;
                        dis.ImageSharePointID = "-1";
                    }
                    else 
                    {
                        var uploadedImage = UploadImageToSharePoint(folderUrl, _arrfolderurl, imageByte, fileNamePrefix, imageClientID, storeConditionID);
                        dis.DisplayImageURL = uploadedImage.FileUrl;
                        dis.ImageSharePointID = uploadedImage.ID;
                    }

                    BC.Common.ExceptionHelper.LogException("6", "");
                }
            }
            catch (Exception ex)
            {

                BC.Common.ExceptionHelper.LogException(ex, "");
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }
        }
        
        public void SaveNoteImage(int storeConditionID, List<DAL.StoreConditionNote> storeNotes)
        {
            BC.Common.ExceptionHelper.LogException("InStoretieimage", "");

            objServiceLog.ServiceName = Constants.SERVICE_NAME;
            objServiceLog.OperationName = MethodBase.GetCurrentMethod().Name;
            objServiceLog.ModifiedDate = System.DateTime.Now;
            objServiceLog.GSN = GSN;
            objServiceLog.Type = "Info";
            objServiceLog.GUID = ServiceContext.CallID;

            BC.Common.ExceptionHelper.LogException("3", "");
            try
            {
                //Creating folder for images
                string folderUrl = "";
                folderUrl = GetDestinationFolder(storeConditionID);

                string[] _arrfolderurl = folderUrl.Split('/');
                BC.Common.ExceptionHelper.LogException("4", "");

                foreach (DAL.StoreConditionNote note in storeNotes)
                {
                    string imageByte = note.ImageBytes;
                    string fileNamePrefix = "note";
                    string imageClientID = note.ClientNoteID.ToString();

                    if (string.IsNullOrWhiteSpace(imageByte))
                    {
                        note.ImageURL = string.Empty;
                        note.ImageSharePointID = "-1";
                        note.ImageName = string.Empty;
                    }
                    else
                    {
                        var uploadedImage = UploadImageToSharePoint(folderUrl, _arrfolderurl, imageByte, fileNamePrefix, imageClientID, storeConditionID);

                        note.ImageURL = uploadedImage.FileUrl;
                        note.ImageSharePointID = uploadedImage.ID;
                        note.ImageName = uploadedImage.FileUrl.Split('/').Last();
                    }
                    BC.Common.ExceptionHelper.LogException("6", "");
                }
            }
            catch (Exception ex)
            {
                BC.Common.ExceptionHelper.LogException(ex, "");
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }
        }

        private DPSG.Portal.BC.DAL.UploadedImage UploadImageToSharePoint(string folderUrl, string[] _arrfolderurl, string imageByte, string fileNamePrefix, string imageClientID, int storeConditionID)
        {
            BC.Common.ExceptionHelper.LogException("5", "");
            DPSG.Portal.BC.DAL.UploadedImage retval = null;

            try
            {
                string url = _SiteURL + _ImgLibName + folderUrl;
                string fileName = Stopwatch.GetTimestamp().ToString() + "_" + fileNamePrefix + imageClientID + _fileExtension;
                string[] destinationUrl = { url + fileName };
                byte[] content = imageByte == null ? null : Convert.FromBase64String(imageByte); //null;

                try
                {
                    if (copyStoreTieInImage == "1")
                    {
                        //Saving contents to file
                        var bw = new System.IO.BinaryWriter(System.IO.File.Open(System.IO.Path.GetDirectoryName(logFileName) + "\\" + fileName, System.IO.FileMode.OpenOrCreate));
                        bw.Write(content);
                        bw.Close();
                    }
                }
                catch (Exception ex)
                {
                    BC.Common.ExceptionHelper.LogException(ex, "");
                }

                if (content != null)
                {
                    if (_arrfolderurl.Length > 2)
                        retval = UploadFileToLibrary(_SiteURL, content, _ImgLibName, fileName, _arrfolderurl[1].ToString(), _arrfolderurl[2].ToString(), storeConditionID, _SiteName);
                }
            }
            catch (Exception ex)
            {
                BC.Common.ExceptionHelper.LogException(ex, "");
                objServiceLog.Exception = GetException(ex);
                oBCRepository.InsertWebServiceLog(objServiceLog);
                throw ex;
            }
            return retval;
        }

        private DPSG.Portal.BC.DAL.UploadedImage UploadFileToLibrary(string SiteURL, byte[] image, string ListName, string FileName, string RootFolder, string SubFolder, int StoreCondtionID, string SiteName)
        {
            UploadedImage retval = new UploadedImage()
            {
                FileUrl = string.Empty,
                ID = string.Empty
            };

            try
            {
                bool errorCreatingFolder = false;
                string xmlCommand;
                
                DPSG.Portal.BC.Common.ExceptionHelper.LogException("RootFolder", RootFolder);
                DPSG.Portal.BC.Common.ExceptionHelper.LogException("SubFolder", SubFolder);

                try
                {
                    DPSG.Portal.BC.Common.ExceptionHelper.LogException("checkFolderExists false", "");
                    DPSG.Portal.BC.Common.ExceptionHelper.LogException("<Method ID='1' Cmd='New'><Field Name='FSObjType'>1</Field><Field Name='BaseName'>" + RootFolder + "</Field><Field Name='ID'>New</Field></Method>", "");

                    XmlDocument doc = new XmlDocument();
                    xmlCommand = "<Method ID='1' Cmd='New'><Field Name='FSObjType'>1</Field><Field Name='BaseName'>" + RootFolder + "</Field><Field Name='ID'>New</Field></Method>";
                    XmlElement ele = doc.CreateElement("Batch");
                    ele.SetAttribute("OnError", "Continue");
                    ele.InnerXml = xmlCommand;
                    listWebService.Credentials = System.Net.CredentialCache.DefaultCredentials;

                    XmlNode node1 = listWebService.UpdateListItems(ListName, ele);
                    DPSG.Portal.BC.Common.ExceptionHelper.LogException("Folder created", "");
                }
                catch (Exception ex)
                {
                    DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "Error creating folder");
                    errorCreatingFolder = true;
                }

                
                try
                {
                    if (errorCreatingFolder == false)
                    {
                        if (SubFolder.Trim() != "")
                        {
                            CreateFolder(ListName, RootFolder, SubFolder, SiteURL);
                        }
                    }
                }
                catch (Exception ex)
                {
                    DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "Error creating sub folder");
                    errorCreatingFolder = true;
                }

                
                string folderPath = string.Empty;

                if (SubFolder != "")
                    folderPath = RootFolder + "/" + SubFolder;
                else
                    folderPath = RootFolder;

                if (errorCreatingFolder)
                    folderPath = "";//Copying to root folder

                DPSG.Portal.BC.Common.ExceptionHelper.LogException("Path : ", folderPath);

                // Delete the uploaded image if storecondtionID exists
              //  DeleteImageByStoreCondtionID(SiteName, ListName, StoreCondtionID);

                //Upload image into the library
                XmlNode ImgUpd = ImagWebService.Upload(ListName, folderPath, image, FileName, true);

                //Updating the store condition id
                try
                {
                    //return xml data of the uploaded file 
                    XmlNode fileInfo = ImagWebService.GetItemsXMLData(ListName, folderPath, new[] { FileName });

                    //read the xml and retrun ID of the uploaded image 
                    var x = XDocument.Parse(fileInfo.InnerXml);
                    string ns = "http://schemas.microsoft.com/sharepoint/soap/ois/";
                    IEnumerable<XElement> items = x.Descendants(XName.Get("item", ns));

                    var i = from element in items
                            select (string)element.Attribute("ID").Value;
                    string ID = i.ElementAt(0);
                    retval.ID = ID;

                    //Update StorecondtionID column for the uploaded image in the library
                    UpdateListItem(ListName, ID, StoreCondtionID);
                }
                catch (Exception ex) { DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "Error updating store conditionid"); }

                if (folderPath == "")
                    retval.FileUrl = SiteURL + ListName + "/" + FileName;
                else
                    retval.FileUrl = SiteURL + ListName + "/" + folderPath + "/" + FileName;
            }
            catch (Exception ex)
            {
                BC.Common.ExceptionHelper.LogException(ex, "");
                throw (new Exception("Error uploading image to library."));
            }

            return retval;
        }

        private void DeleteImageByStoreCondtionID(string SiteName, string ListName, int StoreCondtionID)
        {
            try
            {
                string ID = string.Empty;
                string imagename = string.Empty;

                XmlDocument xDoc = new XmlDocument();
                XmlNode Query = xDoc.CreateNode(XmlNodeType.Element, "Query","");
                XmlNode QueryOptions = xDoc.CreateNode(XmlNodeType.Element, "QueryOptions", "");

                Query.InnerXml = "<Where><Eq><FieldRef Name='StoreConditionId' /><Value Type='Text'>" + StoreCondtionID + "</Value></Eq></Where>";

                QueryOptions.InnerXml = "<QueryOptions><ViewAttributes Scope='RecursiveAll'/></QueryOptions>";

                XmlNode resultNode = listWebService.GetListItems(ListName, string.Empty, Query, null, null, QueryOptions, null);

                foreach (System.Xml.XmlNode node in resultNode)
                {
                    if (node.Name == "rs:data")
                    {
                        for (int i = 0; i < node.ChildNodes.Count; i++)
                        {
                            if (node.ChildNodes[i].Name == "z:row")
                            {
                                try
                                {
                                    ID = node.ChildNodes[i].Attributes["ows_ID"].Value;
                                    imagename = SiteName + "" + node.ChildNodes[i].Attributes["ows_RequiredField"].Value;                                  
                                }
                                catch
                                {

                                }
                            }
                        }
                       
                    }
                }

                //Delete Image from library 
                string strBatch = "<Method ID='3' Cmd='Delete'>" +
                                  "<Field Name='ID'>" + ID + "</Field>" +
                                  "<Field Name='FileRef'>" + imagename + "</Field></Method>";

                XmlDocument xmlDoc = new System.Xml.XmlDocument();
                System.Xml.XmlElement elBatch = xmlDoc.CreateElement("Batch");
                elBatch.SetAttribute("OnError", "Continue");
                elBatch.SetAttribute("ListVersion", "1");

                elBatch.InnerXml = strBatch;
                XmlNode ndReturn = listWebService.UpdateListItems(ListName, elBatch);

            }
            catch (Exception ex)
            {

            }
        }

        private void DeleteImageByName(string ListName, string imageName, string ID)
        {
            string strBatch = "<Method ID='3' Cmd='Delete'>" +
                  "<Field Name='ID'>" + ID + "</Field>" +
                  "<Field Name='FileRef'>" + imageName + "</Field></Method>";

            XmlDocument xmlDoc = new System.Xml.XmlDocument();
            System.Xml.XmlElement elBatch = xmlDoc.CreateElement("Batch");
            elBatch.SetAttribute("OnError", "Continue");
            elBatch.SetAttribute("ListVersion", "1");

            elBatch.InnerXml = strBatch;
            XmlNode ndReturn = listWebService.UpdateListItems(ListName, elBatch);
        }

        private void UpdateListItem(string ListName, string ID, int StoreCondtionID)
        {
            try
            {
                string strBatch = "<Method ID='1' Cmd='Update'>" +
                     "<Field Name='ID'>" + ID + "</Field>" +
                    "<Field Name='StoreConditionId'>" + StoreCondtionID + "</Field></Method>";

                XmlDocument xmlDoc = new System.Xml.XmlDocument();
                System.Xml.XmlElement elBatch = xmlDoc.CreateElement("Batch");
                elBatch.SetAttribute("OnError", "Continue");
                elBatch.SetAttribute("ListVersion", "1");

                elBatch.InnerXml = strBatch;
                XmlNode ndReturn = listWebService.UpdateListItems(ListName, elBatch);
            }
            catch (Exception ex)
            {

            }

        }

        private void CreateFolder(string listName, string rootSubFolderName, string newFolderName, string SiteURL)
        {
            try
            {
                SiteURL = SiteURL.Trim("/".ToCharArray());
                ListService.Lists ws = new ListService.Lists();
                ws.Credentials = System.Net.CredentialCache.DefaultCredentials;
                string _SiteURL = WebConfigurationManager.AppSettings["SiteURL"].ToString();
                ws.Url = _SiteURL + "_vti_bin/Lists.asmx";

                newFolderName = newFolderName.Replace(":", "_");
                string rootFolder = rootSubFolderName.Length > 0 ? string.Format("/{0}/{1}", listName, rootSubFolderName) : listName;
                string xmlCommand = string.Format("<Method ID='1' Cmd='New'><Field Name='ID'>New</Field><Field Name='FSObjType'>1</Field><Field Name='BaseName'>{1}</Field></Method>", rootFolder, newFolderName);
                if (!rootFolder.StartsWith("/"))
                    rootFolder = string.Format("/{0}", rootFolder);

                XmlDocument xmlDoc = new System.Xml.XmlDocument();
                System.Xml.XmlElement elBatch = xmlDoc.CreateElement("Batch");
                elBatch.SetAttribute("OnError", "Continue");
                elBatch.SetAttribute("RootFolder", @SiteURL + rootFolder);
                elBatch.InnerXml = xmlCommand;
                XmlNode resultNode1 = ws.UpdateListItems(listName, elBatch);

                DPSG.Portal.BC.Common.ExceptionHelper.LogException("Sub Folder created", "");
            }
            catch (Exception ex)
            {
                DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "");
                throw (ex);
            }
        }

        private bool checkFolderExists(string RootFolder, string ListName)
        {
            bool IsFolderExists = false;
            try
            {
                string strViewGUID = "";
                XmlDocument xmlDoc = new XmlDocument();
                XmlNode query = xmlDoc.CreateNode(XmlNodeType.Element, "Query", "");
                XmlNode viewFields = xmlDoc.CreateNode(XmlNodeType.Element, "ViewFields", "");
                XmlNode queryOptions = xmlDoc.CreateNode(XmlNodeType.Element, "QueryOptions", "");
                query.InnerXml = "";
                viewFields.InnerXml = "";
                queryOptions.InnerXml = "<IncludeAttachmentUrls>TRUE</IncludeAttachmentUrls>";
                System.Xml.XmlNode nodeListItems = listWebService.GetListItems(ListName, strViewGUID, query, viewFields, "1000", queryOptions, null);

                XmlDocument doc = new XmlDocument();
                doc.LoadXml(nodeListItems.InnerXml);
                XmlNamespaceManager nsmgr = new XmlNamespaceManager(doc.NameTable);
                nsmgr.AddNamespace("z", "#RowsetSchema");
                nsmgr.AddNamespace("rs", "urn:schemas-microsoft-com:rowset");

                foreach (XmlNode node in doc.SelectNodes("/rs:data/z:row", nsmgr))
                {
                    if (node.Attributes["ows_NameOrTitle"].Value.ToLower() == RootFolder)
                    {
                        IsFolderExists = true;
                        break;
                    }

                }
                
            }
            catch (Exception ex)
            {

            }

            return IsFolderExists;
        }

        private string GetDestinationFolder(int ConditionId)
        {
            try
            {
                string folder2 = string.Empty;
                string createResult = string.Empty;
                string lstoffolders = ConditionId.ToString();
                int folderLength = 3;
                string tempUrl = "";

                if (ConditionId.ToString().Length <= folderLength)
                {
                    return "/" + ConditionId.ToString() + "/";
                }
                else
                {
                    tempUrl = "/" + ConditionId.ToString().Substring(0, folderLength) + "/" + ConditionId.ToString().Substring(folderLength) + "/";
                }
                return tempUrl ;
            }
            catch (Exception ex)
            {
            }
            return "/";
        }

        private byte[] GetBytes(string str)
        {
            byte[] bytes = new byte[str.Length * sizeof(char)];
            System.Buffer.BlockCopy(str.ToCharArray(), 0, bytes, 0, bytes.Length);
            return bytes;
        }

        //Archived code for DWS 
        private string UploadFileToSharepoint(CopySoapClient CopyClient, string FileName, string[] DestinationUrl, byte[] Content)
        {
            string _url = "";
            FieldInformation descInfo = new FieldInformation
            {
                DisplayName = "Description",
                Type = DPSG.Portal.BC.BAL.CopyFileServiceRef.FieldType.File,
                Value = "Test file for upload"
            };
            FieldInformation[] fileInfoArray = { descInfo };
            CopyResult[] arrayOfResults;
            uint result = CopyClient.CopyIntoItems(FileName, DestinationUrl, fileInfoArray, Content, out arrayOfResults);
            Trace.WriteLine("Upload Result: " + result);


            foreach (CopyResult copyResult in arrayOfResults)
            {
                string msg = "====================================" +
                             "SharePoint Error:" +
                             "\nUrl: " + copyResult.DestinationUrl +
                             "\nError Code: " + copyResult.ErrorCode +
                             "\nMessage: " + copyResult.ErrorMessage +
                             "====================================";
                _url = copyResult.DestinationUrl;
            }
            return _url;
        }

    }
}
