using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
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
using DPSG.Portal.BC.Common;
using DPSG.Portal.BC.Services.DataContract;
using DPSG.Portal.BC.BAL;
using DPSG.Portal.Framework.CommonUtils;
using System.Runtime.Serialization;
using DPSG.Portal.BC.Types;
using System.Web.Configuration;


namespace DPSG.Portal.BC.Services.OperationContract
{
    public class Base
    {
        protected bool IsSessionValid { get; set; }
        
        UserSession _userSession = new UserSession();

        #region properties
        private ExceptionErrorMsg _ExceptionErrorMsg = new ExceptionErrorMsg();
        public ExceptionErrorMsg ExceptionErrorMsg
        {
            get { return _ExceptionErrorMsg; }
            set
            {
                if (_ExceptionErrorMsg == null)
                    _ExceptionErrorMsg = value;
            }
        }

        public ExceptionErrorMsg GetExceptionErrorMsg(bool result, string ErrorMessage, string ErrorDetails)
        {
            _ExceptionErrorMsg.Result = result;
            _ExceptionErrorMsg.ErrorMessage = ErrorMessage;
            _ExceptionErrorMsg.ErrorDetails = ErrorDetails;
            return _ExceptionErrorMsg;
        }

        private ServiceLog _servicelog;
        public ServiceLog objServiceLog
        {
            get
            {
                if (_servicelog == null)
                {
                    _servicelog = new ServiceLog();
                }
                return _servicelog;
            }
        }
        
        
        DataContract.Base _base = new DataContract.Base();
        ExceptionErrorMsg ExcepError = new ExceptionErrorMsg();

        string gsn = "";

        public string GSN { 
            get {
                if (gsn == "")
                {
                    try
                    {
                        gsn = System.Web.HttpContext.Current.Request.UserAgent.Split(',')[4];
                    }
                    catch { }
                }
                return gsn;
            } 
        }
        #endregion

