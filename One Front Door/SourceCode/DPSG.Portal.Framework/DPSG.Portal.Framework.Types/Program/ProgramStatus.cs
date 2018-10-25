using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public enum ProgramStatus
    {
        NotStarted = 1, 
        Completed = 2,
        Draft = 3,
        Approved = 4,
        Cancelled = 5,
        InProgress = 6,
        Red = 7,
        Amber = 8,
        Green = 9,
        ReadyforApproval = 12
    }
}
