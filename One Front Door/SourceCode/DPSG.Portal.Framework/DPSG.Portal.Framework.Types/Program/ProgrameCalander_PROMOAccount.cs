using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class ProgrameCalander_PROMOAccount
    {
        public int AccountId { get; set; }
        public string AccountName { get; set; }

        public int ProgrameId { get; set; }
        public int IsMyAccount { get; set; }
    }
}
