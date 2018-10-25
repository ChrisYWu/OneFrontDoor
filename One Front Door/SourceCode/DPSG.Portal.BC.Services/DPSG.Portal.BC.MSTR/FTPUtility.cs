using Limilabs.FTP.Client;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Security;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace DPSG.Portal.BC.MSTR
{
    public class FTPUtility
    {
        public static void UploadImage(string fileName, byte[] file)
        {
            var imgStream = new MemoryStream();
            try
            {
                imgStream.Write(file, 0, file.Length);
                imgStream.Flush();
                UploadImage(fileName, imgStream);
            }
            finally
            {
                imgStream.Close();
                imgStream.Dispose();
            }

        }

        public static void UploadImage(string fileName, Stream file)
        {
            int height = int.Parse(ConfigurationManager.AppSettings["MaxHeight"]);
            int width = int.Parse(ConfigurationManager.AppSettings["MaxWidth"]);
            System.Drawing.Image i = System.Drawing.Image.FromStream(file);
            if (i.Height > i.Width)
                width = i.Width / i.Height * height;
            else
                height = i.Height / i.Width * width;

            var thumb = i.GetThumbnailImage(width, height, null, System.IntPtr.Zero);

            MemoryStream stream = new MemoryStream();

            try
            {
                thumb.Save(stream, System.Drawing.Imaging.ImageFormat.Jpeg);
                Upload(Path.GetFileNameWithoutExtension(fileName) + ".jpg", stream);
            }
            finally
            {
                stream.Close();
                stream.Dispose();
            }
        }

        public static void Upload(string fileName, Stream file)
        {
            byte[] filebytes;
            filebytes = file.ReadAllBytes();
            Upload(fileName, filebytes);
        }


        public static void Upload(string fileName, byte[] file)
        {
            var ftpFQDN = System.Configuration.ConfigurationManager.AppSettings["FtpServer"];

            using (Ftp client = new Ftp())
            {
                client.ServerCertificateValidate += new ServerCertificateValidateEventHandler(Validate);
                client.Connect(ftpFQDN, 21);
                client.AuthSSL();
                client.Login(ConfigurationManager.AppSettings["FtpUserName"], 
                             ConfigurationManager.AppSettings["FtpPassword"]);

                
                if(!string.IsNullOrEmpty(ConfigurationManager.AppSettings["FtpSubFolder"]))
                    client.ChangeFolder(ConfigurationManager.AppSettings["FtpSubFolder"]);
                
                client.Upload(fileName, file);
                client.Close();
            }
        }

        private static void Validate(object sender, ServerCertificateValidateEventArgs e)
        {
            const SslPolicyErrors ignoredErrors =
                SslPolicyErrors.RemoteCertificateChainErrors |  // self-signed
                SslPolicyErrors.RemoteCertificateNameMismatch;  // name mismatch

            string nameOnCertificate = e.Certificate.Subject;
            if ((e.SslPolicyErrors & ~ignoredErrors) == SslPolicyErrors.None)
            {
                e.IsValid = true;
                return;
            }

            e.IsValid = false;
        }
    }
}
