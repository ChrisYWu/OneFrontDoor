using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Portal.Framework.CommonUtils;
using DPSG.Portal.Framework.Types;
using DPSG.Portal.Framework.Types.Constants;
using DPSG.Portal.Framework.Types.SRE;
using DPSG.Portal.Framework.Types.SupplyChain;
using DPSG.Portal.SRE.Consumption;
using DPSG.Portal.SRE.DataContracts;

namespace DPSG.Portal.Framework
{
    public class SREBase
    {
        public string GSN { get; internal set; }
        public int? CurrentUserPersona { get; internal set; }
        public string RequestURL { get; internal set; }
        private bool LogSreConsumption
        {
            get
            {
                string value = HelperUtils.GetConfigEntrybyKey(Config.LogSreConsumption);
                return string.IsNullOrEmpty(value) ? false : Convert.ToBoolean(value);
            }
        }

        private SREBase()
        {
        }

        private static SREBase instance;
        public static SREBase Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new SREBase();
                }
                return instance;
            }
        }

        /// <summary>
        /// Check if the user has permission for the Right
        /// </summary>
        /// <param name="ApplicationName"></param>
        /// <param name="RightName"></param>
        /// <returns></returns>
        public bool CheckUserApplicationRights(string ApplicationName, string RightName)
        {
            Boolean retSREValue = false;
            System.Diagnostics.Stopwatch prefLog = new System.Diagnostics.Stopwatch();

            if (LogSreConsumption)
                prefLog.Start();

            List<DPSG.Portal.SRE.DataContracts.ApplicationRight> appRights = RuleEngine.Instance.GetUserApplicationRights(this.GSN, ApplicationName, this.RequestURL, CurrentUserPersona);

            if (appRights != null && appRights.Any(i => i.RightName == RightName))
                retSREValue = true;
            else
                retSREValue = false;

            if (LogSreConsumption)
            {
                prefLog.Stop();
                DPSG.Portal.Framework.SDM.UserProfileRepository.TraceConsumptionInfo(this.GSN, prefLog.ElapsedTicks, "Application: " + ApplicationName + ". Right Name:  " + RightName, DateTime.Now);
            }

            return retSREValue;
        }

        /// <summary>
        /// Checks if the user has the permission to the application
        /// </summary>
        /// <param name="ApplicationName"></param>
        /// <returns></returns>
        public bool CheckUserApplications(string ApplicationName)
        {
            List<DPSG.Portal.SRE.DataContracts.Application> lstApplication = RuleEngine.Instance.GetUserApplications(this.GSN, this.RequestURL, CurrentUserPersona);

            if (lstApplication != null && lstApplication.Any(i => i.ApplicationName == ApplicationName))
                return true;
            else
                return false;
        }

        /// <summary>
        /// Checks the user behavior
        /// </summary>
        /// <param name="BehaviorName"></param>
        /// <returns></returns>
        public bool CheckUserBehavior(string BehaviorName)
        {
            List<DPSG.Portal.SRE.DataContracts.Behavior> lstBehavior = RuleEngine.Instance.GetUserBehaviors(this.GSN, this.RequestURL, CurrentUserPersona);

            if (lstBehavior != null && lstBehavior.Any(i => i.BehaviorName == BehaviorName))
                return true;
            else
                return false;
        }

        /// <summary>
        /// Checks if the user has the accessibility to the behavior member
        /// </summary>
        /// <param name="BehaviorName"></param>
        /// <param name="BehaviorMemberName"></param>
        /// <returns></returns>
        public bool CheckUserBehaviorMember(string BehaviorName, string BehaviorMemberName)
        {
            Boolean retSREValue = false;
            //System.Diagnostics.Stopwatch prefLog = new System.Diagnostics.Stopwatch();

            //if (LogSreConsumption)
            //    prefLog.Start();

            List<DPSG.Portal.SRE.DataContracts.BehaviorMember> lstBehaviorMember = RuleEngine.Instance.GetUserBehaviorMembers(this.GSN, BehaviorName, this.RequestURL, CurrentUserPersona);

            if (lstBehaviorMember != null && lstBehaviorMember.Any(i => i.BehaviorMemberName == BehaviorMemberName))
                retSREValue = true;
            else
                retSREValue = false;

            //if (LogSreConsumption)
            //{
            //    prefLog.Stop();
            //    DPSG.Portal.Framework.SDM.UserProfileRepository.TraceConsumptionInfo(this.GSN, prefLog.ElapsedTicks, "Behavior: " + BehaviorName + ". Behavior Name:  " + BehaviorMemberName, DateTime.Now);
            //}

            return retSREValue;
        }

        /// <summary>
        /// Returns the list of the behavior members for the corresponding user and behavior
        /// </summary>
        /// <param name="BehaviorName"></param>
        /// <returns></returns>
        public List<string> GetUserBehaviorMember(string BehaviorName)
        {
            List<string> lstBehaviorMembers = new List<string>();

            List<DPSG.Portal.SRE.DataContracts.BehaviorMember> lstBehaviorMember = RuleEngine.Instance.GetUserBehaviorMembers(this.GSN, BehaviorName, this.RequestURL, CurrentUserPersona);

            if (lstBehaviorMember != null)
            {
                lstBehaviorMembers = lstBehaviorMember.Select(i => i.MemberValue).ToList();
            }

            return lstBehaviorMembers;

        }

        /// <summary>
        /// Returns the User Systems
        /// </summary>
        /// <returns></returns>
        public List<ProgramSystem> GetUserSystems()
        {
            List<ProgramSystem> lstSystems = new List<ProgramSystem>();

            List<DataScopeValue> lstdataValues = RuleEngine.Instance.GetUserDataScopeValues(this.GSN, DataScopes.RTM_SYSTEM, this.RequestURL, CurrentUserPersona);

            if (lstdataValues != null)
            {
                int k = 0;
                lstSystems = lstdataValues.Select(i => new ProgramSystem()
                                        {
                                            Disabled = false,
                                            ID = Convert.ToInt32(i.Value),
                                            IsDefault = i.IsDefault,
                                            Name = i.Text,
                                            SequenceID = k++
                                        })
                                        .ToList();
            }


            return lstSystems;
        }

        /// <summary>
        /// Returns the Create Promotion Applicable Systems
        /// </summary>
        /// <returns></returns>
        public List<ProgramSystem> GetCreateApplicableSystems()
        {
            List<ProgramSystem> lstSystems = new List<ProgramSystem>();

            List<DataScopeValue> lstdataValues = RuleEngine.Instance.GetUserDataScopeValues(this.GSN, DataScopes.CREATE_PROMOTION_APPLICABLE_SYSTEMS, this.RequestURL, CurrentUserPersona);

            if (lstdataValues != null)
            {
                int k = 0;
                lstSystems = lstdataValues.Select(i => new ProgramSystem()
                {
                    Disabled = false,
                    ID = Convert.ToInt32(i.Value),
                    IsDefault = i.IsDefault,
                    Name = i.Text,
                    SequenceID = k++
                })
                                        .ToList();
            }


            return lstSystems;
        }

        /// <summary>
        /// Returns the Data Scope Values for the corresponding Data scope
        /// </summary>
        /// <param name="DataScopeName"></param>
        /// <returns></returns>
        public List<DataScopeValue> GetDataScopeValues(string DataScopeName)
        {
            List<DataScopeValue> lstdataValues = RuleEngine.Instance.GetUserDataScopeValues(this.GSN, DataScopeName, this.RequestURL, CurrentUserPersona);

            return lstdataValues;
        }
        /// <summary>
        /// This method will return the Member Name and Member Value. Also this method used in "DPSG.Portal.GOAL.wsp" solution. If making changes please keep an eye on this method also.
        /// </summary>
        /// <param name="BehaviorName"></param>
        /// <returns></returns>
        public List<PlantReportURL> GetSupplyChainManufacturingPlantReportURL(string BehaviorName)
        {
            List<PlantReportURL> lstPlantReports = new List<PlantReportURL>();

            List<BehaviorMember> lstdataValues = RuleEngine.Instance.GetUserBehaviorMembers(this.GSN, BehaviorName, this.RequestURL, CurrentUserPersona); 

            if (lstdataValues != null)
            {
                
                lstPlantReports = lstdataValues.Select(i => new PlantReportURL()
                {
                    ReportType = i.BehaviorMemberName,
                    ReportURL = i.MemberValue,
                    
                })
                                        .ToList();
            }


            return lstPlantReports;
            

        }

        /// <summary>
        /// This method returns true if user is assigned to any role otherwise returns false
        /// </summary>
        /// <returns></returns>
        public bool IsUserAssignedToRole()
        {
            if (RuleEngine.Instance.GetUserRoles(this.GSN, this.RequestURL, CurrentUserPersona).Count > 0)
                return true;
            else
                return false;
        }

        /// <summary>
        /// Returns the user default landing page url
        /// </summary>
        /// <returns></returns>
        public string DefaultURL()
        {
            string url = string.Empty;

            string value = HelperUtils.GetConfigEntrybyKey(Config.RedirectToDefaultURL);
            bool _redirectReq = string.IsNullOrEmpty(value) ? false : Convert.ToBoolean(value);

            if (_redirectReq)
            {
                List<UserPortalRole> lstRoles = RuleEngine.Instance.GetUserRoles(this.GSN, this.RequestURL, CurrentUserPersona);

                if (lstRoles != null && lstRoles.Count > 0)
                {
                    url = lstRoles.First().DefaultURL;
                }
            }

            return url;
        }

        /// <summary>
        /// Returns the user default role
        /// </summary>
        /// <returns></returns>
        public string DefaultRole()
        {
            string _roleName = string.Empty;

            List<UserPortalRole> lstRoles = RuleEngine.Instance.GetUserRoles(this.GSN, this.RequestURL, CurrentUserPersona);

            if (lstRoles != null && lstRoles.Count > 0)
            {
                _roleName = lstRoles.First().RoleName;
            }

            return _roleName;
        }

        /// <summary>
        /// Returns the list of the role that user in 
        /// </summary>
        /// <param name="BehaviorName"></param>
        /// <returns></returns>
        public List<string> GetUserRoles()
        {
            List<string> lstRoleNames = new List<string>();

            List<UserPortalRole> lstRoles = RuleEngine.Instance.GetUserRoles(this.GSN, this.RequestURL, CurrentUserPersona);

            if (lstRoles != null)
            {
                lstRoleNames = lstRoles.Select(i => i.RoleName).ToList();
            }

            return lstRoleNames;

        }

        public string UserPrimaryRole()
        {
            string _primaryRole = string.Empty;

            List<UserPortalRole> lstRoles = RuleEngine.Instance.GetUserRoles(this.GSN, this.RequestURL, CurrentUserPersona);

            if (lstRoles != null)
            {
                UserPortalRole _objRole = lstRoles.FirstOrDefault(i => i.RolePrecedence == 1);

                _primaryRole = (_objRole != null) ? _objRole.RoleName : string.Empty;
            }


            return _primaryRole;
        }

        /// <summary>
        /// Returns the user Role Term Set
        /// </summary>
        /// <returns></returns>
        public string UserTermSetRole()
        {
            string _roleTermSet = string.Empty;

            List<UserPortalRole> lstRoles = RuleEngine.Instance.GetUserRoles(this.GSN, this.RequestURL, CurrentUserPersona);

            if (lstRoles != null && lstRoles.Count > 0)
            {
                _roleTermSet = lstRoles.First().RoleTermSetName;
            }

            return _roleTermSet;
        }

        /// <summary>
        /// Checks if the user is assigned respective data scope
        /// </summary>
        /// <param name="DataScopeName"></param>
        /// <returns></returns>
        public bool CheckUserDataScope(string DataScopeName)
        {
            List<DataScope> lstDataScope = RuleEngine.Instance.GetUserDataScopes(this.GSN, this.RequestURL, CurrentUserPersona);

            if (lstDataScope.Any(i => i.DataScopeName == DataScopeName))
                return true;
            else
                return false;
        }
        
        //public Boolean ClearCache(string GSN)
        //{

        //    return RuleEngine.Instance.ClearUserCache(GSN, string.Empty, CurrentUserPersona);
        //}
        public List<BehaviorMemberList> GetBehaviorMembersByBehaviorName(string BehaviorName)
        {
            List<BehaviorMemberList> lstBehaviorMembers = new List<BehaviorMemberList>();
            List<BehaviorMember> lstdataValues = RuleEngine.Instance.GetUserBehaviorMembers(this.GSN, BehaviorName, this.RequestURL, CurrentUserPersona);
            if (lstdataValues != null)
            {

                lstBehaviorMembers = lstdataValues.Select(i => new BehaviorMemberList()
                {
                    BehaviorMemberName = i.BehaviorMemberName,
                     BehaviorMemberValue = i.MemberValue,
                     BehaviorName=i.BehaviorName,
                     BehaviorMemberPrecedence=i.CalculatedSequence

                })
                                        .ToList();
            }


            return lstBehaviorMembers;
            
        }
    }
}
