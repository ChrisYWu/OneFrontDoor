using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types.ApplicationRights
{

    /// <summary>
    /// All the rights applicable to promotion activity application
    /// </summary>
    public class PromotionActivity
    {
        public const string APPROVE = "Approve";
        public const string ADD_ATTACHMENT = "AddAttachment";
        public const string APPROVE_PROMOTIONS_NA = "APPROVE_PROMOTIONS_NA";
        public const string CANCEL = "CANCEL";
        public const string CANCEL_PROMOTIONS_NA = "CANCEL_PROMOTIONS_NA";

        public const string CREATE_PROMOTIONS_NA = "CREATE_PROMOTIONS_NA";

        public const string CREATE_NEW = "CreateNew";

        public const string DELETE_ATTACHMENT = "DeleteAttachment";
        public const string EDIT = "Edit";
        public const string EDIT_PROMOTIONS_NA = "EDIT_PROMOTIONS_NA";
        public const string HIDE_DRAFT_PROMOTION = "HIDE_DRAFT_PROMOTION";


        public const string VIEW_DRAFT_NA = "VIEW_DRAFT_NA";
        public const string VIEW_PROMOTIONS_NA = "VIEW_PROMOTIONS_NA";
        public const string VIEW_NATIONAL_ACCOUNT_PROMOTION = "ViewNationalAccountPromotion";

        public const string DISABLE_ACCOUNT_TYPE = "DisableAccountType";
        public const string EDIT_PROMOTION_PRIORITY = "EditPromotionPriority";
        public const string READ_ONLY = "Read Only";
        public const string HIDE_ACNT_CHNL_PROMOTION_TYPE = "HideAccountChannelPromotionType";
        public const string SHOW_MY_ACCOUNT = "Show My Account";
        public const string SHOW_MY_CHANNEL = "Show My Channel";

        public const string SET_DEFAULT_SYSTEM = "Set Default System";

        public const string SAVE_DRAFT_ATTACHMENT = "Save Draft Attachment";
        public const string PREFERRED_ACCOUNT_LIST = "GetPreferredAccountList";
        public const string CREATE_MASS_UPLOAD_PROMOTIONS = "CREATE_MASS_UPLOAD_PROMOTIONS";
        public const string SHOW_CREATEDBY_FILTER= "Show CreatedBy Filter";
        public const string VIEW_REV = "View REV";
        public const string CREATE_PROMOTION_ACCRUAL_FIELDS = "AccrualFields";
        public const string SEND_BOTTLER_ANNOUNCEMENTS = "SEND_BOTTLER_ANNOUNCEMENTS";  
    }

    public class MarketingProgram
    {
        public const string VIEW_DRAFT_PROGRAM = "VIEW_DRAFT_PROGRAM";
        public const string CREATE_NEW = "CreateNew";
        public const string GENERIC_RIGHT = "Generic Right";
        public const string VIEW_DRAFT_ATTACHMENT = "View Draft Attachment";
        public const string MILESTONE_ALERTS = "MILESTONE_ALERTS";
        public const string APPROVE_PROGRAM = "Approve Program";
        public const string PREFERRED_PROGRAM_ALERTS = "PreferredProgramsForAlerts";


        public const string VIEW_DRAFT_MARKETING_PROGRAM = "VIEW_DRAFT_MARKETING_PROGRAM";
        public const string CREATE_NEW_MARKETING_PROGRAM = "CreateNewMarketingProgram";
        public const string VIEW_DRAFT_ATTACHMENT_MARKETING_PROGRAM = "View Draft Attachment Marketing Program";
        public const string APPROVE_MARKETING_PROGRAM = "Approve Marketing Program";
        public const string VIEW_ALL_PROGRAMS = "View All Program";
    }

    public class Milestone
    {
        public const string GENERIC_RIGHT = "Generic Right";
        public const string CREATE = "Create";
    }

    /// <summary>
    /// All the rights applicable for ten incentive application
    /// </summary>
    public class Incentives
    {

        public const string TEN_INCENTIVE_APPROVE = "TEN Incentive Approval";
        public const string TEN_INCENTIVE_REJECT = "TEN Incentive Reject";
    }

    public class Goal
    {
        public const string LEADERSHIP = "Leadership";
        public const string CREATETACTIC = "Create Tactic";
        public const string DELETETACTIC = "Delete Tactic";
        public const string CREATETASK = "Create Task";
        public const string DELETETASK = "Delete Task";
        public const string ISMYGOALAVAILABLE = "Is MyGoal Available";

    }
    public class MyPreferences
    {
        public const string RELATED_ACCOUNTS = "Related Accounts";
        public const string LOCATION_LABEL = "Location Label Text";
        public const string SHOW_SYSTEM_IN_MY_SETTINGS = "Show System in My Settings";
    }

    public class Global
    {
        public const string PREFERENCE_REQUIRED = "IsRequiredPreferences";
        public const string AMPLIFYLINK_REQUIRED = "Amplify Link";
        public const string SPLASHPAD_SETBRANCH = "Splashpad Branch Filter";
        public const string SPLASHPAD_SETCHAIN = "Splashpad Chain Filter";
    }
    public class ICE
    {
        public const string ICE_APPROVE = "Approve";
        public const string ICE_VIEW = "View";

    }

    public class RCI
    {
        public const string RCI_IsAdmin = "IsAdmin";
        public const string RCI_IsFinance = "IsFinance";
    }

    public class SUPPLYCHAINMANUFACTURING
    {
        public const string VIEWOPERATIONS = "View Operations";

    }
    public class SUPPLYCHAININVENTORY
    {
        public const string VIEWOPERATIONS = "View Operations";

    }
}
