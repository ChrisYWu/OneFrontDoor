using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class UserProductLinesItem
    {
        //private int _userProductLineID;
        //public virtual int UserProductLineID
        //{
        //    get
        //    {
        //        return this._userProductLineID;
        //    }
        //    set
        //    {
        //        this._userProductLineID = value;
        //    }
        //}

        private string _gSN;
        public virtual string GSN
        {
            get
            {
                return this._gSN;
            }
            set
            {
                this._gSN = value;
            }
        }

        private int? _sPUserProfileID;
        public virtual int? SPUserProfileID
        {
            get
            {
                return this._sPUserProfileID;
            }
            set
            {
                this._sPUserProfileID = value;
            }
        }

        private int? _productLineID;
        public virtual int? ProductLineID
        {
            get
            {
                return this._productLineID;
            }
            set
            {
                this._productLineID = value;
            }
        }

        private int? _tradeMarkID;
        public virtual int? TradeMarkID
        {
            get
            {
                return this._tradeMarkID;
            }
            set
            {
                this._tradeMarkID = value;
            }
        }
    }
}
