/// <summary>
/*  Module Name         : One Portal Cookie Helper
 *  Purpose             : Provide the Helper Methods to Work with Cookies 
 *  Created Date        : 04-Feb-2013
 *  Created By          : Himanshu Panwar
 *  Last Modified Date  : 04-Feb-2013
 *  Last Modified By    : 04-Feb-2013
 *  Where to use        : In One Portal 
 *  Dependency          : 
*/
/// </summary>

#region using

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Security.Cryptography;
using System.IO;
using System.Collections;
using DPSG.Portal.Framework.Types.Constants;

#endregion

namespace DPSG.Portal.Framework.CommonUtils
{
    public static class OnePortalCookieHelper
    {
        public static void CreateCookie(HttpRequest request, HttpResponse response, string cookieName, Hashtable cookieKeyCollection)
        {
            HttpCookie cookieUserInfo = request.Cookies.Get(cookieName);
            if (cookieUserInfo == null)
                cookieUserInfo = new HttpCookie(cookieName);

            foreach (DictionaryEntry entry in cookieKeyCollection)
                cookieUserInfo[entry.Key.ToString()] = Encrypt(entry.Value.ToString());

            cookieUserInfo.Expires = DateTime.Now.AddYears(Config.CookieExpiryInYears);
            response.Cookies.Add(cookieUserInfo);
        }

        public static void DeleteCookie(HttpRequest request, HttpResponse response, string cookieName)
        {
            HttpCookie cookieUserInfo = request.Cookies.Get(cookieName);
            if (cookieUserInfo == null)
                cookieUserInfo = new HttpCookie(cookieName);

            cookieUserInfo.Expires = DateTime.Now.AddDays(-1);
            response.Cookies.Add(cookieUserInfo);
        }

        public static string GetCookieValue(HttpRequest request, string key)
        {
            return GetCookieValue(request, CookieKeys.CookieUserName, key);
        }

        public static string GetCookieValue(HttpRequest request, string cookiename, string key)
        {
            string returnvalue = string.Empty;
            HttpCookie cookieUserInfo = request.Cookies.Get(cookiename);
            if (cookieUserInfo != null)
            {
                if (cookieUserInfo.Values[key] != null)
                    returnvalue = Decrypt(cookieUserInfo.Values[Decrypt(key)].ToString());
            }

            return returnvalue;
        }

        public static string Decrypt(string TextToBeDecrypted)
        {
            RijndaelManaged RijndaelCipher = new RijndaelManaged();

            string Password = "DPSG";
            string decryptedDate;

            try
            {
                byte[] EncryptedData = Convert.FromBase64String(TextToBeDecrypted);

                byte[] Salt = Encoding.ASCII.GetBytes(Password.Length.ToString());
                //Making of the key for decryption
                PasswordDeriveBytes SecretKey = new PasswordDeriveBytes(Password, Salt);
                //Creates a symmetric Rijndael decryptor object.
                ICryptoTransform Decryptor = RijndaelCipher.CreateDecryptor(SecretKey.GetBytes(32), SecretKey.GetBytes(16));

                MemoryStream memoryStream = new MemoryStream(EncryptedData);
                //Defines the cryptographics stream for decryption.THe stream contains decrpted data
                CryptoStream cryptoStream = new CryptoStream(memoryStream, Decryptor, CryptoStreamMode.Read);

                byte[] PlainText = new byte[EncryptedData.Length];
                int DecryptedCount = cryptoStream.Read(PlainText, 0, PlainText.Length);
                memoryStream.Close();
                cryptoStream.Close();

                //Converting to string
                decryptedDate = Encoding.Unicode.GetString(PlainText, 0, DecryptedCount);
            }
            catch { decryptedDate = TextToBeDecrypted; }

            return decryptedDate;
        }

        public static string Encrypt(string TextToBeEncrypted)
        {
            //return TextToBeEncrypted;
            RijndaelManaged RijndaelCipher = new RijndaelManaged();
            string Password = "DPSG";
            byte[] PlainText = System.Text.Encoding.Unicode.GetBytes(TextToBeEncrypted);
            byte[] Salt = Encoding.ASCII.GetBytes(Password.Length.ToString());
            PasswordDeriveBytes SecretKey = new PasswordDeriveBytes(Password, Salt);
            //Creates a symmetric encryptor object. 
            ICryptoTransform Encryptor = RijndaelCipher.CreateEncryptor(SecretKey.GetBytes(32), SecretKey.GetBytes(16));
            MemoryStream memoryStream = new MemoryStream();
            //Defines a stream that links data streams to cryptographic transformations
            CryptoStream cryptoStream = new CryptoStream(memoryStream, Encryptor, CryptoStreamMode.Write);
            cryptoStream.Write(PlainText, 0, PlainText.Length);
            //Writes the final state and clears the buffer
            cryptoStream.FlushFinalBlock();
            byte[] CipherBytes = memoryStream.ToArray();
            memoryStream.Close();
            cryptoStream.Close();
            string EncryptedData = Convert.ToBase64String(CipherBytes);

            return EncryptedData;
        }

    }
}
