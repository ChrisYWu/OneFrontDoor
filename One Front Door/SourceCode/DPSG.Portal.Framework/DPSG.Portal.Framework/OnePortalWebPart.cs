using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.SharePoint;
using DPSG.Portal.Framework.Types;
using System.Web.UI;
using DPSG.Portal.Framework.CommonUtils;

namespace DPSG.Portal.Framework
{
    public class OnePortalWebPart : System.Web.UI.WebControls.WebParts.WebPart
    {       

        protected bool _error;

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
        }
        OnePortalBase _portalBase;
        public OnePortalBase PortalBase
        {
            get {
                if (_portalBase == null)
                {
                    _portalBase = ((OnePortalMasterPage)this.Page.Master).portalBase;
                }
                return _portalBase; 
            }
        }

        protected override void OnLoad(EventArgs e)
        {
            if (!_error)
            {
                try
                {
                    base.OnLoad(e);
                    EnsureChildControls();
                }
                catch (Exception ex)
                {
                    HandleException(ex);
                }
            }
        }

        protected override void CreateChildControls()
        {
            if (!_error)
            {
                try
                {
                    base.CreateChildControls();
                }
                catch (Exception ex)
                {
                    HandleException(ex);
                }
            }
        }

        protected void HandleException(Exception ex)
        {
            ExceptionHelper.LogException("ERROR: COULD NOT LOAD WEBPART::" + this.Title, ex);

            _error = true; 
            Controls.Clear(); 
            Controls.Add(new LiteralControl(ex.Message));
        }
    }
}
