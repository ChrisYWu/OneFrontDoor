﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class Account
    {
        public int? ChainId { get; set; }
        public string ChainName { get; set; }
        public string SAPChainId { get; set; }
        public bool IsLocal { get; set; }
    }
}
