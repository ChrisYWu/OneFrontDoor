/// <summary>
/*  
    * Module Name         :DPSG.Portal.Framework.Types.PromoWeek.cs
    * Purpose             :To store promotion details.
    * Created Date        :5/17/2013
    * Created By          :Ranjeet Tiwari
    * Last Modified Date  :5/17/2013
    * Last Modified By    :Ranjeet Tiwari
    * Where To Use        :PlayBook
    * Dependancy          :
*/
/// </summary>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public  class PromoWeek
    {
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
