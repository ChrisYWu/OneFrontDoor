using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.SharePoint;
using System.Globalization;
using System.Data;
using Microsoft.SharePoint.WebPartPages;
using WebUIWebParts = System.Web.UI.WebControls.WebParts;
using Microsoft.SharePoint.Taxonomy;

namespace DPSG.Portal.Framework.CommonUtils
{
    public class SPHelper
    {
        /// <summary>
        /// This method is used to check whether a webpart exists on a page
        /// </summary>
        /// <param name="parts"></param>
        /// <param name="type"></param>
        /// <param name="title"></param>
        /// <returns></returns>
        public static bool IsWebPartExists(SPLimitedWebPartCollection parts, Type type, string title)
        {
            foreach (WebUIWebParts.WebPart part in parts)
            {
                if ((part.GetType() == type) && (part.Title == title))
                {
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// This method is used to check whether list exists or not
        /// </summary>
        /// <param name="web">SPWeb object</param>
        /// <param name="listName">listName</param>
        /// <returns></returns>
        public static bool ListExists(SPWeb web, string listName)
        {
            return web.Lists.Cast<SPList>().Any(list => string.Equals(list.Title.ToLower(), listName.ToLower()));
        }
        /// <summary>
        /// This method is used to check whether list field exists or not
        /// </summary>
        /// <param name="web">SPWeb object</param>
        /// <param name="listName">List Name</param>
        /// <param name="fieldName">field name</param>
        /// <returns>bool value</returns>
        public static bool ListFieldExists(SPWeb web, string listName, string fieldName)
        {
            return web.Lists[listName].Fields.ContainsField(fieldName);
        }


        /// <summary>
        /// This method will get an SPListItemCollection from the specified list based on a specified query.
        /// </summary>
        /// <param name="listUrl">The Url of the SPList</param>
        /// <param name="query">The SPQuery to find the item</param>
        /// <param name="web">The SPWeb of the SPList</param>
        /// <returns>The SPListItemCollection in the SPList</returns>
        public SPListItemCollection GetAllListItems(string listUrl, SPQuery query, SPWeb web)
        {
            SPListItemCollection collection = null;
            collection = web.GetList(listUrl).GetItems(query);
            return collection;
        }

        /// <summary>
        /// This method will add a new SPListItem to the specified list with a set of values.
        /// </summary>
        /// <param name="web">The SPWeb of the SPList</param>
        /// <param name="listName">The name of the SPList</param>
        /// <param name="fields">Dictionarty containing unique SPField name and values</param>
        /// <returns>The new SPListItem added to the SPList</returns>
        public SPListItem Add(SPWeb web, string listName, string folderUrl, Dictionary<string, object> fields)
        {
            SPListItem newItem = null;
            SPSecurity.RunWithElevatedPrivileges(delegate()
            {
                using (SPSite spSite = new SPSite(web.Url))
                {
                    using (SPWeb spWeb = spSite.OpenWeb())
                    {
                        spWeb.AllowUnsafeUpdates = true;
                        Guid folderID = GetFolder(spWeb, listName, ref folderUrl);

                        newItem = spWeb.Lists[listName].Items.Add(spWeb.Lists[listName].Folders[folderID].Folder.ServerRelativeUrl, SPFileSystemObjectType.File, null);

                        foreach (string key in fields.Keys)
                        {
                            newItem[key] = fields[key];
                        }

                        newItem.Update();
                        spWeb.AllowUnsafeUpdates = false;
                    }
                }
            });
            return newItem;
        }

        /// <summary>
        /// This method will return the GUID of existing folder or creates a folder and returns it's GUID
        /// </summary>
        /// <param name="web"></param>
        /// <param name="listName"></param>
        /// <param name="folderUrl"></param>
        /// <returns></returns>

        private Guid GetFolder(SPWeb spWeb, string listName, ref string folderUrl)
        {
            SPListItem folder = null;
            string fldURL = folderUrl;
            SPList spList = spWeb.Lists[listName];
            SPFolder spfolder = spWeb.GetFolder(spList.RootFolder.Url + "/" + fldURL);

            if (!spfolder.Exists)
            {
                folder = spList.Items.Add(string.Empty, SPFileSystemObjectType.Folder, fldURL);
                folder["Title"] = folder;
                folder.Update();
            }
            else
            {
                folder = spWeb.Lists[listName].Folders[spfolder.UniqueId];
            }

            return folder.UniqueId;
        }

        /// <summary>
        /// Returns DataTable with the listitems fetched for specified Caml Query
        /// </summary>
        /// <param name="listName"></param>
        /// <param name="query"></param>
        /// <param name="web"></param>
        /// <returns></returns>
        public DataTable GetDataTable(string listName, SPQuery query, SPWeb web)
        {
            DataTable dataTable = new DataTable();
            dataTable = (web.Lists[listName].GetItems(query)).GetDataTable();
            return dataTable;
        }

        /// <summary>
        /// This method will get an SPListItem from the specified list based on a specified query.
        /// </summary>
        /// <param name="web">The SPWeb of the SPList</param>
        /// <param name="listName">The name of the SPList</param>
        /// <param name="query">The SPQuery to find the item</param>
        /// <returns>The SPListItem in the SPList</returns>
        public SPListItem Get(SPWeb web, string listName, SPQuery query)
        {
            SPListItem item = null;
            SPListItemCollection collection = null;

            collection = web.Lists[listName].GetItems(query);

            if (collection != null && collection.Count > 0)
            {
                item = collection[0];
            }

            return item;
        }

        /// <summary>
        /// This method will get an SPListItem from the specified list based on a specified query.
        /// </summary>
        /// <param name="web">The SPWeb of the SPList</param>
        /// <param name="listName">The name of the SPList</param>
        /// <param name="query">The SPQuery to find the item</param>
        /// <returns>The SPListItem in the SPList</returns>
        public SPListItemCollection Get(SPWeb web, string listName, SPQuery query, String folderName)
        {
            SPList docLib = null;
            SPListItemCollection collection = null;
            docLib = web.Lists[listName];

            foreach (SPFolder subfolder in docLib.RootFolder.SubFolders)
            {
                if (subfolder.Name.ToUpper() == folderName.ToUpper())
                {
                    query.Folder = subfolder;
                    collection = docLib.GetItems(query);
                }
            }
            return collection;
        }

        /// <summary>
        /// This method will return a CAML query to fetch an item from sharepoint list on the basis of item id.
        /// </summary>
        /// <param name="listItemId">ID of item to be fetched</param>
        /// <returns></returns>
        private static SPQuery BuildQuery(int listItemId)
        {
            SPQuery query = new SPQuery();
            query.Query = string.Format(CultureInfo.InvariantCulture, "<Where><Eq><FieldRef Name='ID'/><Value Type='Counter'>{0}</Value></Eq></Where>", listItemId);
            return query;
        }

        /// <summary>
        /// This method will delete a SPListItem in the specified list for a given folder.
        /// </summary>
        /// <param name="web">The SPWeb of the SPList</param>
        /// <param name="listName">The name of the SPList</param>
        ///<param name="FolderName">in format "UserName_SID/TargetFolder"</param>
        /// <param name="ItemGUID">The DataGuid of the list item to be deleted</param>
        public bool Delete(SPWeb web, string listName, String FolderName, String ItemGUID)
        {
            SPSecurity.RunWithElevatedPrivileges(delegate()
            {
                using (SPSite spSite = new SPSite(web.Url))
                {
                    using (SPWeb spWeb = spSite.OpenWeb())
                    {

                        SPListItem item = null;
                        SPListItemCollection collection = null;
                        SPQuery query = new SPQuery();

                        SPList list = spWeb.Lists[listName];
                        SPFolder folder = list.ParentWeb.GetFolder(list.RootFolder.Url + "/" + FolderName);
                        query.Folder = folder;

                        StringBuilder queryBuilder = new StringBuilder("<Where>");
                        queryBuilder.Append(string.Format(CultureInfo.InvariantCulture, "<Eq><FieldRef Name='DataGUID'/>"));
                        queryBuilder.Append(string.Format(CultureInfo.InvariantCulture, "<Value Type='Text'>{0}</Value></Eq>", ItemGUID));
                        // queryBuilder.Append(string.Format(CultureInfo.InvariantCulture, "<QueryOptions> <Folder>{0}/{1}</Folder></QueryOptions>", ListName, FolderName));
                        queryBuilder.Append("</Where>");

                        query.Query = queryBuilder.ToString();

                        collection = list.GetItems(query);

                        if (collection != null && collection.Count > 0)
                        {
                            spWeb.AllowUnsafeUpdates = true;
                            item = collection[0];
                            item.Delete();
                            list.Update();
                            spWeb.AllowUnsafeUpdates = false;

                        }
                    }
                }
            });
            return true;
        }

        /// <summary>
        /// This method will delete a SPListItem in the specified list.
        /// </summary>
        /// <param name="web">The SPWeb of the SPList</param>
        /// <param name="listName">The name of the SPList</param>
        /// <param name="listItemId">The Id of the list item to upldate</param>
        public void DeleteItemsByQuery(SPWeb web, string listName, String query)
        {
            SPSecurity.RunWithElevatedPrivileges(delegate()
            {
                using (SPSite spSite = new SPSite(web.Url))
                {
                    using (SPWeb newWeb = spSite.OpenWeb())
                    {
                        //SPListItem item = null;
                        SPListItemCollection collection = null;
                        SPQuery spQuery = new SPQuery();
                        spQuery.Query = query;

                        SPList list = newWeb.Lists[listName];
                        collection = list.GetItems(spQuery);

                        if (collection != null && collection.Count > 0)
                        {
                            int collectionTotal = collection.Count;
                            newWeb.AllowUnsafeUpdates = true;
                            for (int counter = collectionTotal - 1; counter >= 0; counter--)
                            {
                                collection[counter].Delete();
                            }
                            //list.Update();
                            newWeb.AllowUnsafeUpdates = false;
                        }
                    }
                }
            });
        }
        /// <summary>
        /// This method will delete the List Items based on ItemGUID
        /// </summary>
        /// <param name="web">SPWeb Object</param>
        /// <param name="listName">list name</param>
        /// <param name="listItemGUID">list item GUID</param>
        /// <returns>bool</returns>
        public bool DeleteItemByGUID(SPWeb web, string listName, string listItemGUID)
        {
            bool itemDeleted = false;
            SPSecurity.RunWithElevatedPrivileges(delegate()
            {
                using (SPSite spSite = new SPSite(web.Url))
                {
                    using (SPWeb newWeb = spSite.OpenWeb())
                    {
                        SPListItem item = GetItemByGUID(newWeb, listName, listItemGUID);

                        if (item != null)
                        {
                            newWeb.AllowUnsafeUpdates = true;
                            item.Delete();
                            newWeb.AllowUnsafeUpdates = false;
                            itemDeleted = true;
                        }
                    }
                }
            });
            return itemDeleted;
        }
        /// <summary>
        /// This method will delete a SPListItem in the specified list.
        /// </summary>
        /// <param name="web">The SPWeb of the SPList</param>
        /// <param name="listName">The name of the SPList</param>
        /// <param name="listItemId">The Id of the list item to upldate</param>
        public void Delete(SPWeb web, string listName, int listItemId)
        {
            SPSecurity.RunWithElevatedPrivileges(delegate()
            {
                using (SPSite spSite = new SPSite(web.Url))
                {
                    using (SPWeb newWeb = spSite.OpenWeb())
                    {
                        SPListItem item = null;
                        SPListItemCollection collection = null;
                        collection = newWeb.Lists[listName].GetItems(BuildQuery(listItemId));

                        if (collection != null && collection.Count > 0)
                        {
                            item = collection[0];
                            newWeb.AllowUnsafeUpdates = true;
                            item.Delete();

                            newWeb.AllowUnsafeUpdates = false;
                        }
                    }
                }
            });
        }
        /// <summary>
        /// This method is used to get the List item by listItemGUID
        /// </summary>
        /// <param name="web">SPWeb object</param>
        /// <param name="listName">list name</param>
        /// <param name="listItemGUID">listItemGUID</param>
        /// <returns>SPList Item</returns>
        public SPListItem GetItemByGUID(SPWeb web, string listName, string listItemGUID)
        {
            SPListItem item = null;
            StringBuilder queryBuilder = new StringBuilder("<Where>");
            queryBuilder.Append(string.Format(CultureInfo.InvariantCulture, "<Eq><FieldRef Name='GUID'/>"));
            queryBuilder.Append(string.Format(CultureInfo.InvariantCulture, "<Value Type='Guid'>{0}</Value></Eq>", listItemGUID));
            queryBuilder.Append("</Where>");
            SPQuery query = new SPQuery();
            query.Query = queryBuilder.ToString();
            query.ViewAttributes = "Scope=\"Recursive\"";

            SPListItemCollection collection = web.Lists[listName].GetItems(query);

            if (collection != null && collection.Count > 0)
            {
                item = collection[0];
            }

            return item;
        }

        /// <summary>
        /// This method will update a SPListItem in the specified list with a set of values based on current user.
        /// </summary>
        /// <param name="web">The SPWeb of the SPList</param>
        /// <param name="listName">The name of the SPList</param>
        /// <param name="listItemId">The Id of the list item to update</param>
        /// <param name="fields">Dictionarty containing unique SPField names and values</param>
        /// <param name="isUpdateWithCurrentUser">update based on current user check</param>
        public void Update(SPWeb web, string listName, int listItemId, Dictionary<string, object> fields, bool isUpdateWithCurrentUser)
        {
            if (isUpdateWithCurrentUser)
            {
                SPListItem item = null;
                SPListItemCollection collection = null;
                SPUserToken userToken = null;
                try
                {
                    SPUser user = web.CurrentUser;
                    userToken = user.UserToken;
                }
                catch (Exception)
                {
                    userToken = web.Site.UserToken;
                }
                using (SPSite spSite = new SPSite(web.Url, userToken))
                {
                    using (SPWeb newWeb = spSite.OpenWeb())
                    {
                        collection = newWeb.Lists[listName].GetItems(BuildQuery(listItemId));
                        if (collection != null && collection.Count > 0)
                        {
                            item = collection[0];
                            foreach (string key in fields.Keys)
                            {
                                item[key] = fields[key];
                            }
                            newWeb.AllowUnsafeUpdates = true;
                            item.Update();
                            item.File.CheckIn(string.Empty, SPCheckinType.MinorCheckIn);
                            newWeb.AllowUnsafeUpdates = false;
                        }
                    }
                }

            }
            else
            {
                this.Update(web, listName, listItemId, fields);
            }
        }

        /// <summary>
        /// This method will update a SPListItem in the specified list with a set of values.
        /// </summary>
        /// <param name="web">The SPWeb of the SPList</param>
        /// <param name="listName">The name of the SPList</param>
        /// <param name="listItemId">The Id of the list item to update</param>
        /// <param name="fields">Dictionarty containing unique SPField names and values</param>
        public void Update(SPWeb web, string listName, int listItemId, Dictionary<string, object> fields)
        {
            SPListItem item = null;
            SPListItemCollection collection = null;
            SPSecurity.RunWithElevatedPrivileges(delegate()
            {
                using (SPSite spSite = new SPSite(web.Url))
                {
                    using (SPWeb newWeb = spSite.OpenWeb())
                    {
                        collection = newWeb.Lists[listName].GetItems(BuildQuery(listItemId));
                        if (collection != null && collection.Count > 0)
                        {
                            item = collection[0];

                            foreach (string key in fields.Keys)
                            {
                                item[key] = fields[key];
                            }
                            newWeb.AllowUnsafeUpdates = true;
                            item.Update();
                            newWeb.AllowUnsafeUpdates = false;
                        }
                    }
                }
            });
        }

        /// <summary>
        /// This method will parse a Taxomony field value
        /// </summary>
        /// <param name="fieldValue">Taxonomy field value</param>
        /// <returns>',' seperated taxomony values</returns>
        public static string GetTaxonomyFieldValue(object fieldValue)
        {
            string returnValue = string.Empty;

            if (fieldValue!=null)
            {
                TaxonomyFieldValueCollection taxFieldValueColl = fieldValue as TaxonomyFieldValueCollection;

                // Loop through all the taxonomy field values
                foreach (TaxonomyFieldValue taxFieldValue in taxFieldValueColl)
                {
                    returnValue += taxFieldValue.Label;
                    returnValue += ", ";
                }
                returnValue = returnValue.Trim(',');
                //returnValue = returnValue.Remove(returnValue.LastIndexOf(","));
            }

            return returnValue;
        }
    }
}