        public Base()
        {
            string GSNID = string.Empty;
            try
            {
                string gsn = System.Web.HttpContext.Current.Request.UserAgent;
                if (string.IsNullOrWhiteSpace(gsn))
                {
                    DPSG.Portal.BC.Common.ExceptionHelper.LogException("User Agent is empty", "");
                }
                else if (gsn.Split(',').Length < 5)
                {
                    DPSG.Portal.BC.Common.ExceptionHelper.LogException("User Agent:" + gsn, "");
                }
                else
                {
                    DPSG.Portal.BC.Common.ExceptionHelper.LogException("GSN = " + gsn.Split(',')[4], "");
                }

            }
            catch (Exception ex)
            {
                DPSG.Portal.BC.Common.ExceptionHelper.LogException(ex, "");
            }
            

            try
            {
                string validateSML = System.Configuration.ConfigurationSettings.AppSettings.Get("validateSML");

                IsSessionValid = false;
                var _samlHeader = HttpContext.Current.Request.Headers[Constants.SAML_XML_HEADER];
                var _samlSDMHeader = HttpContext.Current.Request.Headers[Constants.SDM_HEADER];
                //_samlSDMHeader = "52cff053-c456-4a5b-b727-661d1dbb10d1";

                if (validateSML == "0")
                    _samlHeader = "<s:Envelope xmlns:s='http://www.w3.org/2003/05/soap-envelope' xmlns:a='http://www.w3.org/2005/08/addressing' xmlns:u='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd'><s:Header><a:Action s:mustUnderstand='1'>http://docs.oasis-open.org/ws-sx/ws-trust/200512/RSTRC/IssueFinal</a:Action><o:Security s:mustUnderstand='1' xmlns:o='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'><u:Timestamp u:Id='_0'><u:Created>2014-05-21T16:52:42.652Z</u:Created><u:Expires>2014-05-21T16:57:42.652Z</u:Expires></u:Timestamp></o:Security></s:Header><s:Body><trust:RequestSecurityTokenResponseCollection xmlns:trust='http://docs.oasis-open.org/ws-sx/ws-trust/200512'><trust:RequestSecurityTokenResponse><trust:Lifetime><wsu:Created xmlns:wsu='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd'>2014-05-21T16:52:42.636Z</wsu:Created><wsu:Expires xmlns:wsu='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd'>2014-05-21T17:52:42.636Z</wsu:Expires></trust:Lifetime><wsp:AppliesTo xmlns:wsp='http://schemas.xmlsoap.org/ws/2004/09/policy'><wsa:EndpointReference xmlns:wsa='http://www.w3.org/2005/08/addressing'><wsa:Address>https://fs.dpsgit.com/adfs/services/dpsmyday</wsa:Address></wsa:EndpointReference></wsp:AppliesTo><trust:RequestedSecurityToken><Assertion ID='_f46824be-43f8-4766-8477-c527830d1c4a' IssueInstant='2014-05-21T16:52:42.652Z' Version='2.0' xmlns='urn:oasis:names:tc:SAML:2.0:assertion'><Issuer>http://fs.dpsgit.com/adfs/services/trust</Issuer><ds:Signature xmlns:ds='http://www.w3.org/2000/09/xmldsig#'><ds:SignedInfo><ds:CanonicalizationMethod Algorithm='http://www.w3.org/2001/10/xml-exc-c14n#'/><ds:SignatureMethod Algorithm='http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'/><ds:Reference URI='#_f46824be-43f8-4766-8477-c527830d1c4a'><ds:Transforms><ds:Transform Algorithm='http://www.w3.org/2000/09/xmldsig#enveloped-signature'/><ds:Transform Algorithm='http://www.w3.org/2001/10/xml-exc-c14n#'/></ds:Transforms><ds:DigestMethod Algorithm='http://www.w3.org/2001/04/xmlenc#sha256'/><ds:DigestValue>6opJnKJYvz3xEOcvIdGVTHjo4RWnZbMpAOgjKkYs+kA=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>coK708VCmH1D31TU80ouJwIWjJr2poUD9lZv5uBrPB3rRHGU+F4RRfkJGrreYjQq8y5h7vsh18gFNUd7wA1CaDOLVx1rRJsQ5JdqkV8EXjh/NwIv/OI7oQIFjhVsb18+l6+YZnqRqnucHZRv3ZjyGG+an9r//+JDovQtKVoaS3AkBv0xy6TP026XnA2Kav8LugEhg3CLN7AjcZMSlyigx93MVzmoU5e433WjRc6jKTreuqT/P3ez0gMKVP7MLZAK+tAGqyLHntvV2hzUokx6VLNQPVbFBR6semCrtuxEzdT+Rj67DQ8iYVxqHV+g6SZdV0FJT8E3IslJzk5Ad7RdTg==</ds:SignatureValue><KeyInfo xmlns='http://www.w3.org/2000/09/xmldsig#'><ds:X509Data><ds:X509Certificate>MIIC1jCCAb6gAwIBAgIQL7sQxprJ+IROoZrl8SM0HTANBgkqhkiG9w0BAQsFADAnMSUwIwYDVQQDExxBREZTIFNpZ25pbmcgLSBmcy5kcHNnaXQuY29tMB4XDTEzMDIyNDIwNDg0MloXDTE4MDIyMzIwNDg0MlowJzElMCMGA1UEAxMcQURGUyBTaWduaW5nIC0gZnMuZHBzZ2l0LmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMOkJIxRV0W9MQMGY7UYfv0ymSVtVQbyJ5vcGuw9x9PYEKlF6eHk4RIg0cfSoe0pQ+uZCyyKwWG2pGJNviBY7EQtrOd4sobNtyyP9ge+SVn4GPx4j+BB1IleuWTK32u4iDzeDT4KJiO2xx2kD4cuFtj5kNGUzieNBduYdQxAwm+hwz+ml8wSfhszl8q4duTnGnFy0ZWT2qgNtksAsY1o6w8xOwRra8ni/pNIu6fwOjGwcNVJeJlj205ubtDSreVWEmnAwIJW8MfkaoPJfOJGRG087CGHPQBYJIVKbZ7GS6qphZAUNtqlXlI5GQVrumZb06Dy5qszamky+lrP+jBSerECAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAq3MfTMFEhgKaHcbRg96mgE1VP0ZghiDSfbJXrTEG43H+JbYa5xCxV4oeAevS2us5Jq4Tjz5HK8LXmhlsel1G7to1gZJGjtUOQVWbPw20tJOICJo653JhAfyFaXRbo/XdYsHxiRb99+I8efrCv/oj4XpsGrv1sqUBFcU5/TsW4AwDBFLyH/kEbuhg16gPRZTWc1R75CXKTkkFcT6Y4bBYYspwswzp/Bvb7m2BBLNE16gDXVO0ROAsnzUoIfkddq19dMQmTOaQ2R8bbjG1Nm21rYK0ZgLH9K4CvbFLgY9ftmGwXZlIxSiwIwbEG1WJr0sLaQvir1VDEjSOJvJ3pm29PQ==</ds:X509Certificate></ds:X509Data></KeyInfo></ds:Signature><Subject><NameID>MODSX001</NameID><SubjectConfirmation Method='urn:oasis:names:tc:SAML:2.0:cm:bearer'><SubjectConfirmationData NotOnOrAfter='2014-05-21T16:57:42.652Z'/></SubjectConfirmation></Subject><Conditions NotBefore='2014-05-21T16:52:42.636Z' NotOnOrAfter='2014-05-21T17:52:42.636Z'><AudienceRestriction><Audience>https://fs.dpsgit.com/adfs/services/dpsmyday</Audience></AudienceRestriction></Conditions><AttributeStatement><Attribute Name='http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'><AttributeValue>Modugu, Surendar</AttributeValue></Attribute></AttributeStatement><AuthnStatement AuthnInstant='2014-05-21T16:52:42.605Z'><AuthnContext><AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:Password</AuthnContextClassRef></AuthnContext></AuthnStatement></Assertion></trust:RequestedSecurityToken><trust:RequestedAttachedReference><SecurityTokenReference b:TokenType='http://docs.oasis-open.org/wss/oasis-wss-saml-token-profile-1.1#SAMLV2.0' xmlns='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd' xmlns:b='http://docs.oasis-open.org/wss/oasis-wss-wssecurity-secext-1.1.xsd'><KeyIdentifier ValueType='http://docs.oasis-open.org/wss/oasis-wss-saml-token-profile-1.1#SAMLID'>_f46824be-43f8-4766-8477-c527830d1c4a</KeyIdentifier></SecurityTokenReference></trust:RequestedAttachedReference><trust:RequestedUnattachedReference><SecurityTokenReference b:TokenType='http://docs.oasis-open.org/wss/oasis-wss-saml-token-profile-1.1#SAMLV2.0' xmlns='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd' xmlns:b='http://docs.oasis-open.org/wss/oasis-wss-wssecurity-secext-1.1.xsd'><KeyIdentifier ValueType='http://docs.oasis-open.org/wss/oasis-wss-saml-token-profile-1.1#SAMLID'>_f46824be-43f8-4766-8477-c527830d1c4a</KeyIdentifier></SecurityTokenReference></trust:RequestedUnattachedReference><trust:TokenType>urn:oasis:names:tc:SAML:2.0:assertion</trust:TokenType><trust:RequestType>http://docs.oasis-open.org/ws-sx/ws-trust/200512/Issue</trust:RequestType><trust:KeyType>http://docs.oasis-open.org/ws-sx/ws-trust/200512/Bearer</trust:KeyType></trust:RequestSecurityTokenResponse></trust:RequestSecurityTokenResponseCollection></s:Body></s:Envelope>";

                DPSG.Portal.BC.Common.ExceptionHelper.LogException("SAMLToken:" + _samlHeader, "");
                if (_samlHeader != null && _samlHeader != "")
                {
                    IsSessionValid = DPSG.Portal.BC.Common.Securityhandler.ValidateSAMLToken(_samlHeader);
                    GSNID = DPSG.Portal.BC.Common.Securityhandler._GSNId;
                    if (IsSessionValid)
                    {
                        string uniqueId = Guid.NewGuid().ToString();
                        double _sessionTime = Convert.ToDouble(WebConfigurationManager.AppSettings["SessionTime"].ToString());
                        _userSession.InsertUserSessionInfo(GSNID, uniqueId, DateTime.Now.AddHours(_sessionTime));
                        HttpContext.Current.Response.Headers.Add(Constants.SDM_HEADER, uniqueId.ToString());
                    }
                }

                else if(_samlSDMHeader!=null)
                {
                    IsSessionValid = (new UserSession()).ValidateUserSession(GSNID, _samlSDMHeader);
                }

            }
            catch (Exception ex)
            {
                IsSessionValid = false;
               // throw new FaultException<ExceptionErrorMsg>(GetExceptionErrorMsg(true, "Invalid Token", ex.InnerException.Message), new FaultReason("Invalid Token....."));
            }
        }
    }

}