using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.BC.Model
{
    public partial class StoreConditionDisplay
    {
        public string ImageBytes;

        private int _isFairShare;
        public virtual int IsFairShare
        {
            get
            {
                return this._isFairShare;
            }
            set
            {
                this._isFairShare = value;
            }
        }

        private int? _dpTieInFlag;
        public virtual int? DPTieInFlag
        {
            get
            {
                return this._dpTieInFlag;
            }
            set
            {
                this._dpTieInFlag = value;
            }
        }

    }
}
