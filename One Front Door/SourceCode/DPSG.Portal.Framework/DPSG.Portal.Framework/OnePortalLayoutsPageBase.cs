using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.SharePoint.WebControls;
using Microsoft.SharePoint;
using DPSG.Portal.Framework.Types;
using System.Web.UI;

namespace DPSG.Portal.Framework
{
    public class OnePortalLayoutsPageBase : LayoutsPageBase
    {
        OnePortalBase _portalBase;
        public OnePortalBase PortalBase
        {
            get
            {
                if (_portalBase == null)
                {
                    _portalBase = ((OnePortalMasterPage)this.Page.Master).portalBase;
                }
                return _portalBase;
            }
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
        }
    }
}
