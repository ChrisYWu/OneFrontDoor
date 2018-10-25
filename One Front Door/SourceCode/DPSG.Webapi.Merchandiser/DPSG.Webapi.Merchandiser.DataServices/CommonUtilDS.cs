using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using DPSG.Webapi.Merchandiser.Modals;
using DPSG.Webapi.Merchandiser.Modal;
using DPSG.Webapi.Merchandiser.Model;

namespace DPSG.Webapi.Merchandiser.DataServices
{
    public class CommonUtilDS : MerchandiserConnectionWrapper
    {

        public UserDetailOutput GetUserDetailDS(string GSN)
        {
            try
            {
                UserDetailOutput output = new UserDetailOutput();
                UserDetail usrDetail = new UserDetail();
                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@GSN", GSN)
                                      };
                SDMReader reader =  this.ExecuteReader(Constants.CommonUtil.StoredProcedures.GetUserDetail, pars);

                if (reader != null)
                {

                    usrDetail = reader.GetResults<UserDetail>().FirstOrDefault();
                    if (usrDetail != null && (usrDetail.IsAuthorized))
                    {

                        output.UserInfo = usrDetail;
                        output.Branches = reader.GetResults<MerchBranch>().ToList();
                        output.Groups = reader.GetResults<MerchGroup>().ToList();
                    }
                    else
                    { 
                        if (usrDetail == null || (String.IsNullOrEmpty(usrDetail.Email) || ((!usrDetail.Email.ToLower().Contains("@dpsg.net") && !usrDetail.Email.ToLower().Contains("@dpsg.com")))))
                        {
                            UserDetail usr = new UserDetail();
                            usr.GSN = GSN;
                            usr.IsValid = 0;
                            output.UserInfo = usr;
                        }
                        else
                        {
                            output.UserInfo = usrDetail;
                            output.Branches = reader.GetResults<MerchBranch>().ToList();
                            output.Groups = reader.GetResults<MerchGroup>().ToList();
                        }
                    }
                }

                return output;
            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }

        public ImageOutput GetImageDetailByBlobIDDS(ImageInput input)
        {
            try
            {
                ImageOutput output = new ImageOutput();
                List<ImageDetail> images = new List<ImageDetail>();
                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@BlobIDs", input.BlobIDs)
                                      };
                SDMReader reader = this.ExecuteReader(Constants.CommonUtil.StoredProcedures.GetImageDetailByBlobID, pars);

                if (reader != null)
                {
                    images = reader.GetResults<ImageDetail>().ToList();
                    output.Images = images;
                }
                return output;
            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }

        }

        public void ExtendContrainerReadSAS(int containerID, DateTime expiration, string readSAS)
        {
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@ContainerID", containerID),
                                        new SqlParameter("@ReadSASExpiration", expiration),
                                        new SqlParameter("@ReadSAS", readSAS),
                                       };
                this.ExecuteNonQuery(Constants.CommonUtil.StoredProcedures.ExtendContainerReadSAS, pars);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }

        public ContainerList GetAzureContainer(int containerID)
        {
            ContainerList retval = new ContainerList();
            try
            {
                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@ContainerID", containerID) };

                SDMReader reader = this.ExecuteReader(Constants.CommonUtil.StoredProcedures.GetAzureContainer, pars);

                retval.Containers = reader.GetResults<AzureContainer>().ToList();

                return retval;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally { this.CloseSession(); }
        }


    }
}
