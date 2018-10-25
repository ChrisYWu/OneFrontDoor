using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ServiceModel;
using System.ServiceModel.Description;
using System.IdentityModel.Selectors;
using System.IdentityModel.Tokens;
using System.IdentityModel.Protocols.WSTrust;
using System.Security.Claims;
using System.ServiceModel.Security;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.IdentityModel.Services;
using System.Security.Principal;
using System.IO;
using System.Collections;
using System.Web.Configuration;

namespace DPSG.Portal.BC.Common
{
    public class Securityhandler
    {
        public static string _GSNId { get; set; }
        static string _thumbPrintVal = WebConfigurationManager.AppSettings["ThumbPrintVal"].ToString();
        static string _thumbPrintName = WebConfigurationManager.AppSettings["ThumbPrintName"].ToString();

        public static bool ValidateSAMLToken(string _samlToken)
        {
            try
            {
                ReadSecurityToken(_samlToken);
                return true;
            }
            catch (Exception ex)
            {
                DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "");
                return false;
            }
        }


        public static bool ValidateSDMToken(string s)
        {
            try
            {
                if (!string.IsNullOrEmpty(s))
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception ex)
            {
                return false;
            }

        }

        
        public static SecurityToken ReadSecurityToken(string signInResponseXml)
        {
            Saml2SecurityToken token = null;
            Saml2SecurityToken _newtokn = null;
            try
            {
                using (StringReader sr = new StringReader(signInResponseXml))
                {
                    using (XmlReader reader = XmlReader.Create(sr))
                    {
                        reader.ReadToFollowing("Assertion", "urn:oasis:names:tc:SAML:2.0:assertion");
                        SecurityTokenHandlerCollection coll = SecurityTokenHandlerCollection.CreateDefaultSecurityTokenHandlerCollection();
                        token = (Saml2SecurityToken)coll.ReadToken(reader.ReadSubtree());
                        _GSNId = token.Assertion.Subject.NameId.Value.ToString();
                        //var identity = _SecurityTokenHandler.ValidateToken(token);
                        
                        /* Add custom Attribute in SAML + Check validated or not*/
                        Saml2SecurityTokenHandler _shandler = new Saml2SecurityTokenHandler();
                        Saml2Assertion _assertion = token.Assertion;
                        Saml2AttributeStatement _smlattristatement = new Saml2AttributeStatement();

                        Saml2Attribute att = new Saml2Attribute("CustomAttribute");
                        att.Name = "CustomAttribute";
                        att.Values.Add("TestingAttribute");
                        _smlattristatement.Attributes.Add(att);

                        _assertion.Statements.Add(_smlattristatement);


                        Saml2Conditions Samlconditions = new Saml2Conditions();
                        Samlconditions.NotBefore = DateTime.Now;
                        Samlconditions.NotOnOrAfter = DateTime.MaxValue;
                        Samlconditions.AudienceRestrictions.Add(new Saml2AudienceRestriction(new Uri("http://mycompany.co.uk/", UriKind.RelativeOrAbsolute)));
                        _assertion.Conditions = Samlconditions;
                        
                        token.Assertion.IssueInstant = DateTime.Now;
                        token.Assertion.Subject.SubjectConfirmations[0].SubjectConfirmationData.NotBefore = DateTime.Now;
                        token.Assertion.Subject.SubjectConfirmations[0].SubjectConfirmationData.NotOnOrAfter = DateTime.MaxValue;
                        
                        _newtokn = new Saml2SecurityToken(_assertion, token.SecurityKeys, token.IssuerToken);

                        var configuration = new SecurityTokenHandlerConfiguration();
                        configuration.AudienceRestriction.AudienceMode = AudienceUriMode.Never;
                        configuration.CertificateValidationMode = X509CertificateValidationMode.None;
                        configuration.RevocationMode = X509RevocationMode.NoCheck;
                        configuration.CertificateValidator = X509CertificateValidator.None;

                        var registry = new ConfigurationBasedIssuerNameRegistry();
                        registry.AddTrustedIssuer(_thumbPrintVal, _thumbPrintName);
                        configuration.IssuerNameRegistry = registry;
                        SecurityTokenHandlerCollection _SecurityTokenHandler = SecurityTokenHandlerCollection.CreateDefaultSecurityTokenHandlerCollection(configuration);

                        var identity = _SecurityTokenHandler.ValidateToken(_newtokn);
                    }
                }
            }
            catch (Exception fe)
            {
                DPSG.Portal.BC.Common.ExceptionHelper.LogException(fe, "");
                Console.WriteLine(fe.Message.ToString());
            }
            return _newtokn;

        }

    }
}
