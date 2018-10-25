

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Webapi.Merchandiser.Model
{
    public class Base
    {
        private int VersionNo = 0;
        public string CreateURL(string Path)
        {
            return Path + "?" + VersionNo.ToString(); ;
        }

        string modifiedBy;
        DateTime modifiedDate;
        string createdBy;
        DateTime createdDate;
        bool returnStatus;
        string returnMessage;
        int totalPages;
        int totalRows;
        int pageSize;

        public Base()
        {

        }


        public string ModifiedBy
        {
            get { return modifiedBy; }
            set { modifiedBy = value; }
        }

        public DateTime ModifiedDate
        {
            get { return modifiedDate; }
            set { modifiedDate = value; }
        }

        public string CreatedBy
        {
            get { return createdBy; }
            set { createdBy = value; }
        }

        public DateTime CreatedDate
        {
            get { return createdDate; }
            set { createdDate = value; }
        }

        public bool ReturnStatus
        {
            get { return returnStatus; }
            set { returnStatus = value; }
        }
        public int TotalPages
        {
            get { return totalPages; }
            set { totalPages = value; }
        }
        public int TotalRows
        {
            get { return totalRows; }
            set { totalRows = value; }
        }
        public int PageSize
        {
            get { return pageSize; }
            set { pageSize = value; }
        }
        public string ReturnMessage
        {
            get { return returnMessage; }
            set { returnMessage = value; }
        }

    }
}
