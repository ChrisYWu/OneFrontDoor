using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Output
{  

    public class MerchProfileOutput : OutputBase
    {
        MerchProfile _merchProfile;
        public MerchProfile MerchUserProfile
        {
            get { return _merchProfile; }
            set { _merchProfile = value; }
        }     
    }

    public class MerchProfileRAW
    {
        MerchProfile _merchProfile;
        public MerchProfile MerchUserProfile
        {
            get { return _merchProfile; }
            set { _merchProfile = value; }

        }

        ProfileImageDetail _imageDetail;
        public ProfileImageDetail ImageDetail
        {
            get { return _imageDetail; }
            set { _imageDetail = value; }
        }
    }

    public class MerchProfile 
    {
        public int MerchGroupID { get; set; }
        public string GroupName { get; set; }
        public string SAPBranchID { get; set; }
        public string BranchName { get; set; }
        public bool Mon { get; set; }
        public bool Tues { get; set; }
        public bool Wed { get; set; }
        public bool Thu { get; set; }
        public bool Fri { get; set; }
        public bool Sat { get; set; }
        public bool Sun { get; set; }
        public string PictureURL { get; set; }
        public string PictureSAS { get; set; }
    }

    public class ProfileImageDetail
    {
        public string GSN { get; set; }
        public string RelativeURL { get; set; }
        public string AbsoluteURL { get; set; }
        public string StorageAccount { get; set; }
        public string Container { get; set; }
        public string AccessLevel { get; set; }
        public string ConnectionString { get; set; }
    }
}
